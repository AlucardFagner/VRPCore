Tunnel = module('vrp', 'lib/Tunnel')
Proxy = module('vrp', 'lib/Proxy')
vRP = Proxy.getInterface('vRP')

zSERVER = {}
Tunnel.bindInterface('zBank', zSERVER)

function get_account_by_user(user_id)
	local consult = vRP.query('vRP/get_account_by_user', {user_id = parseInt(user_id)})
	if consult[1] then
		return consult[1].account
	end
end

function get_account_by_username(username)
	local rows = vRP.query('vRP/get_account_by_username', {username = username})
	if #rows > 0 then
		return rows[1].account, rows[1].password
	else
		return false
	end
end

function get_account_by_pix(pix)
	local rows = vRP.query('vRP/get_account_by_pix', {pix = pix})
	if #rows > 0 then
		return rows[1].account
	else
		return false
	end
end

function get_owner_by_pix(pix)
	local rows = vRP.query('vRP/get_owner_by_pix', {pix = pix})
	if #rows > 0 then
		return rows[1].user_id
	else
		return false
	end
end

function get_account_score(account)
    local rows = vRP.query('vRP/get_account_score', {account = account})
    if #rows > 0 then
		return rows[1].score
	else
		return 0
	end
end

function get_account_pix(account)
    local rows = vRP.query('vRP/get_account_pix', {account = account})
    if #rows > 0 then
		return rows[1].pix
	else
		return 0
	end
end

function get_pix_key(key)
    local rows = vRP.query('vRP/get_pix_key', {pix = key})
    if #rows > 0 then
		return rows[1].pix
	else
		return false
	end
end

function get_account_balance(account)
    local rows = vRP.query('vRP/get_account_balance', {account = account})
    if #rows > 0 then
		return rows[1].balance
	else
		return 0
	end
end

function get_loan_data(account)
	local rows = vRP.query('vRP/get_loan_data', {account = account})
	if #rows > 0 then
		return json.decode(rows[1].loan_data)
	else
		return {}
	end
end

function get_loan_payday(account)
	local rows = vRP.query('vRP/get_loan_payday', {account = account})
	if #rows > 0 then
		return json.decode(rows[1].loan_last_payment)
	else
		return {}
	end
end

function get_loan_available(account)
	local rows = vRP.query('vRP/get_loan_available', {account = account})
	if #rows > 0 then
		return json.decode(rows[1].loan_available)
	else
		return 0
	end
end

function get_loan_contracted(account)
	local rows = vRP.query('vRP/get_loan_contracted', {account = account})
	if #rows > 0 then
		return json.decode(rows[1].loan_contracted)
	else
		return 0
	end
end

function get_credit_data(account)
	local rows = vRP.query('vRP/get_credit_data', {account = account})
	if #rows > 0 then
		return json.decode(rows[1].credit_data)
	else
		return {}
	end
end

function get_credit_payday(account)
	local rows = vRP.query('vRP/get_credit_payday', {account = account})
	if #rows > 0 then
		return json.decode(rows[1].credit_last_payment)
	else
		return {}
	end
end

function get_credit_available(account)
	local rows = vRP.query('vRP/get_credit_available', {account = account})
	if #rows > 0 then
		return json.decode(rows[1].credit_available)
	else
		return 0
	end
end

function get_credit_used(account)
	local rows = vRP.query('vRP/get_credit_used', {account = account})
	if #rows > 0 then
		return json.decode(rows[1].credit_used)
	else
		return 0
	end
end

function get_invoices(account)
    local rows = vRP.query('vRP/get_invoices', {account = account})
	if #rows > 0 then
		return json.decode(rows[1].invoices)
	else
		return {}
	end
end

function get_transactions(account)
	local rows = vRP.query('vRP/get_transactions', {account = account})
	if #rows > 0 then
		return json.decode(rows[1].transactions)
	else
		return {}
	end
end

