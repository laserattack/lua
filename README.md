# lua-playground

Изучаю Lua, LuaJIT и т.д. Играюсь, тестирую, проверяю

## Источники информации
- Роберту Иерузалимски - "Программирование на языке Lua"
- Lua 5.1 Reference Manual - [www.lua.org/manual/5.1/](https://www.lua.org/manual/5.1/)
- Lua 5.1 Reference Manual на русском - [linuxshare.ru/docs/devel/languages/lua/reference/index.html](https://linuxshare.ru/docs/devel/languages/lua/reference/index.html)
- Репозиторий с исходниками LuaJIT - [github.com/LuaJIT/LuaJIT](https://github.com/LuaJIT/LuaJIT)

## Установка luajit (Windows)

### Установка

```
**********************************************************************
** Visual Studio 2022 Developer Command Prompt v17.3.6
** Copyright (c) 2022 Microsoft Corporation
**********************************************************************

C:\Program Files\Microsoft Visual Studio\2022\Community>cd C:\tools\LuaJIT\src
C:\tools\LuaJIT\src>msvcbuild
```

Вывелось:

```
=== Successfully built LuaJIT for Windows/x64 ===
```

В папке `C:\tools\LuaJIT\src` появились файлы `lua51.dll` и `luajit.exe`

Теперь переименовал `C:\tools\LuaJIT\` в `C:\tools\repo_luajit\`, создал новую папку `C:\tools\LuaJIT\`, туда скопировал `lua51.dll` и `luajit.exe`, создал папку `C:\tools\LuaJIT\lua\jit\` и скопировал туда все `.lua` файлы из  `C:\tools\repo_luajit\src\jit`

Итоговая структура папки `C:\tools\LuaJIT\`:

```
├── luajit.exe
├── lua51.dll
├── <- put your own classic Lua/C API modules (*.dll) here
└── lua
    ├── <- put your own Lua modules (*.lua) here
    └── jit
        ├── bc.lua
        └── (etc …)
```

### Проверка установки

```
C:\tools\LuaJIT>luajit -v
LuaJIT 2.1.1748459687 -- Copyright (C) 2005-2025 Mike Pall. https://luajit.org/
```

## Language Server

Я использую VS Code, расширение `Lua` от sumneko