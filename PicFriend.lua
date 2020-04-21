local log = require("log")
local Api = require("coreApi")
local json = require("json")
local http = require("http")
-- local cjson = require "cjson"
								
function ReceiveGroupMsg(CurrentQQ, data)
	
    return 1
end

function ReceiveFriendMsg(CurrentQQ, data)

	if string.find(data.Content, "插画") == 1 then 
		Illustration(CurrentQQ,data)
		end
	if string.find(data.Content, "漫画") == 1 then
		Comic(CurrentQQ,data)
		end
	if string.find(data.Content, "其他") == 1 then 
		Draw(CurrentQQ,data)
		end
	if string.find(data.Content, "首页") == 1 then 
		Index(CurrentQQ,data)
		end
	if string.find(data.Content, "随机") == 1 then
		Random(CurrentQQ,data)
		end
	if string.find(data.Content, "周排行") == 1 then
		RankComic(CurrentQQ,data)
		end
	if string.find(data.Content, "cos") == 1 then 
		Cosplay(CurrentQQ,data)
		end
	if string.find(data.Content, "私服") == 1 then
		Sifu(CurrentQQ,data)
		end
	if string.find(data.Content, "cos周排行") == 1 then
		WeekRankCosplay(CurrentQQ,data)
		end
	if string.find(data.Content, "cos月排行") == 1 then
		MonthRankCosplay(CurrentQQ,data)
		end
	if string.find(data.Content, "私服排行") == 1 then
		MonthRankSifu(CurrentQQ,data)
		end
	-- if string.find(data.Content, "萌图") == 1 then
	-- 	menTu(CurrentQQ,data)
	-- 	end
	-- if string.find(data.Content, "图") == 1 then 
	-- 	menTu2(CurrentQQ,data)
	-- 	end
	keyWord = string.gsub(data.Content, "群图片", "sb")
	if string.match(data.Content, keyWord) == "图" then
		
	menTu(CurrentQQ,data)
	menTu2(CurrentQQ,data)
	end
	if string.find(data.Content, "少前") == 1 then
		girlFront(CurrentQQ,data)
		end
	if string.find(data.Content, "美图") == 1 then
		Pixiv(CurrentQQ,data)
		end
    return 1
end

function ReceiveEvents(CurrentQQ, data, extData)
    return 1
end

function Illustration(CurrentQQ, data) 

			number = math.random(1,24)
			response, error_message =
			    http.request(
			    "GET",
			    "https://api.vc.bilibili.com/link_draw/v2/Doc/list",
			    {
			        query = "category=illustration&type=hot&page_size=20&page_num=" ..
							number
			    --     headers = {
							-- 	User-Agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.132 Safari/537.36"
							-- }
			    }
			)			
			-- local number = tonumber(num)
			local html = response.body
			local strJson = json.decode(html)
			math.randomseed(tonumber(tostring(os.time()):reverse():sub(1, 6)))
			randomINum = math.random(1,20)
			log.notice("the randomINum is %s", randomINum)
			local Plength = table.getn(strJson["data"]["items"][1]["item"]["pictures"])
			log.notice("the pictures_length is %s", Plength)
			math.randomseed(tonumber(tostring(os.time()):reverse():sub(1, 6)))
			randomPNum = math.random(1,Plength)
			log.notice("the randomPNum is %s", randomPNum)
			local img_url = strJson["data"]["items"][randomINum]["item"]["pictures"][randomPNum]["img_src"]
			log.notice("the img_url is %s", img_url)
	
			loading(CurrentQQ,data)
	    luaPic =
	        Api.Api_SendMsg(--调用发消息的接口
	        CurrentQQ,
	         {
								toUser = data.FromUin, --回复当前消息的来源群ID
								sendToType = 1, --2发送给群1发送给好友3私聊
								sendMsgType = "PicMsg",
								content = img_url,
								picUrl = img_url,
								picBase64Buf = "",
								fileMd5 = ""
						}
	    )
	    log.notice("From Lua SendMsg Ret-->%d", luaPic.Ret)
	end
	
