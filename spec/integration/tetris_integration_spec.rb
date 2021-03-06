require "tetris"

describe "tetris command line game" do
  
  describe "first tetromino placement" do
    it "should be able to determine all possible placements of the current tetromino" do
      @game = Tetris::Game.new(Tetris::Dimensions.new({:width => 3, :height => 4}))
      @board = @game.board
      @tm = Tetris::Tetromino.new('O')
      @board.current_tetromino = @tm
      @possibilities = @board.generate_possibilities_for_current_tetromino
      @possibilities.should have(2).items
    end

    it "should be possible to place a sqare tetromino on a field of height 2" do
      @game = Tetris::Game.new(Tetris::Dimensions.new({:width => 4, :height => 2}))
      @board = @game.board
      @tm = Tetris::Tetromino.new('O')
      @board.current_tetromino = @tm
      @possibilities = @board.generate_possibilities_for_current_tetromino
      @possibilities.should have(3).items
    end

    it "should rotate tetrominos when placing them" do
      @game = Tetris::Game.new(Tetris::Dimensions.new({:width => 4, :height => 4}))
      @board = @game.board
      @tm = Tetris::Tetromino.new('I')
      @board.current_tetromino = @tm
      @possibilities = @board.generate_possibilities_for_current_tetromino_including_variants
      @possibilities.should have(5).items    
    end

    it "place a T tetromino" do
      @game = Tetris::Game.new(Tetris::Dimensions.new({:width => 4, :height => 4}))
      @board = @game.board
      @tm = Tetris::Tetromino.new('T')
      @board.current_tetromino = @tm
      @possibilities = @board.generate_possibilities_for_current_tetromino_including_variants
      @possibilities.should have(10).items
    end
  end
  
  describe "tetromino on non-empty board" do
    # 000     000  000
    # 000     110  000
    # 000     110  011
    # 100 =>  100  111
    it "should calc positions for nonempty board" do
      @game = Tetris::Game.new(Tetris::Dimensions.new({:width => 3, :height => 4}))
      @board = @game.board.set(3,0)
      @tm = Tetris::Tetromino.new('O')
      @board.current_tetromino = @tm
      @possibilities = @board.generate_possibilities_for_current_tetromino
      @possibilities.should have(2).items
    end
    
    # 000     000
    # 000     000
    # 000     110
    # 100 =>  111
    it "should be possible to fit in a Z" do
      @game = Tetris::Game.new(Tetris::Dimensions.new({:width => 3, :height => 4}))
      @board = @game.board.set(3,0)
      @tm = Tetris::Tetromino.new('Z')
      @board.current_tetromino = @tm
      @possibilities = @board.generate_possibilities_for_current_tetromino
      @possibilities.should have(1).items
    end
    
    # 00000     00000     00000
    # 11100     11100     11100
    # 00100 NOT 11100 BUT 00111
    # 00100 =>  11100     00111 (see following test)
    it "should not be possible to place a TM in an enclosed hole" do
      @game = Tetris::Game.new(Tetris::Dimensions.new({:width => 5, :height => 4}))
      @board = @game.board
        .set(1,0).set(1,1).set(1,2)
                          .set(2,2)
                          .set(3,2)
      @tm = Tetris::Tetromino.new('O')
      @board.current_tetromino = @tm
      @possibilities = @board.generate_possibilities_for_current_tetromino
      @possibilities.map(&:state_hash).should_not include("00000111001110011100")
    end
    
    # see test above for description
    it "should be possible to place an O" do
      @game = Tetris::Game.new(Tetris::Dimensions.new({:width => 5, :height => 4}))
      @board = @game.board
        .set(1,0).set(1,1).set(1,2)
                          .set(2,2)
                          .set(3,2)
      @tm = Tetris::Tetromino.new('O')
      @board.current_tetromino = @tm
      @possibilities = @board.generate_possibilities_for_current_tetromino
      @possibilities.map(&:state_hash).should     include("00000111000011100111")
    end
    
    # 0000
    # 1101 +Z
    # 1001 => No Possibilities
    # 1011
    it "should not be possible to place a Z in an unreachable place" do
      @game = Tetris::Game.new(Tetris::Dimensions.new({:width => 4, :height => 4}))
      @board = @game.board
        .set(1,0).set(1,1)         .set(1,3)
        .set(2,0)                  .set(2,3)        
        .set(3,0)         .set(3,2).set(3,3)  
      @tm = Tetris::Tetromino.new('Z')
      @board.current_tetromino = @tm
      @possibilities = @board.generate_possibilities_for_current_tetromino_including_variants
      @possibilities.count.should eql(0)
    end

    # 0111
    # 0011
    # 0001
    # 0001
    it "should not be possible to place an L in an unreachable place" do
      @game = Tetris::Game.new(Tetris::Dimensions.new({:width => 6, :height => 4}))
      @board = @game.board
        .set(0,1).set(0,2).set(0,3).set(0,4).set(0,5)
                 .set(1,2).set(1,3).set(1,4).set(1,5)
                          .set(2,3).set(2,4).set(2,5)
                          .set(3,3).set(3,4).set(3,5)
      @board.current_tetromino = Tetris::Tetromino.new('L')
      @possibilities = @board.generate_possibilities_for_current_tetromino_including_variants
      @possibilities.count.should eql(0)
    end
    
    # 0111
    # 0011
    # 0001
    # 0001
    it "should be possible to place an I on the edge of the board", :current => true do
      @game = Tetris::Game.new(Tetris::Dimensions.new({:width => 6, :height => 4}))
      @board = @game.board
        .set(0,1).set(0,2).set(0,3).set(0,4).set(0,5)
                 .set(1,2).set(1,3).set(1,4).set(1,5)
                          .set(2,3).set(2,4).set(2,5)
                          .set(3,3).set(3,4).set(3,5)
      @board.current_tetromino = Tetris::Tetromino.new('I')
      @possibilities = @board.generate_possibilities_for_current_tetromino_including_variants
      @possibilities.count.should eql(1)
    end
    
  end
  
  describe "loose the game" do
    # 000
    # 110 + 11 => loose
    # 110   11
    it "should be possible to loose the game" do
      @game = Tetris::Game.new(Tetris::Dimensions.new({:width => 3, :height => 3}))
      @board = @game.board.set(2,0).set(2,1).set(1,0).set(1,1)
      @tm = Tetris::Tetromino.new('Z')
      @board.current_tetromino = @tm
      @game.should_not be_lost
      @possibilities = @board.generate_possibilities_for_current_tetromino_including_variants
      @possibilities.should have(0).items
      @game.should be_lost
    end
  end
  
  describe "double tetromino placement" do
  
    it "should calculate all boards for current and next tetromino" do
      @game = Tetris::Game.new(Tetris::Dimensions.new({:width => 4, :height => 4}))
      @board = @game.board
      @board.current_tetromino  = Tetris::Tetromino.new('O')
      @board.next_tetromino     = Tetris::Tetromino.new('I')
      @possibilities = @board.generate_possibilities_for_both_tetrominos
      @possibilities.should have(9).items
    end
    
  end
  
  def possibilities_printer(p)
    p.each do |b|
      b.display
      puts "\n"
    end
  end
  
end