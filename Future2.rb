#!/usr/bin/env ruby
module ActiveObject
  require "thread"
  class MethodRequest
    def initialize( servant,future )
      @servant = servant
      @future = future
    end
    def execute() nil end
  end
  class DisplayStringRequest < MethodRequest
    def initialize( servant, str)
      super(servant,nil)
      @content = str
    end
    def execute()
      @servant.display_string @content
    end
  end
  class MakeStringRequest < MethodRequest
    def initialize( servant,future,count,fill_char )
      super(servant, future)
      @count = count
      @fill_char = fill_char
    end
    def execute()
      result = @servant.make_string @count, @fill_char
      @future.set_result result
    end
  end
  class Proxy
    def scheduler() @scheduler end
    def initialize scheduler, servant
      @scheduler = scheduler
      @servant = servant
    end
    def make_string count, fill_char
      future = FutureResult.new
      req =  MakeStringRequest.new(@servant,future,count,fill_char)
      @scheduler.invoke(req)
      return future
    end
    def display_string str
      req = DisplayStringRequest.new(@servant,str)
      @scheduler.invoke(req )
    end
  end
  class Result
    def get_value() nil end
  end
  class RealResult < Result
    def initialize value
      @result_value = value
    end
    def get_value
      @result_value
    end
  end
  class FutureResult < Result
    def initialize
      @m = Mutex.new
      @cv = ConditionVariable.new
      @ready = false
    end
    def set_result(ret)
      @m.synchronize{
        return if(@ready)
        @result = ret
        @ready = true
        @cv.broadcast
      }
    end
    def get_value()
      @m.synchronize{
        #return "準備中" if !@ready
        while(!@ready) do @cv.wait(@m) end
        @result.get_value
      }
    end
  end
  class SchedulerThread
    def get_thread() @t end
    def initialize queue
      @q = queue
    end
    def start
      b=Proc.new{
        loop do
          req = @q.take_request
          sleep 0.05
          req.execute
        end
      }
      @t=Thread.new(&b)
    end
    def invoke( request )
      @q.put_request request
    end
  end
  class ActivationQueue
    MAX_METHOD_REQUEST = 100
    def initialize 
      @list = Array.new
      @size = MAX_METHOD_REQUEST
      @m = Mutex.new
      @cv_full  = ConditionVariable.new
      @cv_empty = ConditionVariable.new
    end
    def put_request req
      @m.synchronize{
        while( @size == @list.size) do
          @cv_full.wait(@m)
        end
        @list.push req
        @cv_empty.broadcast
      }
    end
    def take_request
      @m.synchronize {
        while(@list.empty?) do
          @cv_empty.wait(@m)
        end
        req = @list.shift
        @cv_full.broadcast
        req
      }
    end
  end
  class Servant
    def make_string count, c
      buff= (1..count).map{sleep 10.to_f/1000; c }.join
      result = RealResult.new buff
    end
    def display_string str
      puts "display_string: #{str}"
      sleep 10.to_f/1000
    end
  end
  class ActiveObjectFactory
    def ActiveObjectFactory.create_active_object
      servant = Servant.new
      queue = ActivationQueue.new
      scheduler = SchedulerThread.new queue
      proxy = Proxy.new scheduler, servant
      t=scheduler.start
      return proxy
    end
  end

end


include ActiveObject

class DisplayClientThread
  def initialize name, activeobject 
    @activeobject = activeobject
    @name = name
    @fill_char = name[0].chr
  end
  def start
    t = Thread.new {
        i=0
        while true do
        #戻り値のない呼び出し
        str = "#{@name} #{i}"
        @activeobject.display_string str
        sleep 0.3
        i=i+1
       end
     }
  end
end

class MakerClientThread
  def initialize name, activeobject 
    @activeobject = activeobject
    @name = name
    @fill_char = name[0].chr
  end
  def start
    t = Thread.new {
      i=0
      while true do
        #戻り値のある呼び出し
        result = @activeobject.make_string i, @fill_char
        sleep rand(1000).to_f/1000
        i = i+ 1
        val = result.get_value
        puts "#{@name}: value = #{val}"
       end
     }
  end
end

activeobject = ActiveObjectFactory.create_active_object
threads=[
  activeobject.scheduler.get_thread,
  MakerClientThread.new("Alice", activeobject).start(),
  MakerClientThread.new("Bobby", activeobject).start(),
  DisplayClientThread.new("Chris", activeobject).start(),
]
threads.first.join
