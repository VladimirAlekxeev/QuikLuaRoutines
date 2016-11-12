package.path = [[C:\Projects\Lua\QuikLuaRoutines\?.lua]]..';'..package.path
local luaunit = require('luaunit')
local Storage = require('storage')
local fstoragePath = 'fstorage'
local fileExtention = 'dat'

TestFileStorage = {}
local storage

function TestFileStorage:setUp()
  storage = Storage(fstoragePath, fileExtention)
end

function TestFileStorage:tearDown()
  storage = nil
end

function TestFileStorage:testConnectToStorage()
  luaunit.assertNotNil(storage)
end

function TestFileStorage:testSave()
  local t = {
    ['SBERP'] = 100,
    ['GAZP'] = 200,
  }
  
  storage:Save('SecAvgPrice', t)
end

function TestFileStorage:testLoad()
  local src = {
    ['SBERP'] = 200,  
  }
  
  storage:Save('SecAvgPrice', src)
  
  local t = storage:Load('SecAvgPrice')

  luaunit.assertNotNil(t)
  luaunit.assertEquals(t.SBERP, 200)
end

os.exit(luaunit.LuaUnit.run())