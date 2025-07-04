local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
local Tools = module("vrp", "lib/Tools")
vRPclient = Tunnel.getInterface('vRP')
vRP = Proxy.getInterface("vRP")
zSERVER = {}
Tunnel.bindInterface("zPolice", zSERVER)

function zSERVER.checkPermission()
    local source = source 
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id, config.Permission) then 
        return true 
    end
    return false
end

function zSERVER.setRegistro(passaporte, dkey, dvalue, img, valor)
    local source = source
    local police_id = vRP.getUserId(source)
    
    if dkey == 'multa' then 
        vRP.execute('vRP/add_fines', { user_id = parseInt(passaporte), nuser_id = parseInt(police_id), date = os.date('%d/%m/%Y'), text = dvalue, price = parseInt(valor), photo = img })
    elseif dkey == 'prisao' then 
        local player = vRP.getUserSource(parseInt(passaporte))
        vRP.setUData(parseInt(passaporte), "vRP:prisao", json.encode(parseInt(valor)))
        if player then
            zClient.setHandcuffed(player, false)
            TriggerClientEvent('zPolice:Prisoner', player, true)
            vRPclient.teleport(player, 1680.1, 2513.0, 45.5)
        end
        zSERVER.PrisonLock(passaporte)
        zClient.playSound(source, "Hack_Success","DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS")
        inPrisao[passaporte] = 0
        vRP.execute('vRP/set_register',{user_id = parseInt(passaporte), police_id = parseInt(police_id), dkey = 'prisao', dvalue = dvalue, img = img, valor = valor, datahora = os.date('%d/%m/%y'), id_pai = nil}) 
    
    elseif dkey == 'ocorrencia' then
        vRP.execute('vRP/set_register',{user_id = parseInt(passaporte), police_id = parseInt(police_id), dkey = 'ocorrencia', dvalue = dvalue, img = img, valor = valor, datahora = os.date('%d/%m/%y'), id_pai = nil}) 
    
    elseif dkey == 'fugitive' then 
        local fugitive = vRP.query('vRP/select', {dkey = 'fugitive', user_id = parseInt(passaporte)})
        if #fugitive > 0 then 
            vRP.execute('vRP/rem_fugitive', {dkey = dkey, user_id = passaporte})
            return
        end
        vRP.execute('vRP/set_register',{user_id = parseInt(passaporte), police_id = parseInt(police_id), dkey = 'fugitive', dvalue = dvalue, img = img, valor = valor, datahora = os.date('%d/%m/%y'), id_pai = nil}) 
    
    elseif dkey == 'ficha' then
        local getficha = vRP.query('vRP/select', {dkey = 'prisao', user_id = parseInt(passaporte)}) 
        local ficha = {}
        for k, v in pairs(getficha) do
            local name = vRP.getInformation(parseInt(v.police_id))
            local oficialPrison = {}
            for a, b in pairs(name) do 
                oficialprison = b.name.. ' '..b.firstname
            end
            table.insert(ficha,{registro = v.id, preso = v.user_id, policial = v.police_id, oficialnameprison = oficialprison, prisonDesc = v.dvalue, img = v.img, datePrison = v.datahora })
        end
        return ficha
    end
    return true
end

function zSERVER.PrisonLock(target_id)
	local player = vRP.getUserSource(parseInt(target_id))
	if player then
		SetTimeout(60000,function()
			local value = vRP.getUData(parseInt(target_id),"vRP:prisao")
			local tempo = json.decode(value) or 0
			if parseInt(tempo) >= 1 then
				TriggerClientEvent("Notify",player,"importante","Ainda vai passar <b>"..parseInt(tempo).." meses</b> preso.",3000)
				vRP.setUData(parseInt(target_id),"vRP:prisao",json.encode(parseInt(tempo)-1))
				zSERVER.PrisonLock(parseInt(target_id))
			elseif parseInt(tempo) == 0 then
				TriggerClientEvent('zPolice:Prisoner',player,false)
				vRPclient.teleport(player,1850.5,2604.0,45.5)
				vRP.setUData(parseInt(target_id),"vRP:prisao",json.encode(-1))
				TriggerClientEvent("Notify",player,"importante","Sua sentença terminou, esperamos não ve-lo novamente.",3000)
			end
			vRPclient.PrisionGod(player)
		end)
	end
end

function zSERVER.getFines(id)
    local consult = vRP.query('vRP/get_bank_id', {user_id = parseInt(id)})
    local fines = {}
    if consult[1] then
        if consult[1].invoices then
            local consult_result = json.decode(consult[1].invoices)
            for k, v in pairs(consult_result) do
                if v.issuer == 'Police' then

                end
            end
        end
    end



    local source = source
    local getfines = vRP.query('vRP/get_fines', {user_id = parseInt(id)})
    local fines = {}
    for k, v in pairs(getfines) do 
        local identity = vRP.getUserIdentity(parseInt(v.nuser_id))
        table.insert(fines, {id = v.id, user_id = v.user_id, nuser_id = v.nuser_id, name = tostring(identity.name..' '..identity.firstname), date = v.date, price = v.price, text = v.text, photo = v.photo})
    end
    return fines
