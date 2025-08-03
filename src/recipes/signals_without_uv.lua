os.execute("stty -echoctl 2>/dev/null")
local ffi = require("ffi")

ffi.cdef[[
    typedef void (*sighandler_t)(int);
    sighandler_t signal(int signum, sighandler_t handler);
    int getchar(void);
    
    // Константы сигналов
    static const int SIGINT = 2;
]]

local function sigint_handler(signum)
    print("Signal handled:", signum)
    os.exit(0)
end

local handler = ffi.cast("sighandler_t", sigint_handler)
ffi.C.signal(ffi.C.SIGINT, handler)

print("Press Ctrl+C to exit...")
while true do
    ffi.C.getchar()
end