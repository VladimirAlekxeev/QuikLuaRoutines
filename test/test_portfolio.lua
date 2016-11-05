luaunit = require('test.luaunit')
portfolio = require('portfolio')

TestPortfolio = {}

function TestPortfolio:testPortfolioIsNotNil()
    luaunit.assertNotNil(portfolio)
end

function TestPortfolio:testGetBalances()
    luaunit.assertIsFunction(portfolio.GetBalances)
end

function TestPortfolio:testGetBalancesReturnsTable()
  local balances = portfolio.GetBalances()
  luaunit.assertIsTable(balances)
  
  for k,v in pairs(balances) do
    if not v.sec_code and not v.qty or not v.value or not v.avgLotPrice then
      luaunit.assertEquals(1, 0)
    end
    luaunit.assertEquals(1, 1)
  end
end

function TestPortfolio:testGetBalanceBySec_Code()
  luaunit.assertIsFunction(portfolio.GetBalance)
end

function TestPortfolio:testGetBalanceBySec_CodeReturnsTable()
  local balanceSBERP = portfolio.GetBalance("SBERP")
  luaunit.assertIsTable(balanceSBERP)
  
  if not balanceSBERP.sec_code and not balanceSBERP.qty or not balanceSBERP.value or not balanceSBERP.avgLotPrice then
      luaunit.assertEquals(1, 0)
    end
    luaunit.assertEquals(1, 1)
end

os.exit(luaunit.LuaUnit.run())