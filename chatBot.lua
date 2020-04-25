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
	math.randomseed(tonumber(tostring(os.time()):reverse():sub(1, 6)))
	local randomNum = math.random(1,120)
	-- 图片路径
	local path = "/root/img/mm/"..randomNum..".jpg"
	res = readImg(path)
	base64 = PkgCodec.EncodeBase64(res)
	 Api.Api_SendMsg(
		CurrentQQ,
		{
				toUser = data.FromUin,
				sendToType = 1,
				sendMsgType = "PicMsg",
				groupid = 0,
				content = "\n"..content,
				picUrl = "",
				picBase64Buf = base64,
				fileMd5 = "",
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
	local msg = json.decode(html)
	local content = msg.content:gsub("{br}","\n")
	math.randomseed(tonumber(tostring(os.time()):reverse():sub(1, 6)))
	local randomNum = math.random(1,120)
	-- 图片路径
	local path = "/root/img/mm/"..randomNum..".jpg"
	res = readImg(path)
	base64 = PkgCodec.EncodeBase64(res)
	 Api.Api_SendMsg(
		CurrentQQ,
		{
				toUser = data.FromGroupId,
				sendToType = 2,
				sendMsgType = "PicMsg",
				groupid = 0,
				content = "\n"..content,
				picUrl = "",
				picBase64Buf = base64,
				fileMd5 = "",
				atUser = 0
		}
	)
	end
    return 1
end
function ReceiveEvents(CurrentQQ, data, extData)
    return 1
end
function readImg(filePath)
    local f, err = io.open(filePath, "rb")
    if err ~= nil then
        return nil, err
    end
    local content = f:read("*all")
    f:close()
    return content, err
end