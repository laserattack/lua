local Animal = {
    type = nil,
    sound = nil,
    do_sound = function (Animal)
        print(Animal.type, "speak:", Animal.sound)
    end
}

local Cat = {type="Cat", sound="Meow", do_sound=Animal.do_sound}
Cat.do_sound(Cat)
Cat:do_sound() -- синаксический сахар для ООП

-- функции в Lua могут возвращать несколько значений
local function foo()
    return 1, 2, 3, 4
end
local a,b,c,d = foo()
print(a,b,c,d) -- 1       2       3       4
print(foo()) -- 1       2       3       4

-- функция, не возвращающая никакого значения
local function foo()
    return
end
-- print(type(foo())) -- bad argument #1 to 'type' (value expected)

-- распаковка таблицы с помощью стандартной функции unpack
local t = {1,2,3,4,5}
local a,b,c,d,e = unpack(t)
print(a,b,c,d,e) -- 1       2       3       4       5
local a = {unpack(t)} -- а это наоборот сборка в таблицу многих аргументов
for _, v in ipairs(a) do print(v) end -- 1,2,3,4,5

-- вариадические функции
local function add(...) -- много аргументов 
    local s = 0
    local args = {...} -- сборка в таблицу
    for _, v in ipairs(args) do
        s = s + v
    end
    return s
end

print("sum =", add(1,2)) -- sum =   3


-- именованные аргументы
-- нет поддержки именованных аргументов как в питоне
-- но вот как можно эмулировать

local function foo(arg)
    print("Name =", arg.name, "Surname =", arg.surname)
end
foo({name="Serr", surname="Laserattack"}) -- Name =  Serr    Surname =       Laserattack
foo({surname="Laserattack", name="Serr"}) -- Name =  Serr    Surname =       Laserattack


-- в lua на самом деле все функции являются анонимными

-- то есть 
-- вот это 
local function foo(x)
    return 2*x
end
-- просто синтаксичекий сахар для этого
local foo = function ()
    return 2*x
end


-- глюк, связанный с локальными функциями и рекурсией
-- код ниже вызовет глюк, потому что когда пытаемся вызвать fact внутри локальной функции
-- она еще не определена. Поэтому данное выражение
-- попытается вызвать глобальную функцию fact, а не локальную.
-- local fact = function (n)
--     if n == 0 then return 1
--     else return n*fact(n-1)
--     end
-- end
-- fix (сперва определить локальную переменную)
local fact
fact = function (n)
    if n == 0 then return 1
    else return n*fact(n-1)
    end
end

print(fact(5)) -- 120


-- Когда Lua предлагает свой синтаксический сахар для локальных
-- функций, он не использует простое определение. Вместо этого
-- определение наподобие
-- local function foo (<параметры>) <тело> end
-- расширяется до
-- local foo; foo = function (<параметры>) <тело> end

-- так что вот это не вызывает глюка:

local function fact(n)
    if n == 0 then return 1
    else return n*fact(n-1)
    end
end

print(fact(5)) -- 120

-- лексическое окружение функции - область видимости в которой она определена
-- функция имеет доступ ко всему в своей области видимости
local count = 0
local foo = function ()
    count = count + 1
    return count
end

print(foo()) -- 1
print(foo()) -- 2
print(foo()) -- 3
print(foo()) -- 4
print(foo()) -- 5

-- способ вызвать анонимную функцию сразу после объявления
local _ = (function()
   print(123)
end)()