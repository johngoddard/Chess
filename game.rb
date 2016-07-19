require_relative "board"

class Game
  attr_reader :current_player
  
  def initialize()
    @board = Board.new(self)
    @player1 = HumanPlayer.new(:white, @board)
    @player2 = HumanPlayer.new(:black, @board)
    @current_player = @player1
  end

  def play
    while true
      @current_player.make_move
      switch_players!
    end
  end

  def switch_players!
    if @current_player == @player2
      @current_player = @player1
    else
      @current_player = @player2
    end
  end

end

g = Game.new
g.play
