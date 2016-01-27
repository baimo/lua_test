--coroutine(table)
--协同程序的四种states：
--挂起(suspended),运行(running)
--死亡(dead),正常(normal)
--产生一个新的协同程序(刚生成的状态是:suspended)：
co=coroutine.create(function()
	print("hi")
end)
--查看状态：
coroutine.status(co)
--启动协同程序,然后将其关闭(协同程序执行完了，就结束程序):
coroutine.resume(co)
--使运行中的协同程序挂起:
coroutine.yield(co)
co=coroutine.create(function()
	while true do
		local x = 1
		print("hi",x)
		x=x+1
		coroutine.yield() --使得程序一直是挂起状态
	end
end)