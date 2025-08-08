local ffi = require("ffi")
-- unix (микросекунды. 1с=10^6мкс)
ffi.cdef[[
    int usleep(unsigned usec);
]]

local event_loop = {
    tasks = {},        -- Очередь задач { callback, delay }
    timers = {},       -- Таймеры { time_left, callback }
    running = true,    -- Флаг работы цикла
    delay = 0.01       -- Глобальная задержка в цикле в секундах
}

-- Добавляет тикер - функцию, которая будет выполняться
-- раз в какое то время
---@param callback function
function event_loop:add_ticker(callback, interval)
    table.insert(self.timers, {
        time_left = interval,  -- Текущее время до срабатывания
        interval = interval,   -- Интервал между вызовами
        callback = callback    -- Функция для вызова
    })
end

-- Добавляет задачу в очередь
---@param callback function
function event_loop:add_task(callback)
    table.insert(self.tasks, callback)
end

function event_loop:run()
    while self.running do
        -- 1. Обработка таймеров
        for i, timer in ipairs(self.timers) do
            timer.time_left = timer.time_left - self.delay  -- Уменьшаем время
            if timer.time_left <= 0 then
                timer.callback()                   -- Вызываем колбэк
                timer.time_left = timer.interval
            end
        end

        -- 2. Выполнение задач из очереди
        if #self.tasks > 0 then
            ---@type function
            local task = table.remove(self.tasks, 1)
            task()  -- Выполняем колбэк
        end

        -- 3. Имитация "ожидания" (чтобы не грузить CPU)
        ffi.C.usleep(self.delay*1000000)
    end
end

---- Далее сценарий работы

-- Фейковый HTTP-запрос, отправляющийся по таймеру
-- Правильный подход при event loop, т.к.
-- колбек выполнится в эвент лупе сам при достижении нужных условий
local function fake_http_get_v1(url, callback)
    event_loop:add_ticker(function()
        print("(Асинхронно) Запрос к " .. url .. " завершён!")
        callback("Данные: " .. url)
    end, math.random(1, 3))  -- Случайная задержка 1-3 сек
end

-- подход не верный, вернется просто nil, потому что
-- таймер еще не сработал
local function fake_http_get_v2(url)
    local response
    event_loop:add_ticker(function()
        response = "Данные: " .. url  -- Запись в переменную
    end, 2)
    return response
end

fake_http_get_v1("https://api.example.com", function(data)
    print("3. Получены данные:", data)
end)


print(fake_http_get_v2("https://api.example.com"))

event_loop:run()