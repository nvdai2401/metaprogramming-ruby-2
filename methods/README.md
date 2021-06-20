# Chapter 3: Methods

## Dynamic methods

> Where you learn how to call and define methods dynamically, and you remove the duplicated code.

### Dynamic dispatch

- **Dynamic dispatch** is the way you use `obj.send(my_method, args...)` method to send the message to `obj` that you want to execute the `my_method` with `args`. With Dynamic dispatch technique, you can **wait until the very last moment to decide which method to call while the code is running**.
- `.send` allows us to call private methods

```ruby
class MyClass
  def my_method(my_arg: 0)
    my_arg * 2
  end
end

obj = MyClass.new
# regular way to call a instance method
obj.my_method(2)
# use dynamic dispatch to call the method
obj.send(:my_method, 2)
```

### Method names and Symbols

In most cases, symbols are used as name of things such as methods because they are **immutable**

```ruby
:x.class # => Symbol
'x'.class # => String
```

### Defining Methods Dynamically

```ruby
class MyClass
  define_method :my_method do |my_arg|
    my_arg * 2
  end
end

obj = MyClass.new
obj.my_method(2) # => 4
```

- `define_method` is executed inside `MyClass`, so `my_method` is defined as an instance of `MyClass`, it allows you to define the method name at runtime. This technique of defining a method at runtime is called a **Dynamic Method**

## Ghost methods

> Use Dynamic methods if you can and Ghost methods if you have to

- **Ghost methods** are not really methods, they're just a way to intercept the method calls by using `method_missing`

### method_missing

```ruby
class Lawyer
  def my_method
    p 'Hello world'
  end
end
nick = Lawyer.new
nick.talk_simple # => NoMethodError: undefined method `talk_simple' for #<Lawyer:0x00007fba52033888>
```

- When you call a method that does not exist in the class, Ruby will searches up the ancestors chain into Object and eventually into BasicObject. When Ruby can't find the method name anywhere, it admits defeat by calling a method named `method_missing` and this method will throw an exception named `NoMethodError: undefined method ...`
- `method_missing` is like an object dead-letter office, the place where unknown messages eventually end up
- You can override `method_missing` by defining a method called `method_missing` in your class

### Dynamic proxy

- A **Dynamic Proxy** is an object that catches Ghost methods and forwards them to another object (Read more at page 58)

### const_missing

- When you reference a constant that doesn't exist, Ruby passes the name of the constant to `const_missing` as a symbol

## Blank slates

- **Blank slates** is a skinny class preventing such name clashes from ever happening again

- To avoid the `method_missing` traps that you call a method that's already defined in the ancestor classes such as `Object`, because if you don't specify a superclass of your class, your class inherits by default from `Object` which is itself a subclass of `BasicObject`. So you should use a blank slate by inheriting your class from `BasicObject`

# Notes

- `<Class or Module>.instance_methods` returns an array containing the names of the public and protected instance methods in the Class or Module
- `object.methods` returns an array containing the names of the public and protected instance methods of the object that are inherited from `Class` or `Module`.
- Class methods can only be called on classes
- Class methods are always defined def self.method_name
- Instance methods can only be called on instances of classes
- Instance methods are always defined `def method_name`
- Ref: <https://medium.com/@weberzt/class-vs-instance-methods-in-ruby-da4de44ac6a0>