function Comic(CurrentQQ, data) 
			number = math.random(1,24)
			response, error_message =
			    http.request(
			    "GET",
			    "https://api.vc.bilibili.com/link_draw/v2/Doc/list",
			    {
			        query = "category=comic&type=hot&page_size=20&page_num=" ..
							number
			    --     headers = {
							-- 	User-Agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.132 Safari/537.36"
							-- }
			    }
			)			
			
			local html = response.body
			local strJson = json.decode(html)
			math.randomseed(tonumber(tostring(os.time()):reverse():sub(1, 6)))
			randomINum = math.random(1,20)
			log.notice("the randomINum is %s", randomINum)
			local Plength = table.getn(strJson["data"]["items"][1]["item"]["pictures"])
			log.notice("the pictures_length is %s", Plength)
			math.randomseed(tonumber(tostring(os.time()):reverse():sub(1, 6)))
			randomPNum = math.random(1,Plength)
			log.notice("the randomPNum is %s", randomPNum)
			local img_url = strJson["data"]["items"][randomINum]["item"]["pictures"][randomPNum]["img_src"]
			log.notice("the img_url is %s", img_url)
	
			loading(CurrentQQ,data)
	    luaPic =
	        Api.Api_SendMsg(--调用发消息的接口
	        CurrentQQ,
	         {
								toUser = data.FromUin, --回复当前消息的来源群ID
								sendToType = 1, --2发送给群1发送给好友3私聊
								sendMsgType = "PicMsg",
								content = img_url,
								picUrl = img_url,
								picBase64Buf = "",
								fileMd5 = ""
						}
	    )
	    log.notice("From Lua SendMsg Ret-->%d", luaPic.Ret)
	end
	
function Draw(CurrentQQ, data) 
			number = math.random(1,24)
			response, error_message =
			    http.request(
			    "GET",
			    "https://api.vc.bilibili.com/link_draw/v2/Doc/list",
			    {
			        query = "category=draw&type=hot&page_size=20&page_num=" ..
							number
			    --     headers = {
							-- 	User-Agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.132 Safari/537.36"
							-- }
			    }
			)			
			local html = response.body
			local strJson = json.decode(html)
			math.randomseed(tonumber(tostring(os.time()):reverse():sub(1, 6)))
			randomINum = math.random(1,20)
			log.notice("the randomINum is %s", randomINum)
			local Plength = table.getn(strJson["data"]["items"][1]["item"]["pictures"])
			log.notice("the pictures_length is %s", Plength)
			math.randomseed(tonumber(tostring(os.time()):reverse():sub(1, 6)))
			randomPNum = math.random(1,Plength)
			log.notice("the randomPNum is %s", randomPNum)
			local img_url = strJson["data"]["items"][randomINum]["item"]["pictures"][randomPNum]["img_src"]
			log.notice("the img_url is %s", img_url)
	
			loading(CurrentQQ,data)
	    luaPic =
	        Api.Api_SendMsg(--调用发消息的接口
	        CurrentQQ,
	         {
								toUser = data.FromUin, --回复当前消息的来源群ID
								sendToType = 1, --2发送给群1发送给好友3私聊
								sendMsgType = "PicMsg",
								content = img_url,
								picUrl = img_url,
								picBase64Buf = "",
								fileMd5 = ""
						}
	    )
	    log.notice("From Lua SendMsg Ret-->%d", luaPic.Ret)
	end

