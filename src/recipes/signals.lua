local uv = require("luv")

-- Создаём обработчик сигнала
local signal_handle = uv.new_signal()

-- Функция-обработчик
uv.signal_start(signal_handle, "sigint", function(signal)
    print("signal handled:", signal)
    uv.stop()
end)

print("Press Ctrl+C for exit...")
uv.run()