local log = require("log")
local Api = require("coreApi")
local json = require("json")
local http = require("http")

function ReceiveFriendMsg(CurrentQQ, data)
if string.find(data.Content, "*") == 1 then
	keyWord = data.Content:gsub("*", "")
	if keyWord == nil then
		return 1
	end
	response, error_message =
	       http.request(
	       "GET",
					"http://api.qingyunke.com/api.php?",
	       {
	           query = "key=free&appid=0&msg=" ..
	               keyWord,
	           headers = {
									["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.163 Safari/537.36"
	           }
	       }
	   )
	local html = response.body
	local msg = json.decode(html)
	local content = msg.content:gsub("{br}","\n")
	 Api.Api_SendMsg(
		CurrentQQ,
		{
				toUser = data.FromUin,
				sendToType = 1,
				sendMsgType = "TextMsg",
				groupid = 0,
				content = content,
				atUser = 0
		}
	)
	end
    return 1
end
function ReceiveGroupMsg(CurrentQQ, data)
if string.find(data.Content, "*") == 1 then
	keyWord = data.Content:gsub("*", "")
	if keyWord == nil then
		return 1
	end
	response, error_message =
	       http.request(
	       "GET",
					"http://api.qingyunke.com/api.php?",
	       {
	           query = "key=free&appid=0&msg=" ..
	               keyWord,
	           headers = {
									["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.163 Safari/537.36"
	           }
	       }
	   )
	local html = response.body
	log.notice("html--->%s", html)
	local msg = json.decode(html)
	local content = msg.content:gsub("{br}","\n")
	 Api.Api_SendMsg(
		CurrentQQ,
		{
				toUser = data.FromGroupId,
				sendToType = 2,
				sendMsgType = "TextMsg",
				groupid = 0,
				content = content,
				atUser = 0
		}
	)
	end
    return 1
end
function ReceiveEvents(CurrentQQ, data, extData)
    return 1
end

	