function Index(CurrentQQ, data) 
			number = math.random(1,24)
			response, error_message =
			    http.request(
			    "GET",
			    "https://api.vc.bilibili.com/link_draw/v2/Doc/index",
			    {
			        query = "type=hot&page_size=20&page_num=" ..
							number
			    --     headers = {
							-- 	User-Agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.132 Safari/537.36"
							-- }
			    }
			)			
			local html = response.body
			local strJson = json.decode(html)
			math.randomseed(tonumber(tostring(os.time()):reverse():sub(1, 6)))
			randomINum = math.random(1,20)
			log.notice("the randomINum is %s", randomINum)
			local Plength = table.getn(strJson["data"]["items"][1]["item"]["pictures"])
			log.notice("the pictures_length is %s", Plength)
			math.randomseed(tonumber(tostring(os.time()):reverse():sub(1, 6)))
			randomPNum = math.random(1,Plength)
			log.notice("the randomPNum is %s", randomPNum)
			local img_url = strJson["data"]["items"][randomINum]["item"]["pictures"][randomPNum]["img_src"]
			log.notice("the img_url is %s", img_url)
	
			loading(CurrentQQ,data)
	    luaPic =
	        Api.Api_SendMsg(--调用发消息的接口
	        CurrentQQ,
	         {
								toUser = data.FromUin, --回复当前消息的来源群ID
								sendToType = 1, --2发送给群1发送给好友3私聊
								sendMsgType = "PicMsg",
								content = img_url,
								picUrl = img_url,
								picBase64Buf = "",
								fileMd5 = ""
						}
	    )
	    log.notice("From Lua SendMsg Ret-->%d", luaPic.Ret)
	end

function Random(CurrentQQ, data) 
			number = math.random(1,24)
			response, error_message =
			    http.request(
			    "GET",
			    "https://api.vc.bilibili.com/link_draw/v2/Doc/index",
			    {
			        query = "type=recommend&page_size=20&page_num=" ..
							number
			    --     headers = {
							-- 	User-Agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.132 Safari/537.36"
							-- }
			    }
			)			
			local html = response.body
			local strJson = json.decode(html)
			math.randomseed(tonumber(tostring(os.time()):reverse():sub(1, 6)))
			randomINum = math.random(1,20)
			log.notice("the randomINum is %s", randomINum)
			local Plength = table.getn(strJson["data"]["items"][1]["item"]["pictures"])
			log.notice("the pictures_length is %s", Plength)
			math.randomseed(tonumber(tostring(os.time()):reverse():sub(1, 6)))
			randomPNum = math.random(1,Plength)
			log.notice("the randomPNum is %s", randomPNum)
			local img_url = strJson["data"]["items"][randomINum]["item"]["pictures"][randomPNum]["img_src"]
			log.notice("the img_url is %s", img_url)
	
			loading(CurrentQQ,data)
	    luaPic =
	        Api.Api_SendMsg(--调用发消息的接口
	        CurrentQQ,
	         {
								toUser = data.FromUin, --回复当前消息的来源群ID
								sendToType = 1, --2发送给群1发送给好友3私聊
								sendMsgType = "PicMsg",
								content = img_url,
								picUrl = img_url,
								picBase64Buf = "",
								fileMd5 = ""
						}
	    )
	    log.notice("From Lua SendMsg Ret-->%d", luaPic.Ret)
	end
	-- 动漫周排行
function RankComic(CurrentQQ, data) 
			response, error_message =
			    http.request(
			    "GET",
			    "https://api.vc.bilibili.com/link_draw/v2/Doc/rank",
			    {
			        query = "biz=1&rank_type=week&page_size=20"
			    --     headers = {
							-- 	User-Agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.132 Safari/537.36"
							-- }
			    }
			)			
			local number = tonumber(num)
			local html = response.body
			local strJson = json.decode(html)
			math.randomseed(tonumber(tostring(os.time()):reverse():sub(1, 6)))
			randomINum = math.random(1,20)
			log.notice("the randomINum is %s", randomINum)
			local Plength = table.getn(strJson["data"]["items"][1]["item"]["pictures"])
			log.notice("the pictures_length is %s", Plength)
			math.randomseed(tonumber(tostring(os.time()):reverse():sub(1, 6)))
			randomPNum = math.random(1,Plength)
			log.notice("the randomPNum is %s", randomPNum)
			local img_url = strJson["data"]["items"][randomINum]["item"]["pictures"][randomPNum]["img_src"]
			log.notice("the img_url is %s", img_url)
	
			loading(CurrentQQ,data)
	    luaPic =
	        Api.Api_SendMsg(--调用发消息的接口
	        CurrentQQ,
	         {
								toUser = data.FromUin, --回复当前消息的来源群ID
								sendToType = 1, --2发送给群1发送给好友3私聊
								sendMsgType = "PicMsg",
								content = img_url,
								picUrl = img_url,
								picBase64Buf = "",
								fileMd5 = ""
						}
	    )
	    log.notice("From Lua SendMsg Ret-->%d", luaPic.Ret)
	end
	
