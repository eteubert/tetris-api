require "tetris"

describe "tetris command line game" do
  
  it "should be possible to place a tetromino" do
    game = Tetris::Game.new
    board = game.board
    
    board.current_tetromino.drop

    game.board.should_not be_empty
  end
  
end