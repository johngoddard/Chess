require 'colorize'
require_relative 'board'
require_relative 'cursorable'
require 'byebug'

class Display
  include Cursorable

  def initialize(board)
    @board = board
    @cursor_pos = [0,0]
  end

  def build_grid
    rows_to_print = []
    @board.grid.each_with_index do |row, i|
      rows_to_print << build_row(row, i)
    end
    rows_to_print
  end

  def build_row(row, i)
    row_string = ""
    # debugger if i > 1
    row.each_with_index do |piece , i|
      piece.nil? ? row_string << "_" : row_string << piece.to_s
    end
    row_string
  end

  def render
    system("clear")
    build_grid.each{|row| puts row}
  end
end
