require 'test_helper'


class AnalysisParserTest < Minitest::Test

  def setup
		@klass = Stockfish::AnalysisParser
  end

  def parsed_fixture(fixture_path)
    analysis_output = read_fixture(fixture_path)
    @klass.new(analysis_output).parse
  end

  def test_parser_suggests_a_move_for_a_normal_position
    output = parsed_fixture("analysis_outputs/tough_midgame.txt")
    assert output[:variations].length == 1
    assert output[:variations][0][:score] == -12.51
  end

  def test_parser_suggests_three_variations_for_multipv_3
    output = parsed_fixture("analysis_outputs/multipv_3.txt")
    assert output[:variations].length == 3
  end

  def test_parser_detects_stalemate
    output = parsed_fixture("analysis_outputs/stalemate.txt")
    assert output[:bestmove] == nil
    assert output[:variations].length == 1
    move = output[:variations][0]
    assert move[:score] == 0
  end

  def test_parser_detects_checkmate
    output = parsed_fixture("analysis_outputs/checkmate.txt")
    assert output[:bestmove] == nil
    assert output[:variations].length == 1
    move = output[:variations][0]
    assert move[:score] == "mate 0"
  end

  def test_parser_detects_imminent_win_by_checkmate
    output = parsed_fixture("analysis_outputs/mate_in_1.txt")
    assert output[:variations].length == 1
    move = output[:variations][0]
    assert move[:score] == "mate 1"
  end

  def test_parser_detects_win_by_checkmate
    output = parsed_fixture("analysis_outputs/white_wins_in_4.txt")
    assert output[:variations].length == 1
    move = output[:variations][0]
    assert move[:score] == "mate 4"
  end

  def test_parser_detects_loss_by_checkmate
    output = parsed_fixture("analysis_outputs/black_loses_in_3.txt")
    assert output[:variations].length == 1
    move = output[:variations][0]
    assert move[:score] == "mate -3"
  end

end
