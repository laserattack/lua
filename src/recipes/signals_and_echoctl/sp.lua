-- Получаем версию Lua (5.1, 5.3 и т.д.)
local version = _VERSION:match("%d+%.%d+")
-- Папка с модулями
local tree = "lua_modules"

-- Далее добавляем папку с модулями в пути где lua ищет модули (path, cpath)

-- package.path — путь, где Lua ищет модули (аналог PATH в системе).
-- Добавляем пути для .lua файлов
package.path = tree .. "/share/lua/" .. version .. "/?.lua;" ..
               tree .. "/share/lua/" .. version .. "/?/init.lua;" ..
               package.path

-- package.cpath — путь для нативных модулей (библиотек).
-- Добавляем пути для .so/.dll файлов (нативные модули)
package.cpath = tree .. "/lib/lua/" .. version .. "/?.so;" ..
                tree .. "/lib/lua/" .. version .. "/?.dll;" ..
                package.cpath