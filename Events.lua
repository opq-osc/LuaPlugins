local log = require("log")
local Api = require("coreApi")
local json = require("json")
local http = require("http")

function ReceiveFriendMsg(CurrentQQ, data)
    return 1
end
function ReceiveGroupMsg(CurrentQQ, data)
    return 1
end

function ReceiveEvents(CurrentQQ, data, extData)
    --QQ登陆成功事件
    if data.MsgType == "ON_EVENT_QQ_LOGIN_SUCC" then
        str = string.format(" QQ 登陆成功%s \n", extData.QQUser)
        log.info("%s", str)
    end
    --QQ离线事件 可能的原因(TX 踢号/异地登陆/冻结/被举报等 导致等Session失效)
    if data.MsgType == "ON_EVENT_QQ_OFFLINE" then
        str = string.format(" QQ 离线事件 %s Data %s \n", extData.QQUser, extData.Data)
        log.info("%s", str)
    end
    --网络变化事件 网络波动引起当前链接 释放 随机8-15s会自动重连登陆 被t下线的QQ 不会在重连
    if data.MsgType == "ON_EVENT_QQ_NETWORK_CHANGE" then
        str = string.format(" QQ 网络变化事件 %s Data %s \n", extData.QQUser, extData.Data)
        log.info("%s", str)
    end
    --添加好友的状态事件 被同意添加好友／被拒绝添加好友
    if data.MsgType == "ON_EVENT_FRIEND_ADD_STATUS" then
        str =
            string.format(
            "事件类型  %d  事件状态 %s 成员 UserID %d 昵称 %s \n",
            extData.Type,
            extData.TypeStatus,
            extData.UserID,
            extData.NickName
        )
        log.info("%s", str)
    end
    if data.MsgType == "ON_EVENT_NOTIFY_PUSHADDFRD" then
        str = string.format("(添加好友成功后的反馈？)成为了好友 UserID %d NickName%s", extData.UserID, extData.NickName)
        log.notice("%s", str)
    end
    --{"CurrentPacket":{"WebConnId":"fi4LFS7_uy8ORrKDQN5Z","Data":{"EventData":{"UserID":103259869,"FromType":2004,"Field_9":1571036852000000,"Content":"收到好友请求 内容我是QQ大冰来源来自QQ群","FromGroupId":757360354,"FromGroupName":"IOTQQ交流群","Action":2},"EventMsg":{"FromUin":103259869,"ToUin":534706350,"MsgType":"ON_EVENT_FRIEND_ADDED","Content":"收到好友请求 内容我是QQ大冰来源来自QQ群","RedBaginfo":null},"EventName":"ON_EVENT_FRIEND_ADD"}},"CurrentQQ":534706350}
    if data.MsgType == "ON_EVENT_FRIEND_ADDED" then
        --Action1忽略2同意3拒绝
        str =
            string.format(
            "收到好友请求事件  Uid %s UserNick %s FromType %d Action %d Content %s FromGroupId %d FromGroupName %s",
            extData.UserID,
            extData.UserNick,
            extData.FromType,
            extData.Action,
            extData.Content,
            extData.FromGroupId,
            extData.FromGroupName
        )
        log.notice("%s", str)
        extData.Action = 2
        apiRet = Api.Api_DealFriend(CurrentQQ, extData)
        str = string.format("From Lua AddFriendMsg Ret-->%d Msg-->%s", apiRet.Ret, apiRet.Msg)
        log.notice("%s", str)
    end

    --{"CurrentPacket":{"WebConnId":"fi4LFS7_uy8ORrKDQN5Z","Data":{"EventData":{"GroupID":960839480},"EventMsg":{"FromUin":0,"ToUin":0,"MsgType":"ON_EVENT_GROUP_EXIT_SUCC","Content":"主动退群成功事件","RedBaginfo":null},"EventName":"ON_EVENT_GROUP_EXIT_SUCC"}},"CurrentQQ":534706350}
    if data.MsgType == "ON_EVENT_GROUP_EXIT_SUCC" then
        str = string.format("QQ机器人主动退出群聊成功 GroupID %s \n", extData.GroupID)
        log.info("%s", str)
    end
    --{"CurrentPacket":{"WebConnId":"I5VW2Hq3YFe18AzvYJFY","Data":{"EventData":{"MsgSeq":3503,"UserID":1700487478},"EventMsg":{"FromUin":0,"ToUin":0,"MsgType":"ON_EVENT_FRIEND_REVOKE","MsgSeq":0,"Content":"好友撤回消息事件","RedBaginfo":null},"EventName":"ON_EVENT_FRIEND_REVOKE"}},"CurrentQQ":534706350}
    if data.MsgType == "ON_EVENT_FRIEND_REVOKE" then
        str = string.format("好友UserID %s 消息Seq %s \n", extData.UserID, extData.MsgSeq)
        log.info("%s", str)
    end
    --{"CurrentPacket":{"WebConnId":"dD8NTg57VpyyXTJDT7iU","Data":{"EventData":{"GroupID":757360354,"ShutTime":4294967295,"UserID":0},"EventMsg":{"FromUin":757360354,"ToUin":0,"MsgType":"ON_EVENT_GROUP_SHUT","MsgSeq":0,"Content":"群禁言事件","RedBaginfo":null},"EventName":"ON_EVENT_GROUP_SHUT"}},"CurrentQQ":534706350}
    --UserID = 0 ShutTime=4294967295 触发了开启全员禁言事件
    --UserID = 0 ShutTime=0 触发了关闭全员禁言事件
    --UserID = 123456789 ShutTime=123456789 触发了禁言用户123456789 禁言世间123456789 事件
    --UserID = 123456789 ShutTime=0 触发了解除用户123456789 禁言事件
    if data.MsgType == "ON_EVENT_GROUP_SHUT" then
        str = string.format("群GroupID %s UserID %d 禁言时间 %s\n", extData.GroupID, extData.UserID, extData.ShutTime)
        log.info("%s", str)
    end
    --{"CurrentPacket":{"WebConnId":"fi4LFS7_uy8ORrKDQN5Z","Data":{"EventData":{"UserID":103259869},"EventMsg":{"FromUin":0,"ToUin":0,"MsgType":"ON_EVENT_FRIEND_DELETE","Content":"被删除好友事件","RedBaginfo":null},"EventName":"ON_EVENT_FRIEND_DELETE"}},"CurrentQQ":534706350}
    if data.MsgType == "ON_EVENT_FRIEND_DELETE" then
        str = string.format(" UserID %s  删除了好友", extData.UserID)
        log.info("%s", str)
    end

    --{"CurrentPacket":{"WebConnId":"x7CHA79ZUNyBjoujRRC8","Data":{"EventData":{"GroupID":960839480,"MsgSeq":1452818440,"UserID":1700487478},"EventMsg":{"FromUin":960839480,"ToUin":0,"MsgType":"ON_EVENT_GROUP_REVOKE","MsgSeq":1452818440,"Content":"群成员撤回消息事件","RedBaginfo":null},"EventName":"ON_EVENT_GROUP_REVOKE"}},"CurrentQQ":534706350}
    if data.MsgType == "ON_EVENT_GROUP_REVOKE" then
        str = string.format("群成 %d  成员 UserID %s 撤回了消息Seq %s \n", extData.GroupID, extData.UserID, extData.MsgSeq)
        log.info("%s", str)
    end
    --{"CurrentPacket":{"WebConnId":"I1bqf1TxoDvDH8GtGTr-","Data":{"EventData":{"Content":"恭喜Kar98k获得群主授予的test头衔","GroupID":757360354,"UserID":1700487478},"EventMsg":{"FromUin":757360354,"ToUin":0,"MsgType":"ON_EVENT_GROUP_UNIQUETITTLE_CHANGED","MsgSeq":0,"Content":"群头衔变更事件","RedBaginfo":null},"EventName":"ON_EVENT_GROUP_UNIQUETITTLE_CHANGED"}},"CurrentQQ":534706350}
    if data.MsgType == "ON_EVENT_GROUP_UNIQUETITTLE_CHANGED" then
        str = string.format("群成 %d  成员 UserID %s 头衔变更了 %s \n", extData.GroupID, extData.UserID, extData.Content)
        log.info("%s", str)
    end
    --{"CurrentPacket":{"WebConnId":"ivNXn033LwcjePqSjFDH","Data":{"EventData":{"InviteUin":103259869,"UserID":1700487478,"UserName":"Kar98k"},"EventMsg":{"FromUin":901924844,"ToUin":534706350,"MsgType":"ON_EVENT_GROUP_JOIN","Content":"","RedBaginfo":null},"EventName":"ON_EVENT_GROUP_JOIN"}},"CurrentQQ":534706350}
    if data.MsgType == "ON_EVENT_GROUP_JOIN" then
        str =
            string.format(
            "GroupJoinEvent\n JoinGroup Id %d  \n JoinUin %d \n JoinUserName \n%s InviteUin \n%s",
            data.FromUin,
            extData.UserID,
            extData.UserName,
            extData.InviteUin --非管理员权限此值是0
        )
        log.info("%s", str)
    end
    --{"CurrentPacket":{"WebConnId":"ivNXn033LwcjePqSjFDH","Data":{"EventData":{"Flag":1,"GroupID":901924844,"UserID":534706350},"EventMsg":{"FromUin":901924844,"ToUin":534706350,"MsgType":"ON_EVENT_GROUP_ADMIN","Content":"管理员变更事件","RedBaginfo":null},"EventName":"ON_EVENT_GROUP_ADMIN"}},"CurrentQQ":534706350}
    --机器人是不是管理员都能收到此群管变更事件
    if data.MsgType == "ON_EVENT_GROUP_ADMIN" then
        str = string.format("群管变更事件 GroupID %d UserID %d  Flag %d", extData.GroupID, extData.UserID, extData.Flag)
        -- Flag 1升管理0将管理
        log.notice("%s", str)
    end
    --{"CurrentPacket":{"WebConnId":"ivNXn033LwcjePqSjFDH","Data":{"EventData":{"UserID":1700487478},"EventMsg":{"FromUin":901924844,"ToUin":534706350,"MsgType":"ON_EVENT_GROUP_EXIT","Content":"群成员退出群聊事件","RedBaginfo":null},"EventName":"ON_EVENT_GROUP_EXIT"}},"CurrentQQ":534706350}
    --无论机器人是不是管理员 群里任意成员 都能收到 此退群事件
    if data.MsgType == "ON_EVENT_GROUP_EXIT" then
        str = string.format("GroupExitEvent\n ExitGroup Id %s  \n ExitUin %d", data.FromUin, extData.UserID)
        log.info("%s", str)
    end
    --{"CurrentPacket":{"WebConnId":"f5LOv77dnotUK7aygso1","Data":{"EventData":{"GroupName":"debug","GroupOwner":69734488,"OwnerName":"Mac"},"EventMsg":{"FromUin":960839480,"ToUin":534706350,"MsgType":"ON_EVENT_GROUP_JOIN_SUCC","Content":"主动进群成功事件","RedBaginfo":null},"EventName":"ON_EVENT_GROUP_JOINED"}},"CurrentQQ":534706350}
    if data.MsgType == "ON_EVENT_GROUP_JOIN_SUCC" then
        str =
            string.format(
            "ON_EVENT_GROUP_JOIN_SUCC \n GroupJoinSuccess Id %d  \n 处理人ID %d 处理人昵称 %s GroupName %s",
            data.FromUin,
            extData.GroupOwner,
            extData.OwnerName,
            extData.GroupName
        )
        log.info("%s", str)
        luaRes =
            Api.Api_SendMsg(
            CurrentQQ,
            {
                toUser = data.FromUin,
                sendToType = 2,
                sendMsgType = "PicMsg",
                content = "感谢🙏@" .. extData.OwnerName .. "收留",
                atUser = 0,
                voiceUrl = "",
                voiceBase64Buf = "",
                picUrl = "http://gchat.qpic.cn/gchatpic_new/1700487478/960839480-2534335053-67CFBAE7F2E0CE681819D5A96134BE00/0?vuin=1700487478&term=255&pictype=0",
                picBase64Buf = "",
                fileMd5 = ""
            }
        )

        log.info("From Lua SendMsg Ret\n%d", luaRes.Ret)
    end
    --{"CurrentPacket":{"WebConnId":"3x1VZ6DlCiNQP1khIB43","Data":{"EventData":{"Seq":1570980892762275,"Type":1,"MsgTypeStr":"邀请加群","Who":534706350,"WhoName":"QQ棒棒冰","MsgStatusStr":"","Flag_7":8192,"Flag_8":512,"GroupId":570065685,"GroupName":"Rust编程语言社区3群","InviteUin":1700487478,"InviteName":"Kar98k","Action":0},"EventMsg":{"FromUin":570065685,"ToUin":534706350,"MsgType":"ON_EVENT_GROUP_INVITED","Content":"邀请加群","RedBaginfo":null},"EventName":"ON_EVENT_GROUP_INVITED"}},"CurrentQQ":534706350}
    --QQ群系统消息通知
    if data.MsgType == "ON_EVENT_GROUP_ADMINSYSNOTIFY" then
        str =
            string.format(
            "FromUin %d\n ToUin %d\n事件类型 %d 消息类型:%s 消息类型状态:%s 触发消息的对象:%d 触发消息的对象昵称:%s  来自群:%s 群名:%s 邀请人(处理人):%s 邀请人(处理人)昵称:%s 邀请人(处理人)群名片:%s (加群)理由:%s Action:%d",
            data.FromUin,
            data.ToUin,
            extData.Type,
            extData.MsgTypeStr,
            extData.MsgStatusStr,
            extData.Who,
            extData.WhoName,
            extData.GroupId,
            extData.GroupName,
            extData.ActionUin,
            extData.ActionName,
            extData.ActionGroupCard,
            extData.Content,
            extData.Action --11 agree 14 忽略 12/21 disagree
        )
        log.notice("%s", str)
        if extData.Type == 1 then
            extData.Action = 11
            --extData.RefuseContent = "小号" --拒绝理由
            apiRet = Api.Api_AnswerInviteGroup(CurrentQQ, extData)
            str = string.format("From Lua AnswerInviteGroup Ret-->%d Msg-->%s", apiRet.Ret, apiRet.Msg)
            log.notice("%s", str)
        end
    end
    return 1
end
