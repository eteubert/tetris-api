module Tetris
  class Tetromino
    
    attr_reader :type
    
    VALID_TYPES = %w[I J S T Z L O]
    
    def initialize
      @type = 'I'
    end
    
    def type=(letter)
      raise 'invalit tetromino type' unless VALID_TYPES.include? letter
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

describe Tetris::Tetromino do
  it "should be printable" do
    tm = Tetris::Tetromino.new
    tm.to_s.should eql("****")
  end
  
  it "should have a type which is a letter representing the form" do
      tm = Tetris::Tetromino.new 
      tm.type.should eql("I")
  end
  
  it "should be possible to change the type" do
      tm = Tetris::Tetromino.new
      tm.type = 'S'
      tm.to_s.should eql(" **\n** ")
  end
  
  it "should not be possible to set an invalid type" do
    tm = Tetris::Tetromino.new
    lambda { tm.type = 'Q' }.should raise_error  
  end
end