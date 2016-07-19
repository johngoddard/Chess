require_relative "player"

class ComputerPlayer < Player
  MAP_OF_PIECE_VALS = {
    :queen => 9,
    :king => 99,
    :bishop => 3,
    :knight => 3,
    :rook => 5,
    :pawn => 1
  }

  def initialize(color, board)
    super
    @opponent_color = (@color == :white) ? :black : :white
  end

  def make_move
    @board.display.render
    sleep(1)
    piece_to_move = nil
    end_pos = nil
    best_move_val = 0
    all_moves = []


    pieces = @board.my_pieces(@color)
    pieces.each do |the_piece|
      the_piece.valid_moves.each do |piece_move|
        if move_value(piece_move, the_piece) > best_move_val
          best_move_val = move_value(piece_move, the_piece)
          piece_to_move = the_piece
          end_pos = piece_move
        end

        all_moves << [the_piece, piece_move]
      end
    end

    if best_move_val > 0
      @board.move(piece_to_move.pos, end_pos)
    else
      move_to_make = all_moves.sample
      @board.move(move_to_make[0].pos, move_to_make[1])
    end
  end

  def move_value(move, piece)
    return 100 if move_is_checkmate?(move, piece)
    move_val = 0

    if @board[move].color == @opponent_color
      move_val = MAP_OF_PIECE_VALS[@board[move].symbol]
    end

    move_is_check?(move, piece) || pawn_promotion?(move, piece) ? move_val + 1 : move_val
  end

  def move_is_check?(move, piece)
    dup_board = @board.dup
    dup_board.move(piece.pos, move)
    dup_board.in_check?(@opponent_color)
  end

  def move_is_checkmate?(move, piece)
    dup_board = @board.dup
    dup_board.move(piece.pos, move)
    dup_board.checkmate?(@opponent_color)
  end

  def pawn_promotion?(move, piece)
    @board.pawn_promotion?(piece.pos, move)
  end
end
