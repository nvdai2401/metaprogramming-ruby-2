class Loan
  def initialize(book)
    @book = book
    @time = Loan.time_class.now
  end

  def self.time_class
    @time_class || Time
  end

  def to_s
    "#{@book.upcase} loaned on #{@time}"
  end
end

class FakeTime
  def self.now
    'Mon Apr 06 12:15:50'
  end
end

Loan.instance_eval { @time_class = FakeTime }
loan = Loan.new('War ans Peace')

p loan.to_s