function Cosplay(CurrentQQ, data) 
			number = math.random(1,24)
			response, error_message =
			    http.request(
			    "GET",
			    "https://api.vc.bilibili.com/link_draw/v2/Photo/list",
			    {
			        query = "category=cos&type=hot&page_size=20&page_num=" ..
							number
			    --     headers = {
							-- 	User-Agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.132 Safari/537.36"
							-- }
			    }
			)			
			local html = response.body
			local strJson = json.decode(html)
			math.randomseed(tonumber(tostring(os.time()):reverse():sub(1, 6)))
			randomINum = math.random(1,20)
			log.notice("the randomINum is %s", randomINum)
			local Plength = table.getn(strJson["data"]["items"][1]["item"]["pictures"])
			log.notice("the pictures_length is %s", Plength)
			math.randomseed(tonumber(tostring(os.time()):reverse():sub(1, 6)))
			randomPNum = math.random(1,Plength)
			log.notice("the randomPNum is %s", randomPNum)
			local img_url = strJson["data"]["items"][randomINum]["item"]["pictures"][randomPNum]["img_src"]
			log.notice("the img_url is %s", img_url)
	
			loading(CurrentQQ,data)
	    luaPic =
	        Api.Api_SendMsg(--调用发消息的接口
	        CurrentQQ,
	         {
								toUser = data.FromUin, --回复当前消息的来源群ID
								sendToType = 1, --2发送给群1发送给好友3私聊
								sendMsgType = "PicMsg",
								content = img_url,
								picUrl = img_url,
								picBase64Buf = "",
								fileMd5 = ""
						}
	    )
	    log.notice("From Lua SendMsg Ret-->%d", luaPic.Ret)
	end
	
function Sifu(CurrentQQ, data) 
			number = math.random(1,24)
			response, error_message =
			    http.request(
			    "GET",
			    "https://api.vc.bilibili.com/link_draw/v2/Photo/list",
			    {
			        query = "category=sifu&type=hot&page_size=20&page_num=" ..
							number
			    --     headers = {
							-- 	User-Agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.132 Safari/537.36"
							-- }
			    }
			)			
			local html = response.body
			local strJson = json.decode(html)
			math.randomseed(tonumber(tostring(os.time()):reverse():sub(1, 6)))
			randomINum = math.random(1,20)
			log.notice("the randomINum is %s", randomINum)
			local Plength = table.getn(strJson["data"]["items"][1]["item"]["pictures"])
			log.notice("the pictures_length is %s", Plength)
			math.randomseed(tonumber(tostring(os.time()):reverse():sub(1, 6)))
			randomPNum = math.random(1,Plength)
			log.notice("the randomPNum is %s", randomPNum)
			local img_url = strJson["data"]["items"][randomINum]["item"]["pictures"][randomPNum]["img_src"]
			log.notice("the img_url is %s", img_url)
	
			loading(CurrentQQ,data)
	    luaPic =
	        Api.Api_SendMsg(--调用发消息的接口
	        CurrentQQ,
	         {
								toUser = data.FromUin, --回复当前消息的来源群ID
								sendToType = 1, --2发送给群1发送给好友3私聊
								sendMsgType = "PicMsg",
								content = img_url,
								picUrl = img_url,
								picBase64Buf = "",
								fileMd5 = ""
						}
	    )
	    log.notice("From Lua SendMsg Ret-->%d", luaPic.Ret)
	end
	--Cosplay周排行
