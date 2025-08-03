-- Возвращает таблицу с функциями из C-кода
---@param c_code string Исходный C-код
---@param defs string Объявления функций для FFI (как в ffi.cdef)
---@return boolean success
---@return table|nil lib Таблица с функциями или nil при ошибке
---@return string|nil error Сообщение об ошибке
local function load_c_code(c_code, defs)
    local c_file = "./__temp_code.c"
    local so_file = "./__temp_code.so"

    -- Запись кода в файл
    local f = io.open(c_file, "w")
    if not f then
        return false, nil, "failed to create temp C file"
    end
    f:write(c_code)
    f:close()

    -- Компиляция в shared библиотеку
    local compile_cmd = string.format(
        'gcc -shared -fPIC -o %s %s', so_file, c_file
    )
    local exit_code = os.execute(compile_cmd)
    os.remove(c_file)
    if exit_code ~= 0 then
        return false, nil, string.format("execute '%s' failed", compile_cmd)
    end

    -- Загрузка библиотеки через FFI
    local ffi = require("ffi")
    local ok, err = pcall(function()
        ffi.cdef(defs)
    end)
    if not ok then
        os.remove(so_file)
        return false, nil, string.format("error in defs: %s", err)
    end
    local lib = ffi.load(so_file)
    os.remove(so_file)

    return true, lib, nil
end

---@diagnostic disable: need-check-nil
local function main()
    os.execute("stty -echoctl 2>/dev/null")

    local c_code = [[
        #include <stdio.h>
        #include <stdlib.h>
        #include <signal.h>
        
        void my_signal_handler(int signum) {
            printf("Custom handler received signal: %d\n", signum);
            exit(1);
        }
        
        int add_numbers(int a, int b) {
            return a + b;
        }
        
        void print_message(const char* msg) {
            printf("Message: %s\n", msg);
        }
    ]]

    local defs = [[
        void my_signal_handler(int signum);
        int add_numbers(int a, int b);
        void print_message(const char* msg);
    ]]

    -- Загрузка кода
    local success, lib, err = load_c_code(c_code, defs)
    if not success then
        print(err)
        return
    end

    -- Тестирование
    print("5 + 7 =", lib.add_numbers(5, 7))
    lib.print_message("Hello from C!")

    -- Установка обработчика сигнала
    local ffi = require("ffi")
    ffi.cdef[[
        typedef void (*sighandler_t)(int);
        sighandler_t signal(int signum, sighandler_t handler);
        static const int SIGINT = 2;
    ]]
    ffi.C.signal(ffi.C.SIGINT, lib.my_signal_handler)

    print("Press Ctrl+C to test signal handler...")
    while true do end
end

main()