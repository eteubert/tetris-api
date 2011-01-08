module Tetris
  
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