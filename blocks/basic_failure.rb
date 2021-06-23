def my_method(a, b)
  a + yield(a, b)
end

my_method(3, 4) { |x, y| (x + y) * 3 }
# my_method(3, 4) do |x, y| (x + y) * 3 end
