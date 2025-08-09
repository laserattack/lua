local ffi = require("ffi")

-- отключение вывода управляющих конструкций
local function disable_control_echo()
    local is_windows = ffi.os == "Windows"

    if is_windows then
        ffi.cdef[[
            int SetConsoleMode(void* hConsoleHandle, int dwMode);
            void* GetStdHandle(int nStdHandle);
        ]]
        local handle = ffi.C.GetStdHandle(-10)  -- STD_INPUT_HANDLE
        ffi.C.SetConsoleMode(handle, 0x0080)    -- ENABLE_VIRTUAL_TERMINAL_INPUT
    else
        os.execute("stty -echoctl 2>/dev/null")
    end
end


disable_control_echo()

print("Press Ctrl+C for exit...")

while true do end