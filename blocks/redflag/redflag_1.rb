def setup(&block)
  @setups << block
end

def event(description, &block)
  @events << { description: description, condition: block }
end

@setups = []
@events = []

setup do
  puts 'Setting up sky'
  @sky_height = 100
end

setup do
  puts 'Setting up moutains'
  @mountain_height = 200
end

event 'the sky is falling' do
  @sky_height < 300
end

event "it's getting closer" do
  @sky_height < @mountain_height
end

event "whoops... it's too late" do
  @sky_height < 0
end

@events.each do |event|
  @setups.each do |setup|
    setup.call
  end
  puts "ALERT: #{event[:description]}" if event[:condition].call
end
