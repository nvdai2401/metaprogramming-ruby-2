class C
  class << self
    def a_class_method
      'C.a_class_method()'
    end
  end
end

class D < C; end

obj = D.new
obj.a_class_method

p C.singleton_class # => #<Class:C>
p D.singleton_class # => #<Class:D>
p D.singleton_class.superclass # => #<Class:C>
p C.singleton_class.superclass # => #<Class:Object>
