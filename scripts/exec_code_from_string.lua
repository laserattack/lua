local ffi = require("ffi")
ffi.cdef[[
    int printf(const char *format, ...);
]]

local code = [[
function Fact(n)
    if n == 0 then
        return 1
    else
        return n * Fact(n - 1)
    end
end
]]

local func, err = load(code)
if func then
    -- загружаем функцию Fact в глобальную область видимости
    func()
    -- вызываем Fact после загрузки
    ---@diagnostic disable-next-line: undefined-global
    local x = Fact(3)
    ffi.C.printf("res: %d\n", ffi.new('int', x))
else
    ffi.C.printf("error: %s\n", err)
end