local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")


z = {}
Tunnel.bindInterface('zADMIN', z)
zCLIENT = Tunnel.getInterface('zADMIN')
zSurvival = Tunnel.getInterface('zSurvival')
zInventory = Tunnel.getInterface('zInventory')

RegisterCommand('createChest',function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id, config.commands['createChest']['permissions'][1]) or vRP.hasPermission(user_id, config.commands['createChest']['permissions'][2]) or vRP.hasPermission(user_id, config.commands['createChest']['permissions'][3]) then
		local x,y,z = vRPclient.getPositions(source)

		local nome = vRP.prompt(source,'Nome do chest?','')
		if nome == '' then
			return
		end

		local perm = vRP.prompt(source,'Permissao do chest?','')
		if perm == '' then
			return
		end

		local peso = vRP.prompt(source,'Capacidade do chest (Peso)?','')
		if peso == '' then
			return
		end

		local tamanho = vRP.prompt(source,'Tamanho do chest (Slots)?','')
			if tamanho == '' then
				return
			end

			zInventory.insertTable(-1, nome, { x, y, z })
		vRP.execute('vRP/addChest', { permission = perm, name = nome, x = x, y = y, z = z, weight = peso, slots = tamanho })
	end
end)

RegisterCommand(config.commands['revive'].cmd, function(source, args)
	local _source = source
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local steam = vRP.getSteam(source)
	local discord = vRP.getDiscord(source)
    if vRP.hasPermission(user_id, config.commands['revive']['permissions'][1]) or vRP.hasPermission(user_id, config.commands['revive']['permissions'][2]) or vRP.hasPermission(user_id, config.commands['revive']['permissions'][3]) then
		if args[1] then
			local nplayer = vRP.getUserSource(parseInt(args[1]))
			if nplayer then
				local nuser_id = vRP.getUserId(nplayer)
				local nuidentity = vRP.getUserIdentity(nuser_id)
				TriggerClientEvent('resetBleeding', nplayer)
				TriggerClientEvent('resetDiagnostic', nplayer)
                zSurvival._revivePlayer(nplayer, 400)
				vRP.upgradeThirst(nuser_id, 15)
				vRP.upgradeHunger(nuser_id, 15)
				vRP.upgradeStress(nuser_id, -100)
				local nusteam = vRP.getSteam(nplayer)
				local nudiscord = vRP.getDiscord(nplayer)
				local w_steam = string.sub(steam, 7)
				local w_discord = string.sub(discord, 9)
				local w_nusteam = string.sub(nusteam, 7)
				local w_nudiscord = string.sub(nudiscord, 9)
				local w_ip = vRP.getPlayerEndpoint(source)
				local w_title = 'REGISTRO DE REVIVER:'
				local w_description = ''
				local w_fields = {
					{ 
						name = 'EQUIPE:',
						value = '```'..identity.name..' '..identity.firstname..' ['..user_id..']```⠀'
					},
					{ 
						name = 'PLAYER:',
						value = '```'..nuidentity.name..' '..nuidentity.firstname..' ['..nuser_id..']```⠀' 
					},
					{ 
						name = 'IDENTIFICAÇÃO:',
						value = 'Equipe: <@'..w_discord..'> - `Steam:'..w_steam..'`\n Player: <@'..w_nudiscord..'> - `Steam:'..w_nusteam..'`'
					},
					{ 
						name = '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━', 
						value = '⠀'
					}
				}
				vRP.sendWebhook(config.commands['revive'].webhoook, w_title, w_description, w_fields)
            end
			TriggerClientEvent('zSurvival:PlayerRevive',nplayer)
		else
			TriggerClientEvent('resetBleeding', source)
			TriggerClientEvent('resetDiagnostic', source)
            zSurvival._revivePlayer(source, 400)
			vRP.upgradeThirst(user_id, 100)
			vRP.upgradeHunger(user_id, 100)
			vRP.upgradeStress(user_id, -100)
			local w_steam = string.sub(steam, 7)
			local w_discord = string.sub(discord, 9)
			local w_title = 'REGISTRO DE REVIVER:'
			local w_description = ''
			local w_fields = {
				{ 
					name = 'EQUIPE:',
					value = '```'..identity.name..' '..identity.firstname..' ['..user_id..'] ```⠀'
				},
				{ 
					name = 'IDENTIFICAÇÃO:',
					value = '<@'..w_discord..'> - `Steam:'..w_steam..'`⠀'
				},
				{ 
					name = '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━', 
					value = '⠀'
				}
			}
			vRP.sendWebhook(config.commands['revive'].webhoook, w_title, w_description, w_fields)
        end
		TriggerClientEvent('zSurvival:PlayerRevive',source)
    end
end)

