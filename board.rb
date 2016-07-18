require_relative "piece"
require_relative "display"

class Board
  attr_reader :grid

  def initialize
    @grid = Array.new(8) {Array.new(8)}
    @display = Display.new(self)
    populate
  end

  def populate
    @grid.each_with_index do |row, idx|
      row.each_with_index do |place, idx2|
        if [0,1,6,7].include?(idx)
          row[idx2] = Piece.new()
        end
      end
    end
  end

  def move(start_pos, end_pos)
    raise if self[start_pos] == nil
    to_move = self[start_pos]
    self[end_pos] = to_move
    self[start_pos] = nil
    rescue
      puts "No piece at start position."
#      retry

  end

  def [](pos)
    row, col = pos
    @grid[row][col]
  end

  def []=(pos, value)
    row, col = pos
    @grid[row][col] = value
  end

  def render
    @display.render
  end


end
