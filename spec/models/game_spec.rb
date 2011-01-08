require 'tetris'

describe Tetris::Game do
  
  before(:each) do
    @game = Tetris::Game.new
    @board = @game.board
  end
  
  it "should be creatable" do
    game = Tetris::Game.new
  end
  
  it "should have a board" do
    @board.should be_present
  end
end