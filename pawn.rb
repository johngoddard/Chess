require_relative "piece"

class Pawn < Piece

  def moves
    forward_steps + side_attacks
  end

  def symbol
     :pawn
  end

  protected

  def at_start_row?
    if @pos[0] == 6 && @color == :white
      true
    elsif @pos[0] == 1 && @color == :black
      true
    else
      false
    end
  end

  def forward_dir
    @color == :white ? -1 : 1
  end

  def forward_steps
    forward_moves = []

    one_step = [@pos[0] + forward_dir, @pos[1]]
    forward_moves << one_step unless !@board.in_bounds?(one_step) || !@board[one_step].symbol.nil? 

    if at_start_row? && forward_moves.size == 1
      two_step = [2*forward_dir+@pos[0], @pos[1]]
      forward_moves << two_step unless !@board[two_step].symbol.nil?
    end

    forward_moves
  end

  def side_attacks
    side_arr = []

    side1 = @board[[@pos[0] + forward_dir, @pos[1] + 1]]
    side2 = @board[[@pos[0] + forward_dir, @pos[1] - 1]]

    if !side1.nil? && side1.color != nil && side1.color != self.color
      side_arr << side1.pos
    end

    if !side2.nil? && side2.color != nil && side2.color != self.color
      side_arr << side2.pos
    end
    side_arr
  end

end
