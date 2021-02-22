require 'rspec'
require './enumerables.rb'


describe Enumerable do
  let(:ary) {%w[a b c]}
  let(:rng) {(1..5)}
  let(:block){|item| print item, "--"}
  let(:sym_ary) {[:foo, :bar, :sym]}
  let(:words) { %w[ant bear cat] }
  let(:numbers) { [1, 3.14, 42] }

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

  describe "#my_any?" do
    let(:block) { proc { |word| word.length >= 3 } }
    let(:false_collection) { [] }
    let(:true_collection) { [nil, true, 99] }
    context 'when no argument or block is given' do
      it 'returns true if the block ever returns a value other than false or nil' do
        expect(true_collection.my_any?).to be true_collection.any?
      end

      it 'returns false when one of the collection members are false or nil' do
        expect(false_collection.my_any?).to be false_collection.any?
      end
    end

    context 'when a class is passed as an argument' do
      it 'returns true if at least one of the collection members is a member of such class' do
        ary << 2
        expect(ary.my_any?(Numeric)).to be ary.any?(Numeric)
      end
    end

    context 'when a pattern is passed as an argument' do
      it 'returns true if at least one of the collection members matches the regex' do
        expect(ary.my_any?(/b/)).to be ary.any?(/b/)
      end

      it 'returns false if none of the collection members matches the regex' do
        expect(ary.my_any?('d')).to be ary.any?('d')
      end
    end

    context 'when a block is given' do
      it 'returns true if the block ever returns a value other than false or nil' do
        expect(words.my_any?(&block)).to be words.any?(&block)
      end
    end
  end

  describe "#my_none" do
    let(:true_collection) { [nil, false] }
    let(:false_collection) { [nil, false, true] }
    let(:true_block) { proc { |word| word.length == 5 } }
    let(:false_block) { proc { |word| word.length == 5 } }


    context 'when no argument or block is given' do
      it 'return true only if none of the collection members is true' do
        expect(true_collection.my_none?).to be true_collection.none?
      end

      it 'returns false if any of the collection members are truthy' do
        expect(false_collection.my_none?).to be false_collection.none?
      end
    end

    context 'when a class is passed as an argument' do
      it 'returns true only if none of the collection members is a member of such class' do
        expect(words.my_none?(Integer)).to be words.none?(Integer)
      end

      it 'returns false if any of the collection members are truthy' do
        expect(numbers.my_none?(Float)).to be numbers.none?(Float)
      end
    end

    context 'when a pattern is passed as an argument' do
      it 'returns whether pattern === element for none of the collection members' do
        expect(words.my_none?(/d/)).to be words.none?(/d/)
      end
    end

    context 'when a block is given' do
      it 'returns true if the block never returns true for all elements' do
        expect(words.my_none?(&true_block)).to be words.none?(&true_block)
      end

      it 'returns false if the block returns true for any collection members' do
        expect(words.my_none?(&false_block)).to be words.none?(&false_block)
      end
    end
  end

  describe "#my_count" do
    let(:block){|item| item > 3}
    it 'It returns the number of items in the object if no param or block is given' do
      expect(rng.my_count).to eq(rng.count)
    end
    context "when an argument is given" do
      it 'The method returns the count that argument appears in object' do
        expect(rng.my_count(2)).to eq(rng.count(2))
      end
    end
    context "when a block is given" do
      it 'The method returns the times the block yields true' do
        expect(rng.my_count{:block}).to eq(rng.count{:block})
      end
    end
  end

  describe "#my_map" do
    let(:block){|i| i * i}
    let(:block2){"cat"}
    context "When no block is given" do
      it 'returns an Enumerator if no block is given' do
        expect(rng.my_map).to be_an(Enumerator)
      end
    end
    context "when a block is given" do
      it 'It returns a new array with the results of running block once for every element' do
        expect(rng.my_map{:block}).to eq(rng.map{:block})
      end
      it 'It returns a new array with the results of running block once for every element' do
        expect(rng.my_map{:block2}).to eq(rng.map{:block2})
      end
    end
  end

  describe "#my_inject" do
    let(:ary_case1){[1, :*]}
    arg_case2 = :*
    initial_value = 1
    let(:block_case3){ |product, n| product * n }
    let(:block_case4){ proc { |memo, word| memo.length > word.length ? memo : word } }
    context "When no block or argument is given" do
      it 'raises a LocalJumpError' do
        expect{rng.my_inject}.to raise_error LocalJumpError
      end
    end
    context "When an initial value and a symbol are given" do
      it 'it returns the accumulation of the block result, accumulating from the initial value' do
        expect(rng.my_inject(ary_case1[0], ary_case1[1])).to eq(rng.inject(ary_case1[0], ary_case1[1]))
      end
    end
    context "When only a symbol is given" do
      it 'it passes the symbol to the block and returns the accum' do
        expect(rng.my_inject(arg_case2)).to eq(rng.inject(arg_case2))
      end
    end
    context "When an initial value and a block are given" do
      it 'it returns the accumulation of the block result, accumulating from the initial value' do
        expect(rng.my_inject(initial_value){:block_case3}).to eq(rng.inject(initial_value){:block_case3})
      end
    end
    context "When only a block given" do
      it 'the block is passed each element in the object' do
        expect(words.my_inject(&block_case4)).to eq(words.inject(&block_case4))
      end
    end

  end

end
