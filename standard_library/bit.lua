-- эта библиотека поставляется вместе с LuaJIT
-- в стандартном Lua 5.1 такой библиотеки нет

-- Из документации LuaJIT
-- Note that all bit operations return signed 32 bit numbers (rationale).
-- And these print as signed decimal numbers by default.
-- т.е. все битовые операции возвращают 32-битные числа

-- for k in pairs(bit) do print(k) end
-- Все что есть в bit:

-- lshift --> сдвиг влево
-- rshift --> сдвиг вправо
-- arshift --> арифметический сдвиг
-- rol --> циклический сдвиг влево
-- ror --> циклический сдвиг вправо
-- band --> побитовое AND
-- bor --> побитовое OR
-- bxor --> побитовое XOR
-- tohex --> обычное число в hex (возвращает строку)
-- tobit --> приведение числа к 32-битному целому со знаком
-- bnot --> побитово обратное число
-- bswap --> little endian <-> big endian

local function printx (x)
    print(bit.tohex(x))
end

printx(bit.band(0xDF, 0xFD)) --> 000000dd (побитовое И)
printx(bit.bor(0xD0, 0x0D)) --> 000000dd (побитовое ИЛИ)
printx(bit.bxor(0xD0, 0xFF)) --> 0000002f (XOR)
printx(bit.bnot(0)) --> ffffffff

-- Причем эти функции могут использоваться с любым кол-вом аргументов
-- НО С 0 АРГУМЕНТОВ НЕЛЬЗЯ

printx(bit.bor(0xA, 0xA0, 0xA00)) --> 00000aaa
printx(bit.band(0xFFA, 0xFAF, 0xAFF)) --> 00000aaa
printx(bit.bxor(0, 0xAAA, 0)) --> 00000aaa

print(select(2, pcall(function ()
    printx(bit.bor())
end))) -- bad argument #1 to 'bor' (number expected, got no value)


-- некоторый нюанс:
local n = bit.bnot(0)
print(n) --> -1 (в доп. коде все единички = -1)
print(bit.tohex(n)) --> ffffffff (bit.tohex(x) выводит 8 младших бит по умолчанию)
print(bit.tohex(n, 16)) --> 00000000ffffffff (все битовые операции из JIT'овского модуля bit возвращают 32-битные числа)
print(string.format("%x", n)) --> ffffffffffffffff (string.format напрямую работает с 64-битным представлением числа в Lua)

-- сдвиги

n = 1; print(bit.lshift(n, 2)) --> 4
n = 4; print(bit.rshift(n, 2)) --> 1

printx(bit.rol(0x12345678, 8)) --> 34567812 (цикл. сдвиг влево на 1 байт)
printx(bit.ror(0x12345678, 8)) --> 78123456 (цикл. сдвиг вправо на 1 байт)
printx(bit.bswap(0x12345678)) --> 0x78563412 (little endian <-> big endian)
