

class Files
	@@num=0
	def initialize()
	end

	def geta
		1
	end

	def show
		@@num+=1
		puts "file#{@@num}"
	end


end

class Directorys
	@@num=0
	@@sp =""
	def initialize()
		@file = []
	end

	def add(file)
		@file << file
	end

	def geta
		ans=0
		@file.each do |obj|
			ans += obj.geta
		end
		ans
	end

	def show
		@@num+=1
		puts "directory#{@@num}"
		@@sp+=" "
		@file.each do |obj|
			print "#{@@sp}"
			obj.show
		end
		
	end
end

d1 = Directorys.new
d1.add(Files.new)
d1.add(Files.new)

d2 = Directorys.new
d2.add(Files.new)
d2.add(Files.new)

d1.add(d2)

d3 = Directorys.new
d3.add(Files.new)

d2.add(d3)

d1.show



