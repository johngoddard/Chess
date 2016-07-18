require 'singleton'

class Piece

  WHITE_PIECE_STRINGS = {
    :king => "\u{2654}",
    :queen => "\u{2655}",
    :rook => "\u{2656}",
    :bishop => "\u{2657}",
    :knight => "\u{2658}",
    :pawn => "\u{2659}"
  }

  BLACK_PIECE_STRINGS = {
    :king => "\u{265A}",
    :queen => "\u{265B}",
    :rook => "\u{265C}",
    :bishop => "\u{265D}",
    :knight => "\u{265E}",
    :pawn => "\u{265F}"
  }

  def initialize(color, position, board)
    @color = color
    @pos = position
    @board = board
  end

  def to_s
    piece_string = @color == :white ? WHITE_PIECE_STRINGS[self.symbol] : BLACK_PIECE_STRINGS[self.symbol]
    " #{piece_string} "
  end

  def symbol
    :pawn
  end

  def moves
  end

end

class NullPiece < Piece
  include Singleton

  def initialize()
  end

  def to_s
    "   "
  end

  def symbol
  end

  def moves
  end

end
