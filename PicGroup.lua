local log = require("log")
local Api = require("coreApi")
local json = require("json")
local http = require("http")
function ReceiveFriendMsg(CurrentQQ, data)
    return 1
end

function ReceiveGroupMsg(CurrentQQ, data)
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
	if string.find(data.Content, "cos") then 
		Cosplay(CurrentQQ,data)
		end
	if string.find(data.Content, "私服") == 1 then
		Sifu(CurrentQQ,data)
		end
	keyWord = string.gsub(data.Content, "群图片", "sb")
	if string.match(data.Content, keyWord) == "图" then
		
	-- menTu(CurrentQQ,data)
	for i=1,5,1 do
		zuxingjian(CurrentQQ,data)
		end
	end
	if string.find(data.Content, "少前") == 1 then
		girlFront(CurrentQQ,data)
		end
	if string.find(data.Content, "收藏") == 1  then
		for i=1,5,1 do
		Pixiv(CurrentQQ,data)
		end
		end
	if string.find(data.MsgType, "PicMsg") then 
		str = json.decode(data.Content)
		FileMd5 = str.GroupPic[1].FileMd5
if FileMd5 == 'pRxceaTnu2Xw1ORFzuZ6SA==' or FileMd5 == '6uw/nFjjp8Dj6gZojum3jA==' then
                   for i=1,5,1 do
                Pixiv(CurrentQQ,data)
                end
                end
if FileMd5 == 'qsFn6mdxIG3T32Kyh0ZKeg==' then
			Pixiv(CurrentQQ,data)
		end
if FileMd5 == 'QoOtD2OwFcB5mEfoTXn36A==' then
                        Pixiv(CurrentQQ,data)
		end
		if FileMd5 == 'dHxyac8V301uxk4iyxEzfQ==' then
			Pixiv(CurrentQQ,data)
		end
	end
    return 1
end

function ReceiveEvents(CurrentQQ, data, extData)
    return 1
end

function Illustration(CurrentQQ, data) 
			number = math.random(1,13)
			response, error_message =
			    http.request(
			    "GET",
			    "https://api.vc.bilibili.com/link_draw/v2/Doc/list",
			    {
			        query = "category=illustration&type=hot&page_size=20&page_num=" ..
							number,
					headers = {
						Cookie = "l=v"
						}
			    }
			)			
			-- local number = tonumber(num)
			local html = response.body
			local strJson = json.decode(html)
			math.randomseed(tonumber(tostring(os.time()):reverse():sub(1, 6)))
			local items = table.getn(strJson["data"]["items"])
			log.notice("item length-->%s",items)
			randomINum = math.random(1,16)
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
								toUser = data.FromGroupId, --回复当前消息的来源群ID
								sendToType = 2, --2发送给群1发送给好友3私聊
								groupid = 0, --不是私聊自然就为0咯
								atUser = 0, --是否 填上data.FromUserId就可以复读给他并@了
								sendMsgType = "PicMsg",
								content = "",
								picUrl = img_url,
								picBase64Buf = "",
								fileMd5 = ""
						}
	    )
	    log.notice("From Lua SendMsg Ret-->%d", luaPic.Ret)
	end
	
function Comic(CurrentQQ, data) 
			number = math.random(0,1)
			response, error_message =
			    http.request(
			    "GET",
			    "https://api.vc.bilibili.com/link_draw/v2/Doc/list",
			    {
			        query = "category=comic&type=hot&page_size=20&page_num=" ..
							number,
					headers = {
						Cookie = "l=v"
						}
			    }
			)			
			
			local html = response.body
			local strJson = json.decode(html)
			math.randomseed(tonumber(tostring(os.time()):reverse():sub(1, 6)))
			local items = table.getn(strJson["data"]["items"])
			log.notice("item length-->%s",items)
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
								toUser = data.FromGroupId, --回复当前消息的来源群ID
								sendToType = 2, --2发送给群1发送给好友3私聊
								groupid = 0, --不是私聊自然就为0咯
								atUser = 0, --是否 填上data.FromUserId就可以复读给他并@了
								sendMsgType = "PicMsg",
								content = "",
								picUrl = img_url,
								picBase64Buf = "",
								fileMd5 = ""
						}
	    )
	    log.notice("From Lua SendMsg Ret-->%d", luaPic.Ret)
	end
	
