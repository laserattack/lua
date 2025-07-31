local ffi = require("ffi")
ffi.cdef[[
    void Sleep(int ms);
    int usleep(unsigned usec);
]]

local function sleep(seconds)
    if ffi.os == "Windows" then
        ffi.C.Sleep(seconds * 1000)
    else
        ffi.C.usleep(seconds * 1000000)
    end
end

local function main()
    while true do
        print(os.time())
        sleep(2)
    end
end

main()