function zSERVER.check_existent_account()
    local source = source
    local user_id = vRP.getUserId(source)
    local account = get_account_by_user(user_id)
    local result = json.encode(account)
    if result ~= 'null' then
        return true
    else
        return false
    end
end

function zSERVER.update_password(password)
    local source = source
    local user_id = vRP.getUserId(source)
    local account = get_account_by_user(user_id)
    vRP.execute('vRP/insert_account_password', {['password'] = password, ['account'] = account})
    TriggerClientEvent('Notify', source, 'sucesso', 'Senha alterada com sucesso.', 10000)
end

function zSERVER.create_account(username, password)
    local source = source
    local user_id = vRP.getUserId(source)
    local account, password_correct = get_account_by_username(username)
    if account then
        TriggerClientEvent('Notify', source, 'negado', 'Esse usuário já está em uso.', 10000)
        TriggerClientEvent('zBank:close', source)
    else
        vRP.execute('vRP/create_bank_acount', {['user_id'] = user_id, ['balance'] = config.initial_money, ['username'] = username, ['password'] = password })
        Wait(100)
        TriggerClientEvent('zBank:open', source)
    end    
end

function zSERVER.login_account(username, password)
    local source = source
    local account, password_correct = get_account_by_username(username)
    if account then
        if password == password_correct then
            return account
        else
            TriggerClientEvent('Notify', source, 'negado', 'Senha inváliada.', 10000)
            TriggerClientEvent('zBank:close', source)
        end
    else
        TriggerClientEvent('Notify', source, 'negado', 'Usuário inválido ou inexistente.', 10000)
        TriggerClientEvent('zBank:close', source)
    end
end

function addComma(amount)
	local formatted = amount
	while true do  
		formatted, k = string.gsub(formatted, '^(-?%d+)(%d%d%d)', '%1.%2')
		if (k==0) then
		break
		end
	end
	return formatted
end

function get_real_price(price, date)
    local fees = config.invoice_fees
    local reference = os.time{day=os.date('%d', date), year=os.date('%Y', date), month=os.date('%m', date)}
    local daysfrom = os.difftime(os.time(), reference) / (24 * 60 * 60)
    local wholedays = math.floor(daysfrom)
    if wholedays > 0 then
        fees = fees * wholedays
        price = price + fees
    else
        price = price
    end
    return price
end

function update_score_positive(account, date)
    local reference = os.time{day=os.date('%d', date), year=os.date('%Y', date), month=os.date('%m', date)}
    local daysfrom = os.difftime(os.time(), reference) / (24 * 60 * 60)
    local wholedays = math.floor(daysfrom)
    local score = get_account_score(account)
    if wholedays > 0 then
        score = score + math.random(1, 4)
    else
        score = score + math.random(5, 65)
    end
    vRP.execute('vRP/insert_account_score', {['score'] = score, ['account'] = account})
end

function insert_transactions(account, type, text, value)
    local source = source
    local user_id = vRP.getUserId(source)
    local data = get_transactions(account)
    local count = 0
    if data ~= nil then
        local initial = 0
        repeat
            initial = initial + 1
        until data[tostring(initial)] == nil
        initial = tostring(initial)
        data[tostring(initial)] = {['type'] = type, ['text'] = text, ['date'] = os.time(), ['value'] = parseInt(value)}
    else
        data = {[tostring(1)] = {['type'] = type, ['text'] = text, ['date'] = os.time(), ['value'] = parseInt(value)}}
    end
    vRP.execute('vRP/insert_transactions', {['transactions'] = json.encode(data), ['account'] = account})
end

