
class Dish
	def initialize() 
		@washing = false
		@m = Mutex.new

	end

	def wash()
		@m.synchronize{
			if @washing
				puts "Balk :#{Thread.current}"
				return
			end
			@washing = true
		}
		rawWash()
		@washing = false
	end
	private
	def rawWash()
		puts "Start washing :#{Thread.current.to_s}"
		sleep(rand(2))
		puts "End washing :#{Thread.current.to_s}"
	end

end

class Worker
	def initialize(dish)
		@dish = dish
	end

	def run
		loop{
			@dish.wash
			puts "Work :#{Thread.current}"
			sleep(rand(2))
		}
	end
end


dish = Dish.new
l1 = Thread.new{
	Worker.new(dish).run
}
l2 = Thread.new{
	Worker.new(dish).run
}
l3 = Thread.new{
	Worker.new(dish).run
}

l1.join
l2.join
l3.join



