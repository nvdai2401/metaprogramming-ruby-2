# Chap 2: Inside the object model

## Inside class definitions

> Class is an object, plus a list of instance methods and a link to a superclass. Class is a subclass of Module, so a class is also a module

- There is no real distinction between code that defines a class and code of any other kind
- If you define a new class with the same name of a existing class. Ruby will adds new methods to the existing class, Ruby doesn't redefine the class
- **Open Class**: you can always open existing classes even standard libraries and modify them on the fly -> don't recommend to do it because new methods will overwrite existing methods of the standard library, it will cause problems with other codes using that methods
- You can use `refine` to define a method that's have same name as a built-in method but it's not global, it's is active only in 2 places: the refine block itself and the code starting from the place where you call `using` until the end of the module

```ruby
module StringExtensions
  refine String do
    def reverse "esrever"
    end
  end
end
module StringStuff
  using StringExtensions
  "my_string".reverse # => "esrever"
end
"my_string".reverse # => "gnirts_ym"
```

## Inside of the object model

### What is an object

> Object is a bunch of instance variables, plus a link to a class, The object's methods don't live in the object, they live in the object's class, called _instace methods_

```ruby
class Foo
  def initialize(a, b, c = nil)
    @a = a
    @b = b
    @c = c if c
  end
end

obj = Foo.new(4, 5)
obj2 = Foo.new(6, 7, 8)
p obj.instance_variables # Result: [:@a, :@b]
p obj2.instance_variables # Result: [:@a, :@b, :@c]
```

- Objects contain instance variables, you can check all the instance variables of an object by `Object#instance_variables`
- There is no connection between an objects class and its instance variables. Instance variables just spring into existence when you assign them a value

### Methods

- Get a list of an object's methods by calling `Object#methods`
- Objects that share the same class also share the same methods, so the methods must be stored in the class, **not the object**
- You can call: "My object has a method called my_method and I can call it by calling `obj.my_method()`". By contrast, you should not say that "My class has a method named `my_method`", it would be confusing, because it would imply that you're able to call `MyClass.my_method()`. To remove the ambiguity, you should say that "my_method is an instance method of MyClass"
- my_method is defined in MyClass, so you need an object of my class to call it

=> **Conclusion:** an object's instance variables live in the object itself, and an object's methods live in the object's class. That's why objects of the same class share same methods but don't share instance variables

### The truth about classes

> Classes themselves are nothing but objects. Because class is an object, everything that applies to objects also applies to classes

- While other languages allow you to read class-related information, Ruby allows you to write that information at runtime
- A Ruby class inherits from its **superclass**

```ruby
Array.superclass # => Object
Object.superclass # => BasicObject
BasicObject.superclass # => nil
Class.superclass # => Module
Module.superclass # => Object
```

- The superclass of `Class` is `Module`, every class is also a module with three additional instance methods (news, allocate and superclass). So Ruby can pick one of them to do a single thing that play both roles
- Clarify class and module
  - You pick module when you mean it to be included somewhere
  - You pick class when you mean it to be instantiated or inherited

### Constants

- Any reference that begins with an uppercase letter, including the names of classes and modules, is a constant
- Constants are nested like directories and files. They are uniquely identified by their paths

```ruby
Y = 'a root-level constant'

module M
  Y = 'a constant in M'
  Y # => 'a constant in M'
  ::Y # => 'a root-level constant'
  class C
    X = 'a constant'
  end
  C::X # => "a constant"
end
M::C::X # => "a constant"
M.constants # => [:C, :Y]
Module.constants.include? :Object # => true
Module.constants.include? :Module # => true
```

- `Module#constants` returns all top-level constants in the current scope including a Class, a Module

### Loading and requiring

- load('motd.rb'): used to execute code, motd.rb can pollute your program with the names of its own constants—in particular, class names -> load('motd.rb', true) to keep the constants to itself

- require: used to import libraries

### What happens when you call a method?

- Ruby does 2 things
  - Finds the method. This is a process called _method lookup_
  - Executes the method. To do that, Ruby needs something called _self_

#### Method lookup

- When you call a method, Ruby look into the object's class and finds the method there
- The receiver is an object that you call a method on. E.g. you call `my_string.reverse()`, then `my_string` is the receiver
- The ancestors chain is a path classes you traverse to find the superclass of a class. To check the ancestors of a class, call `MyClass.ancestors`

=> to find a method, Ruby goes in the receiver's class, and from there it climbs the ancestor chain until finds the method

- The Kernel module is included in every object, that's why you can access some methods such as `print`, `p`, etc.

#### The self keyword

> The current object is known as **self**

- All methods called without an explicit receiver are called on self.
- Private methods are governed by a single simple rule: you cannot call a private method with an explicit receiver, call a private method by its name without the self keyword
- To become a master of Ruby, you should always know which object has the role self at any given moment. In most cases, just track which object was the last method receiver

#### The Top level

```ruby
self # => main
self.class # => Object
```

- When you're at the top level of the call stack (top-level context), Ruby creates an object named **main** for you
- When self is in a class, the role of self is taken by the class or module itself
