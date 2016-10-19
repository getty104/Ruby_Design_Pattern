
class Target
	def initialize(adapter)
		@adapter = adapter
	end

	def func1
		@adapter.func1
	end

	def func2
		@adapter.func2
	end
end

class Client
	
end

class Adapter
	def initialize(adaptee)
		@adaptee = adaptee
	end

	def func1
		@adaptee.show1
	end

	def func2
		@adaptee.show2
	end
end

class Adaptee

	def show1
	 "1"
	end

	def show2
		"2"
	end
end

t = Target.new(Adapter.new(Adaptee.new))

puts t.func1
puts t.func2