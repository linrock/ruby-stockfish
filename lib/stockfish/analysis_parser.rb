module Stockfish

  # Converts raw analysis output into a hash
  #
  class AnalysisParser

    ROW_SCANNER = %r{
      \Ainfo\s
      depth\s
      (?<depth>\d+)\s
      seldepth\s
      (?<seldepth>\d+)\s
      (multipv\s(?<multipv>\d+)\s)?
      score\s
      (?<score_type>\w+)?\s
      (?<score>[-\d]+)\s
      (lowerbound\s|upperbound\s)?
      nodes
    }x


    attr_accessor :raw_analysis, :analysis

    def initialize(raw_analysis = nil)
      @raw_analysis = raw_analysis
      @analysis = {}
    end

    def parse
      if game_over?
        handle_game_over
        return
      end
      if @raw_analysis.include?("multipv")
        multipv_parse
      else
        singlepv_parse
      end
    end

    def game_over?
      !!@raw_analysis[/bestmove \(none\)/]
    end

    def handle_game_over
      if @raw_analysis[/info depth 0 score mate 0/]
        @analysis = {
          :bestmove => nil,
          :score => "mate 0"
        }
      elsif @raw_analysis[/info depth 0 score cp 0/]
        @analysis = {
          :bestmove => nil,
          :score => 0
        }
      end
      @analysis
    end

    def best_move_uci
      @raw_analysis[/bestmove (\w+)/, 1]
    end

    def parse_move_row(row)
      sequence = row.match(/ pv (?<moves>.*)/)
      return if sequence.nil?
      analysis = row.match(ROW_SCANNER)
      score = case analysis[:score_type]
              when "cp" then analysis[:score].to_f/100
              when "mate" then "mate #{analysis[:score]}"
              end
      output = {
        :score    => score,
        :sequence => sequence[:moves],
        :depth    => analysis[:depth].to_i,
      }
      output[:multipv] = analysis[:multipv].to_i if analysis[:multipv]
      output
    end

    def singlepv_parse
      @raw_analysis.strip.split("\n").reverse.each do |row|
        analysis = parse_move_row(row)
        next if analysis.nil? || analysis[:sequence].split(" ")[0] != best_move_uci
        @analysis = {
          :bestmove => best_move_uci,
          :moves    => [analysis]
        }
        return @analysis
      end
      @analysis || {}
    end

    def multipv_parse
      multipv = nil
      count = 0
      @analysis = {
        :bestmove => best_move_uci,
        :moves    => []
      }
      @raw_analysis.strip.split("\n").reverse.each do |row|
        analysis = parse_move_row(row)
        next if analysis.nil?
        multipv = analysis[:multipv] if multipv.nil?
        @analysis[:moves].push analysis
        count += 1
        break if count >= multipv
      end
      @analysis || {}
    end

  end

end
