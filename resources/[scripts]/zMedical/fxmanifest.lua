fx_version 'adamant'
game 'gta5'
lua54 'yes'

author 'ZIRAFLIX'
contact 'E-mail: contato@ziraflix.com - Discord: discord.gg/ziraflix'

ui_page 'web/darkside.html'

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

files {
	'web/*',
	'web/img/*.png'
}

escrow_ignore {
	'config/*',
}