require_relative "../quicksort"

describe Quicksort do
  it "sorts" do
    10.times do |n|
      # this will be mutated
      arr = (1..20).to_a.shuffle
      expected = (1..20).to_a
      sorted = Quicksort.new.sort(arr)
      expect(sorted[0].size).to eq(20)
      expect(sorted[0]).to eq(expected)
    end
  end

  context "first-elem partition" do
    it "knows the number of comparisons it performed" do
      sorted = Quicksort.new(Quicksort::FIRST_ELEM_PIVOT_STRATEGY).sort([1, 2, 3, 4])
      expect(sorted[1]).to eq(6)
    end
  end

  context "last-elem partition" do
    it "sorts" do
      sorted = Quicksort.new(Quicksort::LAST_ELEM_PIVOT_STRATEGY).sort([1, 2, 3, 4])
      expect(sorted[0]).to eq([1, 2, 3, 4])
    end

    it "knows the number of comparisons it performed" do
      sorted = Quicksort.new(Quicksort::LAST_ELEM_PIVOT_STRATEGY).sort([1, 2, 3, 4])
      expect(sorted[1]).to eq(6)
    end
  end

  context "median-of-three partition" do
    it "sorts" do
      sorted = Quicksort.new(Quicksort::MED_THREE_ELEM_PIVOT_STRATEGY).sort([1, 2, 3, 4])
      expect(sorted[0]).to eq([1, 2, 3, 4])
    end

    it "knows the number of comparisons it performed" do
      sorted = Quicksort.new(Quicksort::MED_THREE_ELEM_PIVOT_STRATEGY).sort([1, 2, 3, 4])
      expect(sorted[1]).to eq(4)
    end
  end

  describe "median-of-three pivot strategy" do
    it "returns the value and index of the right pivot" do
      expect(
        Quicksort.new(Quicksort::MED_THREE_ELEM_PIVOT_STRATEGY).pivot_method.call([1, 2, 3])
      ).to eq 2

      expect(Quicksort.find_median([1, 2, 3])).to eq 1

      expect(
        Quicksort.new(Quicksort::MED_THREE_ELEM_PIVOT_STRATEGY).pivot_method.call([5, 6, 7, 8])
      ).to eq 6

      expect(Quicksort.find_median([5, 6, 7, 8])).to eq 1

      expect(
        Quicksort.new(Quicksort::MED_THREE_ELEM_PIVOT_STRATEGY).pivot_method.call([5])
      ).to eq 5

      expect(Quicksort.find_median([5])).to eq 0

      expect(
        Quicksort.new(Quicksort::MED_THREE_ELEM_PIVOT_STRATEGY).pivot_method.call([8,2,4,5,7,1])
      ).to eq 4

      expect(Quicksort.find_median([8,2,4,5,7,1])).to eq 2
    end
  end
end
