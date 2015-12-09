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
      return handle_game_over if game_over?
      if @raw_analysis.include?("multipv")
        handle_multipv
      else
        handle_singlepv
      end
    end

    def game_over?
      !!@raw_analysis[/^bestmove \(none\)$/]
    end

    def handle_game_over
      game_over = @raw_analysis.match(/^info depth 0 score (?<outcome>[a-z]+) 0$/)
      score = case game_over[:outcome]
              when "mate" then "mate 0"
              when "cp" then 0
              end
      @analysis = {
        :bestmove   => nil,
        :variations => [{ :score => score, :sequence => [], :depth => 0 }]
      }
    end

    def best_move_uci
      @raw_analysis[/^bestmove (\w+)/, 1]
    end

    def parse_variation_row(row)
      sequence = row.match(/ pv (?<moves>.*)/)
      return if sequence.nil?
      analysis = row.match(ROW_SCANNER)
      score = case analysis[:score_type]
              when "cp" then analysis[:score].to_f/100
              when "mate" then "mate #{analysis[:score]}"
              end
      variation = {
        :score    => score,
        :sequence => sequence[:moves].split(/\s+/),
        :depth    => analysis[:depth].to_i,
      }
      variation[:multipv] = analysis[:multipv].to_i if analysis[:multipv]
      variation
    end

    def handle_singlepv
      @raw_analysis.strip.split("\n").reverse.each do |row|
        variation = parse_variation_row(row)
        next if variation.nil? || variation[:sequence].split(" ")[0] != best_move_uci
        @analysis = {
          :bestmove   => best_move_uci,
          :variations => [variation]
        }
        return @analysis
      end
      @analysis || {}
    end

    def handle_multipv
      multipv = nil
      count = 0
      @analysis = {
        :bestmove   => best_move_uci,
        :variations => []
      }
      @raw_analysis.strip.split("\n").reverse.each do |row|
        variation = parse_variation_row(row)
        next if variation.nil?
        multipv = variation[:multipv] if multipv.nil?
        @analysis[:variations].push variation
        count += 1
        break if count >= multipv
      end
      @analysis || {}
    end

  end

end
