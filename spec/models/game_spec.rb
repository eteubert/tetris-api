require 'tetris'

describe Tetris::Game do
  it "should be creatable" do
    game = Tetris::Game.new
  end
  
  it "should have a board" do
    game = Tetris::Game.new
    game.board.should be_present
  end
end