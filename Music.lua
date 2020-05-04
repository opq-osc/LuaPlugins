local log = require("log")
local Api = require("coreApi")
local json = require("json")
local http = require("http")

function ReceiveFriendMsg(CurrentQQ, data)
		if string.find(data.Content, "点歌") == 1 then --判断一下所接收的消息里是否含有复读机字样 有则进行处理
        keyWord = data.Content:gsub("点歌", "") --提取关键词 保存到keyWord里
				keyWord = keyWord:gsub(" ", "") --去除空格
				log.notice("keyWord-->%s",keyWord)
		if keyWord == "" then
							return 1
					end
    response, error_message =
        http.request(
        "GET",
        "https://c.y.qq.com/soso/fcgi-bin/client_search_cp",
        {
            query = "ct=24&qqmusic_ver=1298&new_json=1&remoteplace=txt.yqq.song&searchid=&t=0&aggr=1&cr=1&catZhida=1&lossless=0&flag_qc=0&p=1&n=20&w=" ..
                keyWord,
            headers = {
                Accept = "*/*"
            }
        }
    )
    local html = response.body
    local str = html:match("callback%((.+)%)")
		-- log.notice("str-->%s",str)
    local j = json.decode(str)
   local songID = ""
   local songname = ""
   local pic_url = ""
   local singer = ""
   if j.data and j.data.song and j.data.song.list and j.data.song.list[1] then
   		songID = j.data.song.list[1].mid
   		songname = j.data.song.list[1].name
   		pic_url = j.data.song.list[1].album.pmid
   		singer = j.data.song.list[1].singer[1].name
   end
	 local jumpUrl = "https://y.qq.com/n/yqq/song/"..songID..".html"
	 pic_url = "http://y.gtimg.cn/music/photo_new/T002R300x300M000"..pic_url..".jpg?max_age=2592000"
		if songID ~= "" then
			response, error_message =
			       http.request(
			       "GET",
							"https://api.qq.jsososo.com/song/url",
			       {
			           query = "type=320&id=" ..
			               songID,
			           headers = {
			               ["Accept"] = "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9",
											["Accept-Encoding"] = "gzip, deflate, br",
											["Accept-Language"] = "zh-CN,zh;q=0.9,en;q=0.8",
											["Cache-Control"] = "max-age=0",
											["Connection"] = "keep-alive",
											["Host"] = "api.qq.jsososo.com",
											["If-None-Match"] = 'W/"4fa-GWBaJze+jTgO5TxSP9IcLAbkhlU"',
											["Sec-Fetch-Dest"] = "document",
											["Sec-Fetch-Mode"] = "navigate",
											["Sec-Fetch-Site"] = "none",
											["Sec-Fetch-User"] = "?1",
											["Upgrade-Insecure-Requests"] = 1,
											["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.163 Safari/537.36"
			           }
			       }
			   )	
				 local Json2 = response.body
				 log.notice("Json2-->%s",Json2)
				 local song = json.decode(Json2)
				 local song_url = song.data
				 log.notice("song_url-->%s",song_url)
					log.notice("content>%s",content)				
				luaPic =
				    Api.Api_SendMsg(--调用发消息的接口
				    CurrentQQ,
							{
									toUser = data.FromUin,
									sendToType = 1,
									sendMsgType = "JsonMsg",
									groupid = 0,
									content = string.format(
											[[{"app":"com.tencent.structmsg","config":{"autosize":true,"ctime":1587018511,"forward":true,"token":"4e1ddb75bc9b780b4eda43d937a9b721","type":"normal"},"desc":"音乐","meta":{"music":{"action":"","android_pkg_name":"","app_type":1,"appid":100497308,"desc":"%s","jumpUrl":"%s","musicUrl":"%s","preview":"%s","sourceMsgId":"0","source_icon":"","source_url":"","tag":"QQ音乐","title":"%s"}},"prompt":"[分享]%s","ver":"0.0.0.1","view":"music"}]],
											singer,
											jumpUrl,
											song_url,
											pic_url,
											songname,
											songname
									),
									atUser = 0
							}
				)
			end
    end
    return 1
end
function ReceiveGroupMsg(CurrentQQ, data)
		if string.find(data.Content, "听歌") == 1 then --判断一下所接收的消息里是否含有复读机字样 有则进行处理
        keyWord = data.Content:gsub("听歌", "") --提取关键词 保存到keyWord里
				keyWord = keyWord:gsub(" ", "") --去除空格
				log.notice("keyWord-->%s",keyWord)
		if keyWord == "" then
							return 1
					end
    response, error_message =
        http.request(
        "GET",
        "https://c.y.qq.com/soso/fcgi-bin/client_search_cp",
        {
            query = "ct=24&qqmusic_ver=1298&new_json=1&remoteplace=txt.yqq.song&searchid=&t=0&aggr=1&cr=1&catZhida=1&lossless=0&flag_qc=0&p=1&n=20&w=" ..
                keyWord,
            headers = {
                Accept = "*/*"
            }
        }
    )
    local html = response.body
    local str = html:match("callback%((.+)%)")
		-- log.notice("str-->%s",str)
    local j = json.decode(str)
    local songID = ""
    local songname = ""
    local pic_url = ""
    local singer = ""
    if j.data and j.data.song and j.data.song.list and j.data.song.list[1] then
    		songID = j.data.song.list[1].mid
    		songname = j.data.song.list[1].name
    		pic_url = j.data.song.list[1].album.pmid
    		singer = j.data.song.list[1].singer[1].name
    end
    local jumpUrl = "https://y.qq.com/n/yqq/song/"..songID..".html"
    pic_url = "http://y.gtimg.cn/music/photo_new/T002R300x300M000"..pic_url..".jpg?max_age=2592000"
		if songID ~= "" then
			response, error_message =
			       http.request(
			       "GET",
							"https://api.qq.jsososo.com/song/url",
			       {
			           query = "type=320&id=" ..
			               songID,
			           headers = {
			               ["Accept"] = "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9",
											["Accept-Encoding"] = "gzip, deflate, br",
											["Accept-Language"] = "zh-CN,zh;q=0.9,en;q=0.8",
											["Cache-Control"] = "max-age=0",
											["Connection"] = "keep-alive",
											["Host"] = "api.qq.jsososo.com",
											["If-None-Match"] = 'W/"4fa-GWBaJze+jTgO5TxSP9IcLAbkhlU"',
											["Sec-Fetch-Dest"] = "document",
											["Sec-Fetch-Mode"] = "navigate",
											["Sec-Fetch-Site"] = "none",
											["Sec-Fetch-User"] = "?1",
											["Upgrade-Insecure-Requests"] = 1,
											["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.163 Safari/537.36"
			           }
			       }
			   )	
				 local Json2 = response.body
				 log.notice("Json2-->%s",Json2)
				 local song = json.decode(Json2)
				 local song_url = song.data
				 log.notice("song_url-->%s",song_url)
				luaPic =
				    Api.Api_SendMsg(--调用发消息的接口
				    CurrentQQ,
							{
									toUser = data.FromGroupId,
									sendToType = 2,
									sendMsgType = "JsonMsg",
									groupid = 0,
									content = string.format(
											[[{"app":"com.tencent.structmsg","config":{"autosize":true,"ctime":1587018511,"forward":true,"token":"4e1ddb75bc9b780b4eda43d937a9b721","type":"normal"},"desc":"音乐","meta":{"music":{"action":"","android_pkg_name":"","app_type":1,"appid":100497308,"desc":"%s","jumpUrl":"%s","musicUrl":"%s","preview":"%s","sourceMsgId":"0","source_icon":"","source_url":"","tag":"点击图片后台播放","title":"%s"}},"prompt":"[分享]%s","ver":"0.0.0.1","view":"music"}]],
											singer,
											song_url,
											song_url,
											pic_url,
											songname,
											songname
									),
									atUser = 0
							}
				)
			end
    end
		
		
			if string.find(data.Content, "点歌") == 1 then --判断一下所接收的消息里是否含有复读机字样 有则进行处理
		        keyWord = data.Content:gsub("点歌", "") --提取关键词 保存到keyWord里
						keyWord = keyWord:gsub(" ", "") --去除空格
						log.notice("keyWord-->%s",keyWord)
				if keyWord == "" then
									return 1
							end
		    response, error_message =
		        http.request(
		        "GET",
		        "https://c.y.qq.com/soso/fcgi-bin/client_search_cp",
		        {
		            query = "ct=24&qqmusic_ver=1298&new_json=1&remoteplace=txt.yqq.song&searchid=&t=0&aggr=1&cr=1&catZhida=1&lossless=0&flag_qc=0&p=1&n=20&w=" ..
		                keyWord,
		            headers = {
		                Accept = "*/*"
		            }
		        }
		    )
		    local html = response.body
		    local str = html:match("callback%((.+)%)")
				-- log.notice("str-->%s",str)
		    local j = json.decode(str)
		   local songID = ""
		   local songname = ""
		   local pic_url = ""
		   local singer = ""
		   if j.data and j.data.song and j.data.song.list and j.data.song.list[1] then
		   		songID = j.data.song.list[1].mid
		   		songname = j.data.song.list[1].name
		   		pic_url = j.data.song.list[1].album.pmid
		   		singer = j.data.song.list[1].singer[1].name
		   end
			 local jumpUrl = "https://y.qq.com/n/yqq/song/"..songID..".html"
			 pic_url = "http://y.gtimg.cn/music/photo_new/T002R300x300M000"..pic_url..".jpg?max_age=2592000"
				if songID ~= "" then
					response, error_message =
					       http.request(
					       "GET",
									"https://api.qq.jsososo.com/song/url",
					       {
					           query = "type=320&id=" ..
					               songID,
					           headers = {
					               ["Accept"] = "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9",
													["Accept-Encoding"] = "gzip, deflate, br",
													["Accept-Language"] = "zh-CN,zh;q=0.9,en;q=0.8",
													["Cache-Control"] = "max-age=0",
													["Connection"] = "keep-alive",
													["Host"] = "api.qq.jsososo.com",
													["If-None-Match"] = 'W/"4fa-GWBaJze+jTgO5TxSP9IcLAbkhlU"',
													["Sec-Fetch-Dest"] = "document",
													["Sec-Fetch-Mode"] = "navigate",
													["Sec-Fetch-Site"] = "none",
													["Sec-Fetch-User"] = "?1",
													["Upgrade-Insecure-Requests"] = 1,
													["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.163 Safari/537.36"
					           }
					       }
					   )	
						 local Json2 = response.body
						 log.notice("Json2-->%s",Json2)
						 local song = json.decode(Json2)
						 local song_url = song.data
						 log.notice("songname>%s",songname)
						 log.notice("jumpUrl>%s",jumpUrl)
						 log.notice("pic_url>%s",pic_url)
						 log.notice("song_url>%s",song_url)
						 log.notice("singer>%s",singer)
		
						 local content = string.format("<?xml version='1.0' encoding='UTF-8' standalone='yes' ?><msg serviceID=\"2\" templateID=\"1\" action=\"web\" brief=\"[分享] %s\" sourceMsgId=\"0\" url=\"%s\" flag=\"0\" adverSign=\"0\" multiMsgFlag=\"0\"><item layout=\"2\"><audio cover=\"%s\" src=\"%s\" /><title>%s</title><summary>%s</summary></item><source name=\"QQ音乐\" icon=\"https://i.gtimg.cn/open/app_icon/01/07/98/56/1101079856_100_m.png?date=20200503\" url=\"http://web.p.qq.com/qqmpmobile/aio/app.html?id=1101079856\" action=\"app\" a_actionData=\"com.tencent.qqmusic\" i_actionData=\"tencent1101079856://\" appid=\"1101079856\" /></msg>",
													songname,
													jumpUrl,
													pic_url,
													song_url,
													songname,
													singer
											)
						content=string.gsub(content,"&","&amp;")
						log.notice("content->%s",content)
		
						luaPic =
						    Api.Api_SendMsg(--调用发消息的接口
						    CurrentQQ,
									{
											toUser = data.FromGroupId,
											sendToType = 2,
											sendMsgType = "XmlMsg",
											groupid = 0,
											content = content,
											atUser = 0
									}
						)
					end
		    end
    return 1
end
function ReceiveEvents(CurrentQQ, data, extData)
    return 1
end
