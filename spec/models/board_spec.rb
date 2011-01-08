require 'tetris'

describe Tetris::Board do
  
  before(:each) do
    @game = Tetris::Game.new
    @board = @game.board
  end
  
  it "should have dimensions" do
    @board.dimensions.height.should eql(20)
    @board.dimensions.width.should eql(10)
  end
  
  it "should be possible to set custom dimensions" do
    dimensions = Tetris::Dimensions.new({:width => 5, :height => 8})
    game = Tetris::Game.new(dimensions)
    board = game.board
    
    board.dimensions.height.should eql(8)
    board.dimensions.width.should eql(5)
  end
  
  it "should start with 0 lines cleared" do
    @board.lines_cleared.should be(0)
  end
end