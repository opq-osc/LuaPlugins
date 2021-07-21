local log = require("log")
local Api = require("coreApi")
local json = require("json")
local http = require("http")

function ReceiveFriendMsg(CurrentQQ, data)
    if string.find(data.Content, "卡片测试") == 1 then -- 判断一下所接收的消息里是否含有复读机字样 有则进行处理
        log.notice("From Lua SendMsg Ret-->%d", data.Content)
        luaRes = Api.Api_SendMsg(CurrentQQ, {
            toUser = data.FromUin,
            sendToType = 1,
            sendMsgType = "JsonMsg",
            groupid = 0,
            content = string.format(
                [[{"app":"com.tencent.structmsg","config":{"autosize":true,"ctime":1587018511,"forward":true,"token":"4e1ddb75bc9b780b4eda43d937a9b721","type":"normal"},"desc":"音乐","meta":{"music":{"action":"","android_pkg_name":"","app_type":1,"appid":100497308,"desc":"ClariS","jumpUrl":"https://i.y.qq.com/v8/playsong.html?_wv=1&songmid=0031Jhwu0ryf6Q&souce=qqaio&ADTAG=aiodiange","musicUrl":"http://dl.stream.qqmusic.qq.com/C400001Oi0Ac0eqdzB.m4a?guid=2447849181&vkey=02ACD32D3CB84BFF6A94FB0F946F85B845C687B981D0612D7EE4582EBF6058356581FECF52A3EB85B3AA504DCA370BBBB3440419F13A2383&uin=0&fromtag=38","preview":"https://y.gtimg.cn/music/photo_new/T001R150x150M00000480ZOx2bAOwm.jpg?max_age=2592000","sourceMsgId":"0","source_icon":"","source_url":"","tag":"QQ音乐","title":"ひらひら ひらら (花瓣翩翩)"}},"prompt":"[分享]ひらひら ひらら (花瓣翩翩)","ver":"0.0.0.1","view":"music"}]]),
            atUser = 0
        })
        log.notice("From Lua SendMsg Ret-->%d", luaRes.Ret)
    end

    if string.find(data.Content, "听歌") == 1 then -- 判断一下所接收的消息里是否含有复读机字样 有则进行处理
        keyWord = data.Content:gsub("听歌", "") -- 提取关键词 保存到keyWord里
        log.notice("keyWord-->%s", keyWord)
        if keyWord == "" then return 1 end
        response, error_message = http.request("GET",
                                               "https://c.y.qq.com/soso/fcgi-bin/client_search_cp",
                                               {
            query = "ct=24&qqmusic_ver=1298&new_json=1&remoteplace=txt.yqq.song&searchid=&t=0&aggr=1&cr=1&catZhida=1&lossless=0&flag_qc=0&p=1&n=20&w=" ..
                keyWord,
            headers = {Accept = "*/*"}
        })
        local html = response.body
        local str = html:match("callback%((.+)%)")
        local j = json.decode(str)
        local song_url = ""
        local songname = ""
        local pic_url = ""
        local singer = ""
        if j.data and j.data.song and j.data.song.list and j.data.song.list[1] then
            song_url = j.data.song.list[1].mid
            songname = j.data.song.list[1].name
            pic_url = j.data.song.list[1].album.pmid
            singer = j.data.song.list[1].singer[1].name
        end
        song_url = "https://y.qq.com/n/yqq/song/" .. song_url .. ".html"
        pic_url = "http://y.gtimg.cn/music/photo_new/T002R300x300M000" ..
                      pic_url .. ".jpg?max_age=2592000"
        log.notice("song_url-->%s", song_url)
        log.notice("songname-->%s", songname)
        log.notice("pic_url-->%s", pic_url)
        log.notice("singer-->%s", singer)
        if song_url ~= "" then
            luaPic = Api.Api_SendMsg( -- 调用发消息的接口
            CurrentQQ, {
                toUser = data.FromUin,
                sendToType = 1,
                sendMsgType = "JsonMsg",
                groupid = 0,
                content = string.format(
                    [[{"app":"com.tencent.structmsg","config":{"autosize":true,"ctime":1587018511,"forward":true,"token":"4e1ddb75bc9b780b4eda43d937a9b721","type":"normal"},"desc":"音乐","meta":{"music":{"action":"","android_pkg_name":"","app_type":1,"appid":100497308,"desc":"%s","jumpUrl":"%s","musicUrl":"%s","preview":"%s","sourceMsgId":"0","source_icon":"","source_url":"","tag":"QQ音乐","title":"%s"}},"prompt":"[分享]%s","ver":"0.0.0.1","view":"music"}]],
                    singer, song_url, song_url, pic_url, songname, songname),
                atUser = 0
            })
        end
    end
    if string.find(data.Content, "xml") == 1 then -- 判断一下所接收的消息里是否含有复读机字样 有则进行处理
        log.notice("From Lua data.Content Ret-->%s", data.Content)
        local InviteUid = 1
        local TotalInvites = 1
        luaRes = Api.Api_SendMsg(CurrentQQ, {
            toUser = data.FromUin,
            sendToType = 1,
            sendMsgType = "XmlMsg",
            content = string.format(
                [[<?xmlversion='1.0'encoding='UTF-8'standalone='yes'?><msgtemplateID="123"url="http://url.cn/5CUkrtp"serviceID="1"action=""actionData=""a_actionData=""i_actionData=""brief="[分享]全球变冷"flag="0"><itemlayout="2"><picturecover="http://y.gtimg.cn/music/photo_new/T002R300x300M000004RbL3b0BDIe2.jpg"/><title>全球变冷</title><summary>许嵩</summary></item><sourceurl=""icon=""name="QQ音乐"appid="100497308"action=""actionData=""a_actionData="tencent100497308://"i_actionData=""/></msg>]]),
            atUser = 0,
            groupid = 0
        })
        log.notice("From Lua SendMsg Ret-->%d", luaRes.Ret)
    end
    return 1
