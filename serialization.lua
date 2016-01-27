print([==[abc[=\/]bbb[]]==])  -->abc[=\/]bbb[]
a='"abc"'
b="'abc'"
print(b)    -->'abc'
print(a)    -->"abc"
print(string.format("%q",a))  -->"\"abc\""
--保持无环的table
function serialize( o )
	if type(o)=="number" then
		io.write(o)
	elseif type(o)=="string" then
		io.write(string.format("%q",o))
	elseif type(o)=="table" then
		io.write("{\n")
		for k,v in pairs(o) do
			--io.write(" ",k,"=")
			io.write("[");serialize(k);io.write("]=")
			serialize(v)
			io.write(",\n")
		end
		io.write("}\n")
	else
		print("cannot serialize a"..type(o))
	end
end
str={"boy",12,"girl"}
serialize(str)
--保存有环的table
function basicserialize( o )
	if type(o)=="number" then
		return tostring(o)
	else
		return string.format("%q",o)
	end
end
function save( name,value,saved )
	saved = saved or {}
	io.write(name,"=")
	if type(value)=="number" or type(value)=="string" then
		io.write(basicserialize(value),"\n")
	elseif type(value)=="table" then
		if saved[value] then
			io.write(saved[value],"\n")
		else
			saved[value]=name
			io.write("{}\n")
			for k,v in pairs(value) do
				k=basicserialize(k)
				local fname = string.format("%s[%s]",name,k)
				save(fname,v,saved)
			end
		end
	else
		error("cannot save a "..type(value))
	end
end
a={a=12,x="y";{1,2,3};{4,5,6}}
b={k=a[1]}
-- a[3]=a --环
-- a.z=a[1]  --共享子table
local t = {}
save("a",a,t)
save("b",b,t)
