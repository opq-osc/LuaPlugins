local log = require("log")
local Api = require("coreApi")
local json = require("json")
local http = require("http")

function ReceiveFriendMsg(CurrentQQ, data) return 1 end
function ReceiveGroupMsg(CurrentQQ, data)
    if string.find(data.MsgType, "PicMsg") then
        str = json.decode(data.Content)
        if str.Content == nil then return 1 end
        if string.find(str.Content, "搜番") then
            img_url = str.GroupPic[1].Url
            log.notice("MsgType--->   %s", data.MsgType)
            log.notice("img_url--->   %s", img_url)
            response, error_message = http.request("GET",
                                                   "https://trace.moe/api/search",
                                                   {
                query = "url=" .. img_url,
                headers = {
                    ["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.163 Safari/537.36"
                }
            })
            local html = response.body
            local re = json.decode(html)
			-- 原名
			local title = re.docs[1].title
            -- 中文番名
            local title_chinese = re.docs[1].synonyms_chinese[1]
			log.notice("title_chinese--->   %s", title_chinese)
            -- 相似度
            local similarity = re.docs[1].similarity
			log.notice("similarity--->   %s", similarity)
            -- 集数
            local episode = re.docs[1].episode
			log.notice("episode--->   %d", episode)
            -- 位置 秒
            local position = re.docs[1].at
            position = math.floor((math.floor(position)) / 60)
			log.notice("position--->   %d", position)
            -- 动漫ID
            local anilistID = re.docs[1].anilist_id
            -- 剩余次数
            -- local limit = re.limit
            -- 获取番的详细信息
			local dataJson = "{\"query\":\"query ($ids: [Int]) {\\n          Page(page: 1, perPage: 50) {\\n            media(id_in: $ids, type: ANIME) {\\n              id\\n              title {\\n                native\\n                romaji\\n                english\\n              }\\n              type\\n              format\\n              status\\n              startDate {\\n                year\\n                month\\n                day\\n              }\\n              endDate {\\n                year\\n                month\\n                day\\n              }\\n              season\\n              episodes\\n              duration\\n              source\\n              coverImage {\\n                large\\n                medium\\n              }\\n              bannerImage\\n              genres\\n              synonyms\\n              studios {\\n                edges {\\n                  isMain\\n                  node {\\n                    id\\n                    name\\n                    siteUrl\\n                  }\\n                }\\n              }\\n              isAdult\\n              externalLinks {\\n                id\\n                url\\n                site\\n              }\\n              siteUrl\\n            }\\n          }\\n        }\\n        \",\"variables\":{\"ids\":["..anilistID.."]}}"
			log.notice("dataJson--->   %s", dataJson)
            response2, error_message2 = http.request("post",
                                                     "https://trace.moe/anilist/", {
                body = dataJson,
                headers = {
                    ["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.163 Safari/537.36",
					["Content-Type"] = "application/json"
                }
            })
            local html2 = response2.body
			log.notice("html2--->   %s", html2)
            local info = json.decode(html2)
            -- 封面
            local coverImageUrl = info.data.Page.media[1].coverImage.large
			log.notice("coverImageUrl--->   %s", coverImageUrl)
            -- 观看地址
            local siteUrl = info.data.Page.media[1].siteUrl
			log.notice("siteUrl--->   %s", siteUrl)
			-- 其他地址
			local length = table.getn(info.data.Page.media[1].externalLinks)
			local urls = ""
			for i=1,length,1 do
                urls = urls .. "\n" .. info.data.Page.media[1].externalLinks[i].url
            end
			log.notice("urls--->   %s", urls)
			-- local officalSite = info.data.Page.media[1].externalLinks[1].url
            luaRes = Api.Api_SendMsg( -- 调用发消息的接口
            CurrentQQ, {
                toUser = data.FromGroupId, -- 回复当前消息的来源群ID
                sendToType = 2, -- 2发送给群1发送给好友3私聊
                sendMsgType = "PicMsg", -- 进行文本复读回复
                content = string.format(
                    "\n相似度：%s\n番名：%s\n中文番名：%s\n集数：%d\n出现位置：大约%d分左右\n相关网站：%s\n",
                    similarity, title, title_chinese, episode, position,urls.."\n"..siteUrl),
                picUrl = coverImageUrl,
                picBase64Buf = "",
                fileMd5 = ""
            })
            -- log.notice("From Lua SendMsg Ret-->%d", luaRes.Ret)
        end
    end
    return 1
end
function ReceiveEvents(CurrentQQ, data, extData) return 1 end
