module Tetris
  
  class Board
    attr_reader :dimensions, :lines_cleared, :next_tetromino
    attr_accessor :current_tetromino
    
    def initialize(dimensions = nil)
      @dimensions = dimensions || Dimensions.new
      @lines_cleared = 0
      @current_tetromino = Tetromino.generate_random
      @next_tetromino = Tetromino.generate_random
    end
    
    def generate_possibilities_for_current_tetromino
      # FIXME just some boilerplate to get started
      [1,2,3,4]
    end
    
  end
  
end