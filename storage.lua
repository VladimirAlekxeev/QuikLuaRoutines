local lfs = require 'lfs'

local FS = {}
FS.__index = FS

setmetatable(FS, {
    __call = function(cls, ...)
      return cls.new(...)
    end,
  }
)

local function isFolderExists(folderPath)
	if lfs.attributes(folderPath:gsub("\\$",""),"mode") == "directory" then
		return true
  end
  
	return false
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
	return 'E'..SerializeTable(t)
end

function FS.new(storagePath, fileExtention)
  local self = setmetatable({}, FS)
  if isFolderExists(storagePath) then
    self.storagePath = storagePath
    self.fileExtention = fileExtention
    return self
  end
  
  return nil
end

function FS:Save(tableName, t)
  str = SerializeEntity(t)
  
  if not str then
    return
  end
	
  local file = assert(io.open(self.storagePath..'\\'..tableName..'.'..self.fileExtention, "w"))

	io.output(file)
	io.write(str)
	io.close(file) 
end

function FS:Load(tableName)
  local tmp
  function E(t)
    tmp = t
  end
  dofile(self.storagePath..'\\'..tableName..'.'..self.fileExtention)
  local E = E

  return tmp
end

return FS