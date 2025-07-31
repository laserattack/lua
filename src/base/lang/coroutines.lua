-- Сопрограмма (coroutine) похожа на нить (thread) (в смысле многонитевости):
-- это поток выполнения со своим стеком, своими локальными
-- переменными и своим указателем команд; но он разделяет глобальные
-- переменные и почти все остальное с другими сопрограммами

-- Функция create создает новые сопрограммы

local co = coroutine.create(function () print("hi") end)
print(co) -- thread: 0x01d63c5ca500

-- Сопрограмма может быть в одном из четырех состояний:
-- - suspended - приоставновлена
-- - running - выполняется
-- - dead - завершена
-- - normal - обычное

-- Мы можем проверить состояние сопрограммы при помощи функции status:

print(coroutine.status(co)) -- suspended

-- Когда мы создаем сопрограмму, она запускается в приостановленном (suspended)
-- состоянии; сопрограмма не начинает автоматически выполнять свое
-- тело при создании. Функция coroutine.resume (пере)запускает
-- выполнение сопрограммы, меняя ее состояние из приостановленного в
-- выполняемое

coroutine.resume(co) --> hi

-- Тут тело сопрограммы просто печатает "hi" и
-- прекращает выполнение, оставляя сопрограмму в завершенном
-- состоянии, из которого ей уже не вернуться:

print(coroutine.status(co)) -- dead

-- Настоящая сила сопрограмм идет от функции
-- yield, которая позволяет выполняемой сопрограмме приостановить свое
-- выполнение (иными словами, уступить управление), чтобы она могла
-- быть возобновлена позже.


local co = coroutine.create(function ()
    for i = 1, 5 do
        print("co", i)
        coroutine.yield()
    end
end)

coroutine.resume(co) --> co 1
print(coroutine.status(co)) --> suspended
coroutine.resume(co) --> co 2
print(coroutine.status(co)) --> suspended
coroutine.resume(co) --> co 3
print(coroutine.status(co)) --> suspended
coroutine.resume(co) --> co 4
print(coroutine.status(co)) --> suspended
coroutine.resume(co) --> co 5
print(coroutine.status(co)) --> suspended
coroutine.resume(co) --> ничего не печатает
print(coroutine.status(co)) --> dead
coroutine.resume(co) --> ничего не печатает
print(coroutine.status(co)) --> dead
print(coroutine.resume(co)) -- false   cannot resume dead coroutine

-- resume выполняется в защищенном режиме.
-- Поэтому, если внутри сопрограммы есть какие-либо ошибки, Lua не
-- будет показывать сообщение об ошибке, а просто вернет управление
-- вызову resume.


-- Запуск сопрограммы с аргументами

local co = coroutine.create(function(a, b)
    print("args:", a, b) -- args:   10      20
    return "done"
end)
-- Запускаем сопрограмму и передаём аргументы
local success, result = coroutine.resume(co, 10, 20)
print("success:", success) --> success:        true
print("result:", result)  --> result: done


-- Передача данных в корутину
print()
local co = coroutine.create(function()
    print("co:", coroutine.yield()) -- co:     data for yield
end)
coroutine.resume(co)
coroutine.resume(co, "data for yield")

-- Передача данных из корутины
print()
local co = coroutine.create(function(a, b)
    coroutine.yield(a + b, a - b)
end)
local _, sum, diff = coroutine.resume(co, 20, 10)
print(sum, diff)  --> 30      10

--   _ _                 _                 
--  (_) |               | |                
--   _| |_ ___ _ __ __ _| |_ ___  _ __ ___ 
--  | | __/ _ \ '__/ _` | __/ _ \| '__/ __|
--  | | ||  __/ | | (_| | || (_) | |  \__ \
--  |_|\__\___|_|  \__,_|\__\___/|_|  |___/

print()
-- Производитель (сопрограмма)
local function producer(t)
    for i = 1, #t do
        coroutine.yield(t[i])  -- "выдаём" текущий элемент
    end
end
-- Итератор на основе сопрограммы
local function iter(t)
    local co = coroutine.create(function()
        producer(t)
    end)
    return function()  -- возвращаем функцию-итератор
        local _, value = coroutine.resume(co)
        return value
    end
end
-- Использование
local myTable = {10, 20, 30}
for item in iter(myTable) do
    print(item)  --> 10, 20, 30
end


-- Пример итератота на корутинах который сложно
-- реализовать обычными замыканиями

-- Обычное замыкание для обхода таблицы
-- local function values(t)
--     local i = 0
--     return function()
--         i = i + 1
--         return t[i]
--     end
-- end

-- Но что если надо обойти таблицу произвольной вложенности?

local t = {
    "A",
    {
        "B",
        {"B1", "B2", "B3"},
        "C",
        {
            "C1",
            {"C1a", "C1b"},
            "C2"
        }
    },
    "D"
}

local function values(t)
    local co = coroutine.create(function ()
        local function traverse(node)
            if type(node) == "table" then
                for _, child in ipairs(node) do
                    traverse(child)
                end
            else
                coroutine.yield(node) -- Значение листа
            end
        end
        traverse(t)
    end)

    return function ()
        local _, value = coroutine.resume(co)
        return value
    end
end

for item in values(t) do
    print(item)  --> A,B,B1,B2,B3,C,C1,C1a,C1b,C2,D
end

-- Почему рекурсивный итератор сложно реализовать на обычных замыканиях?
-- Проблема сохранения состояния рекурсии
-- Обычные замыкания хранят состояние в локальных переменных, но для рекурсивного обхода нужно:
--     Запоминать текущую позицию на каждом уровне вложенности
--     Отслеживать, какие узлы уже были обработаны
--     Уметь "возвращаться" из вложенных вызовов
-- В примере с корутинами это решается автоматически - стек вызовов сохраняется самой корутиной.