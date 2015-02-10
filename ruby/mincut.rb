require File.expand_path(".", "util")

class MinCut

  attr_accessor :graph

  def initialize(input)
    @graph = build_graph(input)
  end

  def min_cut
    2
  end

  def connections_to(node)
    @graph[node]
  end

  private

  def build_graph(input)
    input.reduce({}) do |acc, line|
      acc[parse_node(line)] = parse_connections(line)
      acc
    end
  end

  def parse_node(line)
    line.first
  end

  def parse_connections(line)
    line[1..-1]
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
