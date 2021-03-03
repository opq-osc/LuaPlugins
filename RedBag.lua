local log = require("log")
local Api = require("coreApi")
local json = require("json")
local http = require("http")
function ReceiveFriendMsg(CurrentQQ, data)
    --log.notice("From RedBag.Lua Log ReceiveFriendMsg %s", CurrentQQ)
    if (string.find(data.MsgType, "RedBagMsg") == 1) then
        log.notice("From Lua RedBaginfo RedType-->%d", data.RedBaginfo.RedType)
        --RedType 12 口令 4普通 2 转账
        if (data.RedBaginfo.RedType ~= 2) then
            Api.Api_OpenRedBag(CurrentQQ, data.RedBaginfo)
        end
    end
    return 1
end
function ReceiveGroupMsg(CurrentQQ, data)

    if (string.find(data.MsgType, "RedBagMsg") == 1) then --判断一下消息类型
        info = Api.Api_OpenRedBag(CurrentQQ, data.RedBaginfo)
        --//RedType4普通红包6拼手气红包12口令红包
        --log.notice("From Lua Tittle Ret-->%s", data.RedBaginfo.Tittle)
        --log.notice("From Lua RedType Ret-->%s", data.RedBaginfo.RedType)
        if (info.Ret == 5) then
            log.notice("为使命%s", "===========")
            return 1
        end

        math.randomseed(os.time())

        replayType = math.random(1, 3) --1回复文字2图片3图文
        replayTextIndex = math.random(1, 10)
        replayPicIndex = math.random(1, 15)
        replaySlowIndex = math.random(1, 8)
        replayTextArray = {
            "谢谢老板～🙏",
            "老板发财💰",
            "谢谢🙏",
            "谢谢大佬的红包",
            "发红包的好帅😂",
            "老板大发特发💰",
            "群里有外挂吧?😂😂😂😂",
            "卧槽 ,好多外挂.....",
            "外挂可耻",
            "着都是什么手速😂😂😂😂"
        }
        replayPicArray = {
            "6GFvNSQ1wVqcWj+NmvYi4A==",
            "MH7vdxYLC7l2mFqcIJr1aw==",
            "zC79HXEwoPk+dlsveNyPuQ==",
            "tl0YFiRJPz02FCL8CFcMqQ==",
            "JUUakch8lT+ScOJgwj95cg==",
            "vZR3/8/Lv5gk1ijO7dilyA==",
            "xcjWoTojxFnGvewqOXp5tw==",
            "T0TwmJcNgIqnTzA+uII+YQ==",
            "7nnAja59BL5IGJwnLfnArw==",
            "aw27Yrg/76t+78Aj/6EvCw==",
            "3TI0gx1g/WqzQcGMMDf4MQ==",
            "p5AEusNTBKfq2gXJBBkk8g==",
            "Gid0AColHpg+5oQW/j07Vg==",
            "CRL1BKRlG1uJPLmrAZ8aCg==",
            "oADim/WQAnlM+eYE8BLxLg=="
        }
        replaySlowArray = {
            "T1c/09liIu9YSWvu0iRRyQ==",
            "4AQkxKnemK8xAkHsw5m4Tg==",
            "UjtiY7IX0gYXgcrn7h/c0Q==",
            "LSRNLtLRYYwBAK7yz8UmEA==",
            "0eydlur02C0tjcvbqktNIQ==",
            "B761bZ+tIi6KBNACifwh1g==",
            "T6qsVuizoLJ4UzZXX/Ix9A==",
            "m5XxhvMF4IN88JfGjwmSTw=="
        }

        if (info.GetMoney == 0) then
            log.notice("没抢到%s", "===========")

            Api.Api_SendMsg(
                CurrentQQ,
                {
                    toUser = data.FromGroupId,
                    sendToType = 2,
                    sendMsgType = "PicMsg",
                    content = "",
                    atUser = 0,
                    voiceUrl = "",
                    voiceBase64Buf = "",
                    picUrl = "",
                    picBase64Buf = "",
                    fileMd5 = replaySlowArray[replaySlowIndex]
                }
            )
            return 1
        end

        if (data.RedBaginfo.RedType == 12) then
         luaRes =
                Api.Api_SendMsg(
                CurrentQQ,
                {
                    toUser = data.FromGroupId,
                    sendToType = 2,
                    sendMsgType = "TextMsg",
                    groupid = 0,
                    content = data.RedBaginfo.Tittle,
                    atUser = 0
                }
            )

        --log.notice("From Lua SendMsg Ret\n%d", luaRes.Ret)
        end
        Sleep(2)
        if (replayType == 1) then
          Api.Api_SendMsg(
                CurrentQQ,
                {
                    toUser = data.FromGroupId,
                    sendToType = 2,
                    sendMsgType = "TextMsg",
                    groupid = 0,
                    content = replayTextArray[replayTextIndex],
                    atUser = 0
                }
            )
        end
        if (replayType == 2) then
          Api.Api_SendMsg(
                CurrentQQ,
                {
                    toUser = data.FromGroupId,
                    sendToType = 2,
                    sendMsgType = "PicMsg",
                    content = "",
                    atUser = 0,
                    voiceUrl = "",
                    voiceBase64Buf = "",
                    picUrl = "",
                    picBase64Buf = "",
                    fileMd5 = replayPicArray[replayPicIndex]
                }
            )
        end
        if (replayType == 3) then
         Api.Api_SendMsg(
                CurrentQQ,
                {
                    toUser = data.FromGroupId,
                    sendToType = 2,
                    sendMsgType = "PicMsg",
                    content = replayTextArray[replayTextIndex],
                    atUser = 0,
                    voiceUrl = "",
                    voiceBase64Buf = "",
                    picUrl = "",
                    picBase64Buf = "",
                    fileMd5 = replayPicArray[replayPicIndex]
                }
            )
        end

        str =
            string.format(
            "已经抢到%d replayType %d replayTextIndex %d replayPicIndex %d replaySlowIndex %d",
            info.GetMoney,
            replayType,
            replayTextIndex,
            replayPicIndex,
            replaySlowIndex
        )
        log.notice("%s", str)
    end
    return 1
end
function ReceiveEvents(CurrentQQ, data, extData)
    return 1
end
function Sleep(n)
    log.notice("==========Sleep==========\n%d", n)
    local t0 = os.clock()
    while os.clock() - t0 <= n do
    end
    log.notice("==========over Sleep==========\n%d", n)
end
