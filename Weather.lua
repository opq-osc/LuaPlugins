local log = require("log")
local Api = require("coreApi")
local json = require("json")
local http = require("http")

function ReceiveFriendMsg(CurrentQQ, data)
		if string.find(data.Content, "天气") == 1 then --判断一下所接收的消息里是否含有复读机字样 有则进行处理
        keyWord = data.Content:gsub("天气", "") --提取关键词 保存到keyWord里
				log.notice("keyWord-->%s",keyWord)
		if keyWord == "" then
							return 1
					end
		cookies = Api.Api_GetUserCook(CurrentQQ)
    response, error_message =
        http.request(
        "GET",
         "https://weather.mp.qq.com/cgi-bin/rich",
       {
           query = "g_tk=" .. cookies.Gtk .. "&city=" .. url_encode(keyWord),
           headers = {
               Referer = "http://weather.mp.qq.com/ark"
           },
           cookies = {
               uin = CurrentQQ,
               skey = cookies.Skey
           }
       }
    )
   local html = response.body
   log.notice("From Lua html -->%s", html)
   
   local j = json.decode(html)
   if j.code ~= 0 then
       return 1
   end
			luaRes =
					Api.Api_SendMsg(
					CurrentQQ,
					{
							toUser = data.FromUin,
							sendToType = 1,
							sendMsgType = "JsonMsg",
							groupid = 0,
							content = string.format(
							    --{"config":{"forward":1,"autosize":1},"prompt":"[应用]天气","app":"com.tencent.weather","ver":"0.0.0.1","view":"RichInfoView","meta":{"richinfo":{"adcode":"101210701","city":"成都","air":"58","min":"20","ts":"1500550866","wind":"1","date":"6月27日 周四","max":"28","type":"201"}},"desc":"天气"}
							    --[[{"app":"com.tencent.weather","desc":"","meta":{"weather":{"ad":[{"icon":"http://imgcache.qq.com/ac/tq/xz2/tp.jpg","p":"ptype=star","t":"2","title":"星座 | 今天会因为感情和家庭的问题，影响工作，还有，也要注意人...","url":""},{"icon":"http://imgcache.qq.com/ac/qqweather/image/2019/6/27.png","p":"ptype=lunar","t":"4","title":"黄历 | 农历五月廿五。宜订盟.纳采.出行.祈福.斋醮.安床.会...","url":""}],"info":{"it1":{"adcode":"101050101","city":"武汉","hour":"18","max":"29","min":"17","temp":"24","type":"202","ut":"1561630401","wea":"多云"},"it2":{"hour":"19","temp":"22","type":"202"},"it3":{"hour":"20","temp":"21","type":"202"},"ts":"1561631244"},"url":""}},"prompt":"【哈尔滨】多云 17°/29°, 18:13更新~","ver":"1.0.0.106","view":"WeatherThreeView"}]]
							    [[{"app":"com.tencent.weather","desc":"天气","view":"RichInfoView","ver":"1.0.0.217","prompt":"[应用]天气","meta":{"richinfo":{"adcode":"%s","air":"%s","city":"%s","date":"%s","max":"%s","min":"%s","ts":"1554951408","type":"%s","wind":"%s"}},"config":{"forward":1,"autosize":1,"type":"card"}}]],
							    j.data.adcode,
							    j.data.air,
							    j.data.city,
							    j.data.date,
							    j.data.max,
							    j.data.min,
							    j.data.type,
							    j.data.wind
							),
							atUser = 0
					}
			)
		log.notice("From Lua SendMsg Ret-->%d", luaRes.Ret)
	end
    return 1
end
function ReceiveGroupMsg(CurrentQQ, data)
if CurrentQQ ~= 664424604 then
	if string.find(data.Content, "天气") == 1 then --判断一下所接收的消息里是否含有复读机字样 有则进行处理
	        keyWord = data.Content:gsub("天气", "") --提取关键词 保存到keyWord里
					log.notice("keyWord-->%s",keyWord)
			if keyWord == "" then
								return 1
						end
			cookies = Api.Api_GetUserCook(CurrentQQ)
	    response, error_message =
	        http.request(
	        "GET",
	         "https://weather.mp.qq.com/cgi-bin/rich",
	       {
	           query = "g_tk=" .. cookies.Gtk .. "&city=" .. url_encode(keyWord),
	           headers = {
	               Referer = "http://weather.mp.qq.com/ark"
	           },
	           cookies = {
	               uin = CurrentQQ,
	               skey = cookies.Skey
	           }
	       }
	    )
	   local html = response.body
	   
	   local j = json.decode(html)
	   if j.code ~= 0 then
	       return 1
	   end
				luaRes =
						Api.Api_SendMsg(
						CurrentQQ,
						{
								toUser = data.FromGroupId,
								sendToType = 2,
								sendMsgType = "JsonMsg",
								groupid = 0,
								content = string.format(
								    [[{"app":"com.tencent.weather","desc":"天气","view":"RichInfoView","ver":"1.0.0.217","prompt":"[应用]天气","meta":{"richinfo":{"adcode":"%s","air":"%s","city":"%s","date":"%s","max":"%s","min":"%s","ts":"1554951408","type":"%s","wind":"%s"}},"config":{"forward":1,"autosize":1,"type":"card"}}]],
								    j.data.adcode,
								    j.data.air,
								    j.data.city,
								    j.data.date,
								    j.data.max,
								    j.data.min,
								    j.data.type,
								    j.data.wind
								),
								atUser = 0
						}
				)
			log.notice("From Lua SendMsg Ret-->%d", luaRes.Ret)
		end
end
	    return 1
	end
function ReceiveEvents(CurrentQQ, data, extData)
    return 1
end
function url_encode(str)
    if (str) then
        str = string.gsub(str, "\n", "\r\n")
        str =
            string.gsub(
            str,
            "([^%w ])",
            function(c)
                return string.format("%%%02X", string.byte(c))
            end
        )
        str = string.gsub(str, " ", "+")
    end
    return str
end