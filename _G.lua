--lua将全局变量存放在一个叫_G的常规table中，叫环境
setmetatable(_G,{
	__index=function( _,n )
		error("attemp to undeclared variable "..n,2)
	end
})   --防止访问不存在的全局变量


for k,v in pairs(_G) do
	print(k,v)
end
