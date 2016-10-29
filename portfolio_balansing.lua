local function GetAdvise(firm_id, client_code)
	local const 				= require "constants"
	local account 			= const.account
	local client_code 		= const.client_code
	local firm_id 			= const.firm_id
	local tag 				= const.tag
	local currcode 			= const.currcode
	local portfolio_sec_cnt = const.portfolio_sec_cnt
	local class_code 		= const.class_code
	message(tostring(firm_id).." "..tostring(client_code))
	local portfolio = getPortfolioInfo(firm_id, client_code)
	local money_available = portfolio["all_assets"]
	local sec_money_limit = money_available / portfolio_sec_cnt
	local money = getMoney (client_code, firmid, tag, currcode)
	local n = getNumberOf("depo_limits")	
	local item={}
	for i=0, n-1 do
		item = getItem("depo_limits", i)
		local sec_info = {}
		if item["limit_kind"] == 0 and item["currentbal"]~=0 then
			local sec_info = getSecurityInfo(class_code, item["sec_code"])
			if sec_info~=nil then
				local sec_code = item["sec_code"]
				local currentbal = item["currentbal"]
				local lot_size = sec_info["lot_size"]
				local current_lots = currentbal / lot_size
				local curr_price = getParamEx (class_code, sec_code, "LAST").param_value
				local current_sec_sum = currentbal * curr_price
				local delta_sec_sum = current_sec_sum - sec_money_limit
				local new_sec_bal = sec_money_limit / curr_price
				local delta_sec_qty = currentbal - new_sec_bal
				local delta_sec_lots = math.ceil(delta_sec_qty / lot_size)
				local status = ""
				if delta_sec_lots < 0 then
					status = "купить"..tostring(math.abs(delta_sec_lots)).." лот."
				elseif delta_sec_lots > 0 then
					status = "продать"..tostring(math.abs(delta_sec_lots)).." лот."
				else
					status = "держать"
				end
				
				message(
					"========================\n"
					..tostring(sec_code).."\n"
					.."========================\n"
					.."Лот: "..tostring(lot_size).."\n"
					.."Текущая цена: "..tostring(curr_price).."\n"
					.."Кол-во: "..tostring(currentbal).."\n"
					.."Сумма: "..tostring(current_sec_sum).."\n"
					.."Лимит: "..tostring(sec_money_limit).."\n"
					.."Дельта суммы: "..tostring(delta_sec_sum).."\n"
					.."Дельта акций: "..tostring(math.ceil(delta_sec_qty)).."\n"
					.."Дельта лотов: "..tostring(delta_sec_lots).."\n"
					.."========================\n"
					.."Действие: "..status.."\n"
					, 1)
			end
		end
	end
	
	return result
end

is_run = true
delay = 10000

function main()	
	while is_run do
		GetAdvise(firm_id, client_code)
        sleep(delay)
    end
end

function OnStop()
	is_run = false
end