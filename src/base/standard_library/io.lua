-- Чтобы открыть файл, вы используете функцию io.open, которая
-- подобна функции fopen в С. В качестве аргументов она принимает имя
-- файла, который нужно открыть, и строку режима (mode string). Эта
-- строка может содержать 'r' для чтения, 'w' для записи (которая при этом
-- стирает любое предыдущее содержимое файла) или 'a' для добавления к
-- файлу; еще она может содержать необязательный 'b' для открытия
-- двоичных файлов. Функция open возвращает новый дескриптор файла. В
-- случае ошибки open возвращает nil, а также сообщение об ошибке и ее
-- код

local filename = "text"

local f = assert(io.open(filename, "w"))
print(f) -- file (0x5940802802a0)
f:write[[
hello, sailor! 1
hello, sailor! 2
hello, sailor! 3
hello, sailor! 4
hello, sailor! 5
hello, sailor! 6
]]
f:close()
print(f) -- file (closed)

-- *а читает весь файл
-- *l читает следующую строку (без символа перевода строки)
-- *L читает следующую строку (с символом перевода строки)
-- *n читает число (число ограничивает количество читаемых символов)

local f = assert(io.open(filename, "r"))
local all_text = f:read("*a")
print(all_text)

f:seek("set") -- каретку в начало файла

repeat
    local line = f:read("*l") -- читает по одной линии
    if line then
        io.write(line, "\n") -- как print только просто пишет в stdout без разделителей, без преобразований автоматических
    else
        print("end of file")
    end
until not line

f:seek("set") -- каретку в начало файла
print()

-- Аналогичное можно записать короче:

-- f:lines() returns an iterator function that, each time it is called, returns a new line from the file.

local iter = f:lines()
for l in iter do
    print(l)
end

f:close()
os.remove(filename)

print()

-- Библиотека ввода-вывода предлагает дескрипторы для трех
-- предопределенных потоков С: io.stdin, io.stdout и io.stderr. Поэтомувы можете послать сообщение прямо в поток вывода при помощи
-- примерно такого кода:

io.stdout:write("hello, standard output!\n")