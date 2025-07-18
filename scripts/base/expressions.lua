---@diagnostic disable: undefined-global, lowercase-global

a = 1
print(-a) -- -1
-- print(+a) -- ошибка, унарного плюса в lua нет

-- некоторые приколы с остатком от деления
a = 4
print(a % 3) -- 1
print(a % 0.3) -- 0.1
print(a % 0.03) -- 0.01
print(a % 0.003) -- 0.00099999999999989

-- операции сравнения

a = 1
print(a == 1) -- true
print(a ~= 1) -- false (аналог != в других ЯП)