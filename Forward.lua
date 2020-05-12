local log = require("log")
local Api = require("coreApi")
local json = require("json")
local http = require("http")

function ReceiveFriendMsg(CurrentQQ, data)
    return 1
end
function ReceiveGroupMsg(CurrentQQ, data)
	if data.FromGroupId == 757360354 then --QQgroup
		if data.FromUserId == 1752951672 then --QQuser
	str = json.decode(data.Content)
	img_url = str.GroupPic[1].Url
	fileMd5 = str.GroupPic[1].FileMd5
	log.notice('data2-->%s', fileMd5)
	log.notice('data-->%s', img_url)
	log.notice('data.GroupId-->%s', data.FromGroupId)
	log.notice('data.GroupUserQQ-->%s', data.FromUserId)
		Api.Api_SendMsg(--调用发消息的接口
		    CurrentQQ,
		    {
		        toUser = 578111062, --回复想要转发的群ID
		        sendToType = 2, --2发送给群1发送给好友3私聊
		        sendMsgType = "PicMsg", --进行文本复读回复
		        groupid = 0, --不是私聊自然就为0咯
		        content = "", --回复内容
						picUrl = "",
						picBase64Buf = "",
						fileMd5 = fileMd5,
						flashPic = true,
		        atUser = 0
		    }
		)
	end
	end
    return 1
end
function ReceiveEvents(CurrentQQ, data, extData)
    return 1
end

	