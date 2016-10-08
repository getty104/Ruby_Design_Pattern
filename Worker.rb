require "singleton"
class Worker
	def initialize(request)
		@request = request
	end

	def work
		num = @request.give_task
		puts"#{num}処理終了"
	end
end

class Task
	def initialize(request)
		@request = request
		@num = 0.to_i
	end

	def make_task
		@num += 1
		data = "仕事"+@num.to_s
		@request.get_task(data)
		puts "#{data}追加"
	end
end

class Request
 	include Singleton
	def initialize
		@queue = Array.new
		@m = Mutex.new
		@cv = ConditionVariable.new
	end

	def get_task(data)
		@m.synchronize{
			while @queue.size >10
				puts "追加待機"
				@cv.wait(@m)
			end

			@queue.push(data)
			@cv.broadcast
		
		}		
	end

	def give_task
		@m.synchronize{
			while @queue.empty?
				puts("処理待機")
				@cv.wait(@m)
			end
			
			dt = @queue.shift
			@cv.broadcast
			return dt
		}
	end
end


worker = Worker.new(Request.instance)
task = Task.new(Request.instance)

t1 = Thread.new{
	100.times do
		task.make_task
		sleep rand(2)
	end
}
t2 = Thread.new{

	100.times do
		worker.work
		sleep rand(2)
	end
}

t1.join
t2.join




