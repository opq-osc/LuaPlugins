local log = require("log")
local Api = require("coreApi")
local json = require("json")
local http = require("http")

function ReceiveFriendMsg(CurrentQQ, data)
    return 1
end
function ReceiveGroupMsg(CurrentQQ, data)
    math.randomseed(os.time())
    ShowType = math.random(40000, 40005)
    log.info("ShowType %d", ShowType)
			if string.find(data.Content, "闪我") == 1 then 
        Api.Api_SendMsg( --通过Url发送图片
            CurrentQQ,
            {
                toUser = data.FromGroupId,
                sendToType = 2,
                sendMsgType = "PicMsg",
                --发送图文消息
                content = string.format("[秀图%d]", ShowType),
                --通过宏[PICFLAG]改变图文顺序  改为现文字后图片
                --通过宏[秀图40001] 范围 40000-40006 实现秀图发送 群有效好友无效
                atUser = 0,
                voiceUrl = "",
                voiceBase64Buf = "",
                picUrl = "http://q1.qlogo.cn/g?b=qq&nk=" .. data.FromUserId .. "&s=640",
                picBase64Buf = "",
                fileMd5 = ""
            }
        )
    end
    if (data.MsgType == "AtMsg") and (string.find(data.Content, "闪她")) then
		log.notice("data.Content>%s",data.Content)
        jData = json.decode(data.Content)
        Api.Api_SendMsg( --通过Url发送图片
            CurrentQQ,
            {
                toUser = data.FromGroupId,
                sendToType = 2,
                sendMsgType = "PicMsg",
                --发送图文消息
                content = string.format("[秀图%d]", ShowType),
                --通过宏[PICFLAG]改变图文顺序  改为现文字后图片
                --通过宏[秀图40001] 范围 40000-40005 实现秀图发送 群有效好友无效
                atUser = 0,
                voiceUrl = "",
                voiceBase64Buf = "",
                picUrl = "http://q1.qlogo.cn/g?b=qq&nk=" .. jData.UserID[1] .. "&s=640",
                picBase64Buf = "",
                fileMd5 = ""
            }
        )
    end
    if (data.MsgType == "PicMsg") and (string.find(data.Content, "秀图")) then --发送图文指令 如秀图40001 文字和图片一起发送就会有效果了
        jData = json.decode(data.Content)
        srcindex = string.match(jData.Content, "%d+")
        -- 提取秀图特效类型40000-40005
        keyWord = jData.Content:gsub("秀图" .. srcindex, "")
        -- 替换关键字 秀图40001 会被替换成""
        Api.Api_SendMsg( --通过图片md5发送图片 秒发不用上传 相当于转发
            CurrentQQ,
            {
                toUser = data.FromGroupId,
                sendToType = 2,
                sendMsgType = "PicMsg",
                --发送图文消息
                content = string.format("[秀图%d]%s", srcindex, keyWord),
                --通过宏[PICFLAG]改变图文顺序  改为先文字后图片
                --通过宏[秀图40001] 范围 40000-40005 实现秀图发送 群有效好友无效
                atUser = 0,
                voiceUrl = "",
                voiceBase64Buf = "",
                picUrl = "",
                picBase64Buf = "",
                fileMd5 = jData.FileMd5
            }
        )
    end
    return 1
end
function ReceiveEvents(CurrentQQ, data, extData)
    -- groupList = {[群号]] = true, [群号] = false}
    -- math.randomseed(os.time())
    -- ShowType = math.random(40000, 40005)
    -- if data.MsgType == "ON_EVENT_GROUP_JOIN" then --监听有人进群的事件 然后秀图她的头像 情景类似Svip的进群特效
    --     str =
    --         string.format(
    --         "GroupJoinEvent\n JoinGroup Id %d  \n JoinUin %d \n JoinUserName \n%s InviteUin \n%s",
    --         data.FromUin,
    --         extData.UserID,
    --         extData.UserName,
    --         extData.InviteUin --非管理员权限此值是0
    --     )
    --     log.info("%s", str)
    --     if groupList[data.FromUin] == nil then --欲处理消息的群ID 简单过滤一下
    --         return 1
    --     end
    --     Api.Api_SendMsg(--通过Url发送图片
    --         CurrentQQ,
    --         {
    --             toUser = data.FromUin,
    --             sendToType = 2,
    --             sendMsgType = "PicMsg",
    --             --发送图文消息
    --             content = string.format("[PICFLAG]闪亮✨登场[秀图%d]", ShowType),
    --             --通过宏[PICFLAG]改变图文顺序  改为先文字后图片
    --             --通过宏[秀图40001] 范围 40000-40005 实现秀图发送 群有效好友无效
    --             atUser = 0,
    --             voiceUrl = "",
    --             voiceBase64Buf = "",
    --             picUrl = "http://q1.qlogo.cn/g?b=qq&nk=" .. extData.UserID .. "&s=640",
    --             picBase64Buf = "",
    --             fileMd5 = ""
    --         }
    --     )
    -- end
    return 1
end
