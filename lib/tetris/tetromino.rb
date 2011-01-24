require 'tetris/tetromino_types'

module Tetris
  
  class Tetromino
    include TetrominoTypes
    
    attr_reader :type, :type_letter
    
    VALID_TYPES = %w[I J S T Z L O]
    
    def initialize(type = nil)
      self.type_letter = type || 'I'
      @rotation_index = 0
    end
    
    def type_letter=(letter)
      
      @type = type_object_by_letter(letter)
      
      @type_letter = letter
    end
    
    def type_object_by_letter(letter)
      case letter
        when "I" then TYPE_I
        when "J" then TYPE_J
        when "S" then TYPE_S
        when "T" then TYPE_T
        when "Z" then TYPE_Z
        when "L" then TYPE_L
        when "O" then TYPE_O
        else raise 'invalid tetromino type'
      end
    end
    
    def get
      @type[@rotation_index]
    end
    
    def to_s
      display(@type[@rotation_index])
    end
    
    def display(tetromino)
      result = ''
      
      tetromino.each do |row|
        row.each do |block|
          if block > 0
            result << '*'
          else
            result << ' '
          end
        end
        result << "\n"
      end
      
      result
    end
    
    def rotation_states
      type_object_by_letter(@type_letter)
    end
    
    def rotate
      @rotation_index = (@rotation_index + 1) % rotation_states.length
      self
    end
    
    def self.generate_random
      random_index = (VALID_TYPES.length * rand).floor
      random_type = VALID_TYPES.at(random_index)
      tm = Tetromino.new(random_type)
      tm
    end
    
  end
  
end