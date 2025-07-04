fx_version 'adamant'
game 'gta5'
lua54 'yes'

author 'ZIRAFLIX'
website 'www.ziraflix.com'
contact 'contato@ziraflix.com'

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
	'web/**/*'
}

escrow_ignore {
	'config/*',
}