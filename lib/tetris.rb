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
    attr_reader :dimensions, :lines_cleared
    
    def initialize(dimensions = nil)
      @dimensions = dimensions || Dimensions.new
      @lines_cleared = 0
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
  
  class Tetromino
    
    attr_reader :type
    
    VALID_TYPES = %w[I J S T Z L O]
    
    def initialize
      @type = 'I'
    end
    
    def type=(letter)
      raise 'invalid tetromino type' unless VALID_TYPES.include? letter
      @type = letter
    end
    
    def to_s
      case @type
      when 'I' then '****'
      when 'S' then " **\n** "  
      end
    end
    
  end
end