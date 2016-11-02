local db = {}
local currentFileName
db.trades = {}

function db.Load(fileName)
	currentFileName = fileName
	dofile(fileName)
end

function db.trades.isCorrectTrade(t)
	if type(t) ~= "table" or t.trade_num == nil then
		return false
	end	
	
	return true
end

function db.trades.Save(entity)
	if currentFileName == nil then
		error("DB not initialized")
		return
	end
	
	local file, errorMsg = io.open(currentFileName, "a+")
	if file == nil then
		error(errorMsg)
	end
	str = Serialize(entity, "Trade")
	io.output(file)
	io.write(str)
	io.close(file)
end

function db.trades.Add(t)
	if db.trades.isCorrectTrade(t) == false then
		return
	end
	
	if db.trades[t.trade_num] == nil then
		message("Save new trades")
		db.trades[t.trade_num] = t
		db.trades.Save(t)
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

function Serialize(t, entityName)
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