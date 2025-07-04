fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'ZIRAFLIX'
contact 'Website: www.ziraflix.com.br - E-mail: contato@ziraflix.com - Discord: discord.gg/ziraflix'

dependencies {
    'PolyZone'
}

ui_page 'web/darkside.html'

client_scripts {
	'@vrp/lib/utils.lua',
	'@PolyZone/client.lua',
	'@PolyZone/BoxZone.lua',
	'@PolyZone/EntityZone.lua',
	'@PolyZone/CircleZone.lua',
	'@PolyZone/ComboZone.lua',
	'config/*',
	'client/*'
}

files {
	'web/*'
}

escrow_ignore {
	'config/*',
}