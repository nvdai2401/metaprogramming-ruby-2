# Chapter 5: Class Definitions

- The class itself takes the role of the current object `self`

## The Current Class

- In Ruby, you always have a current object: `self` and a `current class (module)`. When you define a method, that method becomes an instance method of the current class.

  - At the top level of your program, the current object is Object, the class is `main`
  - In a method, the current class is the class of the current object
  - When you open a class with class keyword (or a module with the module keyword), that class becomes the current class

- Use `Module#class_eval` or `Module#module_eval` evaluates a block in the context of an existing class

```ruby
def add_method_to(a_class)
  a_class.class_eval do
    def my_method
      'Hello!'
    end
  end
end

add_method_to String
p 'abc'.my_method
```

- `Module#class_eval` is very different from `BasicObject.instance_eval`, `instance_eval` only changes `self` and use to open an object of a class, while `class_eval` change both `self` and `current class` ans use to open class definition and define methods with `def`. So all method define with `def` become instance methods of the current class
- You can use `module_exec/class_exec` to pass extra parameters to the block
- In class definition, the current object `self` and the current class are the same - the class being defined

## Class instance variables

- The Ruby interpreter assumes that all instance variables belong to the current object `self`
- In a class definition, the role of `self` belongs to the class itself, so the instance variables belong to the class

```ruby
class MyClass
  @my_var = 1  # => Class Instance Variable

  def self.read
    p @my_var
  end

  def write
    p "Write"
    @my_var = 2 # => Object Instance Variable
  end

  def read
    p @my_var
  end
end

obj = MyClass.new
obj.read # => nil
obj.write
obj.read # => 2
MyClass.read # => 1
```

- Class variables are different from Class Instance Variables because they can be accessed by subclasses and by regular instance methods

```ruby
@@v = 0

class C
  @@v = 1
end

class D < C
  def my_method
    @@v # => 1
    @@v = 2
  end
end

@@v = 2
```

- Class variables don't really belong to classes, they belong to class hierarchies. Above example, `@@v` is defined in the context of `main`, so it belong to main's class Object and belong to all the descendants of `Object`. `MyClass` inherits from `Object`, so it ends up sharing the same class variables

## Singleton methods
