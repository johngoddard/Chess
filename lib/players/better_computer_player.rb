require_relative "player"
require_relative "computer_move"

class BetterComputerPlayer < ComputerPlayer
  AGGRESSIVE_FACTOR = 0.2

  def initialize(color, board)
    super
  end

  private

  def minimax_value(move, piece, color, board)
    test_board = move_test_board(piece, move, board)
    opponent_moves = create_move_array(@opponent_color, test_board, false)

    return -1000000 unless opponent_moves.size > 0

    opponent_moves.sort_by!{|move| move.value}.last.value
  end

  def create_move_array(color, board, mini = true)
    move_map = []

    pieces = board.my_pieces(color)

    pieces.each do |piece|
      piece.valid_moves.each do |piece_move|
        value = mini ? -minimax_value(piece_move, piece, color, board) :
          board_score(move_test_board(piece, piece_move, board), color)
        move_map << ComputerMove.new(piece.pos, piece_move, value)
      end
    end

    move_map
  end

  def move_test_board(piece, move, board)
    dup_board = board.dup
    dup_board.move(piece.pos, move)
    dup_board
  end


end
