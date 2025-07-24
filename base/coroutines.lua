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