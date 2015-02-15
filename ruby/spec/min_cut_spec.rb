require_relative "../mincut"

describe MinCut do
  describe ".new" do
    it "parses the first element as a node connected to all others" do
      input = [[1, 37, 79]]
      graph = MinCut.new(input).graph
      expect(graph.edges).to eq [[1, 37], [1, 79]]
    end
  end

  describe "#edges" do
    it "returns the edges between vertices" do
      input = [[1, 2, 3],
               [2, 1, 3],
               [3, 1, 2]]
      expect(MinCut.new(input).edges).to eq([[1, 2], [1, 3], [2, 3]])
    end
  end

  describe "#contract" do
    it "squashes edges" do
      input = [[1, 2, 3],
               [2, 1, 3],
               [3, 1, 2]]
      mc = MinCut.new(input)
      mc.contract(1, 2)
      expect(mc.edges).to eq([[1, 3]])

      input = [[1, 2, 3],
               [2, 1, 3],
               [3, 1, 2]]
      mc = MinCut.new(input)
      mc.contract(1, 3)
      expect(mc.edges).to eq([[1, 2]])

      input = [[1, 2, 3],
               [2, 1, 3],
               [3, 1, 2]]
      mc = MinCut.new(input)
      mc.contract(3, 1)
      expect(mc.edges).to eq([[2, 3]])
    end
  end

  describe "#min_cut" do
    it "computes a minimum cut" do
      #
      # (1) ----- (2)
      #  |         |
      # (3) ----- (4)
      #
      #
      input = [[1, 2, 3],
               [2, 1, 4],
               [3, 1, 4],
               [4, 2, 3]]
      edges_with_1 = MinCut.new(input).edges.select {|edge| edge.include?(1)}
      expect(edges_with_1).to eq([[1, 2], [1, 3]])
    end
  end
end
