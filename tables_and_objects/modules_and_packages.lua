-- С точки зрения пользователя, модуль — это некоторый код (на Lua
-- или С), который может быть загружен посредством require и который
-- создает и возвращает таблицу. Все, что модуль экспортирует, будь то
-- функции или таблицы, он определяет внутри этой таблицы, которая
-- выступает в качестве пространства имен.

local m = require("math")
print(m.sqrt(100)) -- 10

-- все ключи таблицы m (модуля math)
for n in pairs(m) do print(n) end

-- Для require модуль — это всего лишь какой-
-- то код, который определяет некоторые значения (например, функции или
-- таблицы, содержащие функции). Обычно этот код возвращает таблицу,
-- состоящую из функций этого модуля. Однако, поскольку это делается
-- кодом самого модуля, а не require, некоторые модули могут выбрать
-- возвращать другие значения или ДАЖЕ ИМЕТЬ ПОБОЧНЫЕ ЭФФЕКТЫ.

-- Список загруженных модулей
print(); for n in pairs(package.loaded) do print(n) end
-- Выгрузить модуль можно так (удалить переменные, хранящие ссылки на таблицу, их 2 в данном случае)
package.loaded.math = nil; m = nil
-- тут уже не будет math
print(); for n in pairs(_G.package.loaded) do print(n) end;

local _, msg = pcall(function () print(m.sqrt(4)) end)
print(msg) -- .\tables_and_objects\modules_and_packages.lua:28: attempt to index upvalue 'm' (a nil value)

-- Для загрузки модуля мы просто вызываем require "имя_модуля".
-- Первым шагом require является проверка по таблице package.loaded, не
-- был ли загружен данный модуль ранее. Если да, require возвращает его
-- соответствующее значение. Поэтому, как только модуль загружен,
-- другие вызовы, для которых он требуется, просто вернут то же значение
-- без повтороного выполнения какого-либо кода.

-- Если модуль еще не загружен, то require ищет файл Lua с именем
-- модуля. Если он находит этот файл, то загружает его при помощи
-- loadfile. Результатом этого является функция, которую мы называем
-- загрузчиком (loader). (Загрузчик — это функция, которая при вызове
-- загружает модуль.)

-- Примерно так работает:
local loader = loadstring(
    [[
        local M = {}
        function M.hello() print("Hello!") end
        return M
    ]]
)
if loader then
    local module_table = loader()
    module_table.hello()  --> Hello!
end

-- Путь, который require использует для поиска файлов Lua, — это
-- всегда текущее значение переменной package.path.

print(package.path) -- .\?.lua;C:\tools\LuaJIT\lua\?.lua;C:\tools\LuaJIT\lua\?\init.lua;

-- Путь для поиска библиотек С работает точно так же, но его значение
-- берется из переменной package.cpath

print(package.cpath) -- .\?.dll;C:\tools\LuaJIT\?.dll;C:\tools\LuaJIT\loadall.dll

-- Массив package.searchers содержит перечень искателей, которыми
-- пользуется require. При поиске модуля require поочередно вызывает
-- каждого искателя из этого перечня, передавая ему имя модуля, до тех
-- пор, пока не найдет загрузчик для этого модуля. Если поиск не дает
-- результата, require вызывает ошибку.

-- Использование списка для управления поиском модуля придает
-- огромную гибкость функции require. Например, если вы хотите хранить
-- модули сжатыми в zip-файлы, то вам лишь нужно предоставить
-- соответствующую функцию-искатель и добавить ее к списку

-- Пример простого модуля:

-- local M = {}
-- function M.new (r, i) return {r=r, i=i} end
-- -- определяет константу 'i'
-- M.i = M.new(0, 1)
-- function M.add (c1, c2)
-- return M.new(c1.r + c2.r, c1.i + c2.i)
-- end
-- function M.sub (c1, c2)
-- return M.new(c1.r - c2.r, c1.i - c2.i)
-- end
-- function M.mul (c1, c2)
-- return M.new(c1.r*c2.r - c1.i*c2.i, c1.r*c2.i + c1.i*c2.r)
-- end
-- local function inv (c)
-- local n = c.r^2 + c.i^2
-- return M.new(c.r/n, -c.i/n)
-- end
-- function M.div (c1, c2)
-- return M.mul(c1, inv(c2))
-- end
-- function M.tostring (c)
-- return "(" .. c.r .. "," .. c.i .. ")"
-- end
-- return M

-- Модуль со списком экспортируемых функций:

-- local function new (r, i) return {r=r, i=i} end
-- -- определяет константу 'i'
-- local i = complex.new(0, 1)
-- <другие функции следуют этому же образцу>
-- return {
-- new = new,
-- i = i,
-- add = add,
-- sub = sub,
-- mul = mul,
-- div = div,
-- tostring = tostring,
-- }