RegisterCommand(config.commands['matar'].cmd, function(source, args)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local steam = vRP.getSteam(source)
	local discord = vRP.getDiscord(source)
    if vRP.hasPermission(user_id, config.commands['matar']['permissions'][1]) or vRP.hasPermission(user_id, config.commands['matar']['permissions'][2]) or vRP.hasPermission(user_id, config.commands['matar']['permissions'][3]) then
		if args[1] then
			local nplayer = vRP.getUserSource(parseInt(args[1]))
			if nplayer then
				local nuser_id = vRP.getUserId(nplayer)
				local nuidentity = vRP.getUserIdentity(nuser_id)
				TriggerClientEvent('resetBleeding', nplayer)
				TriggerClientEvent('resetDiagnostic', nplayer)
                zSurvival._revivePlayer(nplayer, 0)
				vRP.upgradeThirst(nuser_id, 0)
				vRP.upgradeHunger(nuser_id, 0)
				vRP.upgradeStress(nuser_id, -100)
				local nusteam = vRP.getSteam(nplayer)
				local nudiscord = vRP.getDiscord(nplayer)
				local w_steam = string.sub(steam, 7)
				local w_discord = string.sub(discord, 9)
				local w_nusteam = string.sub(nusteam, 7)
				local w_nudiscord = string.sub(nudiscord, 9)
				local w_ip = vRP.getPlayerEndpoint(source)
				local w_title = 'REGISTRO DE REVIVER:'
				local w_description = ''
				local w_fields = {
					{ 
						name = 'EQUIPE:',
						value = '```'..identity.name..' '..identity.firstname..' ['..user_id..']```⠀'
					},
					{ 
						name = 'PLAYER:',
						value = '```'..nuidentity.name..' '..nuidentity.firstname..' ['..nuser_id..']```⠀' 
					},
					{ 
						name = 'IDENTIFICAÇÃO:',
						value = 'Equipe: <@'..w_discord..'> - `Steam:'..w_steam..'`\n Player: <@'..w_nudiscord..'> - `Steam:'..w_nusteam..'`'
					},
					{ 
						name = '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━', 
						value = '⠀'
					}
				}
				vRP.sendWebhook(config.commands['matar'].webhoook, w_title, w_description, w_fields)
            end
		else
			TriggerClientEvent('resetBleeding', source)
			TriggerClientEvent('resetDiagnostic', source)
            zSurvival._revivePlayer(source, 0)
			vRP.upgradeThirst(user_id, 0)
			vRP.upgradeHunger(user_id, 0)
			vRP.upgradeStress(user_id, -100)
			local w_steam = string.sub(steam, 7)
			local w_discord = string.sub(discord, 9)
			local w_title = 'REGISTRO DE REVIVER:'
			local w_description = ''
			local w_fields = {
				{ 
					name = 'EQUIPE:',
					value = '```'..identity.name..' '..identity.firstname..' ['..user_id..'] ```⠀'
				},
				{ 
					name = 'IDENTIFICAÇÃO:',
					value = '<@'..w_discord..'> - `Steam:'..w_steam..'`⠀'
				},
				{ 
					name = '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━', 
					value = '⠀'
				}
			}
			vRP.sendWebhook(config.commands['matar'].webhoook, w_title, w_description, w_fields)
        end
    end
end)

RegisterCommand(config.commands['skin'].cmd, function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local steam = vRP.getSteam(source)
	local discord = vRP.getDiscord(source)
	if vRP.hasPermission(user_id, config.commands['skin']['permissions'][1]) or vRP.hasPermission(user_id, config.commands['skin']['permissions'][2]) or vRP.hasPermission(user_id, config.commands['skin']['permissions'][3]) then
		TriggerClientEvent('skinmenu', args[1], args[2])
		TriggerClientEvent('Notify', source, 'negado', 'Voce setou a skin <b>'..args[2]..'</b> no passaporte <b>'..parseInt(args[1])..'</b>.', 5000)
		local nplayer = vRP.getUserSource(parseInt(args[1]))
		local nuser_id = vRP.getUserId(nplayer)
		local nuidentity = vRP.getUserIdentity(nuser_id)
		local w_nusteam = string.sub(nusteam, 7)
		local w_nudiscord = string.sub(nudiscord, 9)
		local w_steam = string.sub(steam, 7)
		local w_discord = string.sub(discord, 9)
		local w_title = 'REGISTRO DE PERSONAGEM:'
		local w_description = ''
		local w_fields = {
			{ 
				name = 'EQUIPE:',
				value = '```'..identity.name..' '..identity.firstname..' ['..user_id..'] ```⠀'
			},
			{
				name = 'PLAYER:',
				value = '```PERSONAGEM: '..args[2]' - '..nuidentity.name..': ['..nuser_id..'] ``` '	
			},
			{ 
				name = 'IDENTIFICAÇÃO:',
				value = 'Equipe: <@'..w_discord..'> - `Steam:'..w_steam..'`\nPlayer: <@'..w_nudiscord..'> - `Steam:'..w_nusteam..'`'
			},
			{ 
				name = '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━', 
				value = '⠀'
			}
		}
		vRP.sendWebhook(config.commands['skin'].webhook, w_title, w_description, w_fields)
	end
end)

RegisterCommand(config.commands['item'].cmd, function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local steam = vRP.getSteam(source)
	local discord = vRP.getDiscord(source)
	if user_id then
		if vRP.hasPermission(user_id, config.commands['item']['permissions'][1]) or vRP.hasPermission(user_id, config.commands['item']['permissions'][2]) or vRP.hasPermission(user_id, config.commands['item']['permissions'][3]) then
			
			if args[1] and args[2] and vRP.itemNameList(args[1]) ~= nil then
				
				if args[3] then
					vRP.giveInventoryItem(user_id, args[1], parseInt(args[2]), true, parseInt(args[3]))
				else
					vRP.giveInventoryItem(user_id, args[1], parseInt(args[2]), true)
				end

				local w_steam = string.sub(steam, 7)
				local w_discord = string.sub(discord, 9)
				local w_ip = vRP.getPlayerEndpoint(source)
				local w_title = 'REGISTRO DE ITEM:'
				local w_description = ''
				local w_fields = {
				{ 
					name = 'EQUIPE:',
					value = '```'..identity.name..' '..identity.firstname..' ['..user_id..'] ```⠀'
				},
				{
					name = 'ITEM:',
					value = '```'..args[1]..' '..args[2]..'x ```'
				},
				{ 
					name = 'IDENTIFICAÇÃO:',
					value = 'Equipe: <@'..w_discord..'> - `Steam:'..w_steam..'`'
				},
				{ 
					name = '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━', 
					value = '⠀'
				}
			}
			vRP.sendWebhook(config.commands['item'].webhook, w_title, w_description, w_fields)
			end
		end
	end
end)

