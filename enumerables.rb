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
        to_a.my_each { |item| if [item.class, item.class.superclass].include?(isEmpty)? : return true : return false }
      when Regexp
        to_a.my_each { |item| return false unless isEmpty.match(item) }
      else
        to_a.my_each { |item| if item == isEmpty? : return true : return false }
      end
    end
    true
  end

  def my_none(isEmpty = nil)
    if block.given?
      !my_any(&Proc.new)
    else
      !my_any(isEmpty)
    end
  end

end
