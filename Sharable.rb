
class Monster
	@@list = Hash.new
	@@m = Mutex.new
	attr_reader :pos
	def initialize()
		@pos = 0
	end

	def self.createMonster(name)
		@@m.synchronize{
			if !@@list.include?(name)
				@@list[name] = Monster.new()
			end
			@@list[name]
		}
	end

	def move(num)
		@pos += num
	end
end

m1 = Monster.createMonster("m1")
m1.move(1)
m2 = Monster.createMonster("m2")
m2.move(-2)

puts m1.pos
puts m2.pos

m3 = Monster.createMonster("m1")
m3.move(3)
puts m3.pos