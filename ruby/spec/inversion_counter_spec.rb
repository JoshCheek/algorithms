require_relative "../inversion_counter"

describe InversionCounter do
  it "counts the number of inversions" do
   # expect(InversionCounter.new.sort_and_count([1,2,3])[0]).to eq 0
   # expect(InversionCounter.new.sort_and_count([1,2,3])[1]).to eq [1,2,3]
   # expect(InversionCounter.new.sort_and_count([3,2,1])[0]).to eq 3
   # expect(InversionCounter.new.sort_and_count([3,2,1])[1]).to eq [1,2,3]
    expect(InversionCounter.new.sort_and_count([6,5,4,3,2,1])[0]).to eq 15
   # expect(InversionCounter.new.sort_and_count([6,5,4,3,2,1])[1]).to eq [1,2,3,4,5,6]
  end
end
