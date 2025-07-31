local function disable_control_echo()
    local is_windows = package.config:sub(1,1) == "\\"

    if is_windows then
        local ok, ffi = pcall(require, "ffi")
        if ok then
            ffi.cdef[[
                int SetConsoleMode(void* hConsoleHandle, int dwMode);
                void* GetStdHandle(int nStdHandle);
            ]]
            local handle = ffi.C.GetStdHandle(-10)  -- STD_INPUT_HANDLE
            ffi.C.SetConsoleMode(handle, 0x0080)    -- ENABLE_VIRTUAL_TERMINAL_INPUT
        end
    else
        os.execute("stty -echoctl 2>/dev/null")
    end
end

local uv = require("luv")

do
    local signal_handle = uv.new_signal()
    uv.signal_start(signal_handle, "sigint", function(signal)
        print("signal handled:", signal)
        uv.stop()
    end)

    disable_control_echo()
end

print("Press Ctrl+C for exit...")

uv.run()