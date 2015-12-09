require 'test_helper'


class AnalysisParserTest < Minitest::Test

  def setup
		@klass = Stockfish::AnalysisParser
  end

  def test_parser_suggests_a_move_for_a_normal_position
    analysis_output = read_fixture("analysis_outputs/tough_midgame.txt")
    output = @klass.new(analysis_output).parse
    assert output[:moves].length == 1
    assert output[:moves][0][:score] == -12.51
  end

  def test_parser_suggests_three_moves_for_multipv_3
    analysis_output = read_fixture("analysis_outputs/multipv_3.txt")
    output = @klass.new(analysis_output).parse
    assert output[:moves].length == 3
  end

  def test_parser_detects_stalemate
    analysis_output = read_fixture("analysis_outputs/stalemate.txt")
    output = @klass.new(analysis_output).parse
    assert output[:bestmove] == nil
    assert output[:score] == 0
  end

  def test_parser_detects_checkmate
    analysis_output = read_fixture("analysis_outputs/checkmate.txt")
    output = @klass.new(analysis_output).parse
    assert output[:bestmove] == nil
    assert output[:score] == "mate 0"
  end

  def test_parser_detects_imminent_win_by_checkmate
    analysis_output = read_fixture("analysis_outputs/mate_in_1.txt")
    output = @klass.new(analysis_output).parse
    assert output[:moves].length == 1
    move = output[:moves][0]
    assert move[:score] == "mate 1"
  end

  def test_parser_detects_win_by_checkmate
    analysis_output = read_fixture("analysis_outputs/white_wins_in_4.txt")
    output = @klass.new(analysis_output).parse
    assert output[:moves].length == 1
    move = output[:moves][0]
    assert move[:score] == "mate 4"
  end

  def test_parser_detects_loss_by_checkmate
    analysis_output = read_fixture("analysis_outputs/black_loses_in_3.txt")
    output = @klass.new(analysis_output).parse
    assert output[:moves].length == 1
    move = output[:moves][0]
    assert move[:score] == "mate -3"
  end

end
