require_relative "../mincut"

describe MinCut do
  describe "#build_graph" do
    it "parses the first element as a node" do
      input = [[1, 37, 79, 164, 155, 32,
                        87, 39, 113, 15, 18, 78,
                        175, 140, 200, 4, 160, 97,
                        191, 100, 91, 20, 69, 198, 196]]
      graph = MinCut.new(input).graph
      expect(graph.keys).to eq [1]
    end

    it "parses the remaining nodes as being connected to the first" do
      input = [[1, 37, 79, 164, 155, 32,
                        87, 39, 113, 15, 18, 78,
                        175, 140, 200, 4, 160, 97,
                        191, 100, 91, 20, 69, 198, 196]]
      connections = MinCut.new(input).connections_to(1)
      expect(connections).to eq input.first[1..-1]
    end
  end

  describe "#edges" do
    it "returns the edges between vertices" do
      input = [[1, 2, 3],
               [2, 1, 3],
               [3, 1, 2]]
      expect(MinCut.new(input).edges).to eq([
        [1, 2], [1, 3], [2, 1],
        [2, 3], [3, 1], [3, 2]
      ])
    end
  end

  describe "#contract" do
    it "squashes edges" do
      input = [[1, 2, 3],
               [2, 1, 3],
               [3, 1, 2]]
      mc = MinCut.new(input)
      mc.contract(1, 2)
      expect(mc.edges).to eq([[1, 3], [3, 1]])

      mc = MinCut.new(input)
      mc.contract(1, 3)
      expect(mc.edges).to eq([[1, 2], [2, 1]])

      mc = MinCut.new(input)
      mc.contract(3, 1)
      expect(mc.edges).to eq([[3, 2], [2, 3]])
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
      connections = MinCut.new(input).connections_to(1)
      expect(connections).to eq input.first[1..-1]
    end
  end
end
