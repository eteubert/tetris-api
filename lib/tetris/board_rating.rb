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
          # skip occupied cells
          next if block == 1
          
          # +1 if there is at least one occupied above
          holes = holes + 1 if row_index.times.any? do |i|
            @board.board[i][column_index] == 1
          end
          
        end
      end
      
      holes
    end
    
    # Connectd Holes: Same as Holes above, however vertically connected unoccupied cells only count as one hole.
    def connected_holes
      holes = 0
      
      @board.columns.each_with_index do |row, row_index|
        an_occupied_block = false
        row.each_with_index do |block, column_index|
          if !an_occupied_block
            if block == 1
              an_occupied_block = true
            end
          else
            if block == 0
              holes = holes + 1
              an_occupied_block = false
            end
          end
        end
      end
      
      holes
    end
    
    # Removed Lines: The number of lines that were cleared in the last step to get to the current board.
    def removed_lines
      @board.previously_removed_lines
    end
    
    # Altitude Difference: The difference between the highest occupied and lowest free cell that are directly reachable from the top.
    def altitude_difference
      altitudes = []
      @board.columns.each do |column|
        continue_counting = true
        empty_from_top = column.inject(0) do |sum, block|
          continue_counting = false if block == 1
          if continue_counting
            sum + 1
          else
            sum
          end
        end
        altitudes << (@board.dimensions.height - empty_from_top)
      end
      
      altitudes.max - altitudes.min
    end
    
  end
  
end