# luajit-playground

Хочу освоить язык lua. Тут играюсь с luajit

## Установка luajit

### Установка

Репозиторий `https://github.com/LuaJIT/LuaJIT`

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

