local log = require("log")
local Api = require("coreApi")
local json = require("json")
local http = require("http")

function ReceiveFriendMsg(CurrentQQ, data) return 1 end
function ReceiveGroupMsg(CurrentQQ, data)
    if string.find(data.MsgType, "PicMsg") then
        str = json.decode(data.Content)
        log.notice("str.Content--->  %s", str.Content)
        if str.Content == nil then return 1 end
        if string.find(str.Content, "搜图") then
            --	loadingG(CurrentQQ,data)
            img_url = str.GroupPic[1].Url
            log.notice("MsgType--->   %s", data.MsgType)
            log.notice("img_url--->   %s", img_url)
            response, error_message = http.request("GET",
                                                   "https://saucenao.com/search.php",
                                                   {
                query = "api_key=自己去申请key&db=999&output_type=2&testmode=1&numres=16&url=" ..
                    img_url,
                headers = {
                    ["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.163 Safari/537.36"
                }
            })
            local html = response.body
            --	log.notice("html-->%s",html)
            local re = json.decode(html)
            local num = 1
            if re.results[num].data.ext_urls == nil then num = 2 end
            -- table2string(re.results[1].data.ext_urls[1])
            log.notice("re---> %s", re.results)
            local similarity = re.results[num].header.similarity
            if tonumber(similarity) < 20 then
                faildSearch(CurrentQQ, data)
                return 1
            end
            local thumbnail_url = re.results[num].header.thumbnail
            local title = re.results[num].data.title
            local pixiv_id = re.results[num].data.pixiv_id
            local member_name = re.results[num].data.member_name
            local ext_urls = re.results[num].data.ext_urls[1]

            if tonumber(similarity) >= 30 then
                log.notice("re---> %s", thumbnail_url)
                loadingG(CurrentQQ, data)
                luaRes = Api.Api_SendMsg( -- 调用发消息的接口
                CurrentQQ, {
                    toUser = data.FromGroupId, -- 回复当前消息的来源群ID
                    sendToType = 2, -- 2发送给群1发送给好友3私聊
                    sendMsgType = "PicMsg", -- 进行文本复读回复
                    content = string.format(
                        "\n相似度：%s\n标题：%s\nPixiv_ID：%d\n插画家昵称：%s\n插画链接：%s",
                        similarity, title, pixiv_id, member_name, ext_urls),
                    picUrl = thumbnail_url,
                    picBase64Buf = "",
                    fileMd5 = ""
                })
            end
            -- log.notice("From Lua SendMsg Ret-->%d", luaRes.Ret)
        end
    end
    return 1
end
function ReceiveEvents(CurrentQQ, data, extData) return 1 end
function loadingG(CurrentQQ, data)
    luaMsg = Api.Api_SendMsg( -- 调用发消息的接口
    CurrentQQ, {
        toUser = data.FromGroupId, -- 回复当前消息的来源群ID
        sendToType = 2, -- 2发送给群1发送给好友3私聊
        sendMsgType = "TextMsg", -- 进行文本复读回复
        groupid = 0, -- 不是私聊自然就为0咯
        content = "正在发送ing[表情178][表情67]", -- 回复内容
        atUser = 0 -- 是否 填上data.FromUserId就可以复读给他并@了
    })
end
function faildSearch(CurrentQQ, data)
    luaMsg = Api.Api_SendMsg( -- 调用发消息的接口
    CurrentQQ, {
        toUser = data.FromGroupId, -- 回复当前消息的来源群ID
        sendToType = 2, -- 2发送给群1发送给好友3私聊
        sendMsgType = "TextMsg", -- 进行文本复读回复
        groupid = 0, -- 不是私聊自然就为0咯
        content = "搜索结果相似度低于80", -- 回复内容
        atUser = 0 -- 是否 填上data.FromUserId就可以复读给他并@了
    })
end

function serialize(obj)
    local lua = ""
    local t = type(obj)
    if t == "number" then
        lua = lua .. obj
    elseif t == "boolean" then
        lua = lua .. tostring(obj)
    elseif t == "string" then
        lua = lua .. string.format("%q", obj)
    elseif t == "table" then
        lua = lua .. "{"
        for k, v in pairs(obj) do
            lua = lua .. "[" .. serialize(k) .. "]=" .. serialize(v) .. ","
        end
        local metatable = getmetatable(obj)
        if metatable ~= nil and type(metatable.__index) == "table" then
            for k, v in pairs(metatable.__index) do
                lua = lua .. "[" .. serialize(k) .. "]=" .. serialize(v) .. ","
            end
        end
        lua = lua .. "}"
    elseif t == "nil" then
        return nil
    else
        error("can not serialize a " .. t .. " type.")
    end
    return lua
end

function table2string(tablevalue)
    local stringtable = serialize(tablevalue)
    print(stringtable)
    return stringtable
end
