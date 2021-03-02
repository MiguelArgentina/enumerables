require 'rspec'
require './enumerables'

describe Enumerable do
  let(:array) { Array.new(10) { rand(0...9) } }
  let(:clone) { array.clone }
  let(:range) { Range.new(0, 9) }
  let(:block1) { proc { |num| num - 1 } }
  let(:block2) { proc { |num, index| "Num: #{num}, index: #{index}\n" } }
  let(:block3) { proc { |num| num == 4 } }
  let(:block4) { proc { |num| num < 9 } }
  let(:block5) { proc { |num| num > 9 } }
  let(:truthy_arr) { [true, 'hi'] }
  let(:falsey_arr) { [false, nil] }
  let(:ffjobs) { %w[red white blacke blue mage] }
  describe '#my_each' do
    it 'returns an Enumerator if no block is given' do
      expect(array.my_each).to be_an(Enumerator)
    end

    it "doesn't change the original array" do
      array.my_each(&block1)
      expect(array).to eq(clone)
    end

    context 'when a block is given' do
      it 'calls the block for each element if an array is passed' do
        expect(array.my_each(&block1)).to be(array.each(&block1))
      end

      it 'calls the block for each element if a range is passed' do
        expect(range.my_each(&block1)).to be(range.each(&block1))
      end
    end
  end

  describe '#my_each_with_index' do
    it 'returns an Enumerator if no block is given' do
      expect(array.my_each_with_index).to be_an(Enumerator)
    end

    it "doesn't change the original array" do
      array.my_each_with_index(&block1)
      expect(array).to eq(clone)
    end

    context 'when a block is given' do
      it 'calls the block for each element if an array is passed' do
        expect(array.my_each(&block2)).to be(array.each(&block2))
      end

      it 'calls the block for each element if a range is passed' do
        expect(range.my_each(&block2)).to be(range.each(&block2))
      end
    end
  end

  describe '#my_select' do
    it 'returns an Enumerator if no block is given' do
      expect(array.my_select).to be_an(Enumerator)
    end

    it "doesn't change the original array" do
      array.my_select(&block1)
      expect(array).to eq(clone)
    end

    it 'returns an array containing elements that return true when an array is passed' do
      expect(array.my_select(&block3)).to eq(array.select(&block3))
    end

    it 'returns an array containing elements that return true when a range is passed' do
      expect(range.my_select(&block3)).to eq(range.select(&block3))
    end
  end

  describe '#my_all?' do
    it "doesn't change the original array" do
      array.my_all?(&block1)
      expect(array).to eq(clone)
    end

    context 'when no block or argument is given' do
      it 'returns true when no elements are false or nil' do
        expect(truthy_arr.my_all?).to be truthy_arr.all?
      end

      it 'returns false when at least one element is false or nil' do
        expect(falsey_arr.my_all?).to be falsey_arr.all?
      end
    end

    context 'when a block is given' do
      it 'returns true if the block never returns false or nil when an array is passed' do
        expect(array.my_all? { :block4 }).to eq(array.all? { :block4 })
      end

      it 'returns true if the block never returns false or nil when a range is passed' do
        expect(range.my_all? { :block4 }).to eq(range.all? { :block4 })
      end

      it 'returns false if the block returns false or nil at least once when an array is passed' do
        expect(array.my_all? { :block5 }).to eq(array.all? { :block5 })
      end

      it 'returns false if the block returns false or nil at least once when a range is passed' do
        expect(range.my_all? { :block5 }).to eq(range.all? { :block5 })
      end
    end

    context 'when a class is passed as an argument' do
      it 'returns true if all elements belong to the class' do
        expect(array.my_all?(Numeric)).to be array.all?(Numeric)
      end
    end

    context 'when a Regex is passed as an argument' do
      it 'returns true if all elements match the Regex' do
        expect(ffjobs.my_all?(/e/)).to be ffjobs.all?(/e/)
      end

      it "returns false if at least one element doesn't match the Regex" do
        expect(ffjobs.my_all?(/x/)).to be ffjobs.all?(/x/)
      end
    end
  end

  describe '#my_any?' do
    it "doesn't change the original array" do
      array.my_any?(&block1)
      expect(array).to eq(clone)
    end

    context 'when no block or argument is given' do
      it 'returns true when at least one element is true' do
        expect(truthy_arr.my_any?).to be truthy_arr.any?
      end

      it 'returns false when all elements are false or nil' do
        expect(falsey_arr.my_any?).to be falsey_arr.any?
      end
    end

    context 'when a block is given' do
      it 'returns true if the block returns true at least once when an array is passed' do
        expect(array.my_any? { :block4 }).to eq(array.any? { :block4 })
      end

      it 'returns true if the block returns true at least once when a range is passed' do
        expect(range.my_any? { :block4 }).to eq(range.any? { :block4 })
      end

      it 'returns false if the block never returns true when an array is passed' do
        expect(array.my_any? { :block5 }).to eq(array.any? { :block5 })
      end

      it 'returns false if the block never returns true when a range is passed' do
        expect(range.my_any? { :block5 }).to eq(range.any? { :block5 })
      end
    end

    context 'when a class is passed as an argument' do
      it 'returns true if any element belongs to the class' do
        expect(array.my_any?(Numeric)).to be array.any?(Numeric)
      end
    end

    context 'when a Regex is passed as an argument' do
      it 'returns true if any element matches the Regex' do
        expect(ffjobs.my_any?(/d/)).to be ffjobs.any?(/d/)
      end

      it 'returns false if any element matches the Regex' do
        expect(ffjobs.my_any?(/x/)).to be ffjobs.any?(/x/)
      end
    end
  end

  describe '#my_none?' do
    it "doesn't change the original array" do
      array.my_none?(&block1)
      expect(array).to eq(clone)
    end

    context 'when no block or argument is given' do
      it 'returns true when all elements are false or nil' do
        expect(falsey_arr.my_none?).to be falsey_arr.none?
      end

      it 'returns false when at least one element is true' do
        expect(truthy_arr.my_none?).to be truthy_arr.none?
      end
    end

    context 'when a block is given' do
      it 'returns true if the block returns false or nil when an array is passed' do
        expect(array.my_none? { :block5 }).to eq(array.none? { :block5 })
      end

      it 'returns true if the block returns false or nil when a range is passed' do
        expect(range.my_none? { :block5 }).to eq(range.none? { :block5 })
      end

      it 'returns true if the block returns true at least once when an array is passed' do
        expect(array.my_none? { :block4 }).to eq(array.none? { :block4 })
      end

      it 'returns true if the block returns true at least once when a range is passed' do
        expect(range.my_none? { :block4 }).to eq(range.none? { :block4 })
      end
    end

    context 'when a class is passed as an argument' do
      it 'returns true if no elements belong to the class' do
        expect(array.my_none?(String)).to be array.none?(String)
      end
    end

    context 'when a Regex is passed as an argument' do
      it 'returns true if no elements match the Regex' do
        expect(ffjobs.my_none?(/x/)).to be ffjobs.none?(/x/)
      end

      it 'returns false if at least one element matches the Regex' do
        expect(ffjobs.my_none?(/e/)).to be ffjobs.none?(/e/)
      end
    end
  end

  describe '#my_count' do
    it "doesn't change the original array" do
      array.my_count(&block1)
      expect(array).to eq(clone)
    end

    it 'counts the number of items when an array is passed' do
      expect(array.my_count).to eq array.count
    end

    it 'counts the number of items when a range is passed' do
      expect(range.my_count).to eq range.count
    end

    it 'returns the number of items that meet the criteria when an argument is given' do
      expect(array.my_count(0)).to eq array.count(0)
    end

    it 'returns the number of items that are true when a block is given' do
      expect(array.my_count(&block3)).to eq array.count(&block3)
    end
  end

  describe '#my_map' do
    it 'returns an Enumerator if no block is given' do
      expect(array.my_map).to be_an(Enumerator)
    end

    context 'when a block is given' do
      it 'calls the block for each element and returns a new array when an array is passed' do
        expect(array.my_each(&block1)).to be(array.each(&block1))
      end

      it 'calls the block for each element and returns a new array when a range is passed' do
        expect(range.my_each(&block1)).to be(range.each(&block1))
      end
    end
  end

  describe '#my_inject' do
    let(:sums) { proc { |sum, n| sum + n } }
    let(:finds) { proc { |memo, word| memo.length > word.length ? memo : word } }
    it 'raises a LocalJumpError if no block or argument is given' do
      expect { array.my_inject }.to raise_error LocalJumpError
    end

    it "doesn't change the original array" do
      array.my_inject(&block1)
      expect(array).to eq(clone)
    end

    context 'when a block is given with no initial value' do
      it 'combines all elements of an array using first element as the initial value' do
        expect(array.my_inject(&sums)).to eq array.inject(&sums)
      end

      it 'combines all elements of a range using first element as the initial value' do
        expect(range.my_inject(&sums)).to eq range.inject(&sums)
      end
    end

    context 'when a block is given with an initial value' do
      it 'combines all elements of an array by using the block and initial value' do
        expect(array.my_inject(6) { sums }).to eq array.inject(6) { sums }
      end

      it 'combines all elements of a range by using the block and initial value' do
        expect(range.my_inject(6) { sums }).to eq range.inject(6) { sums }
      end
    end

    context 'when a symbol is specified with no initial value' do
      it 'combines each element of an array by using the symbol' do
        expect(array.my_inject(:*)).to eq array.inject(:*)
      end

      it 'combines each element of a range by using the symbol' do
        expect(range.my_inject(:-)).to eq range.inject(:-)
      end
    end

    context 'when a symbol is specified with an initial value' do
      it 'combines each element of an array by using the symbol and initial value' do
        expect(array.my_inject(7, :+)).to eq array.inject(7, :+)
      end

      it 'combines each element of an range by using the symbol and initial value' do
        expect(range.my_inject(3, :-)).to eq range.inject(3, :-)
      end
    end
  end

  describe '#multiply_els' do
    it 'receives an array as an argument and multiplies all elements using #my_inject' do
      result = multiply_els [1, 3, 5]
      expect(result).to eq 15
    end
  end
end
