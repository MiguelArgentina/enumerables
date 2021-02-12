# rubocop:disable Style/CaseEquality, Style/StringLiterals, Style/For
# rubocop:disable Metrics/CyclomaticComplexity
# rubocop:disable Metrics/PerceivedComplexity

module Enumerable
  def my_each()
    return to_a.to_enum unless block_given?

    0.upto(to_a.length - 1) do |i|
      yield to_a[i]
    end
    to_a
  end

  def my_each_with_index
    if block.given?
      0.upto (arr.length - 1) do |i|
        yield(to_a[i], i)
      end
    else
      return to_enum(:my_each_with_index)
    end
    self
  end

  def my_select()
      return to_enum unless block_given?

      ary_aux = []
      my_each { |item| ary_aux << item if yield item }
      ary_aux
  end

  def my_all(isEmpty = nil)
    if block.given?
      to_a.my_each { |item| if yield(item)? : return true : return false }
    else
      case isEmpty
      when nil
        to_a.my_each { |item| return false if item == false || item.nil? }
      when Class
        to_a.my_each { |item| return false unless [item.class, item.class.superclass].include?(isEmpty) }
      when Regexp
        to_a.my_each { |item| return false unless isEmpty.match(item) }
      else
        to_a.my_each { |item| if item == isEmpty? : return true : return false }
      end
    end
    true
  end

  def my_any(isEmpty = nil)
    if block.given?
      to_a.my_each { |item| if yield(item)? : return true : return false }
    else
      case isEmpty
      when nil
        to_a.my_each { |item| return true if item }
      when Class
        to_a.my_each { |item| return true if [item.class, item.class.superclass].include?(isEmpty) }
      when Regexp
        to_a.my_each { |item| return true if isEmpty.match(item) }
      else
        to_a.my_each { |item| return true if item == isEmpty }
      end
    end
    false
  end

  def my_none(isEmpty = nil)
    if block.given?
      !my_any(&Proc.new)
    else
      !my_any(isEmpty)
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
    return to_enum(:my_map) unless block.given? || !proc.nil?
    array = []
    if proc.nil?
      to_a.my_each { |item| array.append(yield(item)) }
    else
      to_a.my_each { |item| array.append(proc.call(item)) }
    end
    array
  end

  def my_inject(*args)
    memo = 0
    sym = nil
    if block_given?
      if args.length == 1
        memo = to_a[0]
      else
        return nil
      end
      my_each do |item|
        accumulator = yield(memo, item)
      end
      accumulator
    end

    if args.length == 2
      memo = args[0]
      sym = args[1]
      0.upto(to_a.length - 1) do |i|
        memo = memo.send(sym, self[i])
      end
      my_each { |item| memo = memo.send(sym, item) }
      memo
    elsif (args.length == 1) && (args[0].is_a? Symbol)
      sym = args[0]
      memo = self[0]
      1.upto(to_a.length - 1) do |i|
        memo = memo.send(sym, self[i])
      end
      memo
    end
  end
end


def multiply_els(ary)
  ary.my_inject(:*)
end
