class Sudoku
  attr_accessor :board
  def initialize(board)
    @board = board
  end
  
  def row(pos)
    pos / 9
  end
  
  def column(pos)
    pos % 9
  end
  
  def quadrant(pos)
    {quadrant_row: row(pos) / 3, quadrant_column: column(pos) / 3}
  end
  
  def same_row?(pos1,pos2)
    row(pos1) == row(pos2)
  end
  
  def same_column?(pos1,pos2)
    column(pos1) == column(pos2)
  end
  
  def same_quadrant?(pos1,pos2)
    quadrant(pos1) == quadrant(pos2)
  end
  
  def must_not_equal?(pos1,pos2)
    same_row?(pos1,pos2) || same_column?(pos1,pos2) || same_quadrant?(pos1,pos2)
  end
  
  def possibilities(given_pos)
    no_go = []
    board.split(//).each_with_index do |cell,pos|
      no_go << cell if must_not_equal?(given_pos,pos)
    end
    [*1..9].join.split(//) - no_go
  end
  
  def solved?
    !board.include?('0')
  end

  def solve!
    board.split(//).each_with_index do |cell,position|
      if cell == '0'
        possibilities = possibilities(position)
        board[position] = possibilities[0] if possibilities.size == 1
      end
    end
    until solved?
      solve!
    end
  end
  
end

class SudokuView
  def self.print_board(board)
    puts '-'*23
    board.split(//).each_slice(9).to_a.each_with_index do |row,row_num|
      string = ''
      row.each_with_index do |cell,col|
        ltr = cell == '0' ? '_' : cell  
        addl_string = "#{ltr} "
        if col%3 == 2
          unless col == 8
            addl_string += ' | '
          end
        end
        string += addl_string
      end
      puts string
      if row_num%3 == 2
        puts '-'*23
      end
    end
  end
end


game = Sudoku.new('619030040270061008000047621486302079000014580031009060005720806320106057160400030')
puts "UNSOLVED BOARD"
SudokuView.print_board(game.board)
game.solve!
puts "SOLVED BOARD"
SudokuView.print_board(game.board)