RegisterCommand('itemall', function(source, args, rawCommand)  -- ARRUMAR
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local steam = vRP.getSteam(source)
	local discord = vRP.getDiscord(source)

	if user_id then
		if vRP.hasPermission(user_id, config.commands['itemall']['permissions'][1]) or vRP.hasPermission(user_id, config.commands['itemall']['permissions'][2]) or vRP.hasPermission(user_id, config.commands['itemall']['permissions'][3]) then
			local users = vRP.getUsers()
			for k, v in pairs(users) do
				vRP.giveInventoryItem(parseInt(k), tostring(args[1]), parseInt(args[2]), true)
				local w_steam = string.sub(steam, 7)
				local w_discord = string.sub(discord, 9)
				local w_ip = vRP.getPlayerEndpoint(source)
				local w_title = 'REGISTRO DE ITEM ALL:'
				local w_description = ''
				local w_fields = {
					{ 
						name = 'EQUIPE:',
						value = '```'..identity.name..' '..identity.firstname..' ['..user_id..'] ```⠀'
					},
					{
						name = 'ITEM:',
						value = '```'..args[1]..' '..args[2]..'x```⠀'
					},
					{
						name = 'IDS:',
						value = '```'..users..' ```⠀'
					},
					{ 
						name = 'IDENTIFICAÇÃO:',
						value = 'Equipe: <@'..w_discord..'> - `Steam:'..w_steam..'` \n⠀'
					},
					{ 
						name = '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━', 
						value = '⠀'
					}
				}
				vRP.sendWebhook(config.commands['itemall'].webhook, w_title, w_description, w_fields)
			end
		end
	end
end)

RegisterCommand(config.commands['debug'].cmd, function(source, args, rawCommand)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id, config.commands['debug']['permissions'][1]) or vRP.hasPermission(user_id, config.commands['debug']['permissions'][2]) or vRP.hasPermission(user_id, config.commands['debug']['permissions'][3]) then
			TriggerClientEvent('ToggleDebug', source)
		end
	end
end)

RegisterCommand(config.commands['updateplate'].cmd, function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local steam = vRP.getSteam(source)
	local discord = vRP.getDiscord(source)
	if user_id then
		if vRP.hasPermission(user_id, config.commands['updateplate']['permissions'][1]) or vRP.hasPermission(user_id, config.commands['updateplate']['permissions'][2]) or vRP.hasPermission(user_id, config.commands['updateplate']['permissions'][3]) and args[1] and args[2] and args[3] then
			local nplayer = vRP.getUserSource(parseInt(args[1]))
				if nplayer then
					vRP.execute('vRP/update_plate_vehicle', { user_id = parseInt(args[1]), vehicle = args[2], plate = args[3] })
					local nuser_id = vRP.getUserId(nplayer)
					local nuidentity = vRP.getUserIdentity(nuser_id)
					local nusteam = vRP.getSteam(nplayer)
					local nudiscord = vRP.getDiscord(nplayer)
					local w_nusteam = string.sub(nusteam, 7)
					local w_nudiscord = string.sub(nudiscord, 9)
					local w_steam = string.sub(steam, 7)
					local w_discord = string.sub(discord, 9)
					local w_ip = vRP.getPlayerEndpoint(source)
					local w_title = 'REGISTRO DE ALTERAÇÃO DE PLACA:'
					local w_description = ''
					local w_fields = {
					{ 
						name = 'EQUIPE:',
						value = '```'..identity.name..' '..identity.firstname..' ['..user_id..'] ``` '
					},
					{
						name = 'PLAYER:',
						value = '```'..nuidentity.name..' ['..nuser_id..']\nVeículo: '..args[2]..' - Placa: ' ..args[3]..' ``` '
					},
					{ 
						name = 'IDENTIFICAÇÃO:',
						value = 'Equipe: <@'..w_discord..'> - `Steam:'..w_steam..'`\nPlayer: <@'..w_nudiscord..'> - `Steam:'..w_nusteam..'`'
					},
					{ 
						name = '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━', 
						value = '⠀'
					}
				}
				vRP.sendWebhook(config.commands['updateplate'].webhook, w_title, w_description, w_fields)
			end
		end
	end
end)

RegisterCommand(config.commands['addvehicle'].cmd, function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local steam = vRP.getSteam(source)
	local discord = vRP.getDiscord(source)
	if user_id then
		if vRP.hasPermission(user_id, config.commands['addvehicle']['permissions'][1]) or vRP.hasPermission(user_id, config.commands['addvehicle']['permissions'][2]) or vRP.hasPermission(user_id, config.commands['addvehicle']['permissions'][3]) and args[1] and args[2] then
			local nplayer = vRP.getUserSource(parseInt(args[1]))
				if nplayer then
					if vRP.execute('vRP/add_vehicle', { user_id = parseInt(args[1]), vehicle = args[2], plate = vRP.generatePlateNumber(), tax = os.time() }) then
						TriggerClientEvent('Notify', nplayer, 'importante', 'Voce recebeu <b>'..args[2]..'</b> em sua garagem.', 5000)
						TriggerClientEvent('Notify', source, 'importante', 'Adicionou o veiculo: <b>'..args[2]..'</b> no ID:<b>'..args[1]..'</b.', 5000)
						local nuser_id = vRP.getUserId(nplayer)
						local nuidentity = vRP.getUserIdentity(nuser_id)
						local nusteam = vRP.getSteam(nplayer)
						local nudiscord = vRP.getDiscord(nplayer)
						local w_nusteam = string.sub(nusteam, 7)
						local w_nudiscord = string.sub(nudiscord, 9)
						local w_steam = string.sub(steam, 7)
						local w_discord = string.sub(discord, 9)
						local w_title = 'REGISTRO DE ADDCAR:'
						local w_description = ''
						local w_fields = {
						{ 
							name = 'EQUIPE:',
							value = '```'..identity.name..' '..identity.firstname..' ['..user_id..'] ```⠀'
						},
						{
							name = 'PLAYER:',
							value = '```'..nuidentity.name..' '..nuidentity.firstname..' ['..nuser_id..'] \nVeículo: '..args[2]..' ``` ' 
						},
						{ 
							name = 'IDENTIFICAÇÃO:',
							value = 'Equipe: <@'..w_discord..'> - `Steam:'..w_steam..'`\nPlayer:<@'..w_nudiscord..'> - `Steam:'..w_nusteam..'`'
						},
						{ 
							name = '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━', 
							value = '⠀'
						}
						}
					end
				vRP.sendWebhook(config.commands['addvehicle'].webhook, w_title, w_description, w_fields)
			end
		end
	end
end)

