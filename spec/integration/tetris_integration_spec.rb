require "tetris"

describe "tetris command line game" do
  
  it "should be able to determine all possible placements of the current tetromino" do
    @game = Tetris::Game.new(Tetris::Dimensions.new({:width => 3, :height => 4}))
    @board = @game.board
    @tm = Tetris::Tetromino.new('O')
    @board.current_tetromino = @tm
    @possibilities = @board.generate_possibilities_for_current_tetromino
    @possibilities.should have(2).items
  end
  
end