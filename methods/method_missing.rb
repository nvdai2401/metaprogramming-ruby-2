class Lawyer
  def my_method
    p 'Hello world'
    Lawyer.my_class_method
  end

  def self.my_class_method
    p 'my_class_method'
  end

  protected

  def my_protected_method
    p 'my_protected_method'
  end

  private

  def my_private_method
    p 'my_private_method'
  end
end
nick = Lawyer.new
p nick.methods
p '================================================'
p Lawyer.instance_methods
nick.talk_simple # => undefined method `talk_simple' for #<Lawyer:0x00007fba52033888> (NoMethodError)
nick.send :my_private_method
nick.my_private_method
nick.my_method
nick.send :method_missing, :my_method
