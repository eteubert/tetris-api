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
  end
  
  describe "loose the game" do
    # 000
    # 110 + 11 => loose
    # 110   11
    it "should be posssible to loose the game", :current => true do
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
  
  def possibilities_printer(p)
    p.each do |b|
      b.display
      puts "\n"
    end
  end
  
end