RegisterCommand(config.commands['remvehicle'].cmd, function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local steam = vRP.getSteam(source)
	local discord = vRP.getDiscord(source)
	if user_id then
		if vRP.hasPermission(user_id, config.commands['remvehicle']['permissions'][1]) or vRP.hasPermission(user_id, config.commands['remvehicle']['permissions'][2]) or vRP.hasPermission(user_id, config.commands['remvehicle']['permissions'][3]) and args[1] and args[2] then
			local nplayer = vRP.getUserSource(parseInt(args[1]))
				if nplayer then
					vRP.execute('vRP/rem_vehicle', { user_id = parseInt(args[1]), vehicle = args[2]})
					TriggerClientEvent('Notify', nplayer, 'importante', 'Seu carro <b>'..args[2]..'</b> foi removido da sua garagem.', 5000)
					TriggerClientEvent('Notify', source, 'importante', 'Removeu o veiculo: <b>'..args[2]..'</b> do ID:<b>'..args[1]..'</b.', 5000)
					
					local nuser_id = vRP.getUserId(nplayer)
					local nuidentity = vRP.getUserIdentity(nuser_id)

					local nusteam = vRP.getSteam(nplayer)
					local nudiscord = vRP.getDiscord(nplayer)

					local w_steam = string.sub(steam, 7)
					local w_discord = string.sub(discord, 9)

					local w_nusteam = string.sub(nusteam, 7)
					local w_nudiscord = string.sub(nudiscord, 9)

					local w_title = 'REGISTRO DE REMCAR:'
					local w_description = ''
					local w_fields = {
					{ 
						name = 'EQUIPE:',
						value = '```'..identity.name..' '..identity.firstname..' ['..user_id..'] ```⠀'
					},
					{
						name = 'PLAYER:',
						value = '```'..nuidentity.name..' '..nuidentity.firstname..' ['..nuser_id..'] \nVeículo: '..args[2]..' ``` ' 
					},
					{ 
						name = 'IDENTIFICAÇÃO:',
						value = 'Equipe: <@'..w_discord..'> - `Steam:'..w_steam..'`\nPlayer:<@'..w_nudiscord..'> - `Steam:'..w_nusteam..'`'
					},
					{ 
						name = '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━', 
						value = '⠀'
					}
				}
				vRP.sendWebhook(config.commands['remvehicle'].webhook, w_title, w_description, w_fields)
			end
		end
	end
end)


RegisterCommand(config.commands['hood'].cmd, function(source, args, rawCommand)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id, config.commands['hood']['permissions'][1]) or vRP.hasPermission(user_id, config.commands['hood']['permissions'][2]) or vRP.hasPermission(user_id, config.commands['hood']['permissions'][3]) and args[1] then
			TriggerClientEvent('zCore_hud:toggleHood', source, args[1])
		end
	end
end)

RegisterCommand(config.commands['kick'].cmd, function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local steam = vRP.getSteam(source)
	local discord = vRP.getDiscord(source)

	if user_id then
		if vRP.hasPermission(user_id, config.commands['kick']['permissions'][1]) or vRP.hasPermission(user_id, config.commands['kick']['permissions'][2]) or vRP.hasPermission(user_id, config.commands['kick']['permissions'][3]) and parseInt(args[1]) > 0 then
			local nplayer = vRP.getUserSource(parseInt(args[1]))
				if nplayer then
					local nuser_id = vRP.getUserId(nplayer)
					local nuidentity = vRP.getUserIdentity(nuser_id)

					local nusteam = vRP.getSteam(nplayer)
					local nudiscord = vRP.getDiscord(nplayer)
					
					local w_nusteam = string.sub(nusteam, 7)
					local w_nudiscord = string.sub(nudiscord, 9)

					local w_steam = string.sub(steam, 7)
					local w_discord = string.sub(discord, 9)

					local w_title = 'REGISTRO DE KICK:'
					local w_description = ''
					local w_fields = {
					{ 
						name = 'PLAYER:',
						value = '```'..nuidentity.name..' '..nuidentity.firstname..'  ['..nuser_id..'] ```⠀'
					},
					{ 
						name = 'EQUIPE:',
						value = '```'..identity.name..' '..identity.firstname..' ['..user_id..']```⠀'
					},
					{ 
						name = 'IDENTIFICAÇÃO:',
						value = 'Equipe: <@'..w_discord..'> - `Steam:'..w_steam..'`\nPlayer:<@'..w_nudiscord..'> - `Steam:'..w_nusteam..'`'
					},
					{ 
						name = '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━', 
						value = '⠀'
					}
				}
				vRP.sendWebhook(config.commands['kick'].webhook, w_title, w_description, w_fields)
				vRP.kick(parseInt(args[1]), 'Você foi expulso da cidade.')
			end
		end
	end
end)

RegisterCommand(config.commands['ban'].cmd, function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local steam = vRP.getSteam(source)
	local discord = vRP.getDiscord(source)

	if user_id then
		if vRP.hasPermission(user_id, config.commands['ban']['permissions'][1]) or vRP.hasPermission(user_id, config.commands['ban']['permissions'][2]) or vRP.hasPermission(user_id, config.commands['ban']['permissions'][3]) and parseInt(args[1]) > 0 then
			local nuidentity = vRP.getUserIdentity(parseInt(args[1]))
			if identity and nuidentity then
				vRP.execute('vRP/set_banned', { steam = tostring(nuidentity.steam), banned = 1 })

				local nplayer = vRP.getUserSource(parseInt(args[1]))
				local nusteam = vRP.getSteam(nplayer)
				local nudiscord = vRP.getDiscord(nplayer)
				local w_nusteam = string.sub(nusteam, 7)
				local w_nudiscord = string.sub(nudiscord, 9)

				local w_steam = string.sub(steam, 7)
				local w_discord = string.sub(discord, 9)
				local w_ip = vRP.getPlayerEndpoint(source)
				local w_title = 'REGISTRO DE BAN:'
				local w_description = ''
				local w_fields = {
				{ 
					name = 'EQUIPE:',
					value = '```'..identity.name..' '..identity.firstname..' ['..user_id..']```'
				},
				{
					name = 'PLAYER:',
					value = '```'..nuidentity.name..' '..nuidentity.firstname..' ['..args[1]..']```' 
				},
				{ 
					name = 'IDENTIFICAÇÃO:',
					value = 'Equipe: <@'..w_discord..'> - `Steam:'..w_steam..'`\nPlayer: <@'..w_nudiscord..'> - `Steam:'..w_nusteam..'`'
				},
				{ 
					name = '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━', 
					value = '⠀'
				}
			}
			vRP.sendWebhook(config.commands['ban'].webhook, w_title, w_description, w_fields)
			vRP.kick(parseInt(args[1]), 'Você foi banido da cidade.')
			end
		end
	end
end)

