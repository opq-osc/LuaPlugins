local log = require("log")
local Api = require("coreApi")
local json = require("json")
local http = require("http")

function ReceiveFriendMsg(CurrentQQ, data)
end
function ReceiveGroupMsg(CurrentQQ, data)

if string.find(data.Content, "#菜单") == 1 then
	menu =  "1.看图命令有：\n漫画、插画、随机、首页、cos、私服、少前、图、收藏。\n"..
					"2.QQ音乐：点歌+歌名/歌手\n"..
					"3.搜图+图片\n"..
					"4.搜番+图片\n"..
					"5.项目地址：.gayhub\n"..
					"6.百度百科：百科+内容\n"..
					"7.毒鸡汤\n"..
					"8.彩虹屁\n"..
					"9.历史上的今天\n"..
					"10.一言\n"..
					"11.运势+星座\n"
					luaMsg =
				    Api.Api_SendMsg(--调用发消息的接口
				    CurrentQQ,
				    {
				       toUser = data.FromGroupId, --回复当前消息的来源群ID
				       sendToType = 2, --2发送给群1发送给好友3私聊
				       sendMsgType = "TextMsg", --进行文本复读回复
				       groupid = 0, --不是私聊自然就为0咯
				       content = menu, --回复内容
				       atUser = 0 --是否 填上data.FromUserId就可以复读给他并@了
				    }
				)
		end
    return 1
end
function ReceiveEvents(CurrentQQ, data, extData)
    return 1
end
	
