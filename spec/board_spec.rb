require 'rspec'
require 'board'

BACK_ROW = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]

describe Board do
  subject(:board){Board.new}

  describe "#initialize" do
    it "creates an 8 x 8 board" do
      expect(board.grid.size).to eq(8)
      expect(board.grid[0].size).to eq(8)
    end

    it "creates 16 pieces of each color" do
      expect(board.my_pieces(:white).size).to eq(16)
      expect(board.my_pieces(:black).size).to eq(16)
    end

    it "places pieces correctly" do
      expect(board.grid[1].all?{|piece| piece.is_a?(Pawn)}).to be true
      expect(board.grid[6].all?{|piece| piece.is_a?(Pawn)}).to be true
      expect(board.grid[0].map{|piece| piece.class}).to eq(BACK_ROW)
      expect(board.grid[7].map{|piece| piece.class}).to eq(BACK_ROW)
    end


  end

  describe "#move" do
    it "moves a piece" do
      board.move([1,1], [2,1])
      expect(board[[1,1]]).to eq(NullPiece.instance())
      expect(board[[2,1]].class).to eq(Pawn)
    end

    it "raises an error if you try to make a move from a square with no piece" do
      expect{board.move([3,3], [4,4])}.to raise_error(StandardError)
    end

    it "promotes pawns that reach the last rank" do
      board.move([1,1], [7,1])
      expect(board[[7,1]].class).to eq(Queen)
      expect(board[[7,1]].color).to eq(:black)
    end
  end

  describe "#my_pieces" do
    it "finds all pieces of the selected color" do
      expect(board.my_pieces(:white).size).to eq(16)
    end

    context "after a piece has been taken" do
      before(:each) do
        board.move([6,1], [1,1])
      end

      it "doesn't return pieces that have been taken" do
        expect(board.my_pieces(:black).size).to eq(15)
      end
    end
  end

  describe "#in_bounds?" do
    it "returns true for a position on the board" do
      expect(board.in_bounds?([0,0])).to be true
    end

    it "returns false for a position not on the board" do
      expect(board.in_bounds?([8,0])).to be false
    end
  end

  describe "#threatened" do
    before(:each) do
      board.move([6,3], [5,4])
    end

    it "returns true for a threatened position" do
      expect(board.threatened?([1,3], :black)).to be true
    end

    it "returns false for a non threatened position" do
      expect(board.threatened?([1,4], :black)).to be false
    end
  end

  describe "#checkmate?" do
    it "returns false when there isn't a checkmate" do
      expect(board.checkmate?(:white)).to be false
    end

    context "when there is a checkmate" do
      before(:each) do
        board.move([6,5], [5,5])
        board.move([1,4], [2,4])
        board.move([6,6], [4,6])
        board.move([0,3], [4,7])
      end

      it "returns true when a player is in checkmate" do
        expect(board.checkmate?(:white)).to be true
      end
    end
  end

  describe "#find_king" do
    it "finds the kings" do
      board.move([0,4],[4,4])
      expect(board.find_king(:black).pos).to eq([4,4])
    end
  end

  describe "#dup" do
    before(:each) do
      board.move([6,5], [5,5])
      board.move([1,4], [2,4])
      board.move([6,6], [4,6])
      board.move([0,3], [3,6])
    end

    it "copies pieces into the correct positions" do
      dup = board.dup
      copy = true
      dup.grid.flatten.each_with_index do |piece,idx|
        original_piece = board.grid.flatten[idx]
        copy = false unless piece.class == original_piece.class && piece.color ==
        original_piece.color
      end
      expect(copy).to be true
    end

    it "moves on the duplicate board don't affect the original" do
      dup = board.dup
      dup.move([7,4], [6,5])
      expect(board.find_king(:white).pos).to eq([7,4])
    end


  end

end
