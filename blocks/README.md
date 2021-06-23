# Chapter 4: Blocks

> Blocks are just one member of a larger family of **callable objects**, which include objects such as procs and lambdas.

## Yield keyword

```ruby
def my_method(a, b)
  a + yield(a, b)
end

my_method(3, 4) { |x, y| (x + y) * 3 } #  => 24
# my_method(3, 4) do |x, y| (x + y) * 3 end
```

- Yield is a Ruby keyword that calls a block when you use it. When you use the yield keyword, the code inside the block will run & do its work
- Yield can be called multiple times

```ruby
def print_twice
  yield
  yield
end
print_twice { puts "Hello" }
# "Hello"
# "Hello"
```

## Explicit Blocks

- Blocks are enclosed in a **do / end statement** or between **brackets {}**, and they can have multiple arguments. It's evaluated in the scope where it's defined
- Explicit means that you give it a name in your parameter list.

```ruby
def explicit_block(&block)
  block.call # same as yield
end
explicit_block { puts "Explicit block called" }
```

- You will get a `no block given (yield)` error when you try to call yield without a block. You can use `block_given?` to check

```ruby
def do_something_with_block
  return "No block given" unless block_given?
  yield
end
```

- Blocks are closures. A block captures the local bindings such as environment (instance variables, local variables), self,.. **when it is defined**. It carries those bindings along when you pass the block into a method

```ruby
  def my_method
    x = "Goodbye"
    yield("Michael")
  end
  x = "Hello"
  my_method { |y| "#{x}, #{y} world" } # =>Hello, Michael world
```

### Scope

- Scopes are sharply separated in Ruby: whenever you enter a new scope, the previous bindings are replaced by a new set of bindings

```ruby
v1 = 1
class MyClass # Scope Gate: entering a class
  v2 = 2
  local_variables     # => [:v2]
  def my_method # Scope Gate: entering a method
    v3 = 3
    local_variables   # => [:v3]
  end  # Scope Gate: leaving a method
  local_variables     # => [:v2]
end  # Scope Gate: leaving a class

obj = MyClass.new
obj.my_method # => [:v3]
obj.my_method # => [:v3]
local_variables # => [:v1, :obj]

```

- You should use top-level variables over global variables, because it's safer
- You can spot scopes by using **Scope Gates**
- You can use `.instance_eval` to access private methods and instance variables but it breaks Encapsulation

```ruby
class MyClass
  def initialize
    @v = 1
  end
end

obj = MyClass.new
obj.instance_eval do
  self
  @v # => 1
end

```

### Scope Gates

- There are 3 places (Scope Gates) where a program leaves the previous scope behind and opens a new scope:
  - Class definitions
  - Module definitions
  - Methods
- You can not pass a variable through Scope Gates. To do it we have some tricks.

  - Use **Flat Scope**: the two scopes share the same variables. Replace a class with a method call

    ```ruby
      my_var = "success"
      MyClass = Class.new do
        p "#{my_var} in the class definition"
      end
    ```

  - Use **Shared Scope**: define all methods in the same Flat scope

    ```ruby
      def define_methods
        shared = 0
        Kernel.send :define_method, :counter do
          shared
        end

        Kernel.send :define_method, :inc do |x|
          shared += x
        end
      end
      define_methods
      counter # => 0
      inc(3)
      counter # => 3
    ```

## Callable objects

There are 3 types of callable objects in Ruby: Procs, lambdas and methods.

### Procs

- A Proc is a block that has been turned into an object. It's evaluated in the scope where it's defined. To create a Proc, you can use `Proc.new`
- You can call a proc by using `.call`

```ruby
inc = Proc.new {|x| x + 1}
inc.call(2) # => 3
```

- Proc return from the scope where the proc itself is defined

```ruby
def double(callable_object)
  callable_object.call * 2
end

def another_double
  p = Proc.new { return 10 } # => should be: Proc.new { 10 }
  res = p.call
 return res * 2 # unreachable code
end

l = lambda { return 10 }
p double(l)  #=> 20
p another_double # => 10
```

- You can call a proc with the wrong number of arguments (can call the arity)

```ruby
p = Proc.new { |a, b| [a, b] }
p.arity #=> 2
p.call(1, 2, 3) #=> [1, 2]
p.call(1) #=> [1, nill]
```

### Lambdas

- A lambda is a way to define a block & its parameters with some special syntax.
- Procs created with `lambda` are call lambdas (you can checks `Proc#lambda?` to check whether the Proc is a lambda)
- Use `.call` method to execute lambda
- A lambda will return normally, like a regular method. _So many Rubyists use lambda as first choice_

```ruby
# You can save this lambda into a variable for later use.
say_something = ->(x) { puts "This is a lambda", x }
#say_something = lambda { |x| puts "This is a lambda", x }
say_something.call(10) # => "This is a lambda" "10"
say_something.(11)
say_something[12]
say_something.=== 13
```

- Call a lambda with the wrong arity, it fails with an `ArgumentError`

```ruby
def double(callable_object, x)
  callable_object.call(x) * 2
end

l = lambda {|x, y| return x + y}
p double(l, 10)  #=> wrong number of arguments (given 1, expected 2) (ArgumentError)

```

## Methods

- Use `Kernel#method` you can get the method itself as a Method object. You can execute it later with `Method.call`
- A method object is similar to a block or a lambda. You can convert a Method to a Proc by calling `Method#to_proc`, and you can convert a block to a method with `define_method`
- The different between lambdas and methods: a lambda is evaluated in the scope where it's defined in (closure), while a method is evaluated in a scope of its object
- They can also be unbound from their scope and rebound to another object or class.

```ruby
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
```
