local log = require("log")
local Api = require("coreApi")
local json = require("json")
local http = require("http")

function ReceiveFriendMsg(CurrentQQ, data)
		if string.find(data.Content, "复读机") == 1 then --判断一下所接收的消息里是否含有复读机字样 有则进行处理
        -- keyWord = data.Content:gsub("复读机", "") --提取关键词 保存到keyWord里
				 keyWord = data.Content.sub(data.Content,10,data.Content.len(data.Content))
        --log.notice("From Lua data.FromGroupId %d", data.FromGroupId)
        --提取完关键词我们就要 从哪个群收到的消息在进行复读回复回去(当然你也可以判断一下 keyWord=="" 的情况 )
        luaRes =
            Api.Api_SendMsg(--调用发消息的接口
            CurrentQQ,
            {
                toUser = data.FromUin, --回复当前消息的来源群ID
                sendToType = 1, --2发送给群1发送给好友3私聊
                sendMsgType = "TextMsg", --进行文本复读回复
                groupid = 0, --不是私聊自然就为0咯
                content = keyWord, --回复内容
                atUser = 0 --是否 填上data.FromUserId就可以复读给他并@了
            }
        )
        log.notice("From Lua SendMsg Ret-->%d", luaRes.Ret)
    end
    return 1
end
function ReceiveGroupMsg(CurrentQQ, data)
    if string.find(data.Content, "复读机") == 1 then --判断一下所接收的消息里是否含有关键字 有则进行处理
        -- keyWord = data.Content:gsub("复读机", "") --提取关键词 保存到keyWord里
				keyWord = data.Content.sub(data.Content,10,data.Content.len(data.Content))
        log.notice("From Lua data.FromGroupId %s", keyWord)
				log.notice("From Lua data.FromGroupId %s", data.FromUserId)
        luaRes =
            Api.Api_SendMsg(--调用发消息的接口
            CurrentQQ,
            {
                toUser = data.FromGroupId, --回复当前消息的来源群ID
                sendToType = 2, --2发送给群1发送给好友3私聊
                sendMsgType = "TextMsg", --进行文本复读回复
                groupid = 0, --不是私聊自然就为0咯
                content = keyWord, --回复内容
                atUser = 0 --是否 填上data.FromUserId就可以复读给他并@了
            }
        )
        log.notice("From Lua SendMsg Ret-->%d", luaRes.Ret)
    end
    return 1
end
function ReceiveEvents(CurrentQQ, data, extData)
    return 1
end