function zSERVER.get_account_data(account)
    local source = source
    local user_id = vRP.getUserId(source)
    local score = 0
    local pix = nil
    local loan_available = get_loan_available(account)
    local loan_contracted = get_loan_contracted(account)
    local credit_available = get_credit_available(account)
    local credit_used = get_credit_used(account)    
    local loan_data = get_loan_data(account)
    local credit_data = get_credit_data(account)
    local invoice_data = get_invoices(account)
    local transactions_data = get_transactions(account)
    local balance = 0
    local debts = 0
    local invoices_debts = 0
    loan_available = loan_available - loan_contracted
    credit_available = credit_available - credit_used
    local loans = {}
    local credits = {}
    local invoices = {}
    local transactions = {}
    if loan_data then
        for k, v in pairs(loan_data) do
            table.insert(loans, {key = k, text = 'Parcela do empréstimo', price = addComma(v.price)})
        end
    end
    if credit_data then
        for k, v in pairs(credit_data) do
            table.insert(credits, {key = k, price = v.price})
        end
    end


    if invoice_data then
        for k, v in pairs(invoice_data) do
            local price = get_real_price(v.price, v.date)
            print(price)

            invoices_debts = invoices_debts + price
            table.insert(invoices, {key = k, price = addComma(price), issuer = v.issuer, date = tostring(os.date('%d/%m/%Y ', v.date)), text = v.text})
        end
    end
    if transactions_data then
        for k, v in pairs(transactions_data) do
            local text = v.text
            if v.issue ~= nil then 
                text = v.text..' <b>'..v.issue..'</b>'
            end
            table.insert(transactions, {value = addComma(v.value), type = v.type, date = tostring(os.date('%d/%m/%Y ', v.date)), text = text})
        end
    end

    pix = get_account_pix(account)

    if pix == nil or pix == '' then
        pix = 'Você ainda não definiu a sua chave pix!'
    end

    score = get_account_score(account)
    balance = get_account_balance(account)
    debts = credit_used + loan_contracted + invoices_debts
    return loans, credits, invoices, addComma(balance), addComma(loan_available), addComma(loan_contracted), addComma(credit_available), addComma(credit_used), addComma(debts), transactions, score, pix
end

function zSERVER.pay_invoice(account, invoice)
    local source = source
    local user_id = vRP.getUserId(source)
    local balance = get_account_balance(account)
    local data = get_invoices(account)
    local new_data = {}
    if parseInt(balance) >= parseInt(data[tostring(invoice)].price) then
        for k, v in pairs(data) do
            if tonumber(k) == tonumber(invoice) then
                local price = get_real_price(v.price, v.date)
                local new_balance = parseInt(balance) - parseInt(price) 
                vRP.execute('vRP/insert_account_balance', {['balance'] = parseInt(new_balance), ['account'] = account})
                insert_transactions(account, 'pay', v.text, price)
                TriggerClientEvent('Notify', source, 'sucesso', 'Pagamento feito com sucesso!', 10000)
                update_score_positive(account, v.date)
                TriggerClientEvent('zBank:update', source, account)
            else
                new_data[k] = {['price'] = v.price, ['issuer'] = v.issuer, ['date'] = v.date, ['text'] = v.text}
            end
        end
        vRP.execute('vRP/insert_invoices', {['invoices'] = json.encode(new_data), ['account'] = account})
    else
        TriggerClientEvent('Notify', source, 'negado', 'Saldo insuficiente', 10000)
    end
end



function zSERVER.withdraw(account, amount)
    local source = source
    local user_id = vRP.getUserId(source)
    if vRP.withdrawCash(user_id, account, amount) then
        TriggerClientEvent('Notify', source, 'sucesso', 'Saque feito com sucesso.', 10000)
        TriggerClientEvent('zBank:update', source, account)
    else
        TriggerClientEvent('Notify', source, 'negado', 'Saldo insuficiente.', 10000)
    end
end

function zSERVER.deposit(account, amount)
    local source = source
    local user_id = vRP.getUserId(source)
    if vRP.depositCash(user_id, account, amount) then
        TriggerClientEvent('Notify', source, 'sucesso', 'Depósito feito com sucesso', 10000)
        TriggerClientEvent('zBank:update', source, account)
    else
        TriggerClientEvent('Notify', source, 'negado', 'Dinheiro insuficiente.', 10000)
    end
end