function Draw(CurrentQQ, data) 
			number = math.random(1,5)
			response, error_message =
			    http.request(
			    "GET",
			    "https://api.vc.bilibili.com/link_draw/v2/Doc/list",
			    {
			        query = "category=draw&type=hot&page_size=20&page_num=" ..
							number,
					headers = {
						Cookie = "l=v"
						}
			    }
			)			
			local html = response.body
			local strJson = json.decode(html)
			math.randomseed(tonumber(tostring(os.time()):reverse():sub(1, 6)))
			local items = table.getn(strJson["data"]["items"])
			log.notice("item length-->%s",items)
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
								toUser = data.FromGroupId, --回复当前消息的来源群ID
								sendToType = 2, --2发送给群1发送给好友3私聊
								groupid = 0, --不是私聊自然就为0咯
								atUser = 0, --是否 填上data.FromUserId就可以复读给他并@了
								sendMsgType = "PicMsg",
								content = "",
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
							number,
					headers = {
						Cookie = "l=v"
						}
			    }
			)			
			local html = response.body
			local strJson = json.decode(html)
			math.randomseed(tonumber(tostring(os.time()):reverse():sub(1, 6)))
			local items = table.getn(strJson["data"]["items"])
			log.notice("item length-->%s",items)
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
								toUser = data.FromGroupId, --回复当前消息的来源群ID
								sendToType = 2, --2发送给群1发送给好友3私聊
								groupid = 0, --不是私聊自然就为0咯
								atUser = 0, --是否 填上data.FromUserId就可以复读给他并@了
								sendMsgType = "PicMsg",
								content = "",
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
							number,
					headers = {
						Cookie = "l=v"
						}
			    }
			)			
			local html = response.body
			local strJson = json.decode(html)
			math.randomseed(tonumber(tostring(os.time()):reverse():sub(1, 6)))
			local items = table.getn(strJson["data"]["items"])
			log.notice("item length-->%s",items)
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
								toUser = data.FromGroupId, --回复当前消息的来源群ID
								sendToType = 2, --2发送给群1发送给好友3私聊
								groupid = 0, --不是私聊自然就为0咯
								atUser = 0, --是否 填上data.FromUserId就可以复读给他并@了
								sendMsgType = "PicMsg",
								content = "",
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
			        query = "biz=1&rank_type=week&page_size=20",
					headers = {
						Cookie = "l=v"
						}
			    }
			)			
			local number = tonumber(num)
			local html = response.body
			local strJson = json.decode(html)
			math.randomseed(tonumber(tostring(os.time()):reverse():sub(1, 6)))
			local items = table.getn(strJson["data"]["items"])
			log.notice("item length-->%s",items)
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
								toUser = data.FromGroupId, --回复当前消息的来源群ID
								sendToType = 2, --2发送给群1发送给好友3私聊
								groupid = 0, --不是私聊自然就为0咯
								atUser = 0, --是否 填上data.FromUserId就可以复读给他并@了
								sendMsgType = "PicMsg",
								content = "",
								picUrl = img_url,
								picBase64Buf = "",
								fileMd5 = ""
						}
	    )
	    log.notice("From Lua SendMsg Ret-->%d", luaPic.Ret)
	end
	
