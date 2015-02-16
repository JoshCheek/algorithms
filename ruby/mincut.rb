require File.expand_path(".", "util")

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
    graph.contract([node_one, node_two])
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
        if edge.sort == [node_one, node_two].sort || edge.uniq.count == 1
          @edges.delete_at(idx)
        end
      end
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
  smallest_cut = 10000000000000
  1000.times do
    smallest_cut = [smallest_cut, MinCut.new(processed_input).min_cut].min
  end
  puts "Smallest cut found after 1000 tries: #{smallest_cut}"
end


__END__


1 2 5
2 3
3 5
4 5


1 - 2 - 3
  \   /
4 - 5


  1 --- 2
  |     |
  3 --- 4

  [1, 2]
  [1, 3]
  [2, 4]
  [3, 4]

  [1, 3]
  [1, 4]
  [3, 4]

  [1, 3]
  [1, 3]

  ---------------------

  1 -- 2
  |    |  \
  3 -- 4 -- 5

  1, 2
  1, 3
  2, 4
  2, 5
  3, 4
  4, 5


  1 ---
  |  \   \
  3 -- 4 -- 5

  1, 3
  1, 4
  1, 5
  3, 4
  4, 5


  / ----
  |       \
   \-- 4 -- 5

  4, 5
  4, 5


  ----------------------

  1 -- 2
  |    |  \
  3 -- 4 -- 5

  1, 2
  1, 3
  2, 4
  2, 5
  3, 4
  4, 5

  1 -- 2
    \  |  \
       4 -- 5

  1, 2
  1, 4
  2, 4
  2, 5
  4, 5

    -- 2
    \  |  \
       4 -- 5

  2, 4
  2, 4
  2, 5
  4, 5

    -- 2
    \  |  \
       4 --

  2, 4
  2, 4
  4, 2

  -------------------------

  Strategy:
    pick one with most edges,
    merge it into neighbour with most edges
    (in cases of ties, choose randomly)


  -- initial --

  1 -- 2
  |    |
  3 -- 4 -- 5 -- 6
            |    |
            7 -- 8

  1, 2
  1, 3
  2, 4
  3, 4
  4, 5
  5, 6
  5, 7
  6, 8
  7, 8

  -- merge 4 into 2 --
    can choose either 4 or 5, b/c they each have |3|
    we choose 4
    can merge it into either 2 or 3, b/c they each have |2|
    we choose 2


  1 -- 2
  | /     \
  3         5 -- 6
            |    |
            7 -- 8

  1, 2
  1, 3
  3, 2
  2, 5
  5, 6
  5, 7
  6, 8
  7, 8

  -- merge 2 into 1 --
    can choose either 2 or 5, b/c they each have |3|
    choose 2
    can merge it into either 1 or 3, b/c they each have |2| (but 5 has |3|)
    we choose 1

  1 -----
  | \     \
  3 -`      5 -- 6
            |    |
            7 -- 8

  1, 3
  3, 1
  1, 5
  5, 6
  5, 7
  6, 8
  7, 8

  -- merge 1 into 3 --
    can choose either 1 or 5, b/c they each have |3|
    choose 1
    can merge it into 1 b/c it has |2| (but 5 has |3|)

    -----
  /       \
  3         5 -- 6
            |    |
            7 -- 8

  3, 5
  5, 6
  5, 7
  6, 8
  7, 8

  -- merge 5 into 6 --
    choose 5 b/c it has |3|
    merge into 6 or 7
    we chose 6

    ----------
  /            \
  3              6
              /  |
            7 -- 8

  3, 6
  6, 7
  6, 8
  7, 8

  -- merge 6 into 7 --

  3 -----   / -- \
          \ |    |
            7 -- 8

  3, 7
  7, 8
  7, 8

  -- merge 7 into 8 --

  3 -----
          \
            ---- 8

  3, 8

  one edge, so the answer is 1


  ----------------

  Why pick node with most edges?

    here is a graph, with cardinalities
      a  1=|ab|
      b  3=|ab, bc, bc|
      c  2=|bc, bc|

    a --- b --- c
            \_/

    The correct answer is 1, because if we remove ab,
    then we have 2 graphs: (a) and (b, c)

    We want to squash b, because it has cardinality 3.
    if we instead picked a, we would be left with

          b --- c
            \_/

    Which we can see that 2 edges must be removed to complete it.

    If we instead picked c, we would be left with

    a --- b

    ...which would actually be fine.

    So, it seems that either b or c could be removed,
    so long as a isn't removed. b and c are in the same subgraph

    a --- b --- c
      \_/   \_/
