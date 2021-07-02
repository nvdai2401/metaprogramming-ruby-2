# module MyModule
#   def self.my_method
#     'hello'
#   end
# end

# class MyClass
#   include MyModule
# end

# # p MyClass.my_method # => undefined method `my_method' for MyClass:Class (NoMethodError)

# module MyModule1
#   def my_method
#     'hello'
#   end
# end

# class MyClass1
#   class << self # => include the singleton class of MyClass
#     include MyModule1
#   end
# end

# p MyClass1.my_method # => "hello"

module MyModule2
  def my_method
    'hello'
  end
end

obj = Object.new
obj.extend MyModule2
p obj.my_method # => "hello"

class MyClass2
  class << self
    include MyModule2
  end
end

p MyClass2.my_method # => "hello"
