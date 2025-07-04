Tunnel = module('vrp', 'lib/Tunnel')
Proxy = module('vrp', 'lib/Proxy')
vRP = Proxy.getInterface('vRP')

-- RegisterCommand('anunciar',function(source,args,rawCommand)
--     local user_id = vRP.getUserId(source)
--     local identity = vRP.getUserIdentity(user_id)
--     if vRP.hasPermission(user_id,'gerente.permissao') or vRP.hasPermission(user_id,'administrador.permissao') or vRP.hasPermission(user_id,'moderador.permissao') then
--         local mensagem = vRP.prompt(source,'Mensagem:','')
--         if mensagem == '' then
--             return
--         end
--         TriggerClientEvent('NotifyAdm',-1,identity.name,mensagem)
--     end
-- end)

-- RegisterCommand('anuncio',function(source,args,rawCommand)
--     local user_id = vRP.getUserId(source)
--     local identity = vRP.getUserIdentity(user_id)
-- 	if vRP.tryPayment(user_id,5000) then
--         local mensagem = vRP.prompt(source,'Mensagem:','')
--         if mensagem == '' then
--             return
--         end
--         TriggerClientEvent('NotifyPol',-1,identity.name,mensagem)
--     end
-- end)

-- RegisterCommand('callback',function(source,args,rawCommand)
--     local user_id = vRP.getUserId(source)
--     local identity = vRP.getUserIdentity(user_id)
--     if vRP.hasPermission(user_id,'chat.permissao') then
--         if args[1] then
--         	local id = vRP.getUserSource(parseInt(args[1]))
--             local mensagem = vRP.prompt(source,'Mensagem:','')
--             if mensagem == '' then
--                 return
--             end
--             TriggerClientEvent('NotifyAdmCallback',id,identity.name,mensagem)
--         end
--     end
-- end)

RegisterCommand('noti',function(source,args,rawCommand)
    local source = source
	local user_id = vRP.getUserId(source)
    if user_id then
        TriggerClientEvent("Notify",source,"sucesso","Aqui é porque alguma coisa deu certo, você teve <b>sucesso</b> em sua notificação",18000)
        Wait(2000)
        TriggerClientEvent("Notify",source,"negado","Xiii parece que alguma coisa deu ruim, o resultado deu <b>negado</b>.",18000)
        Wait(2000)
        TriggerClientEvent("Notify",source,"aviso","Essa é uma notificação de <b>aviso</b>, cuidado daqui para frente com o resultado",18000)
        Wait(3000)
        TriggerClientEvent("Notify",source,"importante","Muito <b>importante</b>, preste atenção ao seu redor, observe bem a paisagem!",18000)
    end
end)