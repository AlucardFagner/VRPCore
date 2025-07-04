-----------------------------------------------------------------------------------------------------------------------------------------
-- Notify
-----------------------------------------------------------------------------------------------------------------------------------------

RegisterNetEvent("Notify")
AddEventHandler("Notify",function(css,prefix,mensagem,delay)
	if not delay then 
		delay = 9000 
	end
	SendNUIMessage({ css = css, prefix = prefix, mensagem = mensagem, delay = delay })
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- ITENSNOTIFY
-----------------------------------------------------------------------------------------------------------------------------------------

RegisterNetEvent("itensNotify")
AddEventHandler("itensNotify",function(mode,mensagem,item)
	SendNUIMessage({ mode = mode, mensagem = mensagem, item = item })
end)

