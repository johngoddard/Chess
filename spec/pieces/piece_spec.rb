require 'rspec'
require 'board'
require 'pieces/piece'

describe Piece do
  let(:board){Board.new}

  describe "#valid_moves" do
    it "returns all valid moves" do
      board.move([0,3], [4,3])
      expect(board[[4,3]].valid_moves.sort).to eq([[5,3], [6,3], [5,2], [6,1], [5,4], [6,5],
      [3,3], [3,2],[2,1], [3,4],[2,5], [4,2], [4,1], [4,0],[4,4], [4,5], [4,6],
      [4,7], [2,3]].sort)
    end

    it "does not include moves that would leave the king in check" do
      board.move([0,3], [4,7])
      expect(board[[5,6]].valid_moves.size).to eq(0)
    end
  end
end
