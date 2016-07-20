require_relative "board"
require_relative "players/player"
require_relative "players/computer_player"
require_relative "players/better_computer_player"

class Game
  attr_reader :current_player

  def initialize(player1, player2)
    @board = Board.new()
    @player1 = handle_player_string(player1, 1)
    @player2 = handle_player_string(player2, 2)
    @current_player = @player1
  end

  def play
    until @board.checkmate?(:white) || @board.checkmate?(:black)
      @current_player.make_move
      switch_players!
    end

    switch_players!
    @board.display.valid_moves = []
    @board.render(true)
    puts "#{current_player.color} wins!"
  end

  private

  def handle_player_string(player_string, player_num)
    colors = [:white, :black]
    player_color = colors[player_num - 1]

    case player_string
    when "h"
      return HumanPlayer.new(player_color, @board)
    when "c"
      return ComputerPlayer.new(player_color, @board)
    when "b"
      return BetterComputerPlayer.new(player_color, @board)
    else
      raise
    end
  end

  def switch_players!
    @current_player = (@current_player == @player1) ? @player2 : @player1
  end

end

if $PROGRAM_NAME == __FILE__
  g = Game.new(ARGV[0], ARGV[1])
  g.play
end
