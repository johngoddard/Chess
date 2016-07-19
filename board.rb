require_relative "piece"
require_relative "display"
require_relative "player"
require_relative "rook"
require_relative "knight"
require_relative "bishop"
require_relative "queen"
require_relative "king"
require_relative "pawn"

class Board
  attr_reader :grid, :display

  def initialize()
    @grid = Array.new(8) {Array.new(8) {NullPiece.instance()}}
    @display = Display.new(self)
    populate
  end

  def move(start_pos, end_pos)
    raise if self[start_pos] == nil
    to_move = self[start_pos]

    self[end_pos] = to_move
    self[start_pos] = NullPiece.instance()

    to_move.pos = end_pos
  end

  def [](pos)
    row, col = pos
    @grid[row][col]
  end

  def []=(pos, value)
    row, col = pos
    @grid[row][col] = value
  end

  def render(over = false)
    @display.render
    @display.get_input unless over
  end

  def in_bounds?(pos)
    pos.all?{|n| n.between?(0,7)}
  end

  def in_check?(color)
    threatened_square = find_king(color).pos
    valid_moves_array = []

    color == :black ? color = :white : color = :black

    my_pieces(color).each {|piece| valid_moves_array += piece.moves}

    return true if valid_moves_array.include?(threatened_square)
    false
  end

  def checkmate?(color)
    if self.in_check?(color)
      my_pieces(color).each{|piece| return false if piece.valid_moves.size > 0}
      true
    else
      false
    end
  end

  def dup
    dup_board = Board.new

    @grid.each_with_index do |row, i|
      row.each_with_index do |piece, j|
        dup_board[[i,j]] = piece.dup(dup_board)
      end
    end

    dup_board
  end

  private

  def populate
    @grid.each_with_index do |row, idx|
      if [0, 7].include?(idx)
        back_row(idx)
      elsif [1, 6].include?(idx)
        i = 0
        color = :white
        color = :black if idx == 1
        while i < 8
          @grid[idx][i] = Pawn.new(color, [idx, i], self)
          i += 1
        end
      end
    end
  end

  def back_row(row)
    color = :white
    color = :black if row == 0
    @grid[row] = [Rook.new(color, [row, 0], self), Knight.new(color, [row, 1], self),
      Bishop.new(color, [row, 2], self), Queen.new(color, [row, 3], self), King.new(color, [row, 4], self),
      Bishop.new(color, [row, 5], self), Knight.new(color, [row, 6], self), Rook.new(color, [row, 7], self)]
  end

  def find_king(color)
    my_pieces(color).select{|piece| piece.class == King}.first
  end

  def my_pieces(color)
    @grid.flatten.select { |piece| piece.color == color}
  end

end
