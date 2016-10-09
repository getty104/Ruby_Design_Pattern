
class Bank
	
	def initialize
		@money = 0
		@m = Mutex.new
		@cv = ConditionVariable.new
	end

	def add
		@m.synchronize{
			while @money >5000
				puts "add wait"
				@cv.wait(@m)
			end
			n =  (rand*2000).to_i
			@money += n
			puts "add:#{n} :#{@money}"
			@cv.broadcast
		}
	end

	def use
		@m.synchronize{
			while @money <= 0
				puts "use wait"
				@cv.wait(@m)
			end
			n = (rand*(@money)).to_i
			@money -= n
			puts "use:#{n} :#{@money}"
			@cv.broadcast
		}
	end

end

class Parent
	def initialize(bank)
		@bank = bank
	end

	def add
		@bank.add
	end
end

class Child
	def initialize(bank)
		@bank = bank
	end

	def use
		@bank.use
	end

end


bank = Bank.new
parent = Parent.new(bank)
child = Child.new(bank)

t1 = Thread.new{
	loop do
		parent.add
		sleep(rand(2))
	end
}

t2 = Thread.new{
	loop do
		child.use
		sleep(rand(2))
	end

}

t1.join
t2.join



