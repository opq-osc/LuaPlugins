local log = require("log")
local Api = require("coreApi")
local json = require("json")
local http = require("http")

function ReceiveFriendMsg(CurrentQQ, data)
    return 1
end
function ReceiveGroupMsg(CurrentQQ, data)
if string.find(data.Content, "post") == 1 then
    
    local data = "sdasdasd"
    response, error_message =
        http.request(
        "GET",
        "http://xiaoling.natapp1.cc/wxPay/test",
        {
            headers = {
               Cookie = "l=v"
            }

        }
    )
    local err = error_message
    log.notice("err---> %s",err)
    local html = response
    log.notice("html---> %s",html)
end
    return 1
end
function ReceiveEvents(CurrentQQ, data, extData)
    return 1
end
	
