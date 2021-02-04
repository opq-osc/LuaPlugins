local log = require("log")
local Api = require("coreApi")
local json = require("json")
local http = require("http")

function ReceiveFriendMsg(CurrentQQ, data)
    return 1
end
function ReceiveGroupMsg(CurrentQQ, data)
if (string.find(data.Content, "垃圾分类") == 1) then
	local keyWord = data.Content:gsub("垃圾分类", "")
	if keyWord == nil then
		return 1
	end
	response, error_message =
		    http.request(
		    "GET",
		    "https://api.vvhan.com/api/la.ji?",
		    {
		        query = "lj="..url_encode(keyWord),
		        headers = {
		            ["Accept"] = "*/*",
								["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.163 Safari/537.36"
		        }
		    }
		)
		local html = response.body
        local status = html
		local a = json.decode(status)
		log.notice("垃圾分类--->%s", html)
		Api.Api_SendMsg(--调用发消息的接口
		    CurrentQQ,
		    {
		        toUser = data.FromGroupId, --回复当前消息的来源群ID
		        sendToType = 2, --2发送给群1发送给好友3私聊
		        sendMsgType = "TextMsg", --进行文本复读回复
		        groupid = 0, --不是私聊自然就为0咯
		        content = "『" ..a.name.. "』" ..a.sort, --回复内容
		        atUser = 0 --是否 填上data.FromUserId就可以复读给他并@了
		    }
		)
	end
    return 1
end
function ReceiveEvents(CurrentQQ, data, extData)
    return 1
end

function url_encode(str)
  if (str) then
    str = string.gsub (str, "\n", "\r\n")
    str = string.gsub (str, "([^%w ])",
        function (c) return string.format ("%%%02X", string.byte(c)) end)
    str = string.gsub (str, " ", "+")
  end
  return str	
end

