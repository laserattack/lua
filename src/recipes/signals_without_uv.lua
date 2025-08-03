os.execute("stty -echoctl 2>/dev/null")
local ffi = require("ffi")

ffi.cdef[[
    typedef void (*sighandler_t)(int);
    sighandler_t signal(int signum, sighandler_t handler);
    int getchar(void);
    
    // Константы сигналов
    static const int SIGINT = 2;
]]

-- Функция-обработчик сигнала (вызывается при SIGINT)
local function sigint_handler(signum)
    print("Signal handled:", signum)
    os.exit(0)
end

-- Получаем указатель на Lua-функцию для передачи в C
local handler = ffi.cast("sighandler_t", sigint_handler)

-- Устанавливаем новый обработчик для SIGINT (Ctrl+C)
ffi.C.signal(ffi.C.SIGINT, handler)

-- Бесконечный цикл для демонстрации
print("Press Ctrl+C to exit...")
while true do
    ffi.C.getchar() -- Ожидаем ввод (необязательно)
end