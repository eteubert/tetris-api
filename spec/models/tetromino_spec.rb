module Tetris
  class Tetromino
    
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
end