local log = require("log")
local Api = require("coreApi")
local json = require("json")
local http = require("http")

function ReceiveFriendMsg(CurrentQQ, data)
    return 1
end
function ReceiveGroupMsg(CurrentQQ, data)
	if string.find(data.Content, "天气菜单") == 1 then
        local msg = "天气菜单：\n"..
        "24小时降水量预报===>降水\n"..
        "24小时最高气温预报===>气温\n"..
        "全国雷达拼图===>全国雷达拼图\n"..
        "华东雷达图===>华东\n"..
        "华北雷达图===>华北\n"..
        "华南雷达图===>华南\n"..
        "西南雷达图===>西南\n"..
        "能见度===>能见度\n"..
        "近10天全国最高气温实况图===>最高气温实况图\n"..
        "近10天全国最低气温实况图===>最低气温实况图"

		Api.Api_SendMsg(--调用发消息的接口
		    CurrentQQ,
		    {
		        toUser = data.FromGroupId, --回复当前消息的来源群ID
		        sendToType = 2, --2发送给群1发送给好友3私聊
		        sendMsgType = "TextMsg", --进行文本复读回复
		        groupid = 0, --不是私聊自然就为0咯
		        content = msg, --回复内容
		        atUser = 0 --是否 填上data.FromUserId就可以复读给他并@了
		    }
		)
	end
    return 1
end
function ReceiveEvents(CurrentQQ, data, extData)
    return 1
end

	