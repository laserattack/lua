-- Вывод имен всех глобальных (системных)
-- переменных (ключей в таблице глобальных переменных)
for n in pairs(_G) do print(n) end

-- Запрет создавать новые глобальные переменные
-- + Запрет читать какие то несуществующие глобальные переменные
setmetatable(_G, {
    __newindex = function (_, n)
        error("attempt to write to undeclared global variable " .. n, 2)
    end,
    __index = function (_, n)
        error("attempt to read undeclared global variable " .. n, 2)
    end,
})

-- попытка создать глобальную переменную
local _, err = pcall(function () A = 1 end)
print(err) -- .\tables_and_objects\environment.lua:18: attempt to write to undeclared variable A
-- попытка прочитать несуществующую глобальную переменную
local _, err = pcall(function () print(A) end)
print(err) -- .\tables_and_objects\environment.lua:22: attempt to read undeclared variable A

-- обойти можно используя rawset, rawget

rawset(_G, "A", 1) -- установка глобальной переменной
print(rawget(_G, "A")) -- 1
rawset(_G, "A", nil) -- удаление глобальной переменной

-- создать изолированное глобальное окружение
-- (например чтобы выполнить ненадежный код, который может поломать
-- глобальное окружение) можно так
local function sandbox(code)
    local env = {
        print = print,
        math = math
    } -- Создаем новое окружение, добавляем в него разрешенные функции/модули
    local f = loadstring(code); assert(f)
    setfenv(f, env)()  -- Настраиваем окружение и выполняем код
    return env -- Возвращаем окружение с результатами
end

local env = sandbox("x = 10; print('x=',x)")
print(env.x) --> 10 (глобальная переменная в таблице env)
-- попытка выполнить небезопасный код в изолированном окружении
local _, msg = pcall(function ()
    sandbox("os.execute()")
end)
print("error in sandbox:", msg) -- [string "os.execute()"]:1: attempt to index global 'os' (a nil value)