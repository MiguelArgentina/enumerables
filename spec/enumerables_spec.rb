require 'rspec'
require './enumerables.rb'


describe Enumerable do
  let(:ary) {%w[a b c]}
  let(:rng) {(1..5)}
  let(:block){|item| print item, "--"}
  describe "#my_each" do
    it "Return an enumerator if no block is given" do
      expect(ary.my_each).to be_an(Enumerator)
    end
    it "Applies the block to every element of the array" do
      expect(ary.my_each{:block}).to be(ary.each{:block})
    end
    it "Applies the block to every element of the range" do
      expect(rng.my_each{:block}).to be(rng.each{:block})
    end
  end
end
