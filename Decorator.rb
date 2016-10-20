

class ConcreteComponent

	def initialize(list)
		@list = list
	end

	def display(n)
		@list[n-1]
	end

	def geta
		@list.length
	end

end

class Culc

	def initialize(component)
		@component = component
	end

	def add(n1,n2)
		@component.display(n1)+@component.display(n2)
	end

	def sub(n1,n2)
		@componet.display(n1)-@componet.display(n2)
	end
end

class Script
	def initialize(component)
		@component = component
	end

	def stream
		str = "#{'"'}"
		@component.geta.times do |i|
			str += @component.display(i+1).to_s
		end
		str += "#{'"'}"
	end
end

comp = ConcreteComponent.new([1,2,3,4,5,6])
culc = Culc.new(comp)
script = Script.new(comp)

puts culc.add(1,3)
puts script.stream

