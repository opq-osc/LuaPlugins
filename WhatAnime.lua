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
  				img_url = str.GroupPic[1].Url
          log.notice("MsgType--->   %s", data.MsgType)
  				log.notice("img_url--->   %s", img_url)
          response, error_message =
                 http.request(
                 "GET",
          				"https://trace.moe/api/search",
                 {
                     query = "url=" ..
                         img_url,
                     headers = {
          								["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.163 Safari/537.36"
                     }
                 }
             )
  				local html = response.body
  				local re = json.decode(html)
					-- 中文番名
  				local title_chinese = re.docs[1].title_chinese
					-- 相似度
  				local similarity = re.docs[1].similarity
					-- 集数
  				local episode = re.docs[1].episode
					-- 位置 秒
  				local position = re.docs[1].at
					position = math.floor((math.floor(position))/60)
					-- 动漫ID
					local anilistID =re.docs[1].anilist_id
					-- 剩余次数
					local limit = re.limit
					-- 获取番的详细信息
					response2, error_message2 =
					       http.request(
					       "GET",
									"https://trace.moe/info",
					       {
					           query = "anilist_id=" ..
					               anilistID,
					           headers = {
													["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.163 Safari/537.36"
					           }
					       }
					   )
					local html2 = response2.body
					local info = json.decode(html2)
					-- 封面
					local coverImageUrl = info[1].coverImage.large
					-- 观看地址
					local siteUrl = info[1].siteUrl
          luaRes =
              Api.Api_SendMsg(--调用发消息的接口
              CurrentQQ,
              {
                  toUser = data.FromGroupId, --回复当前消息的来源群ID
                  sendToType = 2, --2发送给群1发送给好友3私聊
                  sendMsgType = "PicMsg", --进行文本复读回复
  								content = string.format(
  									"\n相似度：%s\n番名：%s\n集数：%d\n出现位置：大约%d分左右\n详细地址：%s\n剩余次数：%s",
  									similarity,
  									title_chinese,
  									episode,
  									position,
  									siteUrl,
										limit
  								),
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

	