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
    announcement ||= nil

    until moves.size == 2
#      debugger
      @display.render(announcement)
      puts("#{@color.to_s}'s turn")
      puts "#{@color} is in check!" if @board.in_check?(@color)

      player_move = @display.get_input
      moves << player_move unless player_move.nil?
    end

    valid_move?(moves[0], moves[1])

    @board.move(moves[0], moves[1])
  rescue => e
      announcement = e.message
      puts e.backtrace
      retry
  end

  def valid_move?(start_pos, end_pos)
    piece_to_move = @board[start_pos]
    possible_moves = piece_to_move.moves

    raise PieceNoMoveError.new(possible_moves) unless possible_moves.include?(end_pos)
    raise unless piece_to_move.moves.include?(end_pos) && piece_to_move.color == @color
  end
end

class PieceNoMoveError < StandardError
  def initialize(moves)
    @moves = moves
  end

  def message
    "Piece did not have move -- valid moves: #{@moves}"
  end
end
