local log = require("log")
local Api = require("coreApi")
local json = require("json")
local http = require("http")

function ReceiveFriendMsg(CurrentQQ, data)
    return 1
end

function ReceiveEvents(CurrentQQ, data, extData)
    return 1
end
function ReceiveGroupMsg(CurrentQQ, data)

    log.info("%s","\nGroupMsgParseMsg")
    str =
        string.format(
        "CurrentQQ %s\nFrom Msg \nGroupId  %d  \nGroupname %s \nGroupUserQQ %d \nGroupUsername %s \nMsgType %s\nContent %s seq %d time %d  MsgRandom %d",
        CurrentQQ,
        data.FromGroupId,
        data.FromGroupName,
        data.FromUserId,
        data.FromNickName,
        data.MsgType,
        data.Content,
        data.MsgSeq,
        data.MsgTime,
        data.MsgRandom
    )

    log.notice("From log.Lua Log\n%s", str)
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
    return 1
end