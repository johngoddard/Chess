module Stepable

  def moves
    all_moves = move_diffs.map{|diff| [@pos[0] + diff[0], @pos[1] + diff[1]]}
    all_moves.select{|move| @board.in_bounds?(move) && @board[move].color != @color}
  end

  private

  def move_diffs
    self.move_diffs
  end
end
