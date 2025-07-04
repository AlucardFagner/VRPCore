fx_version 'adamant'
game 'gta5'
lua54 'yes'

author 'ZIRAFLIX'
contact 'Website: www.ziraflix.com.br - E-mail: contato@ziraflix.com - Discord: discord.gg/ziraflix'

client_scripts{
	'@vrp/lib/utils.lua',
	'client/*.lua',
}

server_scripts{
	'@vrp/lib/utils.lua',
	'server/*.lua'
}

files {

	"web/*.js",
	"web/*.html",
	"web/**/*"
}

ui_page {
	"web/darkside.html"
}

escrow_ignore {
	'config/*',
}