function zSERVER.transfer(account, pix, amount)
    local source = source
    local user_id = vRP.getUserId(source)
    local target_account = get_account_by_pix(pix)
    local targe_id = get_owner_by_pix(pix)
    if target_account and target_account ~= account then
        if vRP.delBank(account, amount) then
            vRP.addBank(target_account, amount)
            TriggerClientEvent('zBank:update', source, account)
        else
            TriggerClientEvent('Notify', source, 'negado', 'Saldo insuficiente', 10000)
        end
    else
        TriggerClientEvent('Notify', source, 'negado', 'Chave inválida.', 10000)
    end
end



function zSERVER.update_pix_key(account, key)
    local source = source
    local user_id = vRP.getUserId(source)
    local key_data = get_pix_key(key)
    if key ~= '' then
        if key_data then
            TriggerClientEvent('Notify', source, 'negado', 'Essa chave já está em uso', 10000)
        else
            vRP.execute('vRP/insert_account_pix', {['pix'] = key, ['account'] = account})
            TriggerClientEvent('zBank:update', source, account)
        end
    end
end

function zSERVER.credit_card()
    local source = source
    local user_id = vRP.getUserId(source)
    vRP.giveInventoryItem(user_id, 'cartao', 1, false)
end

RegisterServerEvent('zBank:loan_contract')
AddEventHandler('zBank:loan_contract', function(amount, installment)
    local source = source
    local user_id = vRP.getUserId(source)
    local account = get_account_by_user(user_id)
    local data = get_credit_data(account)
    local installment_count = 0
    local division = amount/installment
    local tax_amount = 0
    if installment <= 12 then
        tax_amount = 18
    elseif installment > 12 and installment <= 24 then
        tax_amount = 21
    elseif installment > 24 and installment <= 36 then
        tax_amount = 36
    end
    local tax = parseInt(tax_amount/100*division)
    if data ~= nil then
        for k, v in pairs(data) do
            installment_count = installment_count + 1
            installment = installment - 1
            v.price = parseInt(v.price + division + tax)
        end
        while installment > 0 do
            installment_count = installment_count + 1
            data[installment_count] = {['price'] = parseInt(division + tax)}
            installment = installment - 1
            Citizen.Wait(100)
        end
    else
        data = {[tostring(installment)] = {['price'] = parseInt(division + tax)}}
        installment = installment - 1
        while installment > 0 do
            data[tostring(installment)] = {['price'] = parseInt(division + tax)}
            installment = installment - 1
            Citizen.Wait(100)
        end
        vRP.execute('vRP/insert_loan_payday', {['loan_last_payment'] = os.time(), ['account'] = account})
    end
    vRP.execute('vRP/insert_loan_data', {['loan_data'] = json.encode(data), ['account'] = account})
end)

RegisterServerEvent('zBank:loan_generate_invoice')
AddEventHandler('zBank:loan_generate_invoice', function()
    local source = source
    local user_id = vRP.getUserId(source)
    local account = get_account_by_user(user_id)
    local data = get_loan_data(account)
    local new_data = {}
    for k, v in pairs(data) do
        local key = tonumber(k)
        local new_key = key - 1
        if tonumber(k) == 1 then
            TriggerEvent('zBank:invoice_generate', 'Banco Z', v.price, os.time(), 'Parcela de empréstimo.')
            vRP.execute('vRP/insert_loan_payday', {['loan_last_payment'] = os.time(), ['account'] = account})
        end
        if new_key > 0 then
            new_data[tostring(new_key)] = {['price'] = v.price}
        end
    end
    vRP.execute('vRP/insert_loan_data', {['loan_data'] = json.encode(new_data), ['account'] = account})
end)