function Cosplay(CurrentQQ, data) 
			number = math.random(0,4)
			response, error_message =
			    http.request(
			    "GET",
			    "https://api.vc.bilibili.com/link_draw/v2/Photo/list",
			    {
			        query = "category=cos&type=hot&page_size=20&page_num=" ..
							number,
					headers = {
						Cookie = "l=v"
						}
			    }
			)			
			local html = response.body
			local strJson = json.decode(html)
			math.randomseed(tonumber(tostring(os.time()):reverse():sub(1, 6)))
			local items = table.getn(strJson["data"]["items"])
			log.notice("item length-->%s",items)
			randomINum = math.random(1,20)
			log.notice("the randomINum is %s", randomINum)
			local Plength = table.getn(strJson["data"]["items"][randomINum]["item"]["pictures"])
			log.notice("the pictures_length is %s", Plength)
			math.randomseed(tonumber(tostring(os.time()):reverse():sub(1, 6)))
			randomPNum = math.random(1,Plength)
			log.notice("the randomPNum is %s", randomPNum)
			local img_url = strJson["data"]["items"][randomINum]["item"]["pictures"][randomPNum]["img_src"]
			log.notice("the img_url is %s", img_url)
	    luaPic =
	        Api.Api_SendMsg(--调用发消息的接口
	        CurrentQQ,
	         {
								toUser = data.FromGroupId, --回复当前消息的来源群ID
								sendToType = 2, --2发送给群1发送给好友3私聊
								groupid = 0, --不是私聊自然就为0咯
								atUser = 0, --是否 填上data.FromUserId就可以复读给他并@了
								sendMsgType = "PicMsg",
								content = "",
								picUrl = img_url,
								picBase64Buf = "",
								fileMd5 = ""
						}
	    )
	    -- log.notice("From Lua SendMsg Ret-->%d", luaPic.Ret)
	end
	

function loading(CurrentQQ,data)
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
	
function menTu(CurrentQQ,data)
	response, error_message =
			    http.request(
			    "GET",
			    "https://api.vc.bilibili.com/link_draw/v1/doc/doc_list",
			    {
			        query = "uid=326544280&page_num=0&page_size=30&biz=all",
			        headers = {
						Cookie = "l=v"
				 	}
			    }
			)			
			local html = response.body
			local strJson = json.decode(html)
			log.notice("strJson is %s", strJson.data)
			math.randomseed(tonumber(tostring(os.time()):reverse():sub(1, 6)))
			local items = table.getn(strJson["data"]["items"])
			log.notice("item length-->%s",items)
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
								toUser = data.FromGroupId, --回复当前消息的来源群ID
								sendToType = 2, --2发送给群1发送给好友3私聊
								groupid = 0, --不是私聊自然就为0咯
								atUser = 0, --是否 填上data.FromUserId就可以复读给他并@了
								sendMsgType = "PicMsg",
								content = "",
								picUrl = img_url,
								picBase64Buf = "",
								fileMd5 = ""
						}
	    )
	    log.notice("From Lua SendMsg Ret-->%d", luaPic.Ret)
	end
	
function zuxingjian(CurrentQQ,data)
	pageNum = math.random(0,30)
	log.notice("pageNum-->%s",pageNum)
	response, error_message =
			    http.request(
			    "GET",
			    "https://api.vc.bilibili.com/link_draw/v1/doc/doc_list",
			    {
			        query = "uid=14453048&page_size=30&biz=all&page_num=" .. pageNum,
					headers = {
						Cookie = "l=v"
						}
			    }
			)			
			local html = response.body
			local strJson = json.decode(html)
			math.randomseed(tonumber(tostring(os.time()):reverse():sub(1, 6)))
			local items = table.getn(strJson["data"]["items"])
			log.notice("item length-->%s",items)
			randomINum = math.random(1,22)
			log.notice("the randomINum is %s", randomINum)
			local Plength = table.getn(strJson["data"]["items"][randomINum]["pictures"])
			log.notice("the pictures_length is %s", Plength)
			math.randomseed(tonumber(tostring(os.time()):reverse():sub(1, 6)))
			randomPNum = math.random(1,Plength)
			log.notice("the randomPNum is %s", randomPNum)
			local img_url = strJson["data"]["items"][randomINum]["pictures"][randomPNum]["img_src"]
			log.notice("the img_url is %s", img_url)
	
			-- loading(CurrentQQ,data)
	    luaPic =
	        Api.Api_SendMsg(--调用发消息的接口
	        CurrentQQ,
	         {
								toUser = data.FromGroupId, --回复当前消息的来源群ID
								sendToType = 2, --2发送给群1发送给好友3私聊
								groupid = 0, --不是私聊自然就为0咯
								atUser = 0, --是否 填上data.FromUserId就可以复读给他并@了
								sendMsgType = "PicMsg",
								content = "",
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
								pageNum,
						headers = {
							Cookie = "l=v"
							}
				    }
				)			
				local html = response.body
				local strJson = json.decode(html)
				math.randomseed(tonumber(tostring(os.time()):reverse():sub(1, 6)))
				local items = table.getn(strJson["data"]["items"])
			log.notice("item length-->%s",items)
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
									toUser = data.FromGroupId, --回复当前消息的来源群ID
									sendToType = 2, --2发送给群1发送给好友3私聊
									groupid = 0, --不是私聊自然就为0咯
									atUser = 0, --是否 填上data.FromUserId就可以复读给他并@了
									sendMsgType = "PicMsg",
									content = "",
									picUrl = img_url,
									picBase64Buf = "",
									fileMd5 = ""
							}
		    )
		    log.notice("From Lua SendMsg Ret-->%d", luaPic.Ret)
		end
