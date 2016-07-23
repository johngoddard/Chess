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
      before(:each){
        board.move([6,1], [1,1])
      }

      it "doesn't return pieces that have been taken" do
        expect(board.my_pieces(:black).size).to eq(15)
      end
    end
  end


end
