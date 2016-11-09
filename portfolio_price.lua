local my_path = "C:\\Projects\\Lua\\QuikLuaRoutines\\?.lua"
package.path = my_path..";"..package.path
package.cpath = my_path..";"..package.cpath

local portfolio = require('portfolio').Load("C:\\Projects\\Lua\\QuikLuaRoutines\\data\\db.dat")
local core = require('core')

local tmp = {}
local balance = {}

Settings={}
Settings.Name = "Portfolio price"

function Init()
  balance = portfolio.GetBalances()
	return 1
end

function OnCalculate(index)
  local ds_info = getDataSourceInfo()
  if not ds_info or ds_info.class_code ~= 'TQBR' then
    return nil
  end
   
  if not tmp[ds_info.sec_code] then
    local sec_info = core.GetSecurityInfo(ds_info.sec_code, ds_info.class_code)
    if not sec_info or not balance[ds_info.sec_code] or sec_info.lot_size == 0 then
      return nil
    end
    
    tmp[ds_info.sec_code] = balance[ds_info.sec_code].avgLotPrice / sec_info.lot_size  
  end
  
  if not tmp[ds_info.sec_code] then
    return nil
  end
  
  return tmp[ds_info.sec_code]
end