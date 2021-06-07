# @file Introspection
class Greeting
  def initialize(text)
    @text = text
  end

  def welcome
    @text
  end
end

my_object = Greeting.new('Hello world!')

p 'welcome', my_object.welcome
p 'class name', my_object.class
p 'instance methods', my_object.class.instance_methods(false)
p 'instance variables', my_object.instance_variables
