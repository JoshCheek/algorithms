require File.expand_path(".", "util")

class Quicksort

  attr_reader :pivot_method

  FIRST_ELEM_PIVOT_STRATEGY = :first
  LAST_ELEM_PIVOT_STRATEGY = :last
  MED_THREE_ELEM_PIVOT_STRATEGY = :med_three

  def self.find_median(arr)
    if arr.length >= 2
      first = arr[0]
      if arr.length % 2 == 0
        median_index = arr.length / 2 - 1
        median = arr[median_index]
      else
        median_index = arr.length / 2
        median = arr[median_index]
      end
      last = arr[arr.length - 1]
      sorted = Quicksort.new.sort([first, median, last])[0]
      if sorted[1] == first
        0
      elsif sorted[1] == median
        median_index
      else
        arr.length - 1
      end
    else
      0
    end
  end

  PIVOT_STRATEGIES = {
    FIRST_ELEM_PIVOT_STRATEGY => lambda {|arr| arr.first},
    LAST_ELEM_PIVOT_STRATEGY => lambda {|arr| arr.last},
    MED_THREE_ELEM_PIVOT_STRATEGY => lambda do |arr|
      arr[find_median(arr)]
    end
  }

  def initialize(strategy=FIRST_ELEM_PIVOT_STRATEGY)
    @strategy = strategy
    @pivot_method = PIVOT_STRATEGIES[strategy]
  end
  # Only sort of quicksort since it's not purely mutative
  # and I can't determine how to do it using Ruby's Array API
  # since subarray access always returns a new array

  def sort(arr, num_comparisons=0)
    if arr.size <= 1
      [arr, num_comparisons]
    else
      pivot = pivot_method.call(arr)
      pivot_idx = partition(arr, pivot)
      num_comparisons += count_comparisons(arr)
      left_of_pivot = arr.shift(pivot_idx)
      right_of_pivot = arr.pop(arr.length - 1)
      sorted_left, num_comparisons = sort(left_of_pivot, num_comparisons)
      sorted_right, num_comparisons = sort(right_of_pivot, num_comparisons)
      merged = (sorted_left << pivot).concat(sorted_right)
      [merged, num_comparisons]
    end
  end

  private

  attr_reader :strategy

  def partition(arr, pivot)
    if strategy == LAST_ELEM_PIVOT_STRATEGY
      arr[0], arr[-1] = arr[-1], arr[0]
    elsif strategy == MED_THREE_ELEM_PIVOT_STRATEGY
      median_index = self.class.find_median(arr)
      arr[0], arr[median_index] = arr[median_index], arr[0]
    end

    divider = 1
    for i in 1..arr.length - 1
      if arr[i] < pivot
        arr[divider], arr[i] = arr[i], arr[divider]
        divider += 1
      end
    end
    pivot_idx = divider - 1
    arr[pivot_idx], arr[0] = pivot, arr[pivot_idx]
    pivot_idx
  end

  def count_comparisons(arr)
    arr.length - 1
  end
end

Util.with_file_arg(__FILE__) do |f|
  entries = f.to_a.map! {|entry| entry.gsub(/\r\n/,"").to_i }
  sorted, comparisons = Quicksort.new(ARGV[1].to_sym).sort(entries)
  puts "Num comparisons: #{comparisons}"
  puts "Sorted: #{sorted}"
end
