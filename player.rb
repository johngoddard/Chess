require "byebug"


class Player
  attr_reader :color

  def initialize(color, board)
    @color = color
    @board = board
    @display = board.display
  end
end

class HumanPlayer < Player

  def initialize(color, board)
    super
  end

  def make_move
    moves = []

    until moves.size == 2
#      debugger
      @display.render
      player_move = @display.get_input
      moves << player_move unless player_move.nil?
    end

    @board.move(moves[0], moves[1])
  end
end
