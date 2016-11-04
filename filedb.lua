local db = {}
local currentFileName

function db.isCorrectEntity(t)
	if type(t) == "table" and t.ename and t.key and t[t.key] then
		return true
	end	
	
	return false
end

function E(t)
	if db.isCorrectEntity(t) then
		local keyName = t.key
		local keyValue = t[keyName]
		
		if not db[t.ename] then
			db[t.ename] = {}
		end
		
		db[t.ename][keyValue] = t
	end
end

local function KeyToStr(key)
	if type(key) == "string" then
		return key
	elseif type(key) == "number" then
		return '['..key..']'
	end
	
	return nil
end

local function SerializeTable(t)
	local str = '{'
	for k, v in pairs(t) do
		if type(v) == "string" then
			str = str..KeyToStr(k)..'="'..v..'",'
		elseif type(v) == "number" then
			str = str..KeyToStr(k)..'='..v..','
		elseif type(v) == "table" then
			str = str..KeyToStr(k)..'='..SerializeTable(v)..','
		end
	end
	return str..'}'
end

local function SerializeEntity(t)
	if not db.isCorrectEntity(t) then
		return nil
	end
	
	return 'E'..SerializeTable(t)
end

function db.Save(t)
	
	local file, errorMsg = io.open(currentFileName, "a+")
	if not file then
		error(errorMsg)
	end
	
	str = SerializeEntity(t)
	
	io.output(file)
	io.write(str)
	io.close(file)
end

function db.Add(t, entityName, entityKey)
	t.ename = t.ename or entityName
	t.key = t.key or entityKey
	
	if not db.isCorrectEntity(t) then
		return
	end
	
	local keyValue = t[t.key]
	
	if db[t.ename][keyValue] then
		return
	end

	E(t)	
	db.Save(t)
end

local function Load(fileName)
	currentFileName = fileName
	dofile(currentFileName)
	
	return db
end

return {Load = Load}