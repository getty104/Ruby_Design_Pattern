require 'singleton'
require 'thread'

class NullWorker
  include Singleton
end

module Worker
  @@active = NullWorker.instance
  @@mutex = Mutex.new
  def initialize(name)
    @name = name
  end
  def activate
    @@mutex.synchronize {
      @@active = self
    }
  end
  def to_s
    "[Worker #{@name}]"
  end
  def Worker.activeWork(job)
    @@mutex.synchronize {
      @@active.work(job)
    }
  end
end

class NullWorker
  include Worker
  def initialize
    super("The NullWorker")
  end
  def work(job)
    puts "(#{job} is ignored by NullWorker)"
  end
end

class PrintWorker
  include Worker
  def initialize(name)
    super(name)
  end
  def work(job)
    puts "#{self} does \"#{job}\"."
  end
end

class Main
  def Main.main
    worker1 = PrintWorker.new("worker1")
    worker2 = PrintWorker.new("worker2")
    Worker.activeWork("Hello, worker!")
    worker1.activate
    Worker.activeWork("Hello, worker!")
    worker2.activate
    Worker.activeWork("Hello, worker!")
  end
end
Main.main