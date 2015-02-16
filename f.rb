require 'pry'
require 'pp'


Node = Struct.new :paths, :edges do
  def initialize
    super [], []
  end
end

class Path
  attr_accessor :node_name, :edges
  def initialize(node_name, edges)
    @node_name, @edges = node_name, edges
  end

  def inspect
    @to_s ||= begin
      es   = edges.dup
      crnt = node_name
      path = crnt.to_s
      until es.empty?
        e = es.pop
        e = e.reverse if e[0] != crnt
        crnt = e.last
        path = "#{crnt}, #{path}"
      end
      "#<Path: #{path}>"
    end
  end
end

def traverse(graph, traversals)
  start_node, associated_nodes = graph.first
  queue = associated_nodes.map do |node_name|
    Path.new node_name, [[start_node, node_name].sort]
  end

  until queue.empty?
    path     = queue.shift
    node     = traversals[path.node_name]
    new_path = (node.edges & path.edges).empty?
    next unless new_path
    node.paths << path
    node.edges.concat(path.edges)
    graph[path.node_name].each do |associated_node_name|
      new_edge = [path.node_name, associated_node_name].sort
      queue << Path.new(associated_node_name, path.edges + [new_edge])
    end
  end
end

def min_cuts_from_adjacency_list(graph)
  traversals = graph.map { |node_name, edges|  [node_name, Node.new] }.to_h
  traverse graph, traversals
  name, node = traversals.min_by { |node_name, node| node.paths.count }
  puts "GRAPH: #{graph.inspect}\nNODE: #{name}\nPATHS: #{node.paths.inspect}"
  require "pry"
  binding.pry
  node.paths.count
end



