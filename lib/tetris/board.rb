module Tetris
  
  class Board
    attr_reader :dimensions, :lines_cleared
    
    def initialize(dimensions = nil)
      @dimensions = dimensions || Dimensions.new
      @lines_cleared = 0
    end
  end
  
end