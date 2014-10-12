class Sudoku
  attr_accessor :board, :guessed_positions
  def initialize(board)
    @board = board
    @guessed_positions = {}
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
  
  def next_possible_index(pos)
    guessed_positions[pos].nil? ? 0 : guessed_positions[pos] + 1
  end
  
  def next_possible_guess(pos)
    possibilities(pos)[next_possible_index(pos)]
  end
  
  def no_more_possibilities?(pos)
    next_possible_guess(pos).nil?
  end
  
  def guess(pos)
    board[pos] = next_possible_guess(pos)
    guessed_positions[pos] = next_possible_index(pos)
  end
  
  def backtrack(pos)
    guessed_positions.delete(pos)
  end
  
  def next_blank_position
    board.index('0')
  end
  
  def last_guessed_position
    guessed_positions.keys.max
  end

  def solve!(position=nil)
    position = board.index('0') if position.nil?
    board[position] = '0'
    unless no_more_possibilities?(position)
      guess(position)
      next_position = next_blank_position 
    else
      backtrack(position)
      next_position = last_guessed_position
    end
    solve!(next_position) until solved?
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

game = Sudoku.new('080020000040500320020309046600090004000640501134050700360004002407230600000700450')
puts "UNSOLVED BOARD"
SudokuView.print_board(game.board)
game.solve!
puts "SOLVED BOARD"
SudokuView.print_board(game.board)

