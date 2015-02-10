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
end
