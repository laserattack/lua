
-- функция assert проверяет условие и выводит сообщение об ошибке если оно указано

-- assert(1 == 2, "1 != 2")
-- C:\tools\LuaJIT\luajit.exe: .\scripts\base\compilation.lua:2: 1 != 2
-- stack traceback:
--         [C]: in function 'assert'
--         .\scripts\base\compilation.lua:2: in main chunk
--         [C]: at 0x7ff6ef254830

-- assert(1 == 2)
-- PS C:\Users\user\Desktop\luajit-playgrounds> luajit .\scripts\base\compilation.lua
-- C:\tools\LuaJIT\luajit.exe: .\scripts\base\compilation.lua:9: assertion failed!
-- stack traceback:
--         [C]: in function 'assert'
--         .\scripts\base\compilation.lua:9: in main chunk
--         [C]: at 0x7ff6ef254830

-- в директории с текущим скриптом тестовый файл "hellosailor.lua"
local exec_path = arg[0]:gsub("[^\\]+$", "").."hellosailor.lua"

--       _        __ _ _      
--      | |      / _(_) |     
--    __| | ___ | |_ _| | ___ 
--   / _` |/ _ \|  _| | |/ _ \
--  | (_| | (_) | | | | |  __/
--   \__,_|\___/|_| |_|_|\___|

-- просто исполняет указанный файл
dofile(exec_path)

--   _                 _  __ _ _      
--  | |               | |/ _(_) |     
--  | | ___   __ _  __| | |_ _| | ___ 
--  | |/ _ \ / _` |/ _` |  _| | |/ _ \
--  | | (_) | (_| | (_| | | | | |  __/
--  |_|\___/ \__,_|\__,_|_| |_|_|\___|

-- возвращает функцию и сообщение об ошибке
-- если функция не nil, то ее можно вызвать - файл исполнится
-- если функция nil, значит возникла какая то ошибка - ее 
-- можно обработать

-- Более того, если нужно выполнить файл несколько раз, то мы можем один раз вызвать
-- loadfile и несколько раз вызвать возвращенную им функцию. Этот
-- подход гораздо дешевле, чем несколько раз вызывать dofile, поскольку
-- файл компилируется лишь один раз

local exec, msg = loadfile("123")
if exec then
    exec()
else
    print("error", msg) -- error   cannot open 123: No such file or directory
end

--   _                 _     _        _             
--  | |               | |   | |      (_)            
--  | | ___   __ _  __| |___| |_ _ __ _ _ __   __ _ 
--  | |/ _ \ / _` |/ _` / __| __| '__| | '_ \ / _` |
--  | | (_) | (_| | (_| \__ \ |_| |  | | | | | (_| |
--  |_|\___/ \__,_|\__,_|___/\__|_|  |_|_| |_|\__, |
--                                             __/ |
--                                            |___/ 

-- выполняет код из строки

local f = loadstring("print('hehey')")
assert(f)
f() -- hehey

-- Функции загрузки кусков никогда не вызывают ошибки. В случае
-- ошибки любого рода они возвращают nil и сообщение об ошибке
-- Более того, у этих функций нет никакого побочного эффекта. Они
-- только компилируют кусок во внутреннее представление и возвращают
-- результат как анонимную функцию. Распространенная ошибка —
-- полагать, что загрузка куска определяет функции.

--   _           _                     _      
--  | |         | |                   | |     
--  | |__  _   _| |_ ___  ___ ___   __| | ___ 
--  | '_ \| | | | __/ _ \/ __/ _ \ / _` |/ _ \
--  | |_) | |_| | ||  __/ (_| (_) | (_| |  __/
--  |_.__/ \__, |\__\___|\___\___/ \__,_|\___|
--          __/ |                             
--         |___/                              

-- Создание байт-кода
local exec = loadstring("x = 0; x = x + 1; print('NUMBER = ', x)")
assert(exec)

-- Сохранение байткода в файл
local tmp = os.tmpname()
local f = io.open(tmp, "wb"); assert(f)
f:write(string.dump(exec))
f:close()

-- Исполнение байткода из файла
local f = io.open(tmp, "rb"); assert(f)
local bytecode = f:read("*a")
loadstring(bytecode)() -- NUMBER =        1

-- так можно вывести байткод в читаемом псевдо-ассемблерном виде 
os.execute("luajit -bl " .. tmp)
os.remove(tmp)
-- сразу вывести через print tring.dump(exec) можно, но
-- выведет ломанные символы, т.к. там просто байты
-- а luajit -bl выводит в читаемом виде

-- Код в предкомпилированной форме не всегда меньше исходного
-- кода, но он ЗАГРУЖАЕТСЯ быстрее.

-- Когда это надо?
-- Загрузка байткода выполняется быстрее, но само выполнение кода — с той же скоростью.
-- Если один и тот же код загружается много раз (например, в плагинах или скриптах игр), байткод даст заметный прирост скорости.

--    ___ _ __ _ __ ___  _ __ ___ 
--   / _ \ '__| '__/ _ \| '__/ __|
--  |  __/ |  | | | (_) | |  \__ \
--   \___|_|  |_|  \___/|_|  |___/

-- Ошибки можно искуственно вызывать с помощью функции error

local number = 10
if type(number) ~= "number" then
    error("type error")
end

-- тут будет type error например
-- local number = "10"
-- if type(number) ~= "number" then
--     error("type error")
-- end

-- Частый случай ошибки - nil в переменной где его не должно быть
local no_nil = 123
if not no_nil then
    error("value error")
end
-- local no_nil = nil
-- if not no_nil then
--     error("value error")
-- end
-- Для такой конструкции создана функция assert
local no_nil = 123
-- assert возвращает все свои аргументы
print(assert(no_nil, "value error")) -- 123     value error
-- local no_nil = nil
-- assert(no_nil, "value error")

-- Когда функция обнаруживает непредвиденную ситуацию
-- (исключение), ей доступны две основные линии поведения: вернуть код
-- ошибки (обычно nil) или вызвать ошибку посредством вызова функции
-- error. Не существует жестких правил для выбора между этими двумя
-- вариантами, но мы можем дать общую рекомендацию: исключение,
-- которое легко обходится, должно вызывать ошибку; иначе оно должно
-- вернуть код ошибки.

-- С помощью pcall (protected call) можно перехватить любое исключение
local status, error_message = pcall(function ()
    local no_nil = nil
    assert(no_nil)
end)
print(status, error_message) -- false   .\scripts\base\compilation.lua:163: assertion failed!

-- В случае успеха возвращает первым значением также статус, а далее 
-- все возвращаемые функцией значения
local results = {pcall(function ()
    local no_nil = 123
    assert(no_nil)
    return "a", "b", "c"
end)}
for k, v in ipairs(results) do
    print(k, v)
end
-- 1       true
-- 2       a
-- 3       b
-- 4       c


--                              _                _     
--                             | |              | |    
--    ___ _ __ _ __ ___  _ __  | | _____   _____| |___ 
--   / _ \ '__| '__/ _ \| '__| | |/ _ \ \ / / _ \ / __|
--  |  __/ |  | | | (_) | |    | |  __/\ V /  __/ \__ \
--   \___|_|  |_|  \___/|_|    |_|\___| \_/ \___|_|___/

local function foo(str)
    if type(str) ~= "string" then
        error("string expected", 1) -- уровень ошибок первый
    end
end
-- Ошибка на 191 строке - в самой функции foo
print(pcall(function ()
   foo() -- false   .\scripts\base\compilation.lua:191: string expected
end))


local function foo(str)
    if type(str) ~= "string" then
        error("string expected", 2) -- уровень ошибок второй
    end
end
-- Ошибка на 208 строке - на строке с вызовом foo
print(pcall(function ()
   foo() -- false   .\scripts\base\compilation.lua:208: string expected
end))


--                  _                    _                     _ _           
--                 | |                  | |                   | | |          
--    ___ _   _ ___| |_ ___  _ __ ___   | |__   __ _ _ __   __| | | ___ _ __ 
--   / __| | | / __| __/ _ \| '_ ` _ \  | '_ \ / _` | '_ \ / _` | |/ _ \ '__|
--  | (__| |_| \__ \ || (_) | | | | | | | | | | (_| | | | | (_| | |  __/ |   
--   \___|\__,_|___/\__\___/|_| |_| |_| |_| |_|\__,_|_| |_|\__,_|_|\___|_|   

-- расширенный pcall, позволяет настроить сообщение об ошибке, например получить более подробное

local function dangerous_function(x)
    if not x then
        error("value error")
    end
end

local function error_handler(err)
    print("error:", err)
    print("stack:")
    print(debug.traceback())
    return "error handled!!"
end

local ok, result = xpcall(dangerous_function, error_handler, nil)
if ok then
    print("result:", result)
else
    print("error:", result)
end