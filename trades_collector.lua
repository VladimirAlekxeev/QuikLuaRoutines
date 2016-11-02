local gPath = getScriptPath()
package.cpath = gPath .. "\\?.dll;" .. package.cpath 
package.path = gPath .. "\\?.lua;" .. package.path

local core = require "core"
local db = require "filedb"

local is_run = true
local delay = 10000

function main()
	--while is_run do
	--	OnTrade({a=1, b="SBERP", c=3, d = {aa = 1, bb = 2}, [1] = "1111"})
		db.Load("data\\trades.dat")
		
		for k, v in pairs(db.trades) do
			if type(v) ~= "function" then
				message(tostring(k)..' : '..tostring(core.TableToStr(v)), 1)
			end
		end
		
		db.trades.Add({["trade_num"]=1234588,["a"]=1,["c"]=3,["b"]="SBERP",[1]="1111",["d"]={["aa"]=1,["bb"]=2,},})
		
	--	sleep(delay)
	--end	
end

function OnTrade(trade)
	core.LogToFile("data\\trades.dat", filedb.Serialize(trade, "Trade"))
end

function OnStop()
	is_run = false
end