local jitp = require("jit.p")

-- for k in pairs(jitp) do print(k) end
-- stop
-- start

jitp.start("f", "progiler.log")
-- первый аргумент - режим работы (https://luajit.org/ext_profiler.html#hl_profiler)
-- если не указать вторым аргументом выходной файл, то напечатает в stdout

local function test()
    local sum = 0
    for i = 1, 1e7 do  -- Увеличиваем количество итераций
        sum = sum + math.sin(i) * math.cos(i)  -- Добавляем больше вычислений
    end
    return sum
end
test()

local function test2()
    local sum = 0
    for i = 1, 1e7*2 do  -- Увеличиваем количество итераций
        sum = sum + math.sin(i) * math.cos(i)  -- Добавляем больше вычислений
    end
    return sum
end
test2()


jitp.stop()

-- serr@home:~/projects/lua-knowledge-base$ cat progiler.log 
-- 68%  test2
-- 32%  test