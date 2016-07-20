require_relative "player"
require_relative "computer_move"

class ComputerPlayer < Player
  MAP_OF_PIECE_VALS = {
    :queen => 9,
    :king => 12,
    :bishop => 3,
    :knight => 3,
    :rook => 5,
    :pawn => 1
  }

  AGGRESSIVE_FACTOR = 0.2

  def initialize(color, board)
    super
    @opponent_color = (@color == :white) ? :black : :white
  end

  def make_move
    @board.display.cursor_pos = nil
    @board.display.render
    # sleep(.5)

    best_move = get_best_move
    @board.move(best_move[0], best_move[1])
  end

  private

  def move_value(move, piece)
    return 100 if move_is_checkmate?(move, piece)
    move_val = 0

    if @board[move].color == @opponent_color
      move_val = MAP_OF_PIECE_VALS[@board[move].symbol]
    end

    move_val += 8 if pawn_promotion?(move, piece)
    move_val -= MAP_OF_PIECE_VALS[piece.symbol] if threatened?(move, piece)
    move_val += threatened_difference(move, piece, @color)
    move_val -= AGGRESSIVE_FACTOR * threatened_difference(move, piece, @opponent_color)

    move_val
  end

  def threatened_difference(move, piece, color)
    current_threat = threatened_total(@board, color)
    dup_board = move_test_board(piece, move,)
    current_threat - threatened_total(dup_board, color)
  end

  def move_test_board(piece, move)
    dup_board = @board.dup
    dup_board.move(piece.pos, move)
    dup_board
  end

  def threatened?(move, piece)
    dup_board = move_test_board(piece, move)
    dup_board.threatened?(move, @color)
  end

  def get_best_move
    move_map = create_move_array(@color, @board)

    move_map = move_map.sort_by!{|move| move.value}.reverse
    best_moves = move_map.select{|move| move.value == move_map.first.value}
    to_make = best_moves.sample

    [to_make.start_pos, to_make.end_pos]
  end

  def create_move_array(color, board)
    move_map = []

    pieces = board.my_pieces(color)

    pieces.each do |piece|
      piece.valid_moves.each do |piece_move|
        value = move_value(piece_move, piece)
        move_map << ComputerMove.new(piece.pos, piece_move, value)
      end
    end

    move_map
  end

  def material_value(board, color)
    total = 0
    board.my_pieces(color).each{|piece| total += MAP_OF_PIECE_VALS[piece.symbol]}
    total
  end

  def move_is_check?(move, piece)
    dup_board = move_test_board(piece, move)
    dup_board.threatened?(@board.find_king(@opponent_color).pos, @opponent_color)
  end

  def move_is_checkmate?(move, piece)
    dup_board = move_test_board(piece, move)
    dup_board.checkmate?(@opponent_color)
  end

  def pawn_promotion?(move, piece)
    @board.pawn_promotion?(piece.pos, move)
  end

  def threatened_total(board, color)
    total = 0
    threatened_pieces = board.my_pieces(color).select{|piece| board.threatened?(piece.pos, color)}
    threatened_pieces.each{|piece| total += MAP_OF_PIECE_VALS[piece.symbol]}
    total
  end
end
