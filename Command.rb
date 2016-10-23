

class Command
	
	def Count0(n1)
		mask =1
		ans =0
		32.times do
			tmp = n1&mask
			if tmp==0
				ans+=1
			end
			mask <<= 1
		end
		ans
	end
	
	def Count1(n1)
		mask =1
		ans =0
		32.times do
			tmp= n1&mask
			if tmp!=0
				ans+=1
			end
			mask <<= 1
		end
		ans
	end

end


n = gets.to_i
c = Command.new
puts c.Count0(n)
puts c.Count1(n)