RegisterCommand(config.commands['unban'].cmd, function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local steam = vRP.getSteam(source)
	local discord = vRP.getDiscord(source)

	if user_id then
		if vRP.hasPermission(user_id, config.commands['unban']['permissions'][1]) or vRP.hasPermission(user_id, config.commands['unban']['permissions'][2]) or vRP.hasPermission(user_id, config.commands['unban']['permissions'][3]) and parseInt(args[1]) > 0 then
			local nuidentity = vRP.getUserIdentity(parseInt(args[1]))
			if identity and nuidentity then
				vRP.execute('vRP/set_banned', { steam = tostring(nuidentity.steam), banned = 0 })

				local nplayer = vRP.getUserSource(parseInt(args[1]))
				local nusteam = vRP.getSteam(nplayer)
				local nudiscord = vRP.getDiscord(nplayer)
				local w_nusteam = string.sub(nusteam, 7)
				local w_nudiscord = string.sub(nudiscord, 9)
	
				local w_steam = string.sub(steam, 7)
				local w_discord = string.sub(discord, 9)
				local w_ip = vRP.getPlayerEndpoint(source)
				local w_title = 'REGISTRO DE UNBAN:'
				local w_description = ''
				local w_fields = {
					{ 
						name = 'EQUIPE:',
						value = '```'..identity.name..' '..identity.firstname..' ['..user_id..']```'
					},
					{
						name = 'PLAYER:',
						value = '```'..nuidentity.name..' '..nuidentity.firstname..' ['..args[1]..']```' 
					},
					{ 
						name = 'IDENTIFICAÇÃO:',
						value = 'Equipe: <@'..w_discord..'> - `Steam:'..w_steam..'`\nPlayer: <@'..w_nudiscord..'> - `Steam:'..w_nusteam..'`'
					},
					{ 
						name = '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━', 
						value = '⠀'
					}
				}
				vRP.sendWebhook(config.commands['unban'].webhook, w_title, w_description, w_fields)
			end
		end
	end
end)

RegisterCommand(config.commands['whitelist'].cmd, function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local steam = vRP.getSteam(source)
	local discord = vRP.getDiscord(source)

	if user_id then
		local nuidentity = vRP.getUserIdentity(parseInt(args[1]))
			if identity and nuidentity then
				if vRP.hasPermission(user_id, config.commands['whitelist']['permissions'][1]) or vRP.hasPermission(user_id, config.commands['whitelist']['permissions'][2]) or vRP.hasPermission(user_id, config.commands['whitelist']['permissions'][3]) then
					vRP.execute('vRP/set_whitelist', { steam = tostring(nuidentity.steam), whitelist = 1 })

					local nplayer = vRP.getUserSource(parseInt(args[1]))
					local nusteam = vRP.getSteam(nplayer)
					local nudiscord = vRP.getDiscord(nplayer)
					local w_nusteam = string.sub(nusteam, 7)
					local w_nudiscord = string.sub(nudiscord, 9)

					local w_steam = string.sub(steam, 7)
					local w_discord = string.sub(discord, 9)
					local w_ip = vRP.getPlayerEndpoint(source)
					local w_title = 'REGISTRO DE WL:⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n⠀'
					local w_description = ''
					local w_fields = {
					{ 
						name = 'EQUIPE:',
						value = '```'..identity.name..' '..identity.firstname..' ['..user_id..']```'
					},
					{
						name = 'PLAYER:',
						value = '```'..nuidentity.name..' '..nuidentity.firstname..' ['..args[1]..']```' 
					},
					{ 
						name = 'IDENTIFICAÇÃO:',
						value = 'Equipe: <@'..w_discord..'> - `Steam:'..w_steam..'`\nPlayer: <@'..w_nudiscord..'> - `Steam:'..w_nusteam..'`'
					},
					{ 
						name = '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━', 
						value = '⠀'
					}
				}
				vRP.sendWebhook(config.commands['whitelist'].webhook, w_title, w_description, w_fields)
			end
		end
	end
end)

RegisterCommand(config.commands['unwhitelist'].cmd, function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local steam = vRP.getSteam(source)
	local discord = vRP.getDiscord(source)

	if user_id then
		if vRP.hasPermission(user_id, config.commands['unwhitelist']['permissions'][1]) or vRP.hasPermission(user_id, config.commands['unwhitelist']['permissions'][2]) or vRP.hasPermission(user_id, config.commands['unwhitelist']['permissions'][3]) and parseInt(args[1]) > 0 then
			local nuidentity = vRP.getUserIdentity(parseInt(args[1]))
				if identity and nuidentity then
					vRP.execute('vRP/set_whitelist', { steam = tostring(nuidentity.steam), whitelist = 0 })

					local nplayer = vRP.getUserSource(parseInt(args[1]))
					local nusteam = vRP.getSteam(nplayer)
					local nudiscord = vRP.getDiscord(nplayer)
					local w_nusteam = string.sub(nusteam, 7)
					local w_nudiscord = string.sub(nudiscord, 9)

					local w_steam = string.sub(steam, 7)
					local w_discord = string.sub(discord, 9)
					local w_ip = vRP.getPlayerEndpoint(source)
					local w_title = 'REGISTRO DE UNWL:⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n⠀'
					local w_description = ''
					local w_fields = {
					{ 
						name = 'EQUIPE:',
						value = '```'..identity.name..' '..identity.firstname..' ['..user_id..']```'
					},
					{
						name = 'PLAYER:',
						value = '```'..nuidentity.name..' '..nuidentity.firstname..' ['..args[1]..']```' 
					},
					{ 
						name = 'IDENTIFICAÇÃO:',
						value = 'Equipe: <@'..w_discord..'> - `Steam:'..w_steam..'`\nPlayer: <@'..w_nudiscord..'> - `Steam:'..w_nusteam..'`'
					},
					{ 
						name = '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━', 
						value = '⠀'
					}
				}
				vRP.sendWebhook(config.commands['unwhitelist'].webhook, w_title, w_description, w_fields)
				vRP.kick(parseInt(args[1]), 'Você foi expulso da cidade.')
			end
		end
	end
end)

