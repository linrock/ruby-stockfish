require 'test_helper'


class EngineTest < Minitest::Test

  def setup
		@klass = Stockfish::Engine
  end

  def test_engine_version_is_valid
    assert @klass.new.version[/^Stockfish \d+/]
  end

  def test_engine_is_ready?
    assert @klass.new.ready?
  end

  def test_engine_returns_position_analysis
    fen = read_fixture("positions/stalemate.txt")
    analysis_output = @klass.new.analyze(fen, { :depth => 6 })
    assert analysis_output[/^info/]
    assert analysis_output[/^bestmove/]
    fen = read_fixture("positions/start.txt")
    analysis_output = @klass.new.analyze(fen, { :depth => 6 })
    assert analysis_output[/^info/]
    assert analysis_output[/^bestmove/]
  end

  def test_multipv_mode_returns_multipv_output
    engine = @klass.new
    engine.multipv(3)
    fen = read_fixture("positions/white_wins_in_4.txt")
    analysis_output = engine.analyze(fen, { :depth => 6 })
    assert analysis_output[/multipv 3/]
    assert analysis_output[/^bestmove/]
  end

end
