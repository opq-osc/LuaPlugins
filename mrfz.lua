local log = require("log")
local Api = require("coreApi")
local json = require("json")
local http = require("http")

function ReceiveFriendMsg(CurrentQQ, data)
    return 1
end
function ReceiveGroupMsg(CurrentQQ, data)
if string.find(data.Content, "明日方舟") == 1 then
	-- math.randomseed(tonumber(tostring(os.time()):reverse():sub(1, 6)))
	math.randomseed(data.MsgRandom)
	local randomNum = math.random(1,293)
	local path = "/root/img/mrfz/"..randomNum..".jpg"
	res = readImg(path)
	base64 = PkgCodec.EncodeBase64(res)
	 Api.Api_SendMsg(
		CurrentQQ,
		{
				toUser = data.FromGroupId,
				sendToType = 2,
				sendMsgType = "PicMsg",
				groupid = 0,
				content = "",
				picUrl = "",
				picBase64Buf = base64,
				fileMd5 = "",
				flashPic = true,
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

