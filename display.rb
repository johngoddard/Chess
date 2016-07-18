require 'colorize'
require_relative 'cursorable'
require 'byebug'

class Display
  include Cursorable

  def initialize(board)
    @board = board
    @cursor_pos = [0,0]
    @selected = false
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
    if pos == @cursor_pos
      bg =  :light_red
    elsif (pos[0] + pos[1]).odd?
      bg = :light_blue
    else
      bg = :blue
    end
    { background: bg, color: :white}
  end


  def render
    system("clear")

    build_grid.each{|row| puts row}
  end
end