function WeekRankCosplay(CurrentQQ, data) 
			response, error_message =
			    http.request(
			    "GET",
			    "https://api.vc.bilibili.com/link_draw/v2/Photo/rank",
			    {
			        query = "biz=2&category=cos&rank_type=week&page_size=20" 
			    --     headers = {
							-- 	User-Agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.132 Safari/537.36"
							-- }
			    }
			)			
			local html = response.body
			local strJson = json.decode(html)
			math.randomseed(tonumber(tostring(os.time()):reverse():sub(1, 6)))
			randomINum = math.random(1,20)
			log.notice("the randomINum is %s", randomINum)
			local Plength = table.getn(strJson["data"]["items"][1]["item"]["pictures"])
			log.notice("the pictures_length is %s", Plength)
			math.randomseed(tonumber(tostring(os.time()):reverse():sub(1, 6)))
			randomPNum = math.random(1,Plength)
			log.notice("the randomPNum is %s", randomPNum)
			local img_url = strJson["data"]["items"][randomINum]["item"]["pictures"][randomPNum]["img_src"]
			log.notice("the img_url is %s", img_url)
	
			loading(CurrentQQ,data)
	    luaPic =
	        Api.Api_SendMsg(--调用发消息的接口
	        CurrentQQ,
	         {
								toUser = data.FromUin, --回复当前消息的来源群ID
								sendToType = 1, --2发送给群1发送给好友3私聊
								sendMsgType = "PicMsg",
								content = img_url,
								picUrl = img_url,
								picBase64Buf = "",
								fileMd5 = ""
						}
	    )
	    log.notice("From Lua SendMsg Ret-->%d", luaPic.Ret)
	end
	--Cosplay月排行
function MonthRankCosplay(CurrentQQ, data) 
			response, error_message =
			    http.request(
			    "GET",
			    "https://api.vc.bilibili.com/link_draw/v2/Photo/rank",
			    {
			        query = "biz=2&category=cos&rank_type=month&page_size=20" 
			    --     headers = {
							-- 	User-Agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.132 Safari/537.36"
							-- }
			    }
			)			
			local html = response.body
			local strJson = json.decode(html)
			math.randomseed(tonumber(tostring(os.time()):reverse():sub(1, 6)))
			randomINum = math.random(1,20)
			log.notice("the randomINum is %s", randomINum)
			local Plength = table.getn(strJson["data"]["items"][1]["item"]["pictures"])
			log.notice("the pictures_length is %s", Plength)
			math.randomseed(tonumber(tostring(os.time()):reverse():sub(1, 6)))
			randomPNum = math.random(1,Plength)
			log.notice("the randomPNum is %s", randomPNum)
			local img_url = strJson["data"]["items"][randomINum]["item"]["pictures"][randomPNum]["img_src"]
			log.notice("the img_url is %s", img_url)
	
			loading(CurrentQQ,data)
	    luaPic =
	        Api.Api_SendMsg(--调用发消息的接口
	        CurrentQQ,
	         {
								toUser = data.FromUin, --回复当前消息的来源群ID
								sendToType = 1, --2发送给群1发送给好友3私聊
								sendMsgType = "PicMsg",
								content = img_url,
								picUrl = img_url,
								picBase64Buf = "",
								fileMd5 = ""
						}
	    )
	    log.notice("From Lua SendMsg Ret-->%d", luaPic.Ret)
	end
	--私服月排行
