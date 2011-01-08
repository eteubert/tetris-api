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
    
    def self.generate_random
      random_index = (VALID_TYPES.length * rand).floor
      random_type = VALID_TYPES.at(random_index)
      tm = Tetromino.new
      tm.type = random_type
      tm
    end
    
  end
  
end