RegisterCommand('coins', function(source, args, rawCommand) -- NÃO TA FUNCIONANDO
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local steam = vRP.getSteam(source)
	local discord = vRP.getDiscord(source)

	if user_id then
		if vRP.hasPermission(user_id, 'gerente') and parseInt(args[1]) > 0 and parseInt(args[2]) > 0 then
			local nuidentity = vRP.getUserIdentity(parseInt(args[1]))
				if identity and nuidentity then
					vRP.addGmsId(args[1], args[2])
					TriggerClientEvent('Notify', source, 'importante', 'Coins entregues para '..nuidentity.name..' | ID: '..args[1]..'.', 5000)

					local nplayer = vRP.getUserSource(parseInt(args[1]))
					local nusteam = vRP.getSteam(nplayer)
					local nudiscord = vRP.getDiscord(nplayer)
					local w_nusteam = string.sub(nusteam, 7)
					local w_nudiscord = string.sub(nudiscord, 9)

					local w_steam = string.sub(steam, 7)
					local w_discord = string.sub(discord, 9)
					local w_ip = vRP.getPlayerEndpoint(source)
					local w_title = 'REGISTRO ALTERAÇÃO DE COINS:'
					local w_description = ''
					local w_fields = {
					{ 
						name = 'EQUIPE:',
						value = '```'..identity.name..' '..identity.firstname..' ['..user_id..']```'
					},
					{
						name = 'PLAYER:',
						value = '```'..nuidentity.name..' '..nuidentity.firstname..' ['..args[1]..'] \nCoins:'..args[2]..'x```' 
					},
					{ 
						name = 'IDENTIFICAÇÃO:',
						value = 'Equipe: <@'..w_discord..'> - `Steam:'..w_steam..'`\nPlayer: <@'..w_nudiscord..'> - `Steam:'..w_nusteam..'`'
					},
					{ 
						name = '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━', 
						value = '⠀'
					}
				}
				vRP.sendWebhook(webhookCoins, w_title, w_description, w_fields)
			end
		end
	end
end)

RegisterCommand(config.commands['tpcds'].cmd, function(source, args)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id, config.commands['tpcds']['permissions'][1]) or vRP.hasPermission(user_id, config.commands['tpcds']['permissions'][2]) or vRP.hasPermission(user_id, config.commands['tpcds']['permissions'][3]) then
		local tcoords = vRP.prompt(source, 'Message:', '')
		if tcoords == '' then
			return
		end
		
		local coords = {}
		for coord in string.gmatch(tcoords or '0, 0, 0', '[^, ]+') do
			table.insert(coords, parseInt(coord))
		end
		
		vRPclient.teleport(source, coords[1] or 0, coords[2] or 0, coords[3] or 0)
	end
end)

RegisterCommand(config.commands['cds'].cmd, function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id, config.commands['cds']['permissions'][1]) or vRP.hasPermission(user_id, config.commands['cds']['permissions'][2]) or vRP.hasPermission(user_id, config.commands['cds']['permissions'][3]) then
			local x, y, z, h = vRPclient.getPositions(source)
			vRP.prompt(source, 'Coordinates:', x..', '..y..', '..z..', '..h)
		end
	end
end)

RegisterCommand(config.commands['cds2'].cmd, function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id, config.commands['cds2']['permissions'][1]) or vRP.hasPermission(user_id, config.commands['cds2']['permissions'][2]) or vRP.hasPermission(user_id, config.commands['cds2']['permissions'][3]) then
			local x, y, z, h = vRPclient.getPositions(source)
			vRP.prompt(source, "Coordinates:","['x'] = "..x..", ['y'] = "..y..", ['z'] = "..z..", ['h'] = "..h)
		end
	end
end)

RegisterCommand(config.commands['group'].cmd, function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
	local steam = vRP.getSteam(source)
	local discord = vRP.getDiscord(source)
	local nuidentity = vRP.getUserIdentity(parseInt(args[1]))

	if user_id then
		if vRP.hasPermission(user_id, config.commands['group']['permissions'][1]) or vRP.hasPermission(user_id, config.commands['group']['permissions'][2]) or vRP.hasPermission(user_id, config.commands['group']['permissions'][3]) then
			if not vRP.hasPermission(parseInt(args[1]), tostring(args[2])) then
				if nuidentity then
					vRP.insertPermission(parseInt(args[1]), tostring(args[2]))

					local identity = vRP.getUserIdentity(user_id)
					local nplayer = vRP.getUserSource(parseInt(args[1]))

					local nusteam = vRP.getSteam(nplayer)
					local nudiscord = vRP.getDiscord(nplayer)
					local w_nusteam = string.sub(nusteam, 7)
					local w_nudiscord = string.sub(nudiscord, 9)

					local w_steam = string.sub(steam, 7)
					local w_discord = string.sub(discord, 9)
					local w_title = 'REGISTRO DE GROUP:'
					local w_description = ''
					local w_fields = {
						{ 
							name = 'EQUIPE:',
							value = '```'..identity.name..' '..identity.firstname..' ['..user_id..']```⠀'
						},
						{
							name = 'PLAYER:',
							value = '```'..nuidentity.name..' '..nuidentity.firstname..' ['..args[1]..'] \nGrupo: '..args[2]..'```'
						},
						{ 
							name = '**IDENTIFICAÇÃO:**',
							value = 'Equipe: <@'..w_discord..'> - `Steam:'..w_steam..'`\nPlayer: <@'..w_nudiscord..'> - `Steam:'..w_nusteam..'`'
						},
						{ 
							name = '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━', 
							value = '⠀'
						}
					}
					vRP.sendWebhook(config.commands['group'].webhook, w_title, w_description, w_fields)
				end
			end
			TriggerClientEvent('Notify', source, 'sucesso', 'Adicionou o ID: <b>'..args[1]..'</b> Ao cargo de <b>'..args[2]..'</b.', 5000)
		end
	end
end)

