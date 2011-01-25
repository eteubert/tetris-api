class Object
   def deep_copy( object )
     Marshal.load( Marshal.dump( object ) )
   end
end

module Tetris
  
  class Board
    attr_reader :dimensions, :lines_cleared, :next_tetromino
    attr_accessor :current_tetromino, :board
    
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
      
      deep_copy(@board).unshift(Array.new(@board.length,1)).each_with_index do |row_obj, row|
        row_obj = row_obj # so the unshifting doesnt affect the board directly
        row_obj.unshift(1).each_with_index do |column_obj, column|
          column = column - 1 # simulates one col next to board (left)
          row = row - 1       # simulates one row above board


          # can tetromino be placed here?
          status = STATUS_YES
          @tm = @current_tetromino.get;
          
          @tm.each_with_index do |tm_row_obj, tm_row|
            tm_row_obj.each_with_index do |tm_column_obj, tm_column|
              next if @tm[tm_row][tm_column] == 0
              
              # block below
              if @board[row + tm_row] == nil
                status = STATUS_NO unless @tm[tm_row].all? { |i| i == 0 }
                next
              end
              
              # block beyond the right edge of the field
              if @board[row + tm_row][column + tm_column] == nil
                status = STATUS_NO unless @tm[tm_row][tm_column] == 0
              end
              
              if @board[row + tm_row][column + tm_column] == 1
                status = STATUS_NO # skipping whole loop would be great
              end
              
              # block beyond the left edge of the field
              if tm_column + column < 0 && @tm[tm_row][tm_column] > 0
                status = STATUS_NO
              end
              
              # so there is enough space here, great
              # but is there any ground below?
              # only check bottom row
              if status == STATUS_YES
                status = STATUS_NO
                (@tm.count-1).downto(0) do |row_i|
                  next if @tm[row_i].all? { |i| i == 0 }

                  @tm[row_i].each_with_index do |col_j_obj, col_j|
                    if @tm[row_i][col_j] > 0
                      if @board[row + row_i + 1] == nil
                        status = STATUS_YES
                        break
                      end
                      if @board[row + row_i + 1][column + col_j] == 1
                        status = STATUS_YES
                        break
                      end
                    end
                  end

                  break
                end
              end
              
            end
          end
          
          if status == STATUS_YES
            # that one fits
            # change the board and add it to possibilities
            possible_board = deep_copy(self)
            @tm.each_with_index do |tm_row_obj2, tm_row2|
              tm_row_obj2.each_with_index do |tm_column2_obj, tm_column2|
                if @tm[tm_row2][tm_column2] > 0
                  possible_board.board[row + tm_row2][column + tm_column2] = 1
                  # puts "possible_board.board[#{row + tm_row2}][#{column + tm_column2}]"
                end
                
              end
            end
            
            possibilities << possible_board
          end
          
        end
      end

      possibilities
    end
    
    def display
      
      result = ''
      
      rows.each do |row|
        row.each do |column|
          if column == 1
            result << '1'
          else
            result << "0"
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

    end
    
    def remove_complete_lines
      rows.each_with_index do |row, row_index|
        if row.present? && row.all? {|r| r == 1}
          # remove row
          @board[row_index] = nil 
          # add new empty row
          @board.unshift(Array.new(@dimensions.width ,0))
        end
      end
      
      # remove nil rows
      @board.compact!
    end
    
  end
  
end