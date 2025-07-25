
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

--                   _ _   _       _        _       _               _ _   
--                  | | | (_)     | |      (_)     | |             (_) |  
--   _ __ ___  _   _| | |_ _ _ __ | | ___   _ _ __ | |__   ___ _ __ _| |_ 
--  | '_ ` _ \| | | | | __| | '_ \| |/ _ \ | | '_ \| '_ \ / _ \ '__| | __|
--  | | | | | | |_| | | |_| | |_) | |  __/ | | | | | | | |  __/ |  | | |_ 
--  |_| |_| |_|\__,_|_|\__|_| .__/|_|\___| |_|_| |_|_| |_|\___|_|  |_|\__|
--                          | |                                           
--                          |_|                                           

-- класс логгера
local Logger = {}
function Logger:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end
function Logger:log(message)
    print("LOG:", message)
end
-- пример объекта класса
local l = Logger:new()
l:log("test") --> LOG:    test

-- 
local function createClass(...) -- принимает любое кол-во таблиц (классов)
    local parents = {...} -- таблица всех классов
    local c = {} -- новый класс

    -- если в комбинированном классе нет какого то поля
    -- то оно ищется в родительских классах
    setmetatable(c, {
        __index = function (_, k)
            for _, class in ipairs(parents) do
                local value = class[k]
                if value then
                    return value
                end
            end
        end
    })

    -- сам комбинированный класс должен являться метатаблицей
    -- для своих экземпляров
    c.__index = c
    function c:new(o)
        o = o or {}
        setmetatable(o, c)
        return o
    end

    return c
end

print()

-- наследуемся от Logger, Account
local LoggingAccount = createClass(Logger, Account)
-- добавляем собственный метод
function LoggingAccount:greet()
    print("hello")
end
local la = LoggingAccount:new()
print(la.balance) -- 0
la:log("test") -- test
la:deposit(1000)
la:withdraw(777)
print(la.balance) -- 223
la:greet() --> hello

--              _                       
--             (_)                      
--   _ __  _ __ ___   ____ _  ___ _   _ 
--  | '_ \| '__| \ \ / / _` |/ __| | | |
--  | |_) | |  | |\ V / (_| | (__| |_| |
--  | .__/|_|  |_| \_/ \__,_|\___|\__, |
--  | |                            __/ |
--  |_|                           |___/ 

print()

local function createAccount()
    -- внутреннее представление (приватные поля)
    local self = {
        balance = 0
    }

    local withdraw = function (v)
        self.balance = self.balance - v
    end
    local deposit = function (v)
        self.balance = self.balance + v
    end
    local getBalance = function ()
        return self.balance
    end

    -- публичный интерфейс
    local public = {
        withdraw = withdraw,
        deposit = deposit,
        getBalance = getBalance
    }

    return public
end

local a = createAccount()
a.deposit(100)
print(a.getBalance()) --> 100

-- наследоваться от такого класса можно так

print()

local function createPremiumAccount()
    local self = {
        status = "gold"
    } -- внутренне представление (приватные поля)

    local parent = createAccount()

    local status = function() -- новый метод
        print("status:", self.status)
    end

    local deposit = function(v) -- переопределение старого метода
        -- Добавляем бонус для premium-аккаунтов
        parent.deposit(v * 1.1) -- +10% бонус
    end

    -- публичный интерфейс
    local public = {
        status = status,
        deposit = deposit
    }

    setmetatable(public, {
        __index = parent
    })

    return public
end

local pa = createPremiumAccount()
pa.deposit(100)
print(pa.getBalance())
pa.status()



-- Далее некоторые нюансы

print()

-- класс аккаунт

local Account = {
    -- описываются атрибуты класса по умолчанию
    balance = 0,
}

-- описываются методы класса

-- создание нового объекта
function Account:new(obj)
    obj = obj or {} -- если таблица не передана, то пустая таблица
    -- метатаблица - та, в которой ищется если нет в obj
    -- в данном случае - таблица Account
    setmetatable(obj, self)
    self.__index = self -- если нет поля в obj - искать в Account
    -- т.е. таблица Account назначена метатаблицей для obj
    return obj
end
function Account:deposit(v)
    -- первым делом выполняется часть
    -- self.balance + v
    -- ищется поле balance в self. 
    -- если его нет, то берется из Account (0)

    -- далее прибавляется v к значению полученному из пред. пункта
    -- и кладется в поле balance в self
    -- если такого поля в объекте не было - оно создается
    self.balance = self.balance + v
end
-- просто функция, находящаяся в таблице Account
-- function Account.deposit(self, v)
--     self.balance = self.balance + v
-- end

local a = Account:new()
a:deposit(100)
print(a.balance)


-- Наследование

SpecialAccount = Account:new()
function SpecialAccount:deposit(v)
    self.balance = self.balance + 1.1*v
end
local sa = SpecialAccount:new()
sa:deposit(100)
print(sa.balance)




-- Разница между 

print()

-- local Account = {
--     balance = 0,
-- }
-- function Account:new(obj)
--     obj = obj or {}
--     setmetatable(obj, {
--         __index = Account
--     })
--     return obj
-- end

-- и 

-- local Account = {
--     balance = 0,
-- }
-- function Account:new(obj)
--     obj = obj or {}
--     setmetatable(obj, self)
--     self.__index = self
--     return obj
-- end


-- Вариант 1

local Account = {
    balance = 0,
}
function Account:new(obj)
    obj = obj or {}
    setmetatable(obj, {
        __index = Account
    })
    return obj
end

local a = Account:new()
print(a.balance)
Account.__tostring = function () return "string" end
print(a) -- table: 0x02783b5b12b0

-- Вариант 2

local Account = {
    balance = 0,
}
function Account:new(obj)
    obj = obj or {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end

local a = Account:new()
print(a.balance)
Account.__tostring = function () return "string" end
print(a) -- string

-- Это потому что в первом варианте метатаблицей назначилась
-- анонимная метатаблица к которой нет доступа и если надо будет добавить 
-- какой то метаметод то этого не получится сделать

-- А во втором варианте метатаблицей сделали саму шаблонную таблицу Account
-- и если надо какой то метаметод назначить - это легко делается
-- и метаметод работает на каждом объекте класса, потому что
-- ищется в объекте -> не находит -> ищется в Account -> находит

-- ну и плюсом для каждого экземпляра не создается новая метатаблица,
-- метатаблица одна на весь класс