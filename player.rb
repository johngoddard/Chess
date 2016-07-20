require "byebug"


class Player
  attr_reader :color

  def initialize(color, board)
    @color = color
    @board = board
  end
end

class HumanPlayer < Player
  attr_accessor :announcement

  def initialize(color, board)
    super
    @display = board.display
    @previous_move = [0,0]
  end

  def make_move
    @display.cursor_pos = @previous_move
    moves = []


    until moves.size == 2
      @display.render
      make_announcements

      player_move = @display.get_input
      moves << player_move unless player_move.nil?
      @display.valid_moves = @board[moves[0]].valid_moves if moves.size == 1
    end

    valid_move?(moves[0], moves[1])

    @announcement = nil
    @previous_move = moves[1]
    @display.valid_moves = []
    @board.move(moves[0], moves[1])

  rescue => e
      @announcement = e.message
      retry
  end

  private

  def valid_move?(start_pos, end_pos)
    piece_to_move = @board[start_pos]
    possible_moves = piece_to_move.valid_moves

    raise NotYourPieceError.new(piece_to_move) unless piece_to_move.color == @color
    raise PieceNoMoveError.new(possible_moves, piece_to_move) unless possible_moves.include?(end_pos)
  end

  def make_announcements
    puts("#{@color.to_s}'s turn")
    puts "#{@color} is in check!" if @board.threatened?(@board.find_king(@color).pos, @color)
    puts @announcement unless @announcement.nil?
  end

end

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