function Pixiv(CurrentQQ,data)
	math.randomseed(tonumber(tostring(os.time()):reverse():sub(1, 6)))
	pageNum = math.random(0,4)
	log.notice("pageNum is %s", pageNum)
		response, error_message =
					http.request(
					"GET",
					"https://api.vc.bilibili.com/link_draw/v1/doc/doc_list",
					{
						query = "uid=53271910&page_size=30&biz=draw&page_num=" ..
								pageNum,
						headers = {
							Cookie = "l=v"
							}
					}
				)			
				local html = response.body
				local strJson = json.decode(html)
				math.randomseed(tonumber(tostring(os.time()):reverse():sub(1, 6)))
				local items = table.getn(strJson["data"]["items"])
				log.notice("item length-->%s",items)
				randomINum = math.random(1,items)
				log.notice("the randomINum is %s", randomINum)
				local Plength = table.getn(strJson["data"]["items"][randomINum]["pictures"])
				log.notice("the pictures_length is %s", Plength)
				math.randomseed(tonumber(tostring(os.time()):reverse():sub(1, 6)))
				randomPNum = math.random(1,Plength)
				log.notice("the randomPNum is %s", randomPNum)
				local img_url = strJson["data"]["items"][randomINum]["pictures"][randomPNum]["img_src"]
				log.notice("the img_url is %s", img_url)
		
				--loading(CurrentQQ,data)
			luaPic =
				Api.Api_SendMsg(--调用发消息的接口
				CurrentQQ,
					{
									toUser = data.FromGroupId, --回复当前消息的来源群ID
									sendToType = 2, --2发送给群1发送给好友3私聊
									groupid = 0, --不是私聊自然就为0咯
									atUser = 0, --是否 填上data.FromUserId就可以复读给他并@了
									sendMsgType = "PicMsg",
									content = "",
									picUrl = img_url,
									picBase64Buf = "",
									fileMd5 = ""
							}
			)
			log.notice("From Lua SendMsg Ret-->%d", luaPic.Ret)
		end

function Pixiv_o(CurrentQQ,data)
	-- if data.FromUserId ~= CurrentQQ then 
	-- 	return
	-- end
		response, error_message =
						http.request(
						"GET",
						"https://api.lolicon.app/setu",
						{
							query = "apikey=890360845f0bd89f905a70",
							 headers = {
							 		["User-Agent"]="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.132 Safari/537.36",
								["Host"]="www.baidu.com"	
							 	}
			
			}
				)			
				local html = response.body
				log.notice("the html is %s", html)
				local strJson = json.decode(html)
				local img_url = strJson["data"][1]["url"]
				log.notice("the img_url is %s", img_url)
				luaPic =
						Api.Api_SendMsg(--调用发消息的接口
						CurrentQQ,
							{
									toUser = data.FromGroupId, --回复当前消息的来源群ID
									sendToType = 2, --2发送给群1发送给好友3私聊
									groupid = 0, --不是私聊自然就为0咯
									atUser = 0, --是否 填上data.FromUserId就可以复读给他并@了
									sendMsgType = "PicMsg",
									content = "",
									picUrl = img_url,
									picBase64Buf = "",
									fileMd5 = ""
							}
				)
				loading(CurrentQQ,data)
				log.notice("From Lua SendMsg Ret-->%d", luaPic.Ret)
	end

