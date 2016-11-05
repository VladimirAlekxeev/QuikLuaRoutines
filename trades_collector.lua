local gPath = getScriptPath()
package.cpath = gPath .. "\\?.dll;" .. package.cpath 
package.path = gPath .. "\\?.lua;" .. package.path

local core = require "core"
local filedb = require "filedb"
local db = filedb.Load(gPath.."\\data\\trades.dat")

local is_run = true
local delay = 10000

function main()
	while is_run do
		sleep(delay)
	end
end

function OnTrade(trade)
	-- Сохраняем только исполненные не активные сделки
	if trade.flags 
		and bit.band(trade.flags, 0x1) == 0 			-- 0 - сделка не активна
		and bit.band(trade.flags, 0x2) == 0 then		-- 0 - сделка исполнена
		
		-- Добавляем новую сделку, если она еще не добавлена
		db.Add(trade, "trade", "trade_num")
	end
end

function OnStop()
	is_run = false
end