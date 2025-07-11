fx_version 'adamant'
game 'gta5'

ui_page 'ui/index.html'

files {
	'ui/index.html',
	'ui/mic_click_on.ogg',
	'ui/mic_click_off.ogg',
}

shared_scripts {
	'config.lua',
	'grid.lua',
}

client_scripts {
	'@vrp/lib/utils.lua',
	'client.lua',
}

server_scripts {
	'@vrp/lib/utils.lua',
	'server.lua',
}

provide 'tokovoip_script'