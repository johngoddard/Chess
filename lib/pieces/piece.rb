require 'singleton'

class Piece
  attr_reader :color
  attr_accessor :pos

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
  end

  def moves
  end

  def dup(board)
    return self.class.new(@color, @pos, board)
  end

  def valid_moves
    test_moves = self.moves

    test_moves.reject do |m|
      test_board = @board.dup
      test_board.move(@pos, m)
      test_board.threatened?(test_board.find_king(@color).pos, @color)
    end
  end

end

class NullPiece < Piece
  include Singleton

  def initialize()
    @color = nil
  end

  def to_s
    "   "
  end

  def symbol
    nil
  end

  def moves
    []
  end

  def color
    nil
  end

  def dup(board)
    self
  end

end
