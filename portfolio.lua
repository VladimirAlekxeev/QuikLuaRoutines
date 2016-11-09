local db = require('filedb')
local portfolio = {}

local function CalculateBalances()
  local balances = {}
  
  for _, v in pairs(db.trade) do
    balances[v.sec_code] = balances[v.sec_code] or {}
    balances[v.sec_code].qty = balances[v.sec_code].qty or 0
    balances[v.sec_code].value = balances[v.sec_code].value or 0
       
    if bit.band(v.flags, 0x4) > 0 then
--      balances[v.sec_code].qty = balances[v.sec_code].qty - v.qty
--      if balances[v.sec_code].qty <= 0 then
--        balances[v.sec_code] = nil
--      else
--        balances[v.sec_code].value = balances[v.sec_code].value 
--          - balances[v.sec_code].avgLotPrice * v.qty   
--      end    
    else
      balances[v.sec_code].qty = balances[v.sec_code].qty + v.qty
      balances[v.sec_code].value = balances[v.sec_code].value  + v.value
      balances[v.sec_code].avgLotPrice = balances[v.sec_code].value / balances[v.sec_code].qty
    end    
  end
  
  return balances
end

function portfolio.GetBalances()
  if not db.balance then
    db.balance = CalculateBalances() 
  end   
 
  return db.balance
end

function portfolio.GetBalance(sec_code)
  if not db.balance then
    portfolio.GetBalances()
  end
  
  if db.balance[sec_code] then
    return db.balance[sec_code]
  end
  
  return nil
end

function portfolio.Load(fileName)
  db = db.Load(fileName)
  
  return portfolio
end

return {
  Load = portfolio.Load
  }