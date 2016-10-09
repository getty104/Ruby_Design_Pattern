
class Monostate
	@@data = nil

	def getData
		@@data
	end

	def setData(data)
		@@data = data
	end
end

m1 = Monostate.new
m2 = Monostate.new
m1.setData("data1")
puts m1.getData
puts m2.getData
puts ""
m2.setData("data2")
puts m1.getData
puts m2.getData
