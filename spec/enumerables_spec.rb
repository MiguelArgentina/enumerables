require 'rspec'
require './enumerables.rb'


describe Enumerable do
  let(:ary) {%w[a b c]}
  let(:rng) {(1..5)}
  let(:block){|item| print item, "--"}
  let(:sym_ary) {[:foo, :bar, :sym]}
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
        expect(rng.my_each_with_index{:block}).to be(rng.each_with_index{:block})
      end
    end
  end

  describe "#my_select" do
    let(:block){|item| item > 3}
    let(:sym_block){|item| item == :foo}
    it 'returns an Enumerator if no block is given' do
      expect(rng.my_select).to be_an(Enumerator)
    end

    context "when a block is given" do
      it 'returns an array with all elements for which the given block returns a true value.' do
        expect(rng.my_select{:block}).to eq(rng.select{:block})
      end

      it 'returns an array with all elements for which the given block returns a true value.' do
        expect(sym_ary.my_select{:sym_block}).to eq(sym_ary.select{:sym_block})
      end
    end
  end

  describe "#my_all?" do
    let(:block){|item| item > 3}
    let(:block_is_numeric){|item| item > 0}

    context "when a block is given" do
      it 'The method returns true if the block never returns false or nil after applying the block to every item' do
        expect(rng.my_all?{:block}).to eq(rng.all?{:block})
      end

      it 'The method returns true if the block never returns false or nil after applying the block to every item' do
        expect(rng.my_all?{:block_is_numeric}).to eq(rng.all?{:blblock_is_numericock})
      end

      it 'The method returns true if the block never returns false or nil after applying the block to every item' do
        expect(rng.my_all?(Numeric)).to eq(rng.all?(Numeric))
      end
    end
  end

end
