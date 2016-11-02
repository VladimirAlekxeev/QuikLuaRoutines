local db = {}
db.trades = {}

function db.Load(fileName)
	dofile(fileName)
end

function db.trades.isCorrectTrade(t)
	if type(t) ~= "table" or t.trade_num == nil then
		return false
	end	
	
	return true
end

function db.trades.Add(t)
	if db.trades.isCorrectTrade(t) == false then
		return
	end
	
	if db.trades[t.trade_num] == nil then
		message("New trade")
	else
		message("Not New trade")
	end
end

function Trade(t)
	if db.trades.isCorrectTrade(t) then
		db.trades[t.trade_num] = t
	end
end

local function KeyToStr(key)
	if type(key) == "string" then
		return '["'..key..'"]'
	elseif type(key) == "number" then
		return '['..key..']'
	else
		return nil
	end
end

local function Serialize(t, entityName)
	if type(t) ~= "table" then
		return nil
	end
	
	local str = ''
	if entityName ~= nil then
		str = str..entityName
	end
	
	str = str..'{'
	for k, v in pairs(t) do
		if type(v) == "string" then
			str = str..KeyToStr(k)..'="'..v..'",'
		elseif type(v) == "number" then
			str = str..KeyToStr(k)..'='..v..','
		elseif type(v) == "table" then
			str = str..KeyToStr(k)..'='..Serialize(v, nil)..','
		end
	end
	str = str..'}'
	
	return str
end

return db