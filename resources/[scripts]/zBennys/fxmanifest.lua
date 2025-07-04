fx_version 'bodacious'
game 'gta5'
lua54 'yes'

client_scripts {
	'@vrp/lib/utils.lua',
	'web/*.lua',
	'config/*.lua',
	'client/*.lua'
	
}

server_scripts {
	'@vrp/lib/utils.lua',
	'config/*.lua',
	'server/*.lua'
}

escrow_ignore {
	'config/*',
}