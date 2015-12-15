require 'open3'
require 'io/wait'


module Stockfish

  class InvalidBinary < StandardError; end
  class InvalidCommand < StandardError; end
  class InvalidOption < StandardError; end

  class Engine
    attr_reader :stdin, :stdout, :stderr, :wait_threads, :version, :pid

    COMMANDS = %w( uci isready setoption ucinewgame position go stop ponderhit quit )

    def initialize(bin_path = `which stockfish`)
      @stdin, @stdout, @stderr, @wait_threads = Open3.popen3(bin_path)
      @pid = @wait_threads[:pid]
      @version = @stdout.readline.strip
      unless @version =~ /^Stockfish/
        raise InvalidBinary.new("Not a valid Stockfish binary!")
      end
    end

    def execute(str)
      command = str.split(" ")[0]
      @stdin.puts str
      unless COMMANDS.include?(command)
        raise InvalidCommand.new(@stdout.readline.strip)
      end
      output = ""
      case command
      when "uci"
        loop do
          output << (line = @stdout.readline)
          break if line =~ /^uciok/
        end
      when "go"
        loop do
          output << (line = @stdout.readline)
          break if line =~ /^bestmove/
        end
      when "setoption"
        sleep 0.1
        raise InvalidOption.new(@stdout.readline.strip) if @stdout.ready?
      when "isready"
        output << @stdout.readline
      end
      output
    end

    def multipv(n)
      execute "setoption name MultiPV value #{n}"
    end

    def ready?
      execute("isready").strip == "readyok"
    end

    def running?
      @wait_threads.alive?
    end

    def analyze(fen, options)
      execute "position fen #{fen}"
      %w( depth movetime nodes ).each do |command|
        if (x = options[command.to_sym])
          return execute "go #{command} #{x}"
        end
      end
    end

  end
end
