local ffi = require("ffi")

ffi.cdef[[
    int MessageBoxA(void *hWnd, const char *lpText, const char *lpCaption, unsigned int uType);
]]

local user32 = ffi.load("user32")
local msg = user32.MessageBoxA

msg(nil, "Message", "Title", 0)