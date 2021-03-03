local log = require("log")
local Api = require("coreApi")
local json = require("json")
local http = require("http")

function ReceiveFriendMsg(CurrentQQ, data)
    return 1
end
function ReceiveGroupMsg(CurrentQQ, data)
if string.find(data.Content, "晚安") then
		luaMsg =
			    Api.Api_SendMsg(--调用发消息的接口
			    CurrentQQ,
			    {
			       toUser = data.FromGroupId, --回复当前消息的来源群ID
			       sendToType = 2, --2发送给群1发送给好友3私聊
			       sendMsgType = "VoiceMsg", --进行文本复读回复
			       groupid = 0, --不是私聊自然就为0咯
			       content = "", --回复内容
			       atUser = 0, --是否 填上data.FromUserId就可以复读给他并@了
						 voiceUrl = "http://static.missevan.com/128BIT/202004/08/49723badf1aaeebd09d04cc5d875888c215453.mp3",
						 voiceBase64Buf = ""
			    }
			)
		end
    return 1
end
function ReceiveEvents(CurrentQQ, data, extData)
    return 1
end
