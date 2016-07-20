class PieceNoMoveError < StandardError
  def initialize(moves, piece)
    @moves = moves
    @piece = piece
  end

  def message
    return "#{@piece.class} at #{@piece.pos} did not have that move -- valid moves: #{@moves}"
  end
end

class NotYourPieceError < StandardError
  def initialize(piece)
    @piece = piece
  end

  def message
    return "There is no piece at that square" if @piece.class == NullPiece
    "That piece is not yours"
  end

end
