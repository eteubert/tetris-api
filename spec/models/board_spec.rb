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
  
  it "should have a current and a next tetromino" do
    @board.current_tetromino.should be_kind_of(Tetris::Tetromino)
    @board.next_tetromino.should be_kind_of(Tetris::Tetromino)
  end
  
  describe "line deletion" do
    
    # 
    # 
    # 1   =>
    # 111    1
    it "should be possible to delete the bottom line" do
      dimensions = Tetris::Dimensions.new({:width => 3, :height => 4})
      game = Tetris::Game.new(dimensions)
      board = game.board
        .set(2,0)
        .set(3,0).set(3,1).set(3,2)
      board.remove_complete_lines
      board.state_hash.should eql "000000000100"
    end
    
    # 
    # 1
    # 111 =>
    # 111    1
    it "should be possible to delete multiple connected lines", :current => true do
      dimensions = Tetris::Dimensions.new({:width => 3, :height => 4})
      game = Tetris::Game.new(dimensions)
      board = game.board
        .set(1,0)
        .set(2,0).set(2,1).set(2,2)
        .set(3,0).set(3,1).set(3,2)
      board.remove_complete_lines
      board.state_hash.should eql "000000000100"
    end
    
  end
  
end