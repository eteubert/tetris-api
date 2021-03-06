class Object
   def deep_copy( object )
     Marshal.load( Marshal.dump( object ) )
   end
end

module Tetris
  
  class Board
    attr_reader :dimensions, :lines_cleared, :next_tetromino
    attr_accessor :current_tetromino, :next_tetromino, :board, :previously_removed_lines, :landing_height, :parent
    
    STATUS_YES = 1
    STATUS_NO = 0
    
    def initialize(dimensions = nil)
      @dimensions = dimensions || Dimensions.new
      @board = Array.new(@dimensions.height)
      @board.each_with_index do |a, i|
        @board[i] = Array.new(@dimensions.width, 0)
      end
      @lines_cleared = 0
      @current_tetromino = Tetromino.generate_random
      @next_tetromino = Tetromino.generate_random
      @lost = false
      @landing_height = 0
      # parent board
      @parent = nil
    end
    
    def lost?
      @lost
    end
    
    # set exact coordinate to 1
    # return self so it can be chained
    def set(x,y)
      @board[x][y] = 1
      return self
    end
    
    # string of 0 and 1 representing board state
    def state_hash
      @board.flatten.join
    end
    
    def unique_possibilities(possibilities)
      possibilities.uniq {|p| p.state_hash}
    end
    
    def generate_possibilities_for_both_tetrominos
      possibilities = []
      
      boards_for_cur_tm = generate_possibilities_for_current_tetromino_including_variants
      boards_for_cur_tm.each do |b|
        # b.current_tetromino = next_tetromino
        lines_deleted_in_first_iteration = b.previously_removed_lines
        possibilities << b.generate_possibilities_for_current_tetromino_including_variants
        # remember deleted lines for both tetrominos
        b.previously_removed_lines = b.previously_removed_lines + lines_deleted_in_first_iteration
      end
      
      unique_possibilities possibilities.flatten
    end
    
    def generate_possibilities_for_current_tetromino_including_variants
      possibilities = []
      
      @current_tetromino.rotation_states.length.times do
        @current_tetromino.rotate
        possibilities << generate_possibilities_for_current_tetromino
      end
      
      p = unique_possibilities(possibilities.flatten)
      
      if p.empty?
        @lost = true
      end
      
      p
    end
    
    def generate_possibilities_for_current_tetromino
      possibilities = []
      
      @hole_coordinates = hole_coordinates
      
      # now iterate over whole board
      for_each_row do |row_obj, row|
        @tm_was_placed_somewhere_in_that_row = STATUS_NO
        for_each_block_in_row(row_obj, row) do |column_obj, column, row|

          # can tetromino be placed here?
          status = can_tetromino_be_placed_here? :at_row => row, :at_column => column
          
          if status == STATUS_YES
            # that one fits
            # change the board and add it to possibilities
            possible_board = get_board_with_tetromino_placed :at_row => row, :at_column => column
            possibilities << possible_board
          end  
                  
        end # iterate over blocks in rows
        
        # we now have iterated over all blocks in that row
        # in case we were not able to place it here, we cannot get past this line
        if @tm_was_placed_somewhere_in_that_row == STATUS_NO
          break
        end
        
      end # iterate over rows

      possibilities
    end
    
    def display
      
      result = ""
      
      rows.each do |row|
        row.each do |column|
          if column == 1
            # result << "\xe2\x96\xa0"
            # result << "\xe2\x97\xbc"
            result << "\342\226\210"
          else
            # result << "\xe2\x96\xa1"
            # result << "\xe2\x97\xbb"
            result << "\342\226\221"
          end
        end
        result << "\n"
      end
      
      puts result << "\n"
    end
    
    def rows
      @board
    end
    
    def columns
      @board.transpose
    end
    
    def remove_complete_lines
      full_row = Array.new(@dimensions.width, 1)
      # delete all complete lines
      @board.delete(full_row)
      # memorize amount of deleted lines
      @previously_removed_lines = @dimensions.height - @board.length
      @lines_cleared += @previously_removed_lines
      # drop in a new line for each removed line
      @previously_removed_lines.times do
         @board.unshift(Array.new(@dimensions.width, 0))
      end
    end
    
    def hole_coordinates
      return @hole_coordinates unless @hole_coordinates.nil?
      
      @hole_coordinates = []
      rows.each_with_index do |row, row_index|
        row.each_with_index do |block, column_index|
          # skip occupied cells
          next if block == 1
    
          # +1 if there is at least one occupied above
          @hole_coordinates << [row_index, column_index] if row_index.times.any? do |i|
            @board[i][column_index] == 1
          end
    
        end
      end
      
      return @hole_coordinates
    end
    
    private
    
    def can_tetromino_be_placed_here?(values)
      row = values[:at_row]
      column = values[:at_column]
      
      status = STATUS_YES
      @tm = @current_tetromino.get;
      @tm.each_with_index do |tm_row_obj, tm_row|
        tm_row_obj.each_with_index do |tm_column_obj, tm_column|
          next if @tm[tm_row][tm_column] == 0

          # block is below the field below
          if @board[row + tm_row] == nil
            return STATUS_NO unless @tm[tm_row].all? { |i| i == 0 }
          end
          
          # block beyond the right edge of the field
          if @board[row + tm_row][column + tm_column] == nil
            return STATUS_NO unless @tm[tm_row][tm_column] == 0
          end
          
          if @board[row + tm_row][column + tm_column] == 1
            return STATUS_NO
          end
          
          # block beyond the left edge of the field
          if tm_column + column < 0 && @tm[tm_row][tm_column] > 0
            return STATUS_NO
          end
          
          # tm must not occupy a hole
          if @hole_coordinates.include? [row + tm_row, column + tm_column]
            return STATUS_NO
          end
          
          # so there is enough space here
          @tm_was_placed_somewhere_in_that_row = STATUS_YES
          status = tetromino_sticky?(@tm, row, column)
        end
      end
      
      return status
    end
    
    def get_board_with_tetromino_placed(values)
      row = values[:at_row]
      column = values[:at_column]
      
      possible_board = deep_copy(self)
      possible_board.parent = self
      possible_board.landing_height = 0
      @tm.each_with_index do |tm_row_obj, tm_row|
        tm_row_obj.each_with_index do |tm_column_obj, tm_column|
          if @tm[tm_row][tm_column] > 0
            possible_board.board[row + tm_row][column + tm_column] = 1
            possible_board.landing_height = row + tm_row if row + tm_row > possible_board.landing_height
          end
        end
      end
      
      # forward tetrominos
      possible_board.current_tetromino = deep_copy(possible_board.next_tetromino)
      possible_board.next_tetromino = Tetromino.generate_random
      
      possible_board.remove_complete_lines
      
      possible_board
    end
    
    # there must be at least one block below the TM
    def tetromino_sticky?(tm, row, column)
      (tm.count-1).downto(0) do |row_i|
        next if tm[row_i].all? { |i| i == 0 }

        tm[row_i].each_with_index do |col_j_obj, col_j|
          if tm[row_i][col_j] > 0
            if @board[row + row_i + 1] == nil
              return STATUS_YES
            end
            if @board[row + row_i + 1][column + col_j] == 1
              return STATUS_YES
            end
          end
        end

        break
      end
      
      return STATUS_NO
    end
    
    def for_each_row
      deep_copy(@board).unshift(Array.new(@board.length,1)).each_with_index do |row_obj, row|
        row = row - 1       # simulates one row above board
        
        yield row_obj, row
      end
    end
    
    def for_each_block_in_row(row_obj, row)
      row_obj.unshift(1).each_with_index do |column_obj, column|
        column = column - 1 # simulates one col next to board (left)
        
        yield column_obj, column, row
      end
    end
    
  end
  
end