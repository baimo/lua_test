--多重赋值：先运算表达式再赋值
a={1,2,3,4}
i=2
i,a[i]=i+1,0
print(a[i])
print(a[1])
print(a[2])
print(a[3])
print(a[4])
--交换x,y,z的值
x=2
y=3
z=4
x,y,z=z,y,x
print(x..y..z)
a,b,c,d=1,2,3
print(a,b,c,d)
--if语句
x=3
if a>0 then
	local x = 1
	print(x)
elseif a>2 then
	print(x+1)
end
print(x)
print("----------数值for语句----------")
-- for var=exp1,exp2,exp3 do
--  	<something>
-- end
--三个表达式exp1（起始值）,exp2（终止）,exp3（步长默认是 1）只有在循环开始是被求值一次
--不要尝试修改控制变量的值，可以用break终止循环
local a = {1,2,3,4,5,6}
for i=1,10 do
	print(i)
end
for i=1,#a do			--# 是取table长度
	print(a[i])
end
for i=#a,1,-1 do
	print(i)
end
print("---------泛型for语句--------------")
-- for i,v in ipairs(table_name) do
-- 	print(i,v)
-- end
--i是索引，v是值，ipairs是迭代器(遍历表)
--同样的迭代器还有：
--io.lines(遍历文件行)
--ipairs(数组元素迭代)

--pairs可以遍历表中所有的key，并且除了迭代器本身以及遍历表本身还可以返回nil
--但是ipairs则不能返回nil,只能返回数字0，如果遇到nil则退出。它只能遍历到表中出现的第一个不是整数的key

--pairs(table元素迭代)(而且不是按顺序输出table中的键和值)
--string.gmatch(遍历字符串)
local b = {1,2,3,4,5,6}
for i,v in ipairs(b) do
	print(i,v)
end
weekdays={"Monday","Tuesday","wednesday","Thursday","Friday"}
weekdaysFor={}
for k,v in pairs(weekdays) do
	weekdaysFor[v]=k
end
print(weekdaysFor["Tuesday"])
for i,v in pairs(weekdaysFor) do
	print(i,v)
end
--break,return,goto语句
local g={1,2,3,4,5,6}
local pos = nil
for i=1,#g do
	if  g[i]>3  then
		pos=g[i]             --找到第一个大于3的值
		print(pos)
		break                --跳出循环
	end
end
--return从函数中返回结果或结束函数
--限制：只能在一个语句块的最后出现
--find "v" corresponding index
function index( a,v )
	for i=1,#a do
		if  a[i]==v  then
			return i
		end
	end
	print("not found the \"v\" corresponding index")
end
print(index(a,9))
--如果return想在中间使用，就要借助do...end语句
function doend()
	print("before return")
	do return 0 end
	print("after return")
end
doend()
--goto语句不能跳出函数（function），
--不能跳入一个块（block）(因为块中的标签对外不可见),
--不能跳入一个局部变量的作用域
--弥补lua缺失的语句：continue，多级break，多级continue，redo，局部错误处理等
local x = 1
while x<6 do
	::redo::
	if  x<10 then
		print(x)
		x=x+2
		goto redo
	end
	print(x)
end
--模仿continue语句：跳出某一次循环
-- while exp do
-- 	if exp1 then
-- 		<something>
-- 		goto continue
-- 	end
-- 	<一段代码>
-- 	::continue::
-- end