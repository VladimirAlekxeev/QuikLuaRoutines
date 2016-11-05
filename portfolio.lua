local db = require('filedb').Load("data\\db.dat")
local portfolio = {}

local function CalculateBalances()
  local balances = {}
  
  for _, v in pairs(db.trade) do
    balances[v.sec_code] = balances[v.sec_code] or {}
    balances[v.sec_code].qty = balances[v.sec_code].qty or 0
    balances[v.sec_code].value = balances[v.sec_code].value or 0
    
    if bit.band(v.flags, 0x4) > 0 then
      tradeType = -1
    else
      tradeType = 1
    end
    
    balances[v.sec_code].sec_code = v.sec_code
    balances[v.sec_code].qty = balances[v.sec_code].qty + tradeType * v.qty
    balances[v.sec_code].value = balances[v.sec_code].value + tradeType * v.value    
  end
  
  for k, v in pairs(balances) do
    if v.qty == 0 then
      balances[k] = nil
    else
      v.avgLotPrice = v.value / v.qty
    end
  end
  return balances
end

function portfolio.GetBalances()
  if db.balance then
    return db.balance
  end   
  
  balances = CalculateBalances()  
  
  for _, v in pairs(balances) do
    v.ename = "balance"
    v.key = "sec_code"
    db.Save(v)
  end
  
  db.balance = balances
  
  return balances
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

return portfolio