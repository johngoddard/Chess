require 'colorize'
require_relative 'cursorable'
require 'byebug'

class Display
  include Cursorable

  attr_accessor :cursor_pos, :valid_moves

  def initialize(board)
    @board = board
    @cursor_pos = nil
    @selected = false
    @valid_moves = []
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
    row.each_with_index do |piece , j|
      color_options = colors_for([i, j])
      row_string << piece.to_s.colorize(color_options)
    end

    row_string
  end

  def colors_for(pos)
    color = @board[pos].color

    if pos == @cursor_pos
      bg =  :light_red
    elsif @valid_moves.include?(pos)
      bg = :green
    elsif (pos[0] + pos[1]).odd?
      bg = :light_blue
    else
      bg = :blue
    end
    { background: bg, color: color}
  end


  def render()
    system("clear")

    build_grid.each{|row| puts row}
  end
end
