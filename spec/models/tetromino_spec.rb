module Tetris
  class Tetromino
    
    def type
      'I'
    end
    
    def to_s
      '****'
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
end