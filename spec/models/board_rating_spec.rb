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
    
    it "should work for main example" do
      @rating.connected_holes.should eql(3)
    end
    
  end
  
  describe "Removed Lines: The number of lines that were cleared in the last step to get to the current board." do
    
    it "should work for simple example" do
      @game = Tetris::Game.new(Tetris::Dimensions.new({:width => 2, :height => 4}))
      @board = @game.board
        .set(2,0).set(2,1)
        .set(3,0).set(3,1)
      @board.remove_complete_lines
      @rating = Tetris::BoardRating.new(@board)
      @rating.removed_lines.should eql(2)
    end
    
  end
  
  describe "Altitude Difference: The difference between the highest occupied and lowest free cell that are directly reachable from the top." do
    
    it "should work for main example" do
      @rating.altitude_difference.should eql(3)
    end
    
  end
  
  describe "Maximum Well Depth: The depth of the deepest well (with a width of one) on the board." do
    
    it "should work for main example" do
      @rating.maximum_well_depth.should eql(0)
    end
    
    # 01101     X11Y1
    # 01101 =>  X11Y1 X ... first well
    # 01011     X1011 Y ... second well
    it "should work for simple example" do
      @game = Tetris::Game.new(Tetris::Dimensions.new({:width => 5, :height => 3}))
      @board = @game.board
        .set(0,1).set(0,2).set(0,4)
        .set(1,1).set(1,2).set(1,4)
        .set(2,1).set(2,3).set(2,4)
      @board.remove_complete_lines
      @rating = Tetris::BoardRating.new(@board)
      
      @rating.maximum_well_depth.should eql(3)
    end
    
  end
  
  describe "Sum of all Wells (CF): Sum of all wells on the board." do
    
    it "should work for main example" do
      @rating.sum_of_all_wells.should eql(0)
    end
    
    # 01101     X11Y1
    # 01101 =>  X11Y1 X ... first well
    # 01011     X1011 Y ... second well
    it "should work for simple example" do
      @game = Tetris::Game.new(Tetris::Dimensions.new({:width => 5, :height => 3}))
      @board = @game.board
        .set(0,1).set(0,2).set(0,4)
        .set(1,1).set(1,2).set(1,4)
        .set(2,1).set(2,3).set(2,4)
      @board.remove_complete_lines
      @rating = Tetris::BoardRating.new(@board)
      
      @rating.sum_of_all_wells.should eql(2)
    end
    
    # 00101     001Y1
    # 01101 =>  X11Y1 X ... first well
    # 01011     X1011 Y ... second well
    it "should work when well does not start at the ceiling" do
      @game = Tetris::Game.new(Tetris::Dimensions.new({:width => 5, :height => 3}))
      @board = @game.board
                 .set(0,2).set(0,4)
        .set(1,1).set(1,2).set(1,4)
        .set(2,1).set(2,3).set(2,4)
      @board.remove_complete_lines
      @rating = Tetris::BoardRating.new(@board)
      
      @rating.sum_of_all_wells.should eql(2)
    end
    
  end
  
  describe "Landing Height (PD): The height at which the last tetramino has been placed." do
    
    it "should work for empty field" do
      @game = Tetris::Game.new(Tetris::Dimensions.new({:width => 5, :height => 3}))
      @board = @game.board.set(2,0)
      @board.current_tetromino = Tetris::Tetromino.new('O')
      boards = @board.generate_possibilities_for_current_tetromino
      boards.all? do |board|
        board.landing_height.to_s.should match(/[21]/)
        rating = Tetris::BoardRating.new(board)
        rating.landing_height.should eql(board.landing_height)
      end
    end
    
  end
  
  describe "Blocks (CF): Number of occupied cells on the board." do
    
    it "should work for main example" do
      @rating.blocks.should eql(16)
    end
    
  end
  
  describe "Weighted Blocks (CF): Same as Blocks above, but blocks in row n count n-times as much as blocks in row 1 (counting from bottom to top)." do
    
    # 000000  6*0
    # 000011  5*2
    # 100001  4*2
    # 111001  3*4
    # 101101  2*4
    # 111001  1*4 => 42 :)
    it "should work for main example" do
      @rating.weighted_blocks.should eql(42)
    end
    
  end
  
  describe "Row Transitions (PD): Sum of all horizontal occupied/unoccupied-transitions on the board. The outside to the left and right counts as occupied." do
    
    # 000000  2
    # 000011  2
    # 100001  2
    # 111001  2
    # 101101  4
    # 111001  2 => 13
    it "should work for main example" do
      @rating.row_transitions.should eql(14)
    end
    
  end
  
  describe "Column Transitions (PD): As Row Transitions above, but counts vertical transitions. The outside below the game-board is considered occupied." do
    
    # 242442  => 18
    # 000000
    # 000011
    # 100001
    # 111001
    # 101101
    # 111001
    it "should work for main example" do
      @rating.column_transitions.should eql(18)
    end
    
  end
  
end