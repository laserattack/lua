-- Пример
-- lj dump.lua /usr/local/bin/luajit

local inp = assert(io.open(arg[1], "rb"))
-- and возвращает первый аргумент если он ложный иначе второй
-- or возвращает первый аргумент если он не ложный иначе второй
local out = arg[2] and assert(io.open(arg[2], "w")) or io.stdout
local block = 16

-- f:lines(block) — читает файл кусками по 16 байт (а не построчно, как обычно)
-- bytes — строка, содержащая прочитанные байты (может быть короче block в конце файла)
for bytes in inp:lines(block) do
    for c in string.gmatch(bytes, ".") do -- разбивает строку на отдельные символы (байты)
        out:write(string.format("%02X ", string.byte(c))) -- печать байта в 16-й системе
    end
    out:write(string.rep("   ", block - string.len(bytes))) -- Если блок меньше 16 байт (например, последний блок в файле), добавляются пробелы, чтобы выровнять hex-дамп.
    out:write(" ", string.gsub(bytes, "%c", "."), "\n") -- Управляющие символы (непечатаемые) заменяются на точку
end