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

end
