#module Enumerable
    def my_each ( ary )
      0.upto (ary.length - 1) do |i|
        p yield ary[i]
      end
    end
#end


my_each(['a', 'b', 'c']){|item| item * 2}
