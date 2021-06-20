require_relative './ds.rb'

class Computer
  def initialize(computer_id, data_source)
    @id = computer_id
    @data_source = data_source
    # automatically define new methods match the pattern: /^get_(.*)_info$/
    data_source.methods.grep(/^get_(.*)_info$/) do
      p Regexp.last_match(0)
      Computer.defined_conponent Regexp.last_match(1)
    end
  end

  def self.defined_conponent(name)
    define_method(name) do
      # use dynamic dispatch .send
      info = @data_source.send "get_#{name}_info", @id
      price = @data_source.send "get_#{name}_price", @id
      result = "#{name.capitalize}: #{info} ($#{price})"
      return "* #{result}" if price >= 100

      result
    end
  end

  # defined_conponent :mouse
  # defined_conponent :cpu
  # defined_conponent :keyboard
end

my_computer = Computer.new(42, DS.new)
p my_computer.mouse
p my_computer.cpu
p my_computer.keyboard
