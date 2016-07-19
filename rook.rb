require_relative "piece"
require_relative "slideable"

class Rook < Piece
  include Slideable

  def symbol
    :rook
  end

  protected

  def move_dirs
    [[1,0], [-1, 0], [0, -1], [0, 1]]
  end

end
