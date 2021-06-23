def double(callable_object, x)
  callable_object.call(x) * 2
end

def another_double
  p = Proc.new { return 10 }
  res = p.call
 return res * 2 # unreachable code
end

l = lambda {|x, y| return x + y}
p double(l, 10)  #=> 20
p another_double # => 10
