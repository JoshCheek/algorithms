class Mergesort
  def self.sort(arr)
    if arr.size <= 1
      arr
    else
      half = arr.size / 2
      first_half = sort(arr[0...half])
      second_half = sort(arr[half..-1])
      merge(first_half, second_half)
    end
  end

  def self.merge(arr_one, arr_two)
    sorted = []
    while (arr_one.length > 0 && arr_two.length > 0)
      if arr_one[0] < arr_two[0]
        sorted << arr_one.slice!(0)
      else
        sorted << arr_two.slice!(0)
      end
    end
      # there's leftovers in one of them
    if arr_one.length > arr_two.length
      sorted.concat(arr_one)
    else
      sorted.concat(arr_two)
    end
    sorted
  end
end
