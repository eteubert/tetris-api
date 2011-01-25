require "tetris"

describe Tetris::BoardRating do

  before(:each) do
    # 000000
    # 000011
    # 100001
    # 111001
    # 101101
    # 111001
    @game = Tetris::Game.new(Tetris::Dimensions.new({:width => 6, :height => 6}))
    @board = @game.board
                                          .set(1,4).set(1,5)
      .set(2,0)                                    .set(2,5)
      .set(3,0).set(3,1).set(3,2)                  .set(3,5)
      .set(4,0)         .set(4,2).set(4,3)         .set(4,5)
      .set(5,0).set(5,1).set(5,2)                  .set(5,5)
    @rating = Tetris::BoardRating.new(@board)
  end

  describe "Pile Height: The row of the highest occupied cell in the board." do
    
    it "should work for main example" do
      @rating.pile_height.should eql(5)
    end
    
  end
  
  describe "Holes: The number of all unoccupied cells that have at least one occupied above them." do
    
    it "should work for main example" do
      @rating.holes.should eql(6)
    end
    
    it "should also count each hole just once when there are more than one block above" do
      @board.set(0,4)
      @rating.holes.should eql(6)
    end
    
  end
  
  describe "Connectd Holes: Same as Holes above, however vertically connected unoccupied cells only count as one hole." do
    
    it "should work for main example", :current => true do
      @rating.connected_holes.should eql(3)
    end
    
  end
  
  describe "Removed Lines: The number of lines that were cleared in the last step to get to the current board." do
    
    it "should work for main example"
    
  end
  
  describe "Altitude Difference: The difference between the highest occupied and lowest free cell that are directly reachable from the top." do
    
    it "should work for main example"
    
  end
  
  describe "Maximum Well Depth: The depth of the deepest well (with a width of one) on the board." do
    
    it "should work for main example"
    
  end
  
  describe "Sum of all Wells (CF): Sum of all wells on the board." do
    
    it "should work for main example"
    
  end
  
  describe "Landing Height (PD): The height at which the last tetramino has been placed." do
    
    it "should work for main example"
    
  end
  
  describe "Blocks (CF): Number of occupied cells on the board." do
    
    it "should work for main example"
    
  end
  
  describe "Weighted Blocks (CF): Same as Blocks above, but blocks in row n count n-times as much as blocks in row 1 (counting from bottom to top)." do
    
    it "should work for main example"
    
  end
  
  describe "Row Transitions (PD): Sum of all horizontal occupied/unoccupied-transitions on the board. The outside to the left and right counts as occupied." do
    
    it "should work for main example"
    
  end
  
  describe "Column Transitions (PD): As Row Transitions above, but counts vertical transitions. The outside below the game-board is considered occupied." do
    
    it "should work for main example"
    
  end
  
end