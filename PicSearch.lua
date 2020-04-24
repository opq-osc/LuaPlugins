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
				log.notice("str.Content--->  %s", str.Content)
				if str.Content == nil then
					return 1
				end
				if string.find(str.Content, "搜图") then
					loadingG(CurrentQQ,data)
  				img_url = str.GroupPic[1].Url
          log.notice("MsgType--->   %s", data.MsgType)
  				log.notice("img_url--->   %s", img_url)
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
  				-- log.notice("html-->%s",html)
  				local re = json.decode(html)
  				-- log.notice("re---> %s", re)
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
function loadingG(CurrentQQ,data)
		luaMsg =
		    Api.Api_SendMsg(--调用发消息的接口
		    CurrentQQ,
		    {
		        toUser = data.FromGroupId, --回复当前消息的来源群ID
		        sendToType = 2, --2发送给群1发送给好友3私聊
		        sendMsgType = "TextMsg", --进行文本复读回复
		        groupid = 0, --不是私聊自然就为0咯
		        content = "正在发送ing[表情178][表情67]", --回复内容
		        atUser = 0 --是否 填上data.FromUserId就可以复读给他并@了
		    }
		)
	end
function loadingF(CurrentQQ,data)
		luaMsg =
		    Api.Api_SendMsg(--调用发消息的接口
		    CurrentQQ,
		    {
		        toUser = data.FromUin, --回复当前消息的来源群ID
		        sendToType = 1, --2发送给群1发送给好友3私聊
		        sendMsgType = "TextMsg", --进行文本复读回复
		        groupid = 0, --不是私聊自然就为0咯
		        content = "正在查询ing[表情178][表情67]", --回复内容
		        atUser = 0 --是否 填上data.FromUserId就可以复读给他并@了
		    }
		)
	end