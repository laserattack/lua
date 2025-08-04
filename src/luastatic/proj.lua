-- С зависимостями от libc:
-- ./lua_modules/bin/luastatic proj.lua /usr/local/lib/libluajit-5.1.a -I/usr/local/include/luajit-2.1/


-- Полностью статический бинарник:
-- ./lua_modules/bin/luastatic proj.lua /usr/local/lib/libluajit-5.1.a -I/usr/local/include/luajit-2.1/ -static -lm -ldl

print("hello, world")