RegisterCommand(config.commands['ungroup'].cmd, function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
	local steam = vRP.getSteam(source)
	local discord = vRP.getDiscord(source)
	local nuidentity = vRP.getUserIdentity(parseInt(args[1]))

	if user_id then
		if vRP.hasPermission(user_id, config.commands['ungroup']['permissions'][1]) or vRP.hasPermission(user_id, config.commands['ungroup']['permissions'][2]) or vRP.hasPermission(user_id, config.commands['ungroup']['permissions'][3]) then
			if vRP.hasPermission(parseInt(args[1]), tostring(args[2])) then
				if nuidentity then
					vRP.removePermission(parseInt(args[1]), tostring(args[2]))

					local identity = vRP.getUserIdentity(user_id)
					local nplayer = vRP.getUserSource(parseInt(args[1]))

					local nusteam = vRP.getSteam(nplayer)
					local nudiscord = vRP.getDiscord(nplayer)
					local w_nusteam = string.sub(nusteam, 7)
					local w_nudiscord = string.sub(nudiscord, 9)

					local w_steam = string.sub(steam, 7)
					local w_discord = string.sub(discord, 9)
					local w_ip = vRP.getPlayerEndpoint(source)
					local w_title = 'REGISTRO DE UNGROUP:'
					local w_description = ''
					local w_fields = {
						{ 
							name = 'EQUIPE:',
							value = '```'..identity.name..' '..identity.firstname..' ['..user_id..']```⠀'
						},
						{
							name = 'PLAYER:',
							value = '```'..nuidentity.name..' '..nuidentity.firstname..' ['..args[1]..'] \nGrupo: '..args[2]..'```'
						},
						{ 
							name = '**IDENTIFICAÇÃO:**',
							value = 'Equipe: <@'..w_discord..'> - `Steam:'..w_steam..'`\nPlayer: <@'..w_nudiscord..'> - `Steam:'..w_nusteam..'`'
						},
						{ 
							name = '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━', 
							value = '⠀'
						}
					}
					vRP.sendWebhook(config.commands['ungroup'].webhook, w_title, w_description, w_fields)
				end
			end
			TriggerClientEvent('Notify', source, 'negado', 'Removeu o ID: <b>'..args[1]..'</b> do cargo <b>'..args[2]..'</b.', 5000)
		end
	end
end)

RegisterCommand(config.commands['tptome'].cmd, function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
	local steam = vRP.getSteam(source)
	local discord = vRP.getDiscord(source)

	if user_id then
		if vRP.hasPermission(user_id, config.commands['tptome']['permissions'][1]) or vRP.hasPermission(user_id, config.commands['tptome']['permissions'][2]) or vRP.hasPermission(user_id, config.commands['tptome']['permissions'][3]) and parseInt(args[1]) > 0 then
			local nplayer = vRP.getUserSource(parseInt(args[1]))
			if nplayer then
				vRPclient.teleport(nplayer, vRPclient.getPositions(source))

				local nuidentity = vRP.getUserIdentity(parseInt(args[1]))

				local nusteam = vRP.getSteam(nplayer)
				local nudiscord = vRP.getDiscord(nplayer)
				
				local w_nusteam = string.sub(nusteam, 7)
				local w_nudiscord = string.sub(nudiscord, 9)
				
				local identity = vRP.getUserIdentity(user_id)
				local w_steam = string.sub(steam, 7)
				local w_discord = string.sub(discord, 9)
				local w_title = 'REGISTRO DE TPTOME:'
				local w_description = ''
				local w_fields = {
					{ 
						name = 'EQUIPE:',
						value = '```'..identity.name..' '..identity.firstname..' ['..user_id..'] ```⠀'
					},
					{
						name = 'PLAYER:',
						value = '```'..nuidentity.name..' '..nuidentity.firstname..' ['..args[1]..'] ``` '
					},
					{ 
						name = 'IDENTIFICAÇÃO:',
						value = 'Equipe: <@'..w_discord..'> - `Steam:'..w_steam..'`\nPlayer: <@'..w_nudiscord..'> - `Steam:'..w_nusteam..'`'
					},
					{ 
						name = '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━', 
						value = '⠀'
					}
				}
				vRP.sendWebhook(config.commands['tptome'].webhook, w_title, w_description, w_fields)
			end
		end
	end
end)

RegisterCommand(config.commands['tpto'].cmd, function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
	local steam = vRP.getSteam(source)
	local discord = vRP.getDiscord(source)

	if user_id then
		if vRP.hasPermission(user_id, config.commands['tpto']['permissions'][1]) or vRP.hasPermission(user_id, config.commands['tpto']['permissions'][2]) or vRP.hasPermission(user_id, config.commands['tpto']['permissions'][3]) and parseInt(args[1]) > 0 then
			local nplayer = vRP.getUserSource(parseInt(args[1]))
			if nplayer then
				vRPclient.teleport(source, vRPclient.getPositions(nplayer))

				local nuidentity = vRP.getUserIdentity(parseInt(args[1]))

				local nusteam = vRP.getSteam(nplayer)
				local nudiscord = vRP.getDiscord(nplayer)
				
				local w_nusteam = string.sub(nusteam, 7)
				local w_nudiscord = string.sub(nudiscord, 9)

				local identity = vRP.getUserIdentity(user_id)
				local w_steam = string.sub(steam, 7)
				local w_discord = string.sub(discord, 9)
				local w_title = 'REGISTRO DE TPTO:'
				local w_description = ''
				local w_fields = {
					{ 
						name = 'EQUIPE:',
						value = '```'..identity.name..' '..identity.firstname..' ['..user_id..'] ```⠀'
					},
					{
						name = 'PLAYER:',
						value = '```'..nuidentity.name..' '..nuidentity.firstname..' ['..args[1]..'] ``` '
					},
					{ 
						name = 'IDENTIFICAÇÃO:',
						value = 'Equipe: <@'..w_discord..'> - `Steam:'..w_steam..'`\nPlayer: <@'..w_nudiscord..'> - `Steam:'..w_nusteam..'`'
					},
					{ 
						name = '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━', 
						value = '⠀'
					}
				}
				vRP.sendWebhook(config.commands['tpto'].webhook, w_title, w_description, w_fields)
			end
		end
	end
end)

