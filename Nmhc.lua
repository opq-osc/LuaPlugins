local log = require("log")
local Api = require("coreApi")
local json = require("json")
local http = require("http")

function ReceiveFriendMsg(CurrentQQ, data)
    return 1
end
function ReceiveGroupMsg(CurrentQQ, data)
if string.find(data.Content, "网易云热评") == 1 then
    response, error_message =
        http.request(
        "GET",
        "https://www.mouse123.cn/api/163/api.php",
        {
            headers = {
                Accept = "*/*"
            }
        }
    )
    local html = response.body
    local info = json.decode(html)
    local img_url = info.images
    log.notice("url:%s",img_url)
    local content = string.format(
                        "\n歌曲名称：%s\n歌曲作者：%s\n热评：%s",
                        info.title,
                        info.author,
                        info.comment_content
                    )
    luaPic =
    Api.Api_SendMsg(--调用发消息的接口
        CurrentQQ,
        {
            toUser = data.FromGroupId, --回复当前消息的来源群ID
            sendToType = 2, --2发送给群1发送给好友3私聊
            groupid = 0, --不是私聊自然就为0咯
            atUser = 0, --是否 填上data.FromUserId就可以复读给他并@了
            sendMsgType = "PicMsg",
            content = content,
            picUrl = img_url,
            picBase64Buf = "",
            fileMd5 = ""
        }
    )
end
    return 1
end
function ReceiveEvents(CurrentQQ, data, extData)
    return 1
end
	