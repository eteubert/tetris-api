module Tetris
  class Game
    attr_reader :dimensions
    
    def initialize(dimensions = nil)
      @dimensions = dimensions || Dimensions.new
    end
  end
  
  class Dimensions
    attr_accessor :width, :height
    
    def initialize(values = {})
      @width = values[:width] || 10
      @height = values[:height] || 20
    end
    
  end
end

describe Tetris::Game do
  it "should be creatable" do
    game = Tetris::Game.new
  end
  
  it "should have dimensions" do
    game = Tetris::Game.new
    game.dimensions.height.should eql(20)
    game.dimensions.width.should eql(10)
  end
  
  it "should be possible to set custom dimensions" do
    dimensions = Tetris::Dimensions.new({:width => 5, :height => 8})
    game = Tetris::Game.new(dimensions)
    game.dimensions.height.should eql(8)
    game.dimensions.width.should eql(5)
  end
end