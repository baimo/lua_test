--用函数闭包的方法实现面向对象
--类的创建
function people( name )
	local self = {}
	local function init()
		self.name=name
	end
	self.sayHi =function ( )
		print("Hello "..self.name)
	end
	init()
	return self
end  
-- local p = people("zhangsan")
-- p.sayHi()
--类的继承
function man( name )
	local self = people(name)
	self.sayHello=function ()
		print("Hi "..self.name)
	end
	self.sayHi=function ()
		print("Hello2 "..self.name)
	end
	return self
end
local m = man("wanger")
m:sayHello()
m:sayHi()