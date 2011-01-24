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
    end
    
    def generate_possibilities_for_current_tetromino
      possibilities = []
      
      rows.each_with_index do |row_obj, row|
        row_obj = row_obj.clone # so the unshifting doesnt affect the board directly
        row_obj.unshift(1).each_with_index do |column_obj, column|
          column = column - 1 # simulates one line next to board (left)

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
                next
              end

              if @board[row + tm_row][column + tm_column] == 1
                status = STATUS_NO # skipping whole loop would be great
              end
              
              # so there is enough space here, great
              # but is there any ground below?
              # only check bottom row
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
      
      possibilities.each do |b|
        b.display
        puts "\n"
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
    
  end
  
end