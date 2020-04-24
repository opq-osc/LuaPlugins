local log = require("log")
local Api = require("coreApi")
local json = require("json")
local http = require("http")

function ReceiveFriendMsg(CurrentQQ, data)
if string.find(data.Content, "语音") == 1 then
	keyWord = data.Content:gsub("语音", "")
	if keyWord == nil then
		return 1
	end
	 Api.Api_SendMsg(
		CurrentQQ,
		{
				toUser = data.FromUin,
				sendToType = 1,
				sendMsgType = "VoiceMsg",
				groupid = 0,
				content = "",
				atUser = 0,
				voiceUrl = "https://dds.dui.ai/runtime/v1/synthesize?voiceId=qianranfa&speed=0.8&volume=100&audioType=wav&text=" ..
						keyWord, --将回复的文字转成语音并听过网络Url方式发送回复语音
				voiceBase64Buf = "",
				picUrl = "",
				picBase64Buf = ""
		}
	)
	end
    return 1
end
function ReceiveGroupMsg(CurrentQQ, data)
if string.find(data.Content, "语音") == 1 then
	keyWord = data.Content:gsub("语音", "")
	if keyWord == nil then
		return 1
	end
	 Api.Api_SendMsg(
		CurrentQQ,
		{
				toUser = data.FromGroupId,
				sendToType = 2,
				sendMsgType = "VoiceMsg",
				groupid = 0,
				content = "",
				atUser = 0,
				voiceUrl = "https://dds.dui.ai/runtime/v1/synthesize?voiceId=qianranfa&speed=0.8&volume=100&audioType=wav&text=" ..
						keyWord, --将回复的文字转成语音并听过网络Url方式发送回复语音
				voiceBase64Buf = "",
				picUrl = "",
				picBase64Buf = ""
		}
	)
	end
    return 1
end
function ReceiveEvents(CurrentQQ, data, extData)
    return 1
end
	