RegisterServerEvent('zBank:credit_purchase')
AddEventHandler('zBank:credit_purchase', function(price, installment)
    local source = source
    local user_id = vRP.getUserId(source)
    local account = get_account_by_user(user_id)
    local data = get_credit_data(account)
    local installment_count = 0
    local division = price/installment
    local tax = parseInt(1/100*division)
    if data ~= nil then
        for k, v in pairs(data) do
            installment_count = installment_count + 1
            installment = installment - 1
            v.price = parseInt(v.price + division + tax)
        end
        while installment > 0 do
            installment_count = installment_count + 1
            data[installment_count] = {['price'] = parseInt(division + tax)}
            installment = installment - 1
            Citizen.Wait(1000)
        end
    else
        data = {[tostring(installment)] = {['price'] = parseInt(division + tax)}}
        installment = installment - 1
        while installment > 0 do
            data[tostring(installment)] = {['price'] = parseInt(division + tax)}
            installment = installment - 1
            Citizen.Wait(1000)
        end
        vRP.execute('vRP/insert_credit_payday', {['credit_last_payment'] = os.time(), ['account'] = account})
    end
    vRP.execute('vRP/insert_credit_data', {['credit_data'] = json.encode(data), ['account'] = account})
end)

RegisterServerEvent('zBank:credit_generate_invoice')
AddEventHandler('zBank:credit_generate_invoice', function()
    local source = source
    local user_id = vRP.getUserId(source)
    local account = get_account_by_user(user_id)
    local data = get_credit_data(account)
    local new_data = {}
    for k, v in pairs(data) do
        local key = tonumber(k)
        local new_key = key - 1
        if tonumber(k) == 1 then
            TriggerEvent('zBank:invoice_generate', 'Banco Z', v.price, os.time(), 'Fatura do cartão de crédito.')
            vRP.execute('vRP/insert_credit_payday', {['credit_last_payment'] = os.time(), ['account'] = account})
        end

        if new_key > 0 then
            new_data[tostring(new_key)] = {['price'] = v.price}
        end
    end
    vRP.execute('vRP/insert_credit_data', {['credit_data'] = json.encode(new_data), ['account'] = account})
end)

RegisterServerEvent('zBank:invoice_generate')
AddEventHandler('zBank:invoice_generate', function(user_id, issuer, price, date, text)
    local account = get_account_by_user(user_id)
    local data = get_invoices(account)
    if data ~= nil then
        local initial = 0
        repeat
            initial = initial + 1
        until data[tostring(initial)] == nil
        initial = tostring(initial)
        data[tostring(initial)] = {['issuer'] = issuer, ['price'] = parseInt(price), ['date'] = (date + 24 * 2 * 60 * 60), ['text'] = text}
    else
        data = {[tostring(1)] = {['issuer'] = issuer, ['price'] = parseInt(price), ['date'] = (date + 24 * 2 * 60 * 60), ['text'] = text}}
    end
    vRP.execute('vRP/insert_invoices', {['invoices'] = json.encode(data), ['account'] = account})
end)

RegisterCommand('bak', function()
    local account = get_account_by_user(user_id)
    print(account)
    local loan_last_payday = get_loan_payday(account)
    print(loan_last_payday)
    local credit_last_payday = get_credit_payday(account)
    print(credit_last_payday)
end)

RegisterServerEvent('zBank:init')
AddEventHandler('zBank:init', function(user_id)
    local account = get_account_by_user(user_id)
    if account ~= nil then
        local loan_last_payday = get_loan_payday(account)
        local credit_last_payday = get_credit_payday(account)
        if loan_last_payday ~= nil then
            if os.time() >= (loan_last_payday + 24 * 5 * 60 * 60) then
                TriggerEvent('zBank:loan_generate_invoice')
                vRP.execute('vRP/insert_loan_payday', {['loan_last_payment'] = os.time(), ['account'] = account})
            end
        end
        if credit_last_payday ~= nil then
            if os.time() >= (credit_last_payday + 24 * 5 * 60 * 60) then
                TriggerEvent('zBank:credit_generate_invoice')
                vRP.execute('vRP/insert_credit_payday', {['credit_last_payment'] = os.time(), ['account'] = account})
            end
        end
    end
end)