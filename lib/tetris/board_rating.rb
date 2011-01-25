module Tetris
  
  class BoardRating
    
    def initialize(board)
      @board = board
    end
    
    # Pile Height: The row of the highest occupied cell in the board.
    def pile_height
      empty_lines_on_top = 0
      
      @board.rows.each do |row|
        if row.all? { |c| c == 0 }
          empty_lines_on_top = empty_lines_on_top + 1
        else
          break
        end
      end
      
      return @board.dimensions.height - empty_lines_on_top
    end
    
    # Holes: The number of all unoccupied cells that have at least one occupied above them.
    def holes
      holes = 0
      @board.rows.each_with_index do |row, row_index|
        row.each_with_index do |block, column_index|
          next if block == 1
          
          holes = holes + 1 if row_index.times.any? do |i|
            @board.board[i][column_index] == 1
          end
          
        end
      end
      
      holes
    end
    
  end
  
end