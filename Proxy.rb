
require 'etc'

class Bank

	def initialize()
		@money =0
	end

	def add(num)
		@money += num
	end

	def use(num)
		@money -= num
	end

	def show
		puts "#{@money}"
	end
end

class DefProxy

	def initialize(real_obj, user_name)
		@real_obj, @user_name = real_obj, user_name
	end

	def add(num)
		@real_obj.add(num)
	end

	def use(num)
		check_access
		@real_obj.use(num)
	end

	def show
		check_access
		@real_obj.show
	end

	def check_access
		if Etc.getlogin != @user_name
			raise "Illegal access: #{@user_name}"
		end
	end

end

class ImProxy
	def initialize()
		puts "ImProxyを作成しました。Bankはまだ生成していません"
	end

	def use(num)
		subject.use(num)
	end

	def add(num)
		subject.add(num)
	end

	def show
		subject.show
	end

	def subject
		@subject || (@subject = Bank.new ; puts "Bankを作成しました")
		@subject
	end
end

bank = Bank.new

d1 = ImProxy.new()
d1.add(100)
d1.use(10)
d1.show

d2 = DefProxy.new(bank,"notuser")
d2.add(100)
d2.use(10)
d2.show
