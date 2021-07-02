an_object = Object.new

singleton_class = class << an_object
                    self
end

def an_object.my_singleton_method; end

p singleton_class.class
p singleton_class.singleton_class
p singleton_class.singleton_class.superclass
p singleton_class.singleton_class.ancestors
p singleton_class.instance_methods.grep(/my_/)
