
require "pp"
require "sync"

class ReadWriteLock
  include Sync_m

  def initialize
    super
    @word =""
  end

  def read(name)
    sync_synchronize(:SH){
      puts("#{name},read:#{@word}")
    }
    sleep(rand(2))
    nil
  end

  def write(data)
    sync_synchronize(:EX){
      puts("write:#{data}")
      @word+=data
      
    }
    sleep(rand(2))
    
    nil
  end
end

class Main

  def initialize(thread)
    @thread = thread
  end
  def read(name)
    @thread.read(name)
  end

  def write(data)
    @thread.write(data)
  end
end


thread = ReadWriteLock.new

thread1 = Main.new(thread)
thread2 = Main.new(thread)
thread3 = Main.new(thread)
t1=Thread.new{
  i=0
  loop do 
    thread.write(((i+=1)%10).to_s)

  end
}

t2=Thread.new{
  loop do
    thread1.read("Thread1")
  end
}

t3=Thread.new{
  loop do
    thread2.read("Thread2")
  end
}

t4=Thread.new{
  loop do
    thread3.read("Thread3")
  end
}

t1.join
t2.join
t3.join
t4.join


