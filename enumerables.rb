# rubocop: disable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity
# Enumerable Methods
module Enumerable
  def my_each
    return to_a.to_enum unless block_given?

    0.upto(to_a.length - 1) do |i|
      yield to_a[i]
    end; self
  end

  def my_each_with_index
    return to_enum(:my_each_with_index) unless block_given?

    if block_given?
      0.upto(size - 1) do |i|
        yield(to_a[i], i)
      end
    end; self
  end

  def my_select
    return to_enum unless block_given?

    ary_aux = []
    my_each { |item| ary_aux << item if yield item }
    ary_aux
  end

  def my_all?(param = nil)
    return my_select { |item| return false if yield(item) == false } unless block_given?

    case param
    when nil
      to_a.my_each { |item| return false if item == false || item.nil? }
    when Class
      to_a.my_each { |item| return false unless [item.class, item.class.superclass].include?(param) }
    when Regexp
      to_a.my_each { |item| return false unless param.match(item) }
    else
      to_a.my_each { |item| return false if item != param }
    end; true
  end

  def my_any?(param = nil)
    if block_given?
      to_a.my_each { |item| return false if yield(item) == false }
      return true
    end
    # Checking Class
    return my_select { |item| item.is_a? param }.size.positive? if param.is_a? Class
    # Checking Regexp
    return my_select { |item| param.match? item }.size.positive? if param.is_a? Regexp
    # Checking Matches
    return my_select { |item| param === item }.size.positive? unless param.nil?

    to_a.my_each { |item| return false if item != param }

    my_select(param).size.positive?
  end

  def my_none?(param = nil)
    if block_given? && param.nil?
      my_each { |item| return false if yield item }
    elsif !block_given? && param.nil?
      my_each { |item| return false if item == true }
    elsif !param.nil? && (param.is_a? Class)
      my_each { |item| return false if item.instance_of?(param) }
    elsif !param.nil? && (param.is_a? Regexp)
      my_each { |item| return false if param.match(item) }
    elsif !param.nil?
      my_each { |item| return false if item == param }
    end; true
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
    # Preprocessing to catch Symbol or String arguments
    raise LocalJumpError, 'No block or initial acc given' if memo.nil? && sym.nil? && !block

    memo = memo.to_sym if memo.is_a?(String) && !sym && !block
    sym = sym.to_sym if sym.is_a?(String)
    if memo.is_a?(Symbol) && !sym
      block = memo.to_proc
      memo = nil
    end
    block = sym.to_proc if sym.is_a?(Symbol)

    my_each { |item| memo = memo.nil? ? item : block.yield(memo, item) }
    memo
  end
end

# rubocop: enable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity

def multiply_els(ary)
  ary.my_inject(:*)
end
