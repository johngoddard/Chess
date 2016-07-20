require_relative "player"

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
    sleep(1)

    best_move = get_best_move
    @board.move(best_move[0], best_move[1])
  end

  def move_value(move, piece)
    return 100 if move_is_checkmate?(move, piece)
    move_val = 0

    if @board[move].color == @opponent_color
      move_val = MAP_OF_PIECE_VALS[@board[move].symbol]
    end

    move_val += 1 if pawn_promotion?(move, piece)
    move_val -= MAP_OF_PIECE_VALS[piece.symbol] if threatened?(move, piece)
    move_val += threatened_difference(move, piece, @color)
    move_val -= AGGRESSIVE_FACTOR * threatened_difference(move, piece, @opponent_color)

    move_val
  end

  private

  def threatened_difference(move, piece, color)
    current_threat = threatened_total(@board, color)
    dup_board = move_test_board(piece, move)
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
    piece_to_move = nil
    end_pos = nil
    best_move_val = 0
    all_moves = []
    zero_moves = []

    pieces = @board.my_pieces(@color)
    pieces.each do |the_piece|
      the_piece.valid_moves.each do |piece_move|
        if move_value(piece_move, the_piece) > best_move_val
          best_move_val = move_value(piece_move, the_piece)
          piece_to_move = the_piece
          end_pos = piece_move
        end

        zero_moves << [the_piece, piece_move] if move_value(piece_move, the_piece) == 0
        all_moves << [the_piece, piece_move]
      end
    end

    if best_move_val > 0
      return [piece_to_move.pos, end_pos]
    elsif zero_moves.size > 0
      move_to_make = zero_moves.sample
      return [move_to_make[0].pos, move_to_make[1]]
    else
      move_to_make = all_moves.sample
      return [move_to_make[0].pos, move_to_make[1]]
    end

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
