module Tetris
  
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