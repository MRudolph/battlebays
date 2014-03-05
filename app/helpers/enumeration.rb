module Enumerable
  def count_if
    sum=0
    each {|x| sum+=1 if yield(x) }
    sum
  end
end
