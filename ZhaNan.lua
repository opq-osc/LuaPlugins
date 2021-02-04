-- https://api.lovelive.tools/api/SweetNothings/WebSite/1
local log = require("log")
local Api = require("coreApi")
local json = require("json")
local http = require("http")

function ReceiveFriendMsg(CurrentQQ, data)
    return 1
end
function ReceiveGroupMsg(CurrentQQ, data)

if string.find(data.Content, "渣男语录") == 1 then
    response, error_message =
        http.request(
        "GET",
        "https://api.lovelive.tools/api/SweetNothings/WebSite/1",
        {
            headers = {
                Accept = "*/*"
            }
        }
    )
    local html = response.body
    local info = json.decode(html)
    local msg = info[1].content
    log.notice("------ %s",msg)
    luaMsg =
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
	