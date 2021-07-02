str = 'Hello world'

def str.title?
  upcase == self
end

p str.title?
p str.methods.grep(/title?/)
p str.singleton_methods
p str.singleton_class
