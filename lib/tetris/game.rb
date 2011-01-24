module Tetris
  
  class Game
    attr_reader :board
    
    def initialize(dimensions = nil)
      @board = Board.new(dimensions)
    end
    
    def lost?
      @board.lost?
    end
  end
  
end