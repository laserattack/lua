-- строки в Lua immutable

-- Строковая библиотека экспортирует свои функции в виде модуля с
-- именем string. Начиная с Lua 5.1, она также экспортирует свои функции
-- как методы, принадлежащие типу string (при помощи метатаблицы
-- данного типа). Поэтому, например, перевод строки в заглавные буквы
-- можно записать либо как string.upper(s), либо как s:upper(). Выбирайте
-- сами.

-- for k in pairs(string) do print(k) end
-- Все что есть в string:

-- find --> 
-- match --> 
-- gmatch --> 
-- gsub --> 
-- format --> использует форматирующую строку и след. аргументы для создания результирующей строки (типо аналог printf из Си)
-- len --> возвращаетдлину строки. Экивалентно оператору длины #
-- byte --> возвращает внутреннее числовое представление символа/символов строки (см ниже)
-- char --> принимает целые числа, преобразует каждое из них в символ и возвращает строку, в которой все эти символы соединены
-- sub --> извлекает часть строки, ограниченную индексами (есть нюансы, см ниже)
-- rep --> возвращает строку, повторенную n раз
-- reverse --> реверсит строку (hello <-> olleh)
-- lower --> возвращает копию строки, у которой заглавные буквы преобразованы в строчные
-- upper --> возвращает копию строки, у которой строчные буквы преобразованы в заглавные
-- dump --> преобразует загруженную функцию (Lua-функцию, но не C-функцию) в бинарную строку (байткод), которую можно сохранить или передать


-- string.rep
-- возвращает строку, повторенную n раз, можно также указать опциональный разделитель
local s = "123"
print(s:rep(10, ", ")) -- 123, 123, 123, 123, 123, 123, 123, 123, 123, 123
-- local big_string = string.rep("a", 2^20) -- строка весом 1мб


-- string.sub
-- можно применять отрицательные индексы
-- отрицательные индексы отсчитываются от конца строки
local s = "hello, sailor!"
print(s:sub(8)) --> sailor!
print(s:sub(8, 13)) --> sailor
print(s:sub(8, 7)) --> ""
print(s:sub(8, -2)) --> sailor


-- string.byte
local s = "hello, sailor!"
print(s:byte()) -- 104 (первый символ)
print(s:byte(1)) -- 104 (первый символ)
print(s:byte(2)) -- 101 (второй символ)
print(s:byte(-1)) -- 33 (последний символ)
print(
    table.concat(
        {s:byte(1, 5)},
        ", "
    )
) -- 104, 101, 108, 108, 111 (первые 5 символов)
print(
    table.concat(
        {s:byte(1, -1)},
        ", "
    )
) -- 104, 101, 108, 108, 111, 44, 32, 115, 97, 105, 108, 111, 114, 33 (вся строка)

-- в Lua есть ограничение на кол-во возвращаемых функцией значений
-- так что тут функция byte вызовет исключение
print(
    select(2, pcall(function ()
        local big_string = string.rep("1", 2^20) -- строка весом 1мб
        local _ = {big_string:byte(1, -1)} -- пытаюсь получить таблицу байт строки
    end))
) -- string slice too long


-- string.char
local s = "hello, sailor!"
---@diagnostic disable-next-line: missing-parameter
print(string.char()) -- ""
print(string.char(97)) -- a
print(string.char(97, 98, 99)) -- abc
print(string.char(s:byte(), s:byte(2))) -- he
print(string.char(s:byte(1, 4))) -- hell

-- Функция string.format — это мощный инструмент для
-- форматирования строк, обычно для вывода. Она возвращает
-- отформатированную версию всех своих аргументов (так как является
-- варидической), следуя описанию, заданному своим первым аргументом,
-- так называемой форматирующей строкой (format string).
-- Форматирующая строка следует правилам, похожим на те, что
-- используются в функции printf стандартного С
print()
print(
    string.format("pi = %.4f", math.pi)
) -- pi = 3.1416
print(
    string.format("%s: %d", "unix timestamp", os.time())
) -- unix timestamp: 1753522683

local d, m, y = 5, 11, 1990
print(
    -- типо если меньше 2/4 символов то нули допишет слева
    string.format("%02d/%02d/%04d", d, m, y) -- 05/11/1990
)


-- string.reverse
s = "hello, sailor!"
print(
    s:reverse() -- !rolias ,olleh
)


-- string.dump 
print()

-- Вариант 1
-- Дамп с отладочной информацией (по умолчанию)
local func = function(a, b) return a + b end
local dump = string.dump(func)
print(
    string.format("dump size = %d", #dump)
) -- dump size = 67

-- сохранение дампа в файл
local tmp = os.tmpname()
local f = io.open(tmp, "wb"); assert(f)
f:write(dump)
f:close()

-- загрузка функции из файла
local f = io.open(tmp, "rb"); assert(f)
local dump = f:read("*a"); f:close()
local func = loadstring(dump); assert(func)
print(func(2003, 22)) -- 2025

-- Вариант 2
-- Дамп без отладочной информации (меньший размер файла)
local func = function(a, b) return a + b end
local dump = string.dump(func, true)
print(
    string.format("dump size = %d", #dump)
) -- dump size = 22

-- сохранение дампа в файл
local tmp = os.tmpname()
local f = io.open(tmp, "wb"); assert(f)
f:write(dump)
f:close()

-- загрузка функции из файла
local f = io.open(tmp, "rb"); assert(f)
local dump = f:read("*a"); f:close()
local func = loadstring(dump); assert(func)
print(func(2003, 22)) -- 2025