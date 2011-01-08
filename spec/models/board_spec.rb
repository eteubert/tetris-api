require 'tetris'

describe Tetris::Board do
  it "should have dimensions" do
    game = Tetris::Game.new
    board = game.board
    board.dimensions.height.should eql(20)
    board.dimensions.width.should eql(10)
  end
  
  it "should be possible to set custom dimensions" do
    dimensions = Tetris::Dimensions.new({:width => 5, :height => 8})
    game = Tetris::Game.new(dimensions)
    board = game.board
    
    board.dimensions.height.should eql(8)
    board.dimensions.width.should eql(5)
  end
end