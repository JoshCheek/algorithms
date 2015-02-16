require File.expand_path(".", "util")
require 'benchmark'
require 'thread'

class MinCut

  attr_accessor :graph

  def initialize(input)
    @graph = Graph.new(input)
  end

  def min_cut
    while graph.remaining_vertices.count > 2
      graph.contract_random_edge
    end
    graph.edges.count
  end

  def edges
    graph.edges
  end

  def contract(node_one, node_two)
    graph.contract([node_one, node_two].sort)
  end

  class Graph

    # stored as an adjacency list
    attr_accessor :edges

    def initialize(input)
      @edges = build_edges(input)
    end

    def remaining_vertices
      @edges.flatten.uniq
    end

    def contract_random_edge
      edge = @edges.sample
      contract(edge)
    end

    def contract(edge)
      @edges.delete(edge)
      new_ref, old_ref = edge
      @edges = move_ref(new_ref, old_ref)
      remove_self_ref_loops(new_ref, old_ref)
    end

    def [](node)
      @edges.select {|edge| edge.include?(node) }
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
        if edge.uniq.count == 1
          @edges.delete_at(idx)
        end
      end
    end

    def build_edges(input)
      input.reduce([]) do |edges, node_and_connections|
        node = node_and_connections.shift
        node_and_connections.collect do |conn|
          edge = [node, conn].sort
          edges << edge unless edges.include?(edge)
        end
        edges
      end
    end
  end

end

Util.with_file_arg(__FILE__) do |f|
  processed_input = f.reduce([]) do |acc, line|
    line.gsub!("\r\n","")
    split = line.split("\t")
    split.map!{|x| x.to_i}
    acc << split
  end
  smallest_cut = 10000000000000
  smallest_cut_list = Queue.new
  duped = Marshal.dump(processed_input)
  threads = []
  ARGV[1].to_i.times do
    threads << Thread.new { smallest_cut_list << MinCut.new(Marshal.load(duped)).min_cut }
  end
  threads.each {|t| t.join}
  l = []
  while !smallest_cut_list.empty?
    l << smallest_cut_list.pop
  end
  puts "Smallest cut found after #{ARGV[1].to_i} tries: #{l.min.inspect}"
end
