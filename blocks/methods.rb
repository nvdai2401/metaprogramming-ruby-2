class MyClass
  def initialize(value)
    @x = value
  end

  def my_method
    @x
  end
end

obj = MyClass.new(12)
m = obj.method :my_method
p m.call #=> 12
