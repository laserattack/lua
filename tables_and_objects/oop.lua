
-- вот это
local account = {balance = 0}
function account.withdraw (v)
    account.balance = account.balance - v
end

-- просто синтаксический сахар для этого
local account = {
    balance = 0,
    withdraw = function (v)
        account.balance = account.balance - v
    end
}

-- Данная разновидность функции — это почти то, что мы называем
-- методом. Однако, использование глобального имени Account внутри
-- функции является плохой практикой программирования.
-- Во-первых, эта
-- функция будет работать только для данного конкретного объекта. Во-
-- вторых, даже для этого объекта функция будет работать ровно до тех
-- пор, пока этот объект хранится в той конкретной глобальной
-- переменной.

-- Более гибкий подход состоит в работе с получателем (receiver)
-- операции. Для этого нашему методу понадобится дополнительный
-- параметр со значением получателя. Этот параметр обычно называется
-- self или this:

local Account = {balance = 0}
function Account.withdraw (self, v)
    self.balance = self.balance - v
end
local a, Account = Account, nil
a.withdraw(a, 10)
print(a.balance) -- -10

-- для 
-- function Account.withdraw (self, v)
--     self.balance = self.balance - v
-- end
-- есть удобный синтаксический сахар

local Account = {balance = 0}
function Account:withdraw (v)
    self.balance = self.balance - v
end
local a, Account = Account, nil
a:withdraw(100)
print(a.balance) -- -100

-- К данному моменту у наших объектов есть идентичность, состояние
-- и действия над этим состоянием. Им по-прежнему не хватает системы
-- классов, наследования и скрытия членов.

-- Класс работает как шаблон для создания объектов. Большинство
-- объектно-ориентированных языков предлагает понятие класса. В таких
-- языках каждый объект является экземпляром какого-то конкретного
-- класса. В Lua нет понятия класса; каждый объект определяет свое
-- собственное поведение и состояние. Однако, смоделировать в Lua
-- классы не трудно, если следовать примеру языков на основе прототипов,
-- вроде Self или NewtonScript. В этих языках у объектов нет классов.
-- Вместо этого у каждого объекта может быть прототип, который
-- является обычным объектом, в котором первый объект ищет
-- неизвестные ему действия. Для представления классов в таких языках
-- мы просто создаем объект, который будет использован только в
-- качестве прототипа для других объектов (его экземпляров).

--        _               
--       | |              
--    ___| | __ _ ___ ___ 
--   / __| |/ _` / __/ __|
--  | (__| | (_| \__ \__ \
--   \___|_|\__,_|___/___/

local Account = {balance = 0} -- прототип
function Account:new(o)
    o = o or {} -- создает таблицу, если пользователь ее не предоставил
    setmetatable(o, self)
    self.__index = self
    return o
end
function Account:deposit(v)
    self.balance = self.balance + v
end
-- сахар для
-- function Account.deposit (obj, v)
--     obj.balance = obj.balance + v
-- end
function Account:withdraw(v)
    if v > self.balance then error "insufficient funds" end
    self.balance = self.balance - v
end

local a = Account:new()
local b = Account:new()
-- Изначально a и b - пустые таблицы
-- При первом вызове a:deposit(100):
--     self.balance ищется в a → не найдено
--     Ищется в Account через __index → найдено 0
--     Присваивание self.balance = 0 + 100 создает поле balance в таблице a
-- Аналогично для других операций
a:deposit(100)
a:withdraw(70)
b:deposit(1000)
print(a.balance) --> 30
print(b.balance) --> 1000

--   _       _               _ _   
--  (_)     | |             (_) |  
--   _ _ __ | |__   ___ _ __ _| |_ 
--  | | '_ \| '_ \ / _ \ '__| | __|
--  | | | | | | | |  __/ |  | | |_ 
--  |_|_| |_|_| |_|\___|_|  |_|\__|

local a = Account:new()
local msg = select(2, pcall(
    function()
        a:withdraw(10)
    end
))
print(msg) -- .\tables_and_objects\oop.lua:91: insufficient funds

-- От этого класса мы можем унаследовать подкласс SpecialAccount,
-- позволяющий покупателю снять больше, чем есть на его балансе.

local SpecialAccount = Account:new()
-- просто задаем метод withdraw
function SpecialAccount:withdraw(v)
    self.balance = self.balance - v
end

local s = SpecialAccount:new()
s:withdraw(1000)
print(s.balance) --> -1000
s:deposit(1000000)
print(s.balance) --> 999000