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

  describe "#my_each_with_index" do
    let(:block){|item, index| print "Item: #{item}, Index: #{index}"}
    it 'calls block with two arguments, the item and its index, for each item in enum' do
      expect(ary.my_each_with_index).to be_an(Enumerator)
    end

    context "when a block is given" do
      it 'returns the array after calling the given block once for each slement in self' do
        expect(ary.my_each_with_index{:block}).to be(ary.each_with_index{:block})
      end

      it "returns the array after calling the given block once for each slement in self::range" do
        expect(rng.my_each_with_index{:block}).to be(rng.eachwith_index{:block})
      end
    end
  end
end
