require File.expand_path(".", "util")

class MinCut

  attr_accessor :graph

  def initialize(input)
    @graph = Graph.new(input)
  end

  def min_cut_edge
    while graph.remaining_vertices.count > 2
      graph.contract_random_edge
    end
    graph.edges.first
  end

  def edges
    graph.edges
  end

  def min_cut
    2
  end

  def contract(node_one, node_two)
    graph.contract([node_one, node_two])
  end

  def connections_to(node)
    @graph[node]
  end

  class Graph

    # stored as an adjacency list
    attr_accessor :edges

    def initialize(input)
      @edges = build_edges(input)
    end

    def contract_random_edge
      edge = edges.sample
      contract(edge)
      #new_ref, old_ref = edge
      #move_ref(new_ref, old_ref)
      #remove_self_ref_loops(new_ref, old_ref)
    end

    def contract(edge)
      new_ref, old_ref = edge
      @edges = move_ref(new_ref, old_ref)
      remove_self_ref_loops(new_ref, old_ref)
      remove_duplicate_edges
    end

    def [](node)
      edges.select {|edge| edge.include?(node) }
    end

    private

    def move_ref(new_ref, old_ref)
      # [[1, 2], [2, 3]] => [[1, 1], [1, 3]]
      new_edges = []
      @edges.each do |edge|
        if edge[0] == old_ref
          new_edges << [new_ref, edge[1]].sort
        elsif edge[1] == old_ref
          new_edges << [edge[0], new_ref].sort
        else
          new_edges << edge
        end
      end
      new_edges
    end

    def remove_self_ref_loops(node_one, node_two)
      @edges.each_with_index do |edge, idx|
        if edge.sort == [node_one, node_two].sort || edge.uniq.count == 1
          @edges.delete_at(idx)
        end
      end
    end

    def remove_duplicate_edges
      @edges.uniq! {|item| item.sort}
    end

    def build_edges(input)
      input.reduce([]) do |edges, node_and_connections|
        node = node_and_connections.shift
        node_and_connections.collect do |conn|
          edge = [node, conn].sort
          edges << edge unless edges.include?(edge.sort)
        end
        edges
      end
    end
  end

end

Util.with_file_arg(__FILE__) do |f|
  processed_input = f.reduce([]) do |acc, line|
    line.gsub!("\r\n","")
    acc << line.split("\t")
  end
  smallest_cut = 10000000000
  1000.times do
    smallest_cut = [smallest_cut, MinCut.new(processed_input).min_cut].min
  end
  puts "Smallest cut found after 1000 tries: #{smallest_cut}"
end
