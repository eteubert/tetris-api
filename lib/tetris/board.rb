module Tetris
  
  class Board
    attr_reader :dimensions, :lines_cleared, :current_tetromino, :next_tetromino
    
    def initialize(dimensions = nil)
      @dimensions = dimensions || Dimensions.new
      @lines_cleared = 0
      @current_tetromino = Tetromino.generate_random
      @next_tetromino = Tetromino.generate_random
    end
    
  end
  
end