RSpec.describe 'min_cuts_from_adjacency_list' do
  def from_drawing(str)
    str.lines
       .drop_while { |line| line !~ /^$/ }
       .map(&:strip)
       .drop_while { |line| line == '' }
       .map { |line| line.split(/\s+/).map(&:intern) }
  end

  def assert_min_cuts(expected, list)
    graph  = list.map { |node_name, *edges| [node_name, edges] }.to_h
    actual = min_cuts_from_adjacency_list(graph)
    expect(actual).to eq expected
  end

  it 'finds 17 for the big problem (the one we checked against theirs)' do
    assert_min_cuts 17, File.read(File.expand_path "ruby/kargerMinCut.txt", __dir__)
                            .lines
                            .map { |line| line.strip.split(/\s+/).map(&:to_i) }
  end

  it 'works with any node name, integers or symbols or whatever' do
    assert_min_cuts 2, [[1, 2, 3],
                        [2, 1, 4],
                        [3, 1, 4],
                        [4, 2, 3]]
    assert_min_cuts 2, [[:a, :b, :c],
                        [:b, :a, :d],
                        [:c, :a, :d],
                        [:d, :b, :c]]
  end

  it 'finds 2 for a square' do
    assert_min_cuts 2, from_drawing(<<-TO_PARSE)
      a --- b
      |     |
      c --- d

      a b c
      b a d
      c a d
      d b c
    TO_PARSE
  end

  it 'finds 1 for an early lonely node' do
    assert_min_cuts 1, from_drawing(<<-TO_PARSE)
      a --- b --- c
             \   /
               d

      a b
      b a c d
      c b d
      d b c
    TO_PARSE
  end

  it 'finds 1 for a late lonely node' do
    assert_min_cuts 1, from_drawing(<<-TO_PARSE)
      a --- b --- c
       \   /
         d

      a b d
      b a c d
      c b
      d a b
    TO_PARSE
  end

  it 'finds 1 for 2 squares with 1 edge connecting' do
    assert_min_cuts 1, from_drawing(<<-TO_PARSE)
      a -- b
      |    |
      c -- d -- e -- f
                |    |
                g -- h

      a b c
      b a d
      c a d
      d b c e
      e d f g
      f e h
      g e h
      h f g
    TO_PARSE
  end

  it 'finds 1 for 2 triangles with 1 edge connecting' do
    assert_min_cuts 1, from_drawing(<<-TO_PARSE)
      a              e
      |  \        /  |
      b -- c -- d -- f

      a b c
      b a c
      c a b d
      d c e f
      e d f
      f d e
    TO_PARSE
  end

  it 'finds 1 for a sophisticated graph, with a lonely node' do
    assert_min_cuts 1, from_drawing(<<-TO_PARSE)
      a -- b
      |  \ |
      c -- d -- e

      a b c d
      b a d
      c a d
      d a b c e
      e d
    TO_PARSE
  end

  # fuuuuuuuuuck >.<
  it 'finds 2 for 2 triangles with 1 node in common', t:true do
    assert_min_cuts 2, from_drawing(<<-TO_PARSE)
      a --- b --- d
       \   / \   /
         c     e

      a b c
      b a c d e
      c a b
      d b e
      e b d
    TO_PARSE
  end

  xit 'finds 2 for four nodes in a line with 2 connections each' do
    assert_min_cuts 2, from_drawing(<<-TO_PARSE)
      a --- b --- c --- d
       \---/ \---/ \---/

      a b b
      b a a c c
      c b b d d
      d c c
    TO_PARSE
  end

  it 'finds 2 for a square with extra edges' do
    assert_min_cuts 2, from_drawing(<<-TO_PARSE)
       a -- b
      /|    |\
      \|    |/
       c -- d

       a b c c
       b a d d
       c a a d
       d b b c
    TO_PARSE
  end

  xit 'finds 2 for a graph with a lonely node that is extra clingy' do
    assert_min_cuts 2, from_drawing(<<-TO_PARSE)
                 - e
               /  /|
             /  c  |
            | / |  |
      a --- b   |  |
       \---/| \ |  |
             \  d  |
               \ \ |
                 - f

      a b b
      b a a c d e f
      c b d e
      d b c f
      e b c f
      f b d e
    TO_PARSE
  end

  xit 'finds 3 for a three node line with edge quantities 3,4,3' do
    assert_min_cuts 3, from_drawing(<<-TO_PARSE)
      a -3- b -4- c -3- d

      a b b b
      b a a a c c c c
      c b b b b d d d
      d c c c
    TO_PARSE
  end

  it 'finds 2 for a well connected graph with a separate node connected into it twice' do
    assert_min_cuts 2, from_drawing(<<-TO_PARSE)
      a - b - c
        \ | X |
          d - e

      a b d
      b a c d e
      c b d e
      d a b c e
      e b c d
    TO_PARSE
  end

  it 'finds 2 when there are two well connected graphs that are connected through 2 independent paths, on later nodes' do
    assert_min_cuts 2, from_drawing(<<-TO_PARSE)
      a -               - i
      |\  \           /  /|
      |  c  \       /  g  |
      |  | \ |     | / |  |
      |  |   e --- f   |  |
      |  | / |     | \ |  |
      |  d  /       \  h  |
      | / /           \ \ |
      b -               - j
       \-----------------/

      a b c e
      b a d e j
      c a d e
      d b c e
      e a b c d f
      f e g h i j
      g f h i
      h f g j
      i f g j
      j b f h i
    TO_PARSE
  end

  it 'finds the right thing for these' do
    assert_min_cuts 3, from_drawing(<<-TO_PARSE)
        a --- b
      / |     | \
      | c --- d  |
      \ |     | /
        e --- f

        a b c e
        b a d f
        c a d e
        d b c f
        e a c f
        f b d e
    TO_PARSE

    assert_min_cuts 2, from_drawing(<<-TO_PARSE)
        a     b
      / |     | \
      | c --- d  |
      \ |     | /
        e --- f

        a c e
        b d f
        c a d e
        d b c f
        e a c f
        f b d e
    TO_PARSE

    assert_min_cuts 2, from_drawing(<<-TO_PARSE)
        a --- b
      / |     | \
      | c     d  |
      \ |     | /
        e --- f

        a b c e
        b a d f
        c a e
        d b f
        e a c f
        f b d e
    TO_PARSE

    assert_min_cuts 2, from_drawing(<<-TO_PARSE)
        a --- b
      / |     | \
      | c --- d  |
      \ |     | /
        e     f

        a b c e
        b a d f
        c a d e
        d b c f
        e a c
        f b d
    TO_PARSE

    assert_min_cuts 2, from_drawing(<<-TO_PARSE)
        a --- b
      / |     |
      | c --- d
      \ |     |
        e --- f

        a b c e
        b a d
        c a d e
        d b c f
        e a c f
        f d e
    TO_PARSE

    assert_min_cuts 2, from_drawing(<<-TO_PARSE)
        a --- b
        |     | \
        c --- d  |
        |     | /
        e --- f

        a b c
        b a d f
        c a d e
        d b c f
        e c f
        f b d e
    TO_PARSE

    assert_min_cuts 1, from_drawing(<<-TO_PARSE)
        a --- b
      / |     | \
     |  c --- d  |
      \ |       /
        e     f

        a b c e
        b a d f
        c a d e
        d b c
        e a c
        f b
    TO_PARSE

    assert_min_cuts 1, from_drawing(<<-TO_PARSE)
        a --- b
      / |     |
     |  c --- d
      \ |     |
        e     f

        a b c e
        b a d
        c a d e
        d b c f
        e a c
        f d
    TO_PARSE
  end
end
