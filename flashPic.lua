local log = require("log")
local Api = require("coreApi")
local json = require("json")
local http = require("http")

function ReceiveFriendMsg(CurrentQQ, data)
    return 1
end
function ReceiveGroupMsg(CurrentQQ, data)
	if string.find(data.Content, ".r18") == 1 then
		response, error_message =
							http.request(
							"GET",
							"https://api.lolicon.app/setu",
							{
									query = "apikey='你的APIKEY'&r18=1"
							  --   headers = {
									-- 	User-Agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.132 Safari/537.36"
									-- }
							}
					)			
					local html = response.body
					local strJson = json.decode(html)
					local img_url = strJson["data"][1]["url"]
					log.notice("the img_url is %s", img_url)
		Api.Api_SendMsg(--调用发消息的接口
		    CurrentQQ,
		    {
		        toUser = data.FromGroupId, --回复当前消息的来源群ID
		        sendToType = 2, --2发送给群1发送给好友3私聊
		        sendMsgType = "PicMsg", --进行文本复读回复
		        groupid = 0, --不是私聊自然就为0咯
		        content = "", --回复内容
						picUrl = img_url,
						picBase64Buf = "",
						fileMd5 = "",
						flashPic = true,
		        atUser = 0 --是否 填上data.FromUserId就可以复读给他并@了
		    }
		)
	end
    return 1
end
function ReceiveEvents(CurrentQQ, data, extData)
    return 1
end

	