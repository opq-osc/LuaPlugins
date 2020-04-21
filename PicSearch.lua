local log = require("log")
local Api = require("coreApi")
local json = require("json")
local http = require("http")

function ReceiveFriendMsg(CurrentQQ, data)
		str = json.decode(data.Content)
		if string.find(str.Content, "搜图") and string.find(data.MsgType, "PicMsg") then 
  --       keyWord = data.Content:gsub("搜图", "") --提取关键词 保存到keyWord里
				 -- keyWord = data.Content.sub(data.Content,10,data.Content.len(data.Content))
				-- str = json.decode(data.Content)
				img_url = str.url
        log.notice("keyWord--->   %s", data.MsgType)
				log.notice("keyWord--->   %s", str.url)
        response, error_message =
               http.request(
               "GET",
        				"https://saucenao.com/search.php?",
               {
                   query = "db=999&output_type=2&testmode=1&numres=1&url=" ..
                       img_url,
                   headers = {
												-- ["Accept"] = "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9",
        				-- 				["Accept-Encoding"] = "gzip, deflate, br",
        				-- 				["Accept-Language"] = "zh-CN,zh;q=0.9,en;q=0.8",
        				-- 				["Cache-Control"] = "max-age=0",
        				-- 				["Connection"] = "keep-alive",
        				-- 				["Host"] = "api.qq.jsososo.com",
        				-- 				["If-None-Match"] = 'W/"4fa-GWBaJze+jTgO5TxSP9IcLAbkhlU"',
        				-- 				["Sec-Fetch-Dest"] = "document",
        				-- 				["Sec-Fetch-Mode"] = "navigate",
        				-- 				["Sec-Fetch-Site"] = "none",
        				-- 				["Sec-Fetch-User"] = "?1",
        				-- 				["Upgrade-Insecure-Requests"] = 1,
        								["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.163 Safari/537.36"
                   }
               }
           )
				local html = response.body
				log.notice("html-->%s",html)
				local re = json.decode(html)
				log.notice("re---> %s", re)
				local similarity = re.results[1].header.similarity
				local thumbnail_url = re.results[1].header.thumbnail
				local title = re.results[1].data.title
				local pixiv_id = re.results[1].data.pixiv_id
				local member_name = re.results[1].data.member_name
				local ext_urls = re.results[1].data.ext_urls[1]
        luaRes =
            Api.Api_SendMsg(--调用发消息的接口
            CurrentQQ,
            {
                toUser = data.FromUin, --回复当前消息的来源群ID
                sendToType = 1, --2发送给群1发送给好友3私聊
                sendMsgType = "PicMsg", --进行文本复读回复
								content = string.format(
									"相似度：%s\n标题：%s\nPixiv_ID：%d\n插画家昵称：%s\n插画链接：%s",
									similarity,
									title,
									pixiv_id,
									member_name,
									ext_urls
								),
								picUrl = thumbnail_url,
								picBase64Buf = "",
								fileMd5 = ""
                -- groupid = 0, --不是私聊自然就为0咯
                -- atUser = 0 --是否 填上data.FromUserId就可以复读给他并@了
            }
        )
        -- log.notice("From Lua SendMsg Ret-->%d", luaRes.Ret)
    end
    return 1
end
function ReceiveGroupMsg(CurrentQQ, data)
  		if string.find(data.MsgType, "PicMsg") then 
				str = json.decode(data.Content)
				if string.find(str.Content, "搜图") then
    --       keyWord = data.Content:gsub("搜图", "") --提取关键词 保存到keyWord里
  				 -- keyWord = data.Content.sub(data.Content,10,data.Content.len(data.Content))
  				-- str = json.decode(data.Content)
					loading(CurrentQQ,data)
  				img_url = str.url
          log.notice("keyWord--->   %s", data.MsgType)
  				log.notice("keyWord--->   %s", str.url)
          response, error_message =
                 http.request(
                 "GET",
          				"https://saucenao.com/search.php?",
                 {
                     query = "db=999&output_type=2&testmode=1&numres=1&url=" ..
                         img_url,
                     headers = {
          								["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.163 Safari/537.36"
                     }
                 }
             )
  				local html = response.body
  				log.notice("html-->%s",html)
  				local re = json.decode(html)
  				log.notice("re---> %s", re)
  				local similarity = re.results[1].header.similarity
  				local thumbnail_url = re.results[1].header.thumbnail
  				local title = re.results[1].data.title
  				local pixiv_id = re.results[1].data.pixiv_id
  				local member_name = re.results[1].data.member_name
  				local ext_urls = re.results[1].data.ext_urls[1]
          luaRes =
              Api.Api_SendMsg(--调用发消息的接口
              CurrentQQ,
              {
                  toUser = data.FromGroupId, --回复当前消息的来源群ID
                  sendToType = 2, --2发送给群1发送给好友3私聊
                  sendMsgType = "PicMsg", --进行文本复读回复
  								content = string.format(
  									"\n相似度：%s\n标题：%s\nPixiv_ID：%d\n插画家昵称：%s\n插画链接：%s",
  									similarity,
  									title,
  									pixiv_id,
  									member_name,
  									ext_urls
  								),
  								picUrl = thumbnail_url,
  								picBase64Buf = "",
  								fileMd5 = ""
                  -- groupid = 0, --不是私聊自然就为0咯
                  -- atUser = 0 --是否 填上data.FromUserId就可以复读给他并@了
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

function loading(CurrentQQ,data)
		Api.Api_SendMsg(--调用发消息的接口
		    CurrentQQ,
		    {
		        toUser = data.FromGroupId, --回复当前消息的来源群ID
		        sendToType = 2, --2发送给群1发送给好友3私聊
		        sendMsgType = "TextMsg", --进行文本复读回复
		        groupid = 0, --不是私聊自然就为0咯
		        content = "正在查询ing[表情178][表情67]", --回复内容
		        atUser = 0 --是否 填上data.FromUserId就可以复读给他并@了
		    }
		)
end