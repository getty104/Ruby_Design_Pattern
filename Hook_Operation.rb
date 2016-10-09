class Button
  def initialize(name, hook = NullHook.new)
    @name = name
    @hook = hook
  end
  def doClick
    @hook.preHook
    click
    @hook.postHook
  end
  def click
    puts(@name + ":click");
  end
end

class NullHook
  def preHook
  end
  def postHook
  end
end

class LogHook
  def preHook
    puts("LogHook:preHook")
  end
  def postHook
    puts("LogHook:postHook")
  end
end


button1 = Button.new("button1")
button1.doClick()

puts("")
button2 = Button.new("button2", LogHook.new)
button2.doClick()
