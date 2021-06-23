module MyModule
  def my_method
    24
  end
end

unbound = MyModule.instance_method(:my_method)
p unbound.my_method
