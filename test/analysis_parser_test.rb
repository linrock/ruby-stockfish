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

end
