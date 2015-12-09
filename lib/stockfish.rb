require "stockfish/engine"
require "stockfish/analysis_parser"


module Stockfish

  def self.analyze(fen, options = {})
    multipv = options.delete(:multipv)
    engine = Engine.new
    engine.multipv(multipv) if multipv
    AnalysisParser.new(engine.analyze(fen, options)).parse
  end

end
