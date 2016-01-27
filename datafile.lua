local count = 0
function Entry( ... )
	count = count + 1
end
dofile("D:\\book")
print("number of entries:"..count)
--根据数组
-- local authors = {}
-- function Entry( b )
-- 	authors[b[1]]=true
-- end
-- dofile("D:\\book")
-- for name in pairs(authors) do
-- 	print(name)
-- end
--根据键值
local authors = {}
function Entry( b )
	authors[b.author]=true
end
dofile("D:\\book")
for name in pairs(authors) do
	print(name)
end
