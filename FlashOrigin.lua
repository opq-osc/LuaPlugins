local log = require("log")
local Api = require("coreApi")
local json = require("json")
local http = require("http")

function ReceiveFriendMsg(CurrentQQ, data)
    return 1
end
function ReceiveGroupMsg(CurrentQQ, data)
if string.find(data.MsgType, "PicMsg") then 
    if string.find(data.Content, "[闪照]") then 
        log.notice("------------------------------")
        str = json.decode(data.Content)
        local FileMd5 = str.FileMd5

        Api.Api_SendMsg(--调用发消息的接口
            CurrentQQ,
            {
                toUser = data.FromGroupId, --回复当前消息的来源群ID
                sendToType = 2, --2发送给群1发送给好友3私聊
                groupid = 0, --不是私聊自然就为0咯
                atUser = 0, --是否 填上data.FromUserId就可以复读给他并@了
                sendMsgType = "PicMsg",
                content = "",
                picUrl = "",
                picBase64Buf = "",
                fileMd5 = FileMd5
            }
        )
    end
end
    return 1
end
function ReceiveEvents(CurrentQQ, data, extData)
    return 1
end
	