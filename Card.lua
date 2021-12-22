local log = require("log")
local Api = require("coreApi")
local json = require("json")
local http = require("http")

function ReceiveFriendMsg(CurrentQQ, data)
    return 1
end
function ReceiveGroupMsg(CurrentQQ, data)
    
    if string.find(data.Content, "xml1") == 1 then
        local content = string.format(
                            "<?xml version='1.0' encoding='UTF-8' standalone='yes'?><msg templateID=\"123\" url=\"https://b23.tv/mMr69DX\" serviceID=\"1\" action=\"web\" actionData=\"\" a_actionData=\"\" i_actionData=\"\" brief=\"[QQ小程序]哔哩哔哩\" flag=\"0\"><item layout=\"2\"><picture cover=\"https://external-30160.picsz.qpic.cn/c00ab19f9326471334b373a700f2a3e2/jpg1\"/><title>哔哩哔哩</title><summary>在日本送外卖平台会对骑手罚款吗？答案来了</summary></item><source url=\"https://b23.tv/mMr69DX\" icon=\"https://open.gtimg.cn/open/app_icon/00/95/17/76/100951776_100_m.png?t=1638951012\" name=\"哔哩哔哩\" appid=\"0\" action=\"web\" actionData=\"\" a_actionData=\"tencent0://\" i_actionData=\"\"/></msg>")
        content = string.gsub(content, "&", "&amp;")
        luaRes = Api.Api_SendMsg(CurrentQQ, {
            toUser = data.FromGroupId,
            sendToType = 2,
            sendMsgType = "XmlMsg",
            groupid = 0,
            content = content,
            atUser = 0
        })
    end
    if string.find(data.Content, "xml2") == 1 then
        local content = string.format(
                            "<?xml version='1.0' encoding='UTF-8' standalone='yes'?><msg templateID=\"123\" url=\"https://ti.qq.com/avatarlist/public/index.html?_wv=3&amp;_wwv=4\" serviceID=\"33\" action=\"web\" actionData=\"\" brief=\"【链接】QQ历史头像\" flag=\"8\"><item layout=\"2\"><picture cover=\"http://wa.qq.com/anniversary/1_100.png\"/><title>QQ历史头像</title><summary>找回我曾用过的QQ自定义头像</summary></item></msg>")
        content = string.gsub(content, "&", "&amp;")
        luaRes = Api.Api_SendMsg(CurrentQQ, {
            toUser = data.FromGroupId,
            sendToType = 2,
            sendMsgType = "XmlMsg",
            groupid = 0,
            content = content,
            atUser = 0
        })
    end
    return 1
end
function ReceiveEvents(CurrentQQ, data, extData) return 1 end
