require_relative "board"

class Game
  attr_reader :current_player

  def initialize()
    @board = Board.new()
    @player1 = HumanPlayer.new(:white, @board)
    @player2 = HumanPlayer.new(:black, @board)
    @current_player = @player1
  end

  def play
    until @board.checkmate?(:white) || @board.checkmate?(:black)
      @current_player.make_move
      switch_players!
    end

    switch_players!
    @board.render(true)
    puts "#{current_player.color} wins!"
  end

  def switch_players!
    @current_player = (@current_player == @player1) ? @player2 : @player1
  end

end

g = Game.new
g.play