end

function zSERVER.setMulta(id, valor)
    local source = source
    if valor > 0 then

        local value = vRP.getUData(parseInt(id),"vRP:multas")
        local multas = json.decode(value) or 0
        vRP.setUData(parseInt(id), "vRP:multas",json.encode(parseInt(multas) + parseInt(valor)))

        local player = vRP.getUserSource(parseInt(id))
        if player then
            TriggerClientEvent("Notify", player, "importante","Você foi multado no valor de R$" ..vRP.format(parseInt(valor)),3000)
            zClient.playSound(source, "Hack_Success","DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS")
        end
    end
end

function zSERVER.getDatasUser(id, dkey)
    local callback = {}
    local selectAll = vRP.query('vRP/select_all', {dkey = dkey})
    local select = vRP.query('vRP/select', {user_id = id, dkey = dkey})
    if not id then
        for k, v in pairs(selectAll) do 
            local identity = vRP.getInformation(parseInt(v.user_id))
            local identityOficial = vRP.getInformation(parseInt(v.police_id))
            local namefugitive = {}
            local nameoficial = {}
            for a, b in pairs(identity) do 
                namefugitive = b.name..' '..b.firstname
            end
            for c, d in pairs(identityOficial) do 
                nameoficial = d.name..' '..d.firstname
            end
            table.insert(callback,{ registro = v.id, fugitiveid = v.user_id, fugitivename = namefugitive, oficialid = v.police_id, oficialname = nameoficial, desc = v.dvalue, img = v.img, date = v.datahora })
        end
        return callback
    else
        for k, v in pairs(select) do 
            local identity = vRP.getInformation(parseInt(v.user_id))
            local identityOficial = vRP.getInformation(parseInt(v.police_id))
            local namefugitive = {}
            local nameoficial = {}
            for a, b in pairs(identity) do 
                namefugitive = b.name..' '..b.firstname
            end
            for c, d in pairs(identityOficial) do 
                nameoficial = d.name..' '..d.firstname
            end
            table.insert(callback,{ registro = v.id, fugitiveid = v.user_id, fugitivename = namefugitive, oficialid = v.police_id, oficialname = nameoficial, desc = v.dvalue, img = v.img, date = v.datahora })
        end
        return callback
    end
end

function zSERVER.getfugitives(dkey) 
    local callback = {}
    local selectAll = vRP.query('vRP/select_all', {dkey = dkey})
    for k, v in pairs(selectAll) do 
        local identity = vRP.getInformation(parseInt(v.user_id))
        local identityOficial = vRP.getInformation(parseInt(v.police_id))
        local namefugitive = {}
        local nameoficial = {}
        for a, b in pairs(identity) do 
            namefugitive = b.name..' '..b.firstname
        end
        for c, d in pairs(identityOficial) do 
            nameoficial = d.name..' '..d.firstname
        end
        table.insert(callback,{ registro = v.id, fugitiveid = v.user_id, fugitivename = namefugitive, oficialid = v.police_id, oficialname = nameoficial, desc = v.dvalue, img = v.img, date = v.datahora })
    end
    return callback
end

function zSERVER.Identidade(user_id)
    local nplayer = vRP.getUserSource(parseInt(user_id))
    local nuser_id = vRP.getUserId(nplayer)
    local getfines = vRP.getFines(nuser_id)
    if user_id then
        local identity = vRP.getUserIdentity(nuser_id)

        if identity then
            return identity, parseInt(nuser_id), parseInt(getfines)
        end
    end
end

AddEventHandler("vRP:playerSpawn",function(user_id,source,first_spawn)
	local player = vRP.getUserSource(parseInt(user_id))
	if player then
		SetTimeout(30000,function()
			local value = vRP.getUData(parseInt(user_id),"vRP:prisao")
			local tempo = json.decode(value) or -1
			if tempo == -1 then
				return
			end
			if tempo > 0 then
				TriggerClientEvent('zPolice:Prisoner',player,true)
				vRPclient.teleport(player,1680.1,2513.0,46.5)
				zSERVER.PrisonLock(parseInt(user_id))
			end
		end)
	end
end)

RegisterServerEvent("zPolice:ReducePrison")
AddEventHandler("zPolice:ReducePrison",function()
	local source = source
	local user_id = vRP.getUserId(source)
	local value = vRP.getUData(parseInt(user_id),"vRP:prisao")
	local tempo = json.decode(value) or 0
	if tempo >= 20 then
		vRP.setUData(parseInt(user_id),"vRP:prisao",json.encode(parseInt(tempo)-2))
		TriggerClientEvent("Notify",source,"sucesso","Sua pena foi reduzida em <b>2 meses</b>, continue o trabalho.",3000)
	else
		TriggerClientEvent("Notify",source,"negado","Atingiu o limite da redução de pena, não precisa mais trabalhar.",3000)
	end
end)