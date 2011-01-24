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
    it "should calc positions for nonempty board", :current => true do
      @game = Tetris::Game.new(Tetris::Dimensions.new({:width => 3, :height => 4}))
      @board = @game.board.set(3,0)
      @tm = Tetris::Tetromino.new('O')
      @board.current_tetromino = @tm
      @possibilities = @board.generate_possibilities_for_current_tetromino
      @possibilities.should have(2).items
    end
  end
  
  def possibilities_printer(p)
    p.each do |b|
      b.display
      puts "\n"
    end
  end
  
end