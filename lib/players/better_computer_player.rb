require_relative "player"
require_relative "computer_move"

class BetterComputerPlayer < ComputerPlayer
  AGGRESSIVE_FACTOR = 0.2
  DEFENSIVE_FACTOR = 0.8
  CENTER_WEIGHT = 0.1
  MOVES_MULTIPLIER = 0.01

  CENTER_SQUARES = [[3,3], [4,4], [3,4], [4,3]]

  def initialize(color, board, level)
    super(color, board)
    @mini_level = level
    @df = (color == :black)? 0.7 : 0.9
  end

  private

  def get_best_move
    level = piece_count < 17 ? @mini_level : 1
    move_map = create_move_array(@color, @board, level)

    move_map = move_map.sort_by!{|move| move.value}.reverse
    best_moves = move_map.select{|move| move.value == move_map.first.value}
    to_make = best_moves.sample

    [to_make.start_pos, to_make.end_pos]
  end

  def minimax_value(move, piece, color, board, level)
    opponent_color = color == :white ? :black : :white
    test_board = move_test_board(piece, move, board)
    opponent_moves = create_move_array(opponent_color, test_board, level - 1)

    return -1000000 unless opponent_moves.size > 0

    opponent_moves.sort_by!{|move| move.value}.last.value
  end

  def create_move_array(color, board, level = 0)
    move_map = []

    pieces = board.my_pieces(color)

    pieces.each do |piece|
      piece.valid_moves.each do |piece_move|
        value = level > 0 ? -minimax_value(piece_move, piece, color, board, level) :
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

  def piece_count
    @board.grid.flatten.select{|piece| piece.class != NullPiece}.count
  end

  def board_score(board, color)
    opponent_color = (color == :white) ? :black : :white
    return 1000 if board.find_king(opponent_color).nil? || board.checkmate?(opponent_color)

    score = 0
    score += (material_value(board, color) - material_value(board, opponent_color))
    score -= @df * threatened_total(board, color)
    score += AGGRESSIVE_FACTOR * threatened_total(board, opponent_color)
    score += CENTER_WEIGHT * center_control(board, color)
    score += CENTER_WEIGHT * 0.5 * center_threat(board, color)
    score += MOVES_MULTIPLIER * open_moves(board, color)
    score
  end

  def center_control(board, color)
    control_score = 0
    CENTER_SQUARES.each do |pos|
      control_score += 1 if board[pos].color == color
      control_score -= 1 if board[pos].color != color &&
        !board[pos].color.nil?
    end

    control_score
  end

  def center_threat(board, color)
    center_squares_threatened = []

    board.my_pieces(color).each do |piece|
      piece.valid_moves.each do |move|
        center_squares_threatened << move if CENTER_SQUARES.include?(move)
      end
    end

    center_squares_threatened.uniq.size
  end

  def open_moves(board, color)
    total_open = 0
    pieces = board.my_pieces(color)

    pieces.each{|piece| total_open += piece.valid_moves.size}
    total_open
  end

end