function MonthRankSifu(CurrentQQ, data) 
			response, error_message =
			    http.request(
			    "GET",
			    "https://api.vc.bilibili.com/link_draw/v2/Photo/rank",
			    {
			        query = "biz=2&category=sifu&rank_type=month&page_size=20" 
			    --     headers = {
							-- 	User-Agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.132 Safari/537.36"
							-- }
			    }
			)			
			local html = response.body
			local strJson = json.decode(html)
			math.randomseed(tonumber(tostring(os.time()):reverse():sub(1, 6)))
			randomINum = math.random(1,20)
			log.notice("the randomINum is %s", randomINum)
			local Plength = table.getn(strJson["data"]["items"][1]["item"]["pictures"])
			log.notice("the pictures_length is %s", Plength)
			math.randomseed(tonumber(tostring(os.time()):reverse():sub(1, 6)))
			randomPNum = math.random(1,Plength)
			log.notice("the randomPNum is %s", randomPNum)
			local img_url = strJson["data"]["items"][randomINum]["item"]["pictures"][randomPNum]["img_src"]
			log.notice("the img_url is %s", img_url)
	
			loading(CurrentQQ,data)
	    luaPic =
	        Api.Api_SendMsg(--调用发消息的接口
	        CurrentQQ,
	         {
								toUser = data.FromUin, --回复当前消息的来源群ID
								sendToType = 1, --2发送给群1发送给好友3私聊
								sendMsgType = "PicMsg",
								content = img_url,
								picUrl = img_url,
								picBase64Buf = "",
								fileMd5 = ""
						}
	    )
	    log.notice("From Lua SendMsg Ret-->%d", luaPic.Ret)
	end

	
function loading(CurrentQQ,data)
		luaMsg =
		    Api.Api_SendMsg(--调用发消息的接口
		    CurrentQQ,
		    {
		        toUser = data.FromUin, --回复当前消息的来源群ID
		        sendToType = 1, --2发送给群1发送给好友3私聊
		        sendMsgType = "TextMsg", --进行文本复读回复
		        groupid = 0, --不是私聊自然就为0咯
		        content = "正在发送。。。", --回复内容
		        atUser = 0 --是否 填上data.FromUserId就可以复读给他并@了
		    }
		)
	end
	
function menTu(CurrentQQ,data)
	response, error_message =
			    http.request(
			    "GET",
			    "https://api.vc.bilibili.com/link_draw/v1/doc/doc_list",
			    {
			        query = "uid=326544280&page_num=0&page_size=30&biz=draw" 
			    --     headers = {
							-- 	User-Agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.132 Safari/537.36"
							-- }
			    }
			)			
			local html = response.body
			local strJson = json.decode(html)
			math.randomseed(tonumber(tostring(os.time()):reverse():sub(1, 6)))
			randomINum = math.random(1,30)
			log.notice("the menTu randomINum is %s", randomINum)
			local Plength = table.getn(strJson["data"]["items"][randomINum]["pictures"])
			log.notice("the pictures_length is %s", Plength)
			math.randomseed(tonumber(tostring(os.time()):reverse():sub(1, 6)))
			randomPNum = math.random(1,Plength)
			log.notice("the randomPNum is %s", randomPNum)
			local img_url = strJson["data"]["items"][randomINum]["pictures"][randomPNum]["img_src"]
			log.notice("the img_url is %s", img_url)
			loading(CurrentQQ,data)
	    luaPic =
	        Api.Api_SendMsg(--调用发消息的接口
	        CurrentQQ,
	         {
								toUser = data.FromUin, --回复当前消息的来源群ID
								sendToType = 1, --2发送给群1发送给好友3私聊
								sendMsgType = "PicMsg",
								content = img_url,
								picUrl = img_url,
								picBase64Buf = "",
								fileMd5 = ""
						}
	    )
	    log.notice("From Lua SendMsg Ret-->%d", luaPic.Ret)
	end
	
