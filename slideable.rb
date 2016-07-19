

module Slideable

  def moves
    moves_array = []
    move_dirs.each do |direction|
      test_pos = @pos
      while true
        test_pos = grow_unblocked_moves_in_dir(direction[0], direction[1], test_pos)

        if test_pos.all?{|x| x.between?(0,7)}
          moves_array << test_pos unless @board[test_pos].color == self.color
          break unless @board[test_pos].symbol.nil?
        else
          break
        end
        
      end
    end
    moves_array
  end

  private

  def move_dirs
    self.move_dirs
  end

  def grow_unblocked_moves_in_dir(dx, dy, pos)
    [pos[0] + dx, pos[1] + dy]
  end


end
