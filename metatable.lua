--------------------元表：算术元方法 ------------------
print("----------元表：算术元方法 -----------")
--[[
+ 	__add
* 	__mul
- 	__sub
/ 	__div
- 	__unm (for negation)
% 	__mod
^ 	__pow
--]]
set={}
local meta = {}
function set.new( t )
	local set = {}
	setmetatable(set,meta)
	for _,v in ipairs(t) do
		set[v]=true
	end
	return set
end
function set.union( a,b )
	local res = set.new{}
	for k in pairs(a) do
		res[k]=true
	end
	for k in pairs(b) do
		res[k]=true
	end
	return res
end
function set.intersection( a,b )
	local res = set.new{}
	for k in pairs(a) do
		res[k]=b[k]
	end
	return res
end

function set.tostring( set )
	local l = {}
	for k in pairs(set) do
		l[#l+1]=k
	end
	return "{"..table.concat(l,",").."}"
end
function set.print( s )
	print(set.tostring(s))
end
meta.__add=set.union
meta.__mul=set.intersection
s1=set.new({10,20,30,40})
s2=set.new({30,20,1})
s3=s1+s2
s4=s1*s2
set.print(s3)
set.print(s4)
------------------------- 关系类的元方法--------------------------------
print("----------- 关系类的元方法------------")
-- __eq(==); __lt(=);__le(<=)
--[[
a ~= b 表示为 not (a == b)
a > b 表示为 b < a
a >= b 表示为 b <= a
--]]
mt={}
mt.__le=function( a,b )  --a<=b(只是比较table中的数量)
	for k in pairs(a) do
		if not b[k] then
			return false
		end
	end
	return true
end
mt.__lt=function( a,b )   --a<b
	return a<=b and not(b<=a)
end
mt.__eq=function( a,b )   --a==b
	return a<=b and b<=a
end
mt.__tostring=function( set ) --当输出一个table时，自动调用__tostring元方法
	local l = {}
	for k,v in pairs(set) do
		l[#l+1]=v
	end
	return "{"..table.concat(l,",").."}"
end
--mt__metatable="not your"
s1={2,3,4,5}
s2={4,5,6}
setmetatable(s1,mt)
setmetatable(s2,mt)
--getmetatable(mt)
print(s2<=s1)
print(s2)
--------------------访问table的元方法----------------------
------在调用table不存在的字段时，会调用__index元方法
------但是，如果这个__index元方法是一个table的话，那么，就会在这个table里查找字段，并调用
------大家要记住这句话：__index用于查询，__newindex用于更新
Window={}       --创建一个名称空间
--使用一个默认值来创建一个原型
Window.prototype={x=0,y=0,width=100,heigth=100}
Window.mt={}         --元表
--声明构造函数
Window.new=function( o )
	setmetatable(o,Window.mt)
	return o
end
Window.mt.__index=function( table,key ) --__index可以是函数也可以是table
	return Window.prototype[key]
end
--Window.mt.__index=Window.prototype    --等价于上面
w=Window.new{x=50,y=50}
print(w.x)
-------------------创建只读的table------------
print("-------------------创建只读的table------------")
readonly=function( t )
	local proxy = {}
	local mt = {
		__index=t;
		__newindex=function( t,k,v )     --__newindex元方法被调用的时候会
		                                 --传入3个参数：table本身、字段名、想要赋予的值
			error("attempt to update a read-only talbe",2)
		end
    }
    setmetatable(proxy,mt)
    return proxy
end
days=readonly{"sunday","monday","Tuesday"}
print(days[1])
--days[1]="Wednesday"           --会报错，进行赋值操作时会调用__newindex元方法
--当试图给days的days[1]字段赋值时，Lua判定days[1]字段是不存在的，所以会去调用元表里的__newindex元方法。
print(rawget(days,1))      --->nil
rawset(days,1,"abc")   --->给days[1]赋值
--但是使用rawset函数可以忽略__newindex功能
--同理rawget函数可以忽略__index功能
--------------------跟踪table的访问和修改---------------
print("------------------跟踪table的访问和修改----------------")
t={1,3,6} --原来的table
local _t = t    --保持对原有table的私有访问
--创建一个代理table
t={}
local mt = {
	__index = function( t,k )
		print("access to element "..tostring(k))
		return _t[k]  --访问table
	end,
	__newindex = function( t,k,v )
		print("update of element "..tostring(k).." to "..tostring(v))
		_t[k]=v       --更新table
	end
}
setmetatable(t,mt)
t[2]="abc"  --->update of element 2 to abc
print(t[2]) --->access to element 2   abc
print(t[3])
--上述无法访问原table，也就是pairs只能操作代理table，无法访问原来的table！！
-- for k,v in pairs(t) do
-- 	print(k,v)   -->abc
-- end
--将原来的table保存在代理table的一个特殊的字段中
--若要监视table t，唯一要做的就是执行： t = track(t)
print("------------------解决上述的问题----------------")
local index = {} --创建私有索引
local mt = {
	__index = function( t,k )
		print("access to element "..tostring(k))
		return t[index][k]  --访问table
	end,
	__newindex = function( t,k,v )
		print("update of element "..tostring(k).." to "..tostring(v))
		t[index][k]=v       --更新table
	end
}
function track( t )   --所有代理共享同一个元表
	local proxy = {}
	proxy[index] = t
	setmetatable(proxy, mt)
	return proxy
end
t = track(t)
-- for k,v in pairs(t) do
-- 	print(k,v)   -->abc
-- end
