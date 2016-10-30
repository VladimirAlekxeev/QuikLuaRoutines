local gPath = getScriptPath()
package.cpath = gPath .. "\\?.dll;" .. package.cpath 
package.path = gPath .. "\\?.lua;" .. package.path 
local core = require "core"
local const = require "constants"

	
is_run = true

function main()	
	local portfolio_securities = {
		"ALRS",
		"CHMF",
		"GAZP",
		"GMKN",
		"LKOH",
		"MGNT",
		"MOEX",
		"SBERP",
		"SNGSP",
		"TATN",
	}
	local advises = core.GetAdvises(const.firm_id, const.client_code, const.class_code, portfolio_securities)
	core.ShowAdvisesMsg(advises)
end

function OnStop()
	is_run = false
end