class Lawyer
  def my_method
    p 'Hello world'
  end

  private

  def my_private_method
    p "my_private_method"
  end
end
nick = Lawyer.new
# nick.talk_simple # => undefined method `talk_simple' for #<Lawyer:0x00007fba52033888> (NoMethodError)
nick.send :my_private_method
nick.my_private_method
nick.my_method
nick.send :method_missing, :my_method
