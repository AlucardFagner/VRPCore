fx_version 'bodacious'
game 'gta5'
lua54 'yes'

client_scripts {
	'@vrp/lib/utils.lua',
	'config/*',
	'client/*'
}

server_scripts {
	'@vrp/lib/utils.lua',
	'config/*',
	'server/*'
}

escrow_ignore {
	'config/*',
}