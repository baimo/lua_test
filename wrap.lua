--用协同程序实现迭代器，coroutine.wrap()函数
function prengem( a,n )
	n = n or #a
	if n<1 then
		coroutine.yield(a) --printResult(a)
	else
		for i=1,n do
			a[n],a[i] = a[i],a[n]
			prengem(a,n-1)
			a[n],a[i] = a[i],a[n]
		end
	end
	-- body
end
function printResult( a )
	for i=1,#a do
		io.write(a[i]," ")
	end
	io.write("\n")
end
function permutations( a )
	--使用wrap函数实现,但无法显示协同程序的状态，只是返回一个函数
	return coroutine.wrap(function() prengem( a ) end)
	-- local co = coroutine.create(function() prengem( a ) end)
	-- return function (  )
	-- 	local status,res=coroutine.resume(co)
	-- 	return res
	-- end
end
for p in permutations({"a","b","c"}) do
	printResult(p)
end
------------非抢先式的多线程(non-preemptive)------------
--用LuaSocket库下载一个文件
require "socket"                             --加载luaSocket
host="www.w3.org"
file="/"
c=assert(socket.connect(host,80))
c:send("GET "..file.." HTTP/1.0\r\n\r\n")
while true do
	local src,status,partial=c:receive(2^10)
	io.write(src or partial)
	if status == "close" then
		break
	end
end
c:close()
--用协同程序实现下载多个文件（并行）
require "socket"
function download( host,file )
	c=assert(socket.connect(host,80))
	c:send("GET "..file.." HTTP/1.0\r\n\r\n")
	while true do
		local src,status,partial = receive( c )
		local count = 0            --记录接收的字节数
		io.write(src or partial)
		if status == "close" then
			count = count + #(src or partial)
			break
		end
	end
end 
--顺序下载
function receive( connection )
	local src,status,partial = connection:receive(2^10)
	return src
end
--并发下载
function receive( connection )
	connection:settimeout(0)             --使receive调用不会阻塞
	local src,status,partial = connection:receive(2^10)
	if status == "timeout" then
		coroutine.yield(connection)
	end
	return src or partial,status
	-- body
end
local threads={}          --用来记录正在运行的线程
function get( host,file )
	local co = coroutine.create(function()
		download( host,file )
	end)
	table.insert(threads,co)
end
--调度程序
function dispatch()
	local i = 1
	while true do
		if threads[i] == nil then
			if threads[1] == nil then break end
			i=1          --重新开始循环
		end
		local status, res = coroutine.resume(threads[i])
		if not res then
			table.remove(threads,i)
		else
			i = i + 1
		end
	end
end
--如果所有的线程都堵塞，退出（用socket.select()函数）
--重写调度函数
function dispatch()
	local i = 1
	local connections = {}
	while true do
		if threads[i] == nil then
			if threads[1] == nil then break end
			i=1          --重新开始循环
			connections = {}
		end
		local status, res = coroutine.resume(threads[i])
		if not res then
			table.remove(threads,i)
		else
			i = i + 1
			connections[#connection+1] = res
			if #connections == #threads then    --所有线程都堵塞就退出
				socket.select(connections)
			end
		end
	end
end
host="www.w3.org"
file="/"
get(host,file)
dispatch()         --主循环