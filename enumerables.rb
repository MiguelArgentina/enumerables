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

end
