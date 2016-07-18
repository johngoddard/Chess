require_relative "board"

class Game

  def initialize()
    @board = Board.new
    @player1 = HumanPlayer.new(:white, @board)
    @player2 = HumanPlayer.new(:black, @board)
  end

  def play
#    b = Board.new
#    p1 = HumanPlayer.new(:white, b)
    while true
      @player1.make_move
    end
  end

end

g = Game.new
g.play
