
-- Чтобы установить пакет (например, luv) в подпапку проекта (например, lua_modules), 
-- выполните: luarocks install --tree ./lua_modules luv

-- запускается через luajit -l set_paths proj.lua
-- эта команда запускает скрипт proj.lua в LuaJIT с предварительной загрузкой set_paths.lua

local uv = require('luv')  -- Импорт библиотеки

-- Создаём таймер
local timer = uv.new_timer()

-- Запускаем таймер:
-- 1000 - задержка старта (мс)
-- 2000 - интервал повторения (мс)
timer:start(1000, 2000, function()
    print(os.date("%H:%M:%S"))
end)

print("The timer is running")

-- Запускаем цикл событий
uv.run()
