local log = require("log")
local Api = require("coreApi")
local json = require("json")
local http = require("http")
local mysql = require("mysql")

function ReceiveFriendMsg(CurrentQQ, data)
    log.info("%s","\nFriendParseMsg")
    str =
        string.format(
        "\nFrom Msg \nFromUin  %d  \nToUin %d\nMsgType %s Content %s MsgSeq %s\n",
        data.FromUin,
        data.ToUin,
        data.MsgType,
        data.Content,
        data.MsgSeq
    )
    log.notice("From log.lua Log\n%s", str)
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
    return 1
end

function ReceiveEvents(CurrentQQ, data, extData)
    return 1
end
