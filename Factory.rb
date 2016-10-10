class DataType1

	def initialize(name)
		@name = name
	end

	def getName
		"DataType1:#{@name}"
	end
end

class DataType2
	def initialize(name)
		@name = name
	end

	def getName
		"DataType2:#{@name}"
	end
end

class Factory
	def initialize(number)
		@data = []
		number.times do |i|
			@data << Data_new(i)
		end
	end

	def getList
		@data.each do |v|
			puts v.getName
		end
	end


end

class Data1Factory < Factory
	def initialize(number)
		super(number)
	end

	def Data_new(name)
		DataType1.new(name)
	end
end

class Data2Factory < Factory
	def initialize(number)
		super(number)
	end

	def Data_new(name)
		DataType2.new(name)
	end
end

data1 = Data1Factory.new(3)
data1.getList

data2 = Data2Factory.new(4)
data2.getList
