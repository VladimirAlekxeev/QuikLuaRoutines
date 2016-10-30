local function GetClientCodes()
	list = {}
	
	local n = getNumberOf("client_codes")
	for i=0, n-1 do
		local item = getItem("client_codes", i)
		table.insert(list, item)
	end
	return list
end

local function LogToFile(fileName, str)
	local file = io.open(fileName, "w+")
	io.output(file)
	io.write(str)
	io.close(file)	
end

local function TableToStr(t)
	local s = ""
	for k, v in pairs(t) do
		if type(v) == "table" then
			s = s..tostring(k)..": ".."{"..TableToStr(v).."}\n"
		else
			s = s..tostring(k)..": "..tostring(v).."\n"
		end
	end
	return s
end

local function GetSecurityInfo(sec_code, class_code)
	class_code = class_code or "TQBR"
	local findedIndexes = SearchItems(
		"securities", 
		0, 
		getNumberOf("securities")-1,
		function (t)
			if t.code == sec_code and t.class_code == class_code then
				return true
			else
				return false
			end
		end
	)
	if findedIndexes == nil then
		return nil
	end
	
	return getItem("securities", findedIndexes[1])
end

local function ChangeTableValuesAndKeys(t)
	local newTable = {}
	
	for k, v in pairs(t) do
		newTable[v] = k
	end
	return newTable
end

local function GetDepoLimits(firm_id, client_code, class_code, portfolio_securities)
	local allowedSecurities = ChangeTableValuesAndKeys(portfolio_securities)
	
	class_code = class_code or "TQBR"
	local findedIndexes = SearchItems(
		"depo_limits", 
		0, 
		getNumberOf("depo_limits")-1,
		function (t)
			if t.firmid == firm_id and t.client_code == client_code and t.limit_kind == 0 and allowedSecurities[t.sec_code] ~= nil  then
				return true
			else
				return false
			end
		end
	)
	local n = getNumberOf("depo_limits")
	local list = {}
	for k, v in pairs(findedIndexes) do
		local item = getItem("depo_limits", v)
		item.secInfo = GetSecurityInfo(item.sec_code, class_code)
		table.insert(list, item)
	end
	return list
end

local function GetAdvises(firm_id, client_code, class_code, portfolio_securities)
	local depoLimits = GetDepoLimits(firm_id, client_code, class_code, portfolio_securities)
	local portfolio = getPortfolioInfo(firm_id, client_code)
	local money_available = portfolio["all_assets"]
	local sec_money_limit = money_available / #portfolio_securities
	local n = getNumberOf("depo_limits")	
	local advises = {}
	for _, item in pairs(depoLimits) do
		local current_lots = item.currentbal / item.secInfo.lot_size
		local curr_price = getParamEx (item.secInfo.class_code, item.sec_code, "LAST").param_value
		local current_sec_sum = item.currentbal * curr_price
		local delta_sec_sum = current_sec_sum - sec_money_limit
		local new_sec_bal = sec_money_limit / curr_price
		local delta_sec_qty = math.ceil(item.currentbal - new_sec_bal)
		local delta_sec_lots = math.ceil(delta_sec_qty / item.secInfo.lot_size)
		
		table.insert(advises, {sec_code = item.sec_code,
							   delta_sec_qty = delta_sec_qty,
							   delta_sec_lots = delta_sec_lots})
	end
	
	return advises
end

local function ShowAdvisesMsg(advises)
	local str = ""
	for _, item in pairs(advises) do
		if item.delta_sec_lots < 0 then
			str = str..item.sec_code..": купить "..tostring(math.abs(item.delta_sec_lots)).." лот.\n"
		elseif item.delta_sec_lots > 0 then
			str = str..item.sec_code..": продать"..tostring(math.abs(item.delta_sec_lots)).." лот.\n"
		else
			str = str..item.sec_code..": держать\n"
		end
		
	end	
	message(str, 1)
end

return{
	GetAdvises = GetAdvises,
	LogToFile = LogToFile,
	GetClientCodes = GetClientCodes,
	GetDepoLimits = GetDepoLimits,
	TableToStr = TableToStr,
	GetSecurityInfo = GetSecurityInfo,
	ShowAdvisesMsg = ShowAdvisesMsg
}