function menTu2(CurrentQQ,data)
	response, error_message =
			    http.request(
			    "GET",
			    "https://api.vc.bilibili.com/link_draw/v1/doc/doc_list",
			    {
			        query = "uid=813818&page_num=0&page_size=30&biz=draw" 
			    --     headers = {
							-- 	User-Agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.132 Safari/537.36"
							-- }
			    }
			)			
			local html = response.body
			local strJson = json.decode(html)
			math.randomseed(tonumber(tostring(os.time()):reverse():sub(1, 6)))
			randomINum = math.random(1,22)
			log.notice("the menTu2 randomINum is %s", randomINum)
			local Plength = table.getn(strJson["data"]["items"][randomINum]["pictures"])
			log.notice("the pictures_length is %s", Plength)
			math.randomseed(tonumber(tostring(os.time()):reverse():sub(1, 6)))
			randomPNum = math.random(1,Plength)
			log.notice("the randomPNum is %s", randomPNum)
			local img_url = strJson["data"]["items"][randomINum]["pictures"][randomPNum]["img_src"]
			log.notice("the img_url is %s", img_url)
	
			loading(CurrentQQ,data)
	    luaPic =
	        Api.Api_SendMsg(--调用发消息的接口
	        CurrentQQ,
	         {
								toUser = data.FromUin, --回复当前消息的来源群ID
								sendToType = 1, --2发送给群1发送给好友3私聊
								sendMsgType = "PicMsg",
								content = img_url,
								picUrl = img_url,
								picBase64Buf = "",
								fileMd5 = ""
						}
	    )
	    log.notice("From Lua SendMsg Ret-->%d", luaPic.Ret)
	end
	
	function girlFront(CurrentQQ,data)
	math.randomseed(tonumber(tostring(os.time()):reverse():sub(1, 6)))
	pageNum = math.random(1,5)
	log.notice("pageNum is %s", pageNum)
		response, error_message =
				    http.request(
				    "GET",
				    "https://api.vc.bilibili.com/link_draw/v1/doc/doc_list",
				    {
				        query = "uid=407558584&page_size=30&biz=all&page_num=" ..
												pageNum
				    --     headers = {
								-- 	User-Agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.132 Safari/537.36"
								-- }
				    }
				)			
				local html = response.body
				local strJson = json.decode(html)
				math.randomseed(tonumber(tostring(os.time()):reverse():sub(1, 6)))
				randomINum = math.random(1,30)
				log.notice("the randomINum is %s", randomINum)
				local Plength = table.getn(strJson["data"]["items"][randomINum]["pictures"])
				log.notice("the pictures_length is %s", Plength)
				math.randomseed(tonumber(tostring(os.time()):reverse():sub(1, 6)))
				randomPNum = math.random(1,Plength)
				log.notice("the randomPNum is %s", randomPNum)
				local img_url = strJson["data"]["items"][randomINum]["pictures"][randomPNum]["img_src"]
				log.notice("the img_url is %s", img_url)
		
				loading(CurrentQQ,data)
		    luaPic =
		        Api.Api_SendMsg(--调用发消息的接口
		        CurrentQQ,
		         {
									toUser = data.FromUin, --回复当前消息的来源群ID
									sendToType = 1, --2发送给群1发送给好友3私聊
									sendMsgType = "PicMsg",
									content = img_url,
									picUrl = img_url,
									picBase64Buf = "",
									fileMd5 = ""
							}
		    )
		    log.notice("From Lua SendMsg Ret-->%d", luaPic.Ret)
		end
	function Pixiv(CurrentQQ,data)
		response, error_message =
							http.request(
							"GET",
							"https://api.lolicon.app/setu",
							{
									query = "apikey=148642895e9691d6762c69"
							--     headers = {
									-- 	User-Agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.132 Safari/537.36"
									-- }
							}
					)			
					local html = response.body
					local strJson = json.decode(html)
					local img_url = strJson["data"][1]["url"]
					log.notice("the img_url is %s", img_url)
					loading(CurrentQQ,data)
					luaPic =
							Api.Api_SendMsg(--调用发消息的接口
							CurrentQQ,
							 {
										toUser = data.FromUin, --回复当前消息的来源群ID
										sendToType = 1, --2发送给群1发送给好友3私聊
										sendMsgType = "PicMsg",
										content = img_url,
										picUrl = img_url,
										picBase64Buf = "",
										fileMd5 = ""
								}
					)
					log.notice("From Lua SendMsg Ret-->%d", luaPic.Ret)
		end