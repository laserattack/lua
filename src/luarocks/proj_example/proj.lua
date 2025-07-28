
-- Чтобы установить пакет (например, luasocket) в подпапку проекта (например, lua_modules), 
-- выполните: luarocks install --tree ./lua_modules luasocket

-- запускается через luajit -l set_paths proj.lua
-- эта команда запускает скрипт proj.lua в LuaJIT с предварительной загрузкой set_paths.lua

local luasocket = require("socket")

for k, v in pairs(luasocket) do print(k) end

-- tcp
-- _DATAGRAMSIZE
-- _SETSIZE
-- _SOCKETINVALID
-- newtry
-- connect4
-- source
-- sink
-- connect
-- sinkt
-- connect6
-- sourcet
-- bind
-- BLOCKSIZE
-- choose
-- try
-- sleep
-- udp6
-- tcp6
-- dns
-- select
-- skip
-- __unload
-- _DEBUG
-- _VERSION
-- protect
-- gettime
-- tcp4
-- udp
-- udp4