RegisterCommand(config.commands['tpway'].cmd, function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id, config.commands['tpway']['permissions'][1]) or vRP.hasPermission(user_id, config.commands['tpway']['permissions'][2]) or vRP.hasPermission(user_id, config.commands['tpway']['permissions'][3])  then
			zCLIENT.teleportWay(source)
		end
	end
end)

RegisterCommand(config.commands['limbo'].cmd, function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRPclient.getHealth(source) <= 101 then
			zCLIENT.teleportLimbo(source)
		end
	end
end)

RegisterCommand(config.commands['hash'].cmd, function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id, config.commands['hash']['permissions'][1]) or vRP.hasPermission(user_id, config.commands['hash']['permissions'][2]) or vRP.hasPermission(user_id, config.commands['hash']['permissions'][3]) then
			local vehicle = vRPclient.getNearVehicle(source, 7)
			if vehicle then
				zCLIENT.vehicleHash(source, vehicle)
			end
		end
	end
end)

RegisterCommand(config.commands['delnpcs'].cmd, function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id, config.commands['delnpcs']['permissions'][1]) or vRP.hasPermission(user_id, config.commands['delnpcs']['permissions'][2]) or vRP.hasPermission(user_id, config.commands['delnpcs']['permissions'][3]) then
			zCLIENT.deleteNpcs(source)
		end
	end
end)

RegisterCommand(config.commands['tuning'].cmd, function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id, config.commands['tuning']['permissions'][1]) or vRP.hasPermission(user_id, config.commands['tuning']['permissions'][2]) or vRP.hasPermission(user_id, config.commands['tuning']['permissions'][3]) then
		TriggerClientEvent('zADMIN:vehicleTuning', source)		
		end
	end
end)

RegisterCommand(config.commands['fix'].cmd, function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id, config.commands['fix']['permissions'][1]) or vRP.hasPermission(user_id, config.commands['fix']['permissions'][2]) or vRP.hasPermission(user_id, config.commands['fix']['permissions'][3]) then
			local vehicle, vehNet = vRPclient.vehList(source, 11)
			if vehicle then
				TriggerClientEvent('zInventory:repairVehicle', -1, vehNet, true)
			end
		end
	end
end)

RegisterCommand(config.commands['cleanarea'].cmd, function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id, config.commands['cleanarea']['permissions'][1]) or vRP.hasPermission(user_id, config.commands['cleanarea']['permissions'][2]) or vRP.hasPermission(user_id, config.commands['cleanarea']['permissions'][3]) then
			local x, y, z = vRPclient.getPositions(source)
			TriggerClientEvent('syncarea', -1, x, y, z, 100)
		end
	end
end)

RegisterCommand(config.commands['players'].cmd, function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id, config.commands['players']['permissions'][1]) or vRP.hasPermission(user_id, config.commands['players']['permissions'][2]) or vRP.hasPermission(user_id, config.commands['players']['permissions'][3]) then
			local quantidade = 0
			local users = vRP.getUsers()
			for k, v in pairs(users) do
				quantidade = parseInt(quantidade) + 1
			end
			TriggerClientEvent('Notify', source, 'importante', '<b>Players Conectados:</b> '..quantidade, 5000)
		end
	end
end)

RegisterCommand(config.commands['pon'].cmd, function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id, config.commands['pon']['permissions'][1]) or vRP.hasPermission(user_id, config.commands['pon']['permissions'][2]) or vRP.hasPermission(user_id, config.commands['pon']['permissions'][3]) then
		local users = vRP.getUsers()
		local players = ''
		local quantidade = 0
		for k, v in pairs(users) do
			if k ~= #users then
				players = players..', '
			end
			players = players..k
			quantidade = quantidade + 1
		end
		TriggerClientEvent('chatMessage', source, 'TOTAL ONLINE', {1, 136, 0}, quantidade)
		TriggerClientEvent('chatMessage', source, 'IDs ONLINE', {1, 136, 0}, players)
	end
end)

RegisterCommand(config.commands['announcement'].cmd, function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id, config.commands['announcement']['permissions'][1]) or vRP.hasPermission(user_id, config.commands['announcement']['permissions'][2]) or vRP.hasPermission(user_id, config.commands['announcement']['permissions'][3]) then
			local message = vRP.prompt(source, 'Message:', '')
			if message == '' then
				return
			end
			TriggerClientEvent('sNotify', -1, 'negado', message..'<br><b>Mensagem enviada por:</b> Governador', 15000)
		end
	end
end)

RegisterCommand(config.commands['car'].cmd,function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local plate = vRP.getUserRegistration(user_id)
	if user_id then
		if vRP.hasPermission(user_id, config.commands['car']['permissions'][1]) or vRP.hasPermission(user_id, config.commands['car']['permissions'][2]) or vRP.hasPermission(user_id, config.commands['car']['permissions'][3]) then
			if args[1] then
				TriggerClientEvent('zADMIN:spawnarveiculo',source,args[1],plate)
			end
		end
	end
end)

function z.buttonTxt()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id, 'gerente') or vRP.hasPermission(user_id, 'administrador') then
			local x, y, z, h = vRPclient.getPositions(source)
			vRP.updateTxt(user_id..'.txt', x..', '..y..', '..z..', '..h)
		end
	end
end

function z.enablaNoclip()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id, config.commands['noclip']['permissions'][1]) or vRP.hasPermission(user_id, config.commands['noclip']['permissions'][2]) or vRP.hasPermission(user_id, config.commands['noclip']['permissions'][3]) then
			vRPclient.noClip(source)
		end
	end
end

function z.getPlateSpawn()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		return vRP.getUserIdentity(user_id)
	end
end

AddEventHandler('vRP:playerSpawn', function(user_id, source)
	local identity = vRP.getUserIdentity(user_id)
	if identity then
		zCLIENT.setDiscord(source, '#'..user_id..' '..identity.name..' '..identity.firstname)
		TriggerClientEvent(source, 'active:checkcam', true)
	end
end)