end
function ReceiveGroupMsg(CurrentQQ, data)
    if string.find(data.Content, "红包") == 1 then -- 判断一下所接收的消息里是否含有复读机字样 有则进行处理
        luaRes = Api.Api_SendMsg(CurrentQQ, {
            toUser = data.FromGroupId,
            sendToType = 2,
            sendMsgType = "JsonMsg",
            groupid = 0,
            content = string.format(
                [[{"app":"com.tencent.cmshow","desc":"","view":"game_redpacket","ver":"1.0.3.5","prompt":"","appID":"","sourceName":"","actionData":"","actionData_A":"","sourceUrl":"","meta":{"redPacket":{"msg":"[QQ红包]恭喜发财","posterUrl":"\/xydata\/cmshow\/gameRedPacket\/2749\/bde0aed576c524d0544a079df0d36a30.png","destUrl":"baidu.com"}},"config":{"forward":1},"text":"","extraApps":[],"sourceAd":""}]]),
            atUser = 0
        })
        log.notice("From Lua SendMsg Ret-->%d", luaRes.Ret)
    end
    if string.find(data.Content, "wwww") == 1 then
        local content = string.format(
                            "<?xmlversion='1.0'encoding='UTF-8'standalone='yes'?><msgserviceID=\"83\"templateID=\"12345\"action=\"web\"brief=\"OPQ器人\"sourceMsgId=\"0\"url=\"https://post.mp.qq.com/group/article/33303433373836353238-35707230.html\"flag=\"0\"adverSign=\"0\"multiMsgFlag=\"0\"><itemlayout=\"2\"advertiser_id=\"0\"aid=\"0\"><picturecover=\"http://gchat.qpic.cn/gchatpic_new/0/0-0-9581D3315877C5E757C8FEC6C04D701F/0\"w=\"0\"h=\"0\"/><title>开机成功</title><summary>发送\"菜单\"使用</summary></item><sourcename=\"OPQ科技\"icon=\"https://ctc.qzs.qq.com/ac/qzone_v5/client/auth_icon.png\"action=\"web\"appid=\"0\"/></msg>")
        content = string.gsub(content, "&", "&amp;")
		log.notice("content-->%s", content)
        luaRes = Api.Api_SendMsg(CurrentQQ, {
			toUser = data.FromGroupId,
			sendToType = 2,
			sendMsgType = "XmlMsg",
			groupid = 0,
			content = content,
			atUser = 0
        })
        log.notice("From Lua SendMsg Ret-->%d", luaRes.Ret)
    end
    return 1
end
function ReceiveEvents(CurrentQQ, data, extData) return 1 end
