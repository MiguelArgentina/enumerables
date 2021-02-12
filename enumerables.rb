# rubocop: disable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity
# Enumerable Methods
module Enumerable
  def my_each
    return to_a.to_enum unless block_given?

    0.upto(to_a.length - 1) do |i|
      yield to_a[i]
    end
    self
  end

  def my_each_with_index
    return to_enum(:my_each_with_index) unless block_given?

    if block_given?
      0.upto(length - 1) do |i|
        yield(to_a[i], i)
      end
    end
    self
  end

  def my_select
    return to_enum unless block_given?

    ary_aux = []
    my_each { |item| ary_aux << item if yield item }
    ary_aux
  end

  def my_all?(param = nil)
    if block_given?
      to_a.my_each { |item| return false if yield(item) == false }
    else
      case param
      when nil
        to_a.my_each { |item| return false if item == false || item.nil? }
      when Class
        to_a.my_each { |item| return false unless [item.class, item.class.superclass].include?(param) }
      when Regexp
        to_a.my_each { |item| return false unless param.match(item) }
      else
        to_a.my_each { |item| return false if item != param }
      end
    end
    true
  end

  def my_any?(param = nil)
    if block_given?
      to_a.my_each { |item| return true if yield(item) }
    else
      case param
      when nil
        to_a.my_each { |item| return true if item }
      when Class
        to_a.my_each { |item| return true if [item.class, item.class.superclass].include?(param) }
      when Regexp
        to_a.my_each { |item| return true if param.match(item) }
      else
        to_a.my_each { |item| return true if item == param }
      end
    end
    false
  end

  def my_none?(param = nil)
    if block_given?
      !my_any(&Proc.new)
    else
      !my_any(param)
    end
  end

  def my_count(param = nil)
    acc = 0
    if param.nil? && block_given?
      my_each { |item| acc += 1 if yield item }
    elsif !param.nil? && !block_given?
      my_each { |item| acc += 1 if item == param }
    elsif param.nil? && !block_given?
      my_each { |_item| acc += 1 }
    end
    acc
  end

  def my_map(proc = nil)
    return to_enum(:my_map) unless block_given? || !proc.nil?

    array = []
    if proc.nil?
      to_a.my_each { |item| array.append(yield(item)) }
    else
      to_a.my_each { |item| array.append(proc.call(item)) }
    end
    array
  end
  
  def my_inject(memo = nil, sym = nil, &block)
    #Preprocessing to catch Symbol or String arguments
    memo = memo.to_sym if memo.is_a?(String) && !sym && !block
    sym = sym.to_sym if sym.is_a?(String)
    block, memo = memo.to_proc, nil if memo.is_a?(Symbol) && !sym
    block = sym.to_proc if sym.is_a?(Symbol)

    my_each { |item| memo = memo.nil? ? item : block.yield(memo, item) }
    memo
  end
end

# rubocop: disable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity

def multiply_els(ary)
  ary.my_inject(:*)
end
