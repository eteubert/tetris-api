module Tetris
  
  class BoardRating
    
    RATING_NAMES = [
      "pile_height",
      "holes",
      "connected_holes",
      "removed_lines",
      "altitude_difference",
      "blocks",
      "weighted_blocks",
      "row_transitions",
      "column_transitions",
      "sum_of_all_wells",
      "maximum_well_depth",
      "landing_height"
    ]
    
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
      @board.hole_coordinates.count
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
    
    def blocks
      @board.state_hash.each_char.inject(0) {|sum, block| sum + block.to_i}
    end
    
    # Weighted Blocks (CF): Same as Blocks above, but blocks in row n count n-times as much as blocks in row 1 (counting from bottom to top).
    def weighted_blocks
      sum = 0
      @board.rows.reverse.each_with_index do |row, row_index|
        sum = sum + row.inject(0) {|sum, block| sum + block.to_i} * (row_index + 1)
      end
      sum
    end
    
    # Row Transitions (PD): Sum of all horizontal occupied/unoccupied-transitions on the board. The outside to the left and right counts as occupied.
    def row_transitions
      transitions @board.rows
    end
    
    # Column Transitions (PD): As Row Transitions above, but counts vertical transitions. The outside below the game-board is considered occupied.
    def column_transitions
      transitions @board.columns
    end
    
    # Sum of all Wells (CF): Sum of all wells on the board.
    def sum_of_all_wells
      well_blocks.compact.count
    end
    
    # Maximum Well Depth: The depth of the deepest well (with a width of one) on the board.
    def maximum_well_depth
      wells = well_blocks
      max = wells.compact.map {|column| column.count }.max
      max || 0
    end
    
    # Landing Height (PD): The height at which the last tetramino has been placed.
    def landing_height
      @board.landing_height
    end
    
    private
    
    def well_blocks
      wells = []
      
      @board.columns.each_with_index do |column, column_index|
        column.each_with_index do |block, row_index|
          is_empty                = (block == 0)
          if column_index > 0
            border_on_the_left    = (@board.board[row_index][column_index - 1] == 1)
          else
            border_on_the_left    = true
          end
          if column_index < @board.dimensions.width - 1
            border_on_the_right   = (@board.board[row_index][column_index + 1] == 1)
          else
            border_on_the_right   = true
          end
          
          is_well_block = is_empty && border_on_the_left && border_on_the_right
          
          if is_well_block
            # above well block must be 0 or end of board
            next unless @board.board[row_index-1][column_index] == 0 || row_index == 0
            if column_index != nil
              wells[column_index] = [] unless wells[column_index]
              wells[column_index] << row_index 
            end
          end
          
        end
      end
      
      # now remove all well blocks that are no real wells
      
      # workaround to have a column index in the loop
      column_index = -1
      wells.map! do |column|
        column_index = column_index + 1
        valid_well = column != nil

        if valid_well
          # well-blocks must not have 
          # an occupied block above them
          valid_well = true
          column.each do |row|
            (row-1).downto(0) do |row_index|
              if @board.board[row_index][column_index] == 1
                valid_well = false
              end
            end
          end
        end
        
        (valid_well) ? column : nil
      end
      
      wells
    end
    
    def transitions(array)
      sum = 0
      array.each_with_index do |row, row_index|
        # first column
        sum = sum + 1 if row.first == 0
        # last column
        sum = sum + 1 if row.last == 0
        row.each_with_index do |block, column_index|
          # general case without first and last column
          if block != row[column_index + 1] && row[column_index + 1] != nil
            sum = sum + 1
          end
        end
      end
      sum
    end
    
  end
  
end