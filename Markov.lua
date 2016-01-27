local statetab = {} 
--我们会把两个单词用一个空格“ ”链接起来，编码为前缀
function prefix (w1, w2)  
    return w1 .. " " .. w2  
end
--程序将它的table保存到变量statetab中。我们用下面的函数在这个table的前缀list中插入一个新的单词
--它首先检查这个前缀是否有list了；如果么有，那么用这个新值创建一个新的list；否则，就将这个新值插入到已存在的list的末尾
function insert (index, value)  
    local list = statetab[index]  
    if list == nil then  
        statetab[index] = {value}  
    else  
        list[#list + 1] = value  
    end  
end  
function allwords ()  
    local line = io.read() -- current line  
    local pos = 1 -- current position in the line  
    return function () -- iterator function  
        while line do -- repeat while there are lines  
            local s, e = string.find(line, "%w+", pos)  
            if s then -- found a word?  
                pos = e + 1 -- update next position  
                return string.sub(line, s, e) -- return the word  
            else  
                line = io.read() -- word not found; try next line  
                pos = 1 -- restart from first position  
            end  
        end  
        return nil -- no more lines: end of traversal  
    end  
end  
-- The Markov program 
local N = 2  
local MAXGEN = 10000  
local NOWORD = "\n"  
-- build table  
local w1, w2 = NOWORD, NOWORD  
for w in allwords() do  
    insert(prefix(w1,  =w2), w)  
    w1 = w2; w2 = w;  
end  
insert(prefix(w1, w2), NOWORD)  
  
-- generate text  
w1 = NOWORD; w2 = NOWORD -- reinitialize  
for i=1, MAXGEN do  
    local list = statetab[prefix(w1, w2)]  
    -- choose a random item from list  
    local r = math.random(#list)  
    local nextword = list[r]  
    if nextword == NOWORD then return end  
    io.write(nextword, " ")  
    w1 = w2; w2 = nextword  
end 