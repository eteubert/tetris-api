require "tetris"

describe Tetris::Tetromino do
  
  before(:each) do
    @tm = Tetris::Tetromino.new
  end
  
  it "should be printable" do
    @tm.to_s.should eql("    \n****\n    \n    \n")
  end
  
  it "should have a type which is a letter representing the form" do
      @tm.type_letter.should eql("I")
  end
  
  it "should be possible to change the type" do
      @tm.type_letter = 'S'
      @tm.to_s.should eql("    \n ** \n**  \n    \n")
  end
  
  it "should not be possible to set an invalid type" do
    lambda { @tm.type_letter = 'Q' }.should raise_error  
  end
  
  it "should be possible to get a random tetromino" do
    Tetris::Tetromino.generate_random.should be_kind_of Tetris::Tetromino
  end
  
  it "should be possible to rotate tetrominos" do
    @tm = Tetris::Tetromino.new('I')
    @tm.rotate.to_s.should eql(" *  \n *  \n *  \n *  \n")
  end
  
  it "should be possible to roate more often than there are states" do
    @tm = Tetris::Tetromino.new('I')
    @tm.rotate.rotate.to_s.should eql(@tm.to_s)
  end
end