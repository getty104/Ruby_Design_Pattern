#!/usr/bin/env ruby
# Future 
require "thread"
class RealData
  attr_reader :content
  def initialize count ,c
    puts "        making RealData( #{count}, #{c} )"
    @content = (1..count).map{sleep(100.to_f/1000); c}.join
  end
end
class FutureData
  @real_data = nil
  @ready = false
  def initialize
    @m = Mutex.new
    @cv = ConditionVariable.new
  end
  def set_real_data data
    @m.synchronize {
      return if( @ready )
      @real_data = data
      @ready = true
      @cv.broadcast
    }
  end
  def contents
    @m.synchronize{
      #while(!@ready) do @cv.wait(@m) end # Guraded Suspention
      return "まだ準備中よ。" if !@ready # Balking
      @real_data.content
    }
  end
  def to_s() contents end
end
class Host
  def request count, str
    future= FutureData.new
    puts "  request ( #{count}, #{str} ) BEGIN"
    t = Thread.new{
      data = RealData.new count,str
      future.set_real_data data
    }
    puts "  request ( #{count}, #{str} ) END"
    return future,t
  end
end
#STDOUT.sync = true
puts "main BEGIN"
host = Host.new
threads =[
  host.request(10, "A"),
  host.request(20, "B"),
  host.request(30, "C"),
]
puts "main END"


# 作り捨てたスレッドを待つ 
# Ruby のスレッドはMainが終了すると他も巻き込むのでここで待つ
# 
# スレッドが終ってからFutureを表示してみる
#    Guraded Suspention の場合 Futureを読み出しでブロックし、スレッド終了待つ
#    Balking            の場合 join で スレッド終了を待つ
threads.map{|r|r[0]}.each{ |v| puts "data = "+ v.to_s }
threads.map{|r|r[1]}.each{ |t|t.join}
threads.map{|r|r[0]}.each{ |v| puts "data = "+ v.to_s }

# Ajaxを状況に応じて表示変えるのに使われてたり？・・・
#   callback
# 終るまで、「処理中...」を表示したり
# 