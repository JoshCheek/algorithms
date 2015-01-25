
class InversionCounter

  def sort_and_count(arr, inversion_count = 0)
    if arr.count <= 1
      [inversion_count, arr]
    else
      half = arr.count / 2
      first_inversion_count, first_half = sort_and_count(arr[0...half], inversion_count)
      second_inversion_count, second_half = sort_and_count(arr[half..-1], inversion_count)
      inversion_count, merged = merge(first_inversion_count + second_inversion_count,
                                      first_half,
                                      second_half)
      [inversion_count, merged]
    end
  end

  def merge(inversion_count, arr_one, arr_two)
    total = arr_one.count + arr_two.count
    merged = []
    total.times do
      x = arr_one.first
      y = arr_two.first
      if (x && y) && x < y
        merged << arr_one.slice!(0)
      elsif (x && y) && y < x
        merged << arr_two.slice!(0)
        inversion_count += arr_one.count
      elsif arr_one.count > arr_two.count
        merged << arr_one.slice!(0)
      else
        merged << arr_two.slice!(0)
      end
    end
    [inversion_count, merged]
  end
end

if __FILE__ == $0
  file_path = ARGV[0]
  File.open(file_path) do |f|
    entries = f.to_a.map! {|entry| entry.gsub(/\r\n/,"").to_i }
    puts "Num inversions: #{InversionCounter.new.sort_and_count(entries)[0]}"
  end
end
