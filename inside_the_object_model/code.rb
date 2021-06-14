class Foo
  def initialize(a, b, c = nil)
    @a = a
    @b = b
    @c = c if c
  end
end

obj = Foo.new(4, 5)
obj2 = Foo.new(6, 7, 8)
p 'instance_variables of obj', obj.instance_variables
p 'instance_variables of obj 2', obj2.instance_variables
p 'Methods', obj2.methods

Y = 'a root-level constant'.freeze

module M
  Y = 'a constant in M'.freeze
  Y # => 'a constant in M'
  ::Y # => 'a root-level constant'
  class C
    X = 'a constant'.freeze
  end
  C::X # => "a constant"
end
p M::C::X # => "a constant"
p 'Const', M.constants # => []
