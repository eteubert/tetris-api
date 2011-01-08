# for Object.present?
require 'active_support/core_ext'

module Tetris
  class Game
    attr_reader :board
    
    def initialize(dimensions = nil)
      @board = Board.new(dimensions)
    end
  end
  
  class Board
    attr_reader :dimensions
    
    def initialize(dimensions = nil)
      @dimensions = dimensions || Dimensions.new
    end
  end
  
  class Dimensions
    attr_accessor :width, :height
    
    DEFAULT_WIDTH = 10
    DEFAULT_HEIGHT = 20
    
    def initialize(values = {})
      @width = values[:width] || DEFAULT_WIDTH
      @height = values[:height] || DEFAULT_HEIGHT
    end
    
  end
end