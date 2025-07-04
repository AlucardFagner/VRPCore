Proxy = module('vrp', 'lib/Proxy')
Tunnel = module('vrp', 'lib/Tunnel')
vRP = Proxy.getInterface('vRP')

zSERVER = Tunnel.getInterface('zBank')

RegisterNUICallback('closeInterface', function(data, cb)
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'hideInterface'})
end)

RegisterNUICallback('notify', function(data, cb)
    TriggerEvent('Notify', data.status, data.text, 5000)
    TriggerEvent('zBank:close')
end)

RegisterNUICallback('login', function(data, cb)
    local account = zSERVER.login_account(data.username, data.password)
    if account then
        SendNUIMessage({ action = 'showHome', account = account})
    end
end)

RegisterNUICallback('createAccount', function(data, cb)
    zSERVER.create_account(data.username, data.password)
end)

RegisterNUICallback('updatePassword', function(data, cb)
    zSERVER.update_password(data.password)
end)

RegisterNUICallback('requestData', function(data, cb)
    local loans, credits, invoices, balance, loan_available, loan_contracted, credit_available, credit_used, debts, transactions, score, pix = zSERVER.get_account_data(data.account)
    cb({
        loans = loans, 
        credits = credits, 
        invoices = invoices, 
        balance = balance, 
        loan_available = loan_available, 
        loan_contracted = loan_contracted, 
        credit_available = credit_available, 
        credit_used = credit_used,
        debts = debts,
        transactions = transactions,
        score = score,
        pix = pix
    })
end)

RegisterNUICallback('payInvoice', function(data, cb)
    zSERVER.pay_invoice(data.account, data.invoice)
end)

RegisterNUICallback('withdraw', function(data, cb)
    zSERVER.withdraw(data.account, tonumber(data.amount))
end)

RegisterNUICallback('deposit', function(data, cb)
    zSERVER.deposit(data.account, tonumber(data.amount))
end)

RegisterNUICallback('update_pix_key', function(data, cb)
    zSERVER.update_pix_key(data.account, data.key)
end)

RegisterNUICallback('transfer', function(data, cb)
    zSERVER.transfer(data.account, data.key, tonumber(data.amount))
end)

RegisterNUICallback('credit_card', function(data, cb)
    zSERVER.credit_card()
end)

RegisterNetEvent('zBank:open')
AddEventHandler('zBank:open', function()
    local account = zSERVER.check_existent_account()
    if account then
        SetNuiFocus(true, true)
        SendNUIMessage({ action = 'showLogin'})
    else
        SetNuiFocus(true, true)
        SendNUIMessage({ action = 'newAccount'})
    end
end)

RegisterNetEvent('zBank:close')
AddEventHandler('zBank:close', function()
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'hideInterface'})
end)

RegisterNetEvent('zBank:update')
AddEventHandler('zBank:update', function(account)
    SendNUIMessage({ action = 'update', account = account})
end)

Citizen.CreateThread(function()
	SetNuiFocus(false, false)
end)