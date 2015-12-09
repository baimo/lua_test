local x = "hello,world"
local s,e=string.find(x,"%w+",1)
print(s,e)
print(string.sub(x,2,8))
--做迭代器遍历一个文件中所有单词
-- for word in allwords() do
-- 	print(word)
-- end
-- function allwords()
-- 	local line = io.read()
-- 	local pos = 1
-- 	return function(  )
-- 		while line do
-- 			local s,e = string.find(line,"%w+",pos)
-- 			if s then
-- 				pos = e+1
-- 				return string.sub(line,s,e)
-- 			else
-- 				line = io.read()
-- 				pos = 1
-- 			end
-- 		end

-- 		return nil
-- 	end
-- end
--用next函数实现pairs()迭代器功能
local a = {"a","b","c"}
for i,v in next,a do
	print(i,v)
end
--复杂状态的迭代器
local iterator
function allwords()
	local state = {line=io.read(),pos=1}
	return iterator,state
end
function iterator( state )
	while state.line do
		local s,e = string.find(state.line,"%w+",state.pos)
		if s then
			state.pos = e+1
			return string.sub(state.line,s,e)
		else
			state.line = io.read()
			state.pos = 1
		end
	end
	return nil
end
for word in allwords() do
	print(word)
end
--编译loadfile(),loadstring()函数
i=0
f=loadstring("i=i+1")
f()
print(i)
f()
print(i)
--dofile()函数是用loadfile（）函数实现的
function dofile(filename)
	local x = assert(loadfile(filename))
	return x()
end
--
i=9
local i = 1
f=loadstring("i=i+1;print(i)")--loadstring()用的是全局变量
g=function ()
	i =i + 1
	print(i)
end
f()   -->10
g()   -->2
--错误处理error
do
	print("plaese enter a number:")
	x = io.read("*number")
	if not x then
		error("invalib input") -->如果输入的不是number类型的就输出invalib input
	end
end
--错误处理assert
do
    print("plaese enter a number:")
    n=assert(io.read("*number"),"invalib input") -->如果输入的不是number类型的就输出invalib input
end
--io.open
do
	print "please enter filename"
	local file , msg
	repeat
		local x = io.read()
		if not x then
			return nil
		end						  --This function opens a file, in the mode specified(指定) in the string mode
		file,msg = io.open(x,'r') --io.open：It returns a new file handle,  
		if not file then		  --or, in case of errors, nil plus an error message.
			print(msg)
		end
	until file
end
do
	print "please enter filename"
	local file
	repeat
		local x = io.read()
		if not x then
			return nil
		end
		file,msg = io.open(x,'r')
		f = assert(file)
	until file
end
--pcall保护模式执行代码:pcall catches(捕获) the error and returns a status code(ture or false)
--xpcall (f, msgh [, arg1, ···]):This function is similar to pcall, except that it sets a new message handler msgh. 
do
	function foo(  )
		print("a"+1)
	end
	if pcall(foo) then --没有错误
		<正常执行代码>
	else               --错误情况
		<错误处理代码>
end
do
	function foo(  )
		print("a"+1)
	end
	function err(  )
		return "error"
	end
	status,msg=xpcall(foo,err)
	if not status then
    	print(msg)
	end
end