function vRP.getBankAccountData(account)
	return vRP.query('vRP/get_bank_account', {account = parseInt(account)})
end

function vRP.getBankIdData(user_id)
	return vRP.query('vRP/get_bank_id', {user_id = parseInt(user_id)})
end

function vRP.getFines(user_id)
    local consult = vRP.query('vRP/get_bank_id', {user_id = parseInt(user_id)})
	local fines = 0
    if consult[1] then
        if consult[1].invoices then
            local consult_result = json.decode(consult[1].invoices)
            for k, v in pairs(consult_result) do
                if v.issuer == 'Police' then
					fines = fines + v.price
                end
            end
			return fines
        end
    end
    return fines
end

function vRP.addBank(account, amount)
	if amount > 0 then
		vRP.execute('vRP/add_bank', {account = account, balance = parseInt(amount)})
	end
end

function vRP.delBank(account, amount)
	local balance = vRP.getBankAccount(account)
	if amount > 0 then
		if balance >= amount then
			vRP.execute('vRP/del_bank', {account = account, balance = parseInt(amount)})
			return true
		end
	end
	return false
end

function vRP.getBankIdAccount(user_id)
	local rows = vRP.query('vRP/get_account_by_user', {user_id = user_id})
	if #rows > 0 then
		return rows[1].account
	else
		return {}
	end
end

function vRP.getBankAccount(account)
	local consult = vRP.getBankAccountData(account)
	if consult[1] then
		return consult[1].balance
	end
end

function vRP.getBankId(user_id)
	local consult = vRP.getBankIdData(user_id)
	if consult[1] then
		return consult[1].balance
	end
end

function vRP.depositCash(user_id, account, amount)
	if amount > 0 then
		local consult = vRP.getBankAccountData(account)
		if consult[1] then
			if consult[1].balance >= amount then
				if vRP.tryGetInventoryItem(user_id, 'dinheiro', amount) then
					vRP.execute('vRP/add_bank', {account = account, balance = parseInt(amount)})
					return true
				end
			end
		end
	end
	return false
end

function vRP.withdrawCash(user_id, account, amount)
	if amount > 0 then
		local consult = vRP.getBankAccountData(account)
		if consult[1] then
			if consult[1].balance >= amount then
				vRP.tryGiveInventoryItem(user_id, 'dinheiro', amount, true)
				vRP.execute('vRP/del_bank', {account = account, balance = parseInt(amount)})
				return true
			end
		end
	end
	return false
end

function vRP.tryPaymentBank(user_id, amount)
	local balance = vRP.getBankId(user_id)
	local account = vRP.getBankIdAccount(user_id)
	if amount > 0 then
		if balance >= amount then
			vRP.execute('vRP/del_bank', {account = account, balance = parseInt(amount)})
			return true
		end
	end
	return false
end

function vRP.tryPayment(user_id, amount)
	local balance = vRP.getBankId(user_id)
	local account = vRP.getBankIdAccount(user_id)
	if amount > 0 then
		if vRP.getInventoryItemAmount(user_id, 'cartao') > 0 then
			if vRP.getInventoryItemAmount(user_id, 'dinheiro') >= amount then
				vRP.tryGetInventoryItem(user_id, 'dinheiro', amount)
				return true
			else
				if balance >= amount then
					vRP.execute('vRP/del_bank', {account = account, balance = parseInt(amount)})
					return true
				end
			end
		else
			if vRP.getInventoryItemAmount(user_id, 'dinheiro') >= amount then
				vRP.tryGetInventoryItem(user_id, 'dinheiro', amount)
				return true
			end
		end
	end
	return false
end


--[[
function vRP.setInvoice(user_id, price, nuser_id, text)
	vRP.execute('vRP/add_invoice', { user_id = user_id, nuser_id = tostring(nuser_id), date = os.date('%d.%m.%Y'), price = price, text = tostring(text) })
end

function vRP.getInvoice(user_id)
	return vRP.query('vRP/get_invoice', { user_id = user_id })
end

function vRP.getMyInvoice(nuser_id)
	return vRP.query('vRP/get_myinvoice', { nuser_id = nuser_id })
end

function vRP.setFines(user_id, price, nuser_id, text)
	vRP.execute('vRP/add_fines', { user_id = user_id, nuser_id = tostring(nuser_id), date = os.date('%d.%m.%Y'), price = price, text = tostring(text)})
end

function vRP.getFines(user_id)
	return vRP.query('vRP/get_fines', { user_id = user_id })
end

function vRP.setSalary(user_id, price)
	vRP.execute('vRP/add_salary', { user_id = user_id, date = os.date('%d.%m.%Y'), price = price })
end

function vRP.getSalary(user_id)
	return vRP.query('vRP/get_salary', { user_id = user_id })
end
]]