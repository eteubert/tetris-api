require "tetris"

describe Tetris::Tetromino do
  
  before(:each) do
    @tm = Tetris::Tetromino.new
  end
  
  it "should be printable" do
    @tm.to_s.should eql("****")
  end
  
  it "should have a type which is a letter representing the form" do
      @tm.type.should eql("I")
  end
  
  it "should be possible to change the type" do
      @tm.type = 'S'
      @tm.to_s.should eql(" **\n** ")
  end
  
  it "should not be possible to set an invalid type" do
    lambda { @tm.type = 'Q' }.should raise_error  
  end
  
  it "should be possible to get a random tetromino" do
    Tetris::Tetromino.generate_random.should be_kind_of Tetris::Tetromino
  end
end