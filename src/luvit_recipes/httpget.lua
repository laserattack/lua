local http = require("http")

local function httpGET(url, callback)
    url = http.parseUrl(url)
    local req = http.get(url, function(res)
        local body={}
        res:on('data', function(s)
            body[#body+1] = s
        end)
        res:on('end', function()
            res.body = table.concat(body)
            callback(res)
        end)
        res:on('error', function(err)
            callback(res, err)
        end)
    end)
    req:on('error', function(err)
        callback(nil, err)
    end)
end

httpGET("https://example.com", function (res, err)
    if err then
        print("error", err)
    else
        print(res.body)
    end
end)