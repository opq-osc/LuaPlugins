local log = require("log")
local Api = require("coreApi")
local json = require("json")
local http = require("http")

function ReceiveFriendMsg(CurrentQQ, data)
    return 1
end
function ReceiveGroupMsg(CurrentQQ, data)
	if string.find(data.Content, "一言") == 1 then
		local type = {'f','g','h','i','a','b','c','d','e','j','k','l'}
		math.randomseed(tonumber(tostring(os.time()):reverse():sub(1, 7)))
		randomNum = math.random(12)
		response, error_message =
		    http.request(
		    "GET",
		    "https://v1.hitokoto.cn/",
		    {
		        query = "c=" ..
		            type[randomNum],
		        headers = {
		            ["Accept"] = "*/*",
								["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.163 Safari/537.36"
		        }
		    }
		)
		local html = response.body
		local j = json.decode(html)
		log.notice("data--->%s", html)
		local str = string.format(
			"%s\n\t\t\t\t--%s",
			j.hitokoto,
			j.from
		)
		Api.Api_SendMsg(--调用发消息的接口
		    CurrentQQ,
		    {
		        toUser = data.FromGroupId, --回复当前消息的来源群ID
		        sendToType = 2, --2发送给群1发送给好友3私聊
		        sendMsgType = "TextMsg", --进行文本复读回复
		        groupid = 0, --不是私聊自然就为0咯
		        content = str, --回复内容
		        atUser = 0 --是否 填上data.FromUserId就可以复读给他并@了
		    }
		)
	end
    return 1
end
function ReceiveEvents(CurrentQQ, data, extData)
    return 1
end

	