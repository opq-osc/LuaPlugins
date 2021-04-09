local log = require("log")
local Api = require("coreApi")
local json = require("json")
local http = require("http")

function ReceiveFriendMsg(CurrentQQ, data)
    return 1
end
function ReceiveGroupMsg(CurrentQQ, data)
  		if string.find(data.MsgType, "PicMsg") then 
				str = json.decode(data.Content)
				if str.Content == nil then
					return 1
				end
				if string.find(str.Content, "搜番") then
				log.notice("----> %s",str.GroupPic)
  				img_url = str.GroupPic[1].Url
          log.notice("MsgType--->   %s", data.MsgType)
  				log.notice("img_url--->   %s", img_url)
          response, error_message =
			http.request(
                 "GET",
          				"https://api.trace.moe/search",
                 {
                     query = "info=advanced&cutBorders=1&url=" ..
                         img_url,
                     headers = {
          					["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.163 Safari/537.36"
                     }
                 }
             )
  				local html = response.body
  				local re = json.decode(html)
				-- log.notice("re is --> %s",html)
					-- 中文番名
  				local title_chinese = re.result[1].anilist.synonyms_chinese[1]
				local title = re.result[1].anilist.title.native
					-- 相似度
  				local similarity = re.result[1].similarity
					-- 集数
  				local episode = re.result[1].episode
					-- 位置 秒
  				local position = re.result[1].from
				position = math.floor((math.floor(position))/60)
				-- 封面
				-- local bannerImage = re.result[1].anilist.bannerImage
				local coverImageUrl = re.result[1].anilist.coverImage.large
				-- 观看地址
				local siteUrl = re.result[1].anilist.siteUrl
				-- 官网
				local officalSite = re.result[1].anilist.externalLinks[1].url
          luaRes =
              Api.Api_SendMsg(--调用发消息的接口
              CurrentQQ,
              {
                  toUser = data.FromGroupId, --回复当前消息的来源群ID
                  sendToType = 2, --2发送给群1发送给好友3私聊
                  sendMsgType = "PicMsg", --进行文本复读回复
  								content = string.format(
  									"\n相似度：%s\n番名：%s\n原名：%s\n集数：%d\n出现位置：大约%d分左右\n详细信息:%s\n官网：%s",
  									similarity,
  									title_chinese,
									title,
  									episode,
  									position,
  									siteUrl,
									officalSite
  								),
								-- picUrl = bannerImage,
  								picUrl = coverImageUrl,
  								picBase64Buf = "",
  								fileMd5 = ""
              }
          )
          -- log.notice("From Lua SendMsg Ret-->%d", luaRes.Ret)
      end
		end
      return 1
  end
function ReceiveEvents(CurrentQQ, data, extData)
    return 1
end

	
