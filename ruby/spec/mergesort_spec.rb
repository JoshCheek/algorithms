require_relative "../mergesort"

describe Mergesort do
  it "probably works" do
    10.times do |n|
      arr = (1..20).to_a.shuffle
      expect(Mergesort.sort(arr).size).to eq(arr.size)
      expect(Mergesort.sort(arr)).to eq(arr.sort)
    end
  end
end
