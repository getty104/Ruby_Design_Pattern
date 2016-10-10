
class Abstractfactory
	def initialize(n1,n2)
		@animal = []
		@feed = []
		n1.times do |i|
			@animal << animal_new("#{i+1}")
		end

		n2.times do |i|
			@feed << feed_new("#{i+1}")
		end

	end

	def getNames
		@animal.each do |v|
			puts "Animal #{v.getName}"
		end
		@feed.each do |v|
			puts "Feed #{v.getName}"
		end
	end
end

class Factory1 < Abstractfactory
	def initialize(n1,n2)
		super(n1,n2)
	end

	def animal_new(name)
		Lion.new(name)
	end

	def feed_new(name)
		Sheep.new(name)
	end

end

class Factory2 < Abstractfactory
	def initialize(n1,n2)
		super(n1,n2)
	end

	def animal_new(name)
		Lion.new(name)
	end

	def feed_new(name)
		Horse.new(name)
	end
end
class Lion
	def initialize(name)
		@name = name
	end

	def getName
		"Lion:#{@name}"
	end
end

class Sheep
	def initialize(name)
		@name = name
	end

	def getName
		"Sheep:#{@name}"
	end
end

class Horse
	def initialize(name)
		@name = name
	end
	
	def getName
		"Horse:#{@name}"
	end
end

factory = Factory1.new(2,4)
factory.getNames
puts ""
factory = Factory2.new(3,4)
factory.getNames
