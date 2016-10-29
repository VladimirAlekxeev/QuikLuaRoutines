local gPath = getScriptPath()
package.cpath = gPath .. "\\?.dll;" .. package.cpath 
package.path = gPath .. "\\?.lua;" .. package.path 

local core = require "core"
	
is_run = true
delay = 10000

function main()	
	while is_run do
		core.GetAdvise(firm_id, client_code)
        sleep(delay)
    end
end

function OnStop()
	is_run = false
end