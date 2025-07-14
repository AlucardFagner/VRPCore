vRP.prepare('vRP/create_players',
  [[
    CREATE TABLE IF NOT EXISTS `players` (
      `steam` varchar(50) NOT NULL,
      `discord` varchar(50) NOT NULL,
      `whitelist` tinyint(1) DEFAULT 0,
      `banned` tinyint(1) DEFAULT 0,
      `coins` int(11) NOT NULL DEFAULT 0,
      `premium` int(12) NOT NULL DEFAULT 0,
      `premium_days` int(2) NOT NULL DEFAULT 0,
      `priority` int(3) NOT NULL DEFAULT 0,
      `characters` int(1) NOT NULL DEFAULT 1,
      PRIMARY KEY (`steam`),
      KEY `steam` (`steam`),
      KEY `discord` (`discord`)
    ) ENGINE=InnoDB DEFAULT CHARSET=latin1;
  ]]
)

vRP.prepare('vRP/create_users',
  [[
    CREATE TABLE IF NOT EXISTS `users` (
      `user_id` int(11) NOT NULL AUTO_INCREMENT,
      `steam` varchar(100) DEFAULT NULL,
      `registration` varchar(20) DEFAULT NULL,
      `phone` varchar(20) DEFAULT NULL,
      `name` varchar(50) DEFAULT 'Individuo',
      `firstname` varchar(50) DEFAULT 'Indigente',
      `garage` int(3) NOT NULL DEFAULT 2,
      `prison` int(6) NOT NULL DEFAULT 0,
      `gunlicense` tinyint(1) NOT NULL DEFAULT 0,
      `drivelicense` tinyint(1) NOT NULL DEFAULT 0,
      `locate` int(1) NOT NULL DEFAULT 1,
      `deleted` int(1) NOT NULL DEFAULT 0,
      PRIMARY KEY (`user_id`),
      KEY `user_id` (`user_id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=latin1;
  ]]
)

vRP.prepare('vRP/create_users_data',
  [[
    CREATE TABLE IF NOT EXISTS `users_data` (
      `user_id` int(11) NOT NULL,
      `dkey` varchar(100) NOT NULL,
      `dvalue` text DEFAULT NULL,
      PRIMARY KEY (`user_id`, `dkey`),
      KEY `user_id` (`user_id`),
      KEY `dkey` (`dkey`)
    ) ENGINE=InnoDB DEFAULT CHARSET=latin1;
  ]]
)

vRP.prepare('vRP/create_server_data',
  [[
    CREATE TABLE IF NOT EXISTS `server_data` (
      `dkey` varchar(100) NOT NULL,
      `dvalue` text DEFAULT NULL,
      PRIMARY KEY (`dkey`),
      KEY `dkey` (`dkey`)
    ) ENGINE=InnoDB DEFAULT CHARSET=latin1;
  ]]
)

vRP.prepare('vRP/create_permissions',
  [[
    CREATE TABLE IF NOT EXISTS `permissions` (
      `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
      `user_id` int(11) NOT NULL DEFAULT 0,
      `permission` text NOT NULL,
      PRIMARY KEY (`id`) USING BTREE
    ) ENGINE=InnoDB DEFAULT CHARSET=latin1;
  ]]
)

vRP.prepare('vRP/create_vehicles',
  [[
    CREATE TABLE IF NOT EXISTS `vehicles` (
      `plate` VARCHAR(8) NULL DEFAULT NULL COLLATE 'latin1_swedish_ci',
      `user_id` INT(11) NOT NULL,
      `vehicle` VARCHAR(100) NOT NULL COLLATE 'latin1_swedish_ci',
      `arrested` INT(1) NOT NULL DEFAULT '0',
      `arrested_time` VARCHAR(24) NOT NULL DEFAULT '0' COLLATE 'latin1_swedish_ci',
      `engine` INT(4) NOT NULL DEFAULT '1000',
      `body` INT(4) NOT NULL DEFAULT '1000',
      `fuel` INT(3) NOT NULL DEFAULT '100',
      `tax` VARCHAR(50) NULL DEFAULT NULL COLLATE 'latin1_swedish_ci',
      PRIMARY KEY (`plate`, `user_id`) USING BTREE,
      KEY `vehicle` (`vehicle`)
    ) COLLATE='latin1_swedish_ci' ENGINE=InnoDB;
  ]]
)

vRP.prepare('vRP/create_weapons',
  [[
    CREATE TABLE IF NOT EXISTS `weapons` (
      `id` int(11) NOT NULL AUTO_INCREMENT,
      `user_id` int(11) NOT NULL DEFAULT 0,
      `weapon` text NOT NULL,
      `ammo` int(11) NOT NULL DEFAULT 0,
      PRIMARY KEY (`id`),
      KEY `user_id` (`user_id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=latin1;
  ]]
)

vRP.prepare('vRP/create_homes',
  [[
    CREATE TABLE IF NOT EXISTS `homes` (
      `home` varchar(50) NOT NULL,
      `user_id` int(11) NOT NULL,
      `owner` int(1) NOT NULL DEFAULT 0,
      `vault` int(5) NOT NULL DEFAULT 0,
      `slots` int(25) DEFAULT NULL,
      PRIMARY KEY (`home`,`user_id`),
      KEY `home` (`home`),
      KEY `user_id` (`user_id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=latin1;
  ]]
)

vRP.prepare('vRP/create_shops',
  [[
    CREATE TABLE IF NOT EXISTS `shops` (
      `shop` varchar(255) NOT NULL,
      `name` varchar(255) DEFAULT NULL,
      `permission` varchar(255) NOT NULL,
      `x` text NOT NULL,
      `y` text NOT NULL,
      `z` text NOT NULL,
      `owner` int(11) NOT NULL DEFAULT 0,
      `security` varchar(255) NOT NULL DEFAULT '1',
      `price` int(11) DEFAULT NULL,
      `forsale` tinyint(1) NOT NULL DEFAULT 1,
      `stock` text NOT NULL DEFAULT '[]',
      `slots` int(11) NOT NULL DEFAULT 9,
      `vault` int(11) NOT NULL DEFAULT 0,
      `maxstock` int(11) DEFAULT 100,
      `maxvault` int(11) DEFAULT 200000,
      PRIMARY KEY (`shop`) USING BTREE
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8;
  ]]
)

vRP.prepare('vRP/create_shops_basic', 
  [[
    INSERT IGNORE INTO shops (shop, name, x, y, z, price, stock) VALUES
      ('drugshopOne', 'Farmácia', 93.25, -230.07, 54.67, 1650000,'{"1":{"stock":2000,"requireAmount":1,"price":500,"gunlicense":false,"item":"paracetamil","require":"r-paracetamil"},"2":{"stock":2000,"requireAmount":1,"price":500,"gunlicense":false,"item":"voltarom","require":"r-voltarom"},"3":{"stock":2000,"requireAmount":1,"price":500,"gunlicense":false,"item":"trandrylux","require":"r-trandrylux"},"4":{"stock":2000,"requireAmount":1,"price":500,"gunlicense":false,"item":"dorfrex","require":"r-dorfrex"},"5":{"stock":2000,"requireAmount":1,"price":500,"gunlicense":false,"item":"buscopom","require":"r-buscopom"}}'),
      ('drugshopTwo', 'Farmácia', -492.27, -340.93, 42.33, 1650000,'{"1":{"stock":2000,"requireAmount":1,"price":500,"gunlicense":false,"item":"paracetamil","require":"r-paracetamil"},"2":{"stock":2000,"requireAmount":1,"price":500,"gunlicense":false,"item":"voltarom","require":"r-voltarom"},"3":{"stock":2000,"requireAmount":1,"price":500,"gunlicense":false,"item":"trandrylux","require":"r-trandrylux"},"4":{"stock":2000,"requireAmount":1,"price":500,"gunlicense":false,"item":"dorfrex","require":"r-dorfrex"},"5":{"stock":2000,"requireAmount":1,"price":500,"gunlicense":false,"item":"buscopom","require":"r-buscopom"}}'),
      ('shopOne', 'Lojinha', 25.82, -1345.72, 29.5, 1650000, '{"1":{"price":20,"gunlicense":false,"item":"agua","stock":10000,"requireAmount":0,"require":false},"2":{"price":30,"gunlicense":false,"item":"garrafa-vazia","stock":1000,"require":false,"requireAmount":0},"3":{"price":110,"gunlicense":false,"item":"leite","stock":1000,"requireAmount":0,"require":false},"4":{"price":150,"gunlicense":false,"item":"cafe","stock":1000,"require":false,"requireAmount":0},"5":{"price":170,"gunlicense":false,"item":"cafecleite","stock":1000,"requireAmount":0,"require":false},"6":{"price":170,"gunlicense":false,"item":"cafeexpresso","stock":1000,"requireAmount":0,"require":false},"7":{"price":170,"gunlicense":false,"item":"capuccino","stock":1000,"requireAmount":0,"require":false},"8":{"price":170,"gunlicense":false,"item":"chips","stock":1000,"requireAmount":0,"require":false},"9":{"price":170,"gunlicense":false,"item":"sanduiche","stock":1000,"requireAmount":0,"require":false}}'),
      ('shopTwo', 'Lojinha', 2555.6, 382.33, 108.63, 1650000, '{"1":{"price":20,"gunlicense":false,"item":"agua","stock":10000,"requireAmount":0,"require":false},"2":{"price":30,"gunlicense":false,"item":"garrafa-vazia","stock":1000,"require":false,"requireAmount":0},"3":{"price":110,"gunlicense":false,"item":"leite","stock":1000,"requireAmount":0,"require":false},"4":{"price":150,"gunlicense":false,"item":"cafe","stock":1000,"require":false,"requireAmount":0},"5":{"price":170,"gunlicense":false,"item":"cafecleite","stock":1000,"requireAmount":0,"require":false},"6":{"price":170,"gunlicense":false,"item":"cafeexpresso","stock":1000,"requireAmount":0,"require":false},"7":{"price":170,"gunlicense":false,"item":"capuccino","stock":1000,"requireAmount":0,"require":false},"8":{"price":170,"gunlicense":false,"item":"chips","stock":1000,"requireAmount":0,"require":false},"9":{"price":170,"gunlicense":false,"item":"sanduiche","stock":1000,"requireAmount":0,"require":false}}'),
      ('shopThree', 'Lojinha', 1163.54, -323.74, 69.21, 1650000, '{"1":{"price":20,"gunlicense":false,"item":"agua","stock":10000,"requireAmount":0,"require":false},"2":{"price":30,"gunlicense":false,"item":"garrafa-vazia","stock":1000,"require":false,"requireAmount":0},"3":{"price":110,"gunlicense":false,"item":"leite","stock":1000,"requireAmount":0,"require":false},"4":{"price":150,"gunlicense":false,"item":"cafe","stock":1000,"require":false,"requireAmount":0},"5":{"price":170,"gunlicense":false,"item":"cafecleite","stock":1000,"requireAmount":0,"require":false},"6":{"price":170,"gunlicense":false,"item":"cafeexpresso","stock":1000,"requireAmount":0,"require":false},"7":{"price":170,"gunlicense":false,"item":"capuccino","stock":1000,"requireAmount":0,"require":false},"8":{"price":170,"gunlicense":false,"item":"chips","stock":1000,"requireAmount":0,"require":false},"9":{"price":170,"gunlicense":false,"item":"sanduiche","stock":1000,"requireAmount":0,"require":false}}'),
      ('shopFour', 'Lojinha', -707.59, -914.23, 19.22, 1650000, '{"1":{"price":20,"gunlicense":false,"item":"agua","stock":10000,"requireAmount":0,"require":false},"2":{"price":30,"gunlicense":false,"item":"garrafa-vazia","stock":1000,"require":false,"requireAmount":0},"3":{"price":110,"gunlicense":false,"item":"leite","stock":1000,"requireAmount":0,"require":false},"4":{"price":150,"gunlicense":false,"item":"cafe","stock":1000,"require":false,"requireAmount":0},"5":{"price":170,"gunlicense":false,"item":"cafecleite","stock":1000,"requireAmount":0,"require":false},"6":{"price":170,"gunlicense":false,"item":"cafeexpresso","stock":1000,"requireAmount":0,"require":false},"7":{"price":170,"gunlicense":false,"item":"capuccino","stock":1000,"requireAmount":0,"require":false},"8":{"price":170,"gunlicense":false,"item":"chips","stock":1000,"requireAmount":0,"require":false},"9":{"price":170,"gunlicense":false,"item":"sanduiche","stock":1000,"requireAmount":0,"require":false}}'),
      ('shopFive', 'Lojinha', -48.33, -1757.68, 29.43, 1650000, '{"1":{"price":20,"gunlicense":false,"item":"agua","stock":10000,"requireAmount":0,"require":false},"2":{"price":30,"gunlicense":false,"item":"garrafa-vazia","stock":1000,"require":false,"requireAmount":0},"3":{"price":110,"gunlicense":false,"item":"leite","stock":1000,"requireAmount":0,"require":false},"4":{"price":150,"gunlicense":false,"item":"cafe","stock":1000,"require":false,"requireAmount":0},"5":{"price":170,"gunlicense":false,"item":"cafecleite","stock":1000,"requireAmount":0,"require":false},"6":{"price":170,"gunlicense":false,"item":"cafeexpresso","stock":1000,"requireAmount":0,"require":false},"7":{"price":170,"gunlicense":false,"item":"capuccino","stock":1000,"requireAmount":0,"require":false},"8":{"price":170,"gunlicense":false,"item":"chips","stock":1000,"requireAmount":0,"require":false},"9":{"price":170,"gunlicense":false,"item":"sanduiche","stock":1000,"requireAmount":0,"require":false}}'),
      ('shopSix', 'Lojinha', 374.26, 327.67, 103.57, 1650000, '{"1":{"price":20,"gunlicense":false,"item":"agua","stock":10000,"requireAmount":0,"require":false},"2":{"price":30,"gunlicense":false,"item":"garrafa-vazia","stock":1000,"require":false,"requireAmount":0},"3":{"price":110,"gunlicense":false,"item":"leite","stock":1000,"requireAmount":0,"require":false},"4":{"price":150,"gunlicense":false,"item":"cafe","stock":1000,"require":false,"requireAmount":0},"5":{"price":170,"gunlicense":false,"item":"cafecleite","stock":1000,"requireAmount":0,"require":false},"6":{"price":170,"gunlicense":false,"item":"cafeexpresso","stock":1000,"requireAmount":0,"require":false},"7":{"price":170,"gunlicense":false,"item":"capuccino","stock":1000,"requireAmount":0,"require":false},"8":{"price":170,"gunlicense":false,"item":"chips","stock":1000,"requireAmount":0,"require":false},"9":{"price":170,"gunlicense":false,"item":"sanduiche","stock":1000,"requireAmount":0,"require":false}}'),
      ('shopSeven', 'Lojinha', -3243.85, 1001.52, 12.84, 1650000, '{"1":{"price":20,"gunlicense":false,"item":"agua","stock":10000,"requireAmount":0,"require":false},"2":{"price":30,"gunlicense":false,"item":"garrafa-vazia","stock":1000,"require":false,"requireAmount":0},"3":{"price":110,"gunlicense":false,"item":"leite","stock":1000,"requireAmount":0,"require":false},"4":{"price":150,"gunlicense":false,"item":"cafe","stock":1000,"require":false,"requireAmount":0},"5":{"price":170,"gunlicense":false,"item":"cafecleite","stock":1000,"requireAmount":0,"require":false},"6":{"price":170,"gunlicense":false,"item":"cafeexpresso","stock":1000,"requireAmount":0,"require":false},"7":{"price":170,"gunlicense":false,"item":"capuccino","stock":1000,"requireAmount":0,"require":false},"8":{"price":170,"gunlicense":false,"item":"chips","stock":1000,"requireAmount":0,"require":false},"9":{"price":170,"gunlicense":false,"item":"sanduiche","stock":1000,"requireAmount":0,"require":false}}'),
      ('shopEight', 'Lojinha', 1729.75, 6416.03, 35.04, 1650000, '{"1":{"price":20,"gunlicense":false,"item":"agua","stock":10000,"requireAmount":0,"require":false},"2":{"price":30,"gunlicense":false,"item":"garrafa-vazia","stock":1000,"require":false,"requireAmount":0},"3":{"price":110,"gunlicense":false,"item":"leite","stock":1000,"requireAmount":0,"require":false},"4":{"price":150,"gunlicense":false,"item":"cafe","stock":1000,"require":false,"requireAmount":0},"5":{"price":170,"gunlicense":false,"item":"cafecleite","stock":1000,"requireAmount":0,"require":false},"6":{"price":170,"gunlicense":false,"item":"cafeexpresso","stock":1000,"requireAmount":0,"require":false},"7":{"price":170,"gunlicense":false,"item":"capuccino","stock":1000,"requireAmount":0,"require":false},"8":{"price":170,"gunlicense":false,"item":"chips","stock":1000,"requireAmount":0,"require":false},"9":{"price":170,"gunlicense":false,"item":"sanduiche","stock":1000,"requireAmount":0,"require":false}}'),
      ('shopNine', 'Lojinha', 548.09, 2669.53, 42.16, 1650000, '{"1":{"price":20,"gunlicense":false,"item":"agua","stock":10000,"requireAmount":0,"require":false},"2":{"price":30,"gunlicense":false,"item":"garrafa-vazia","stock":1000,"require":false,"requireAmount":0},"3":{"price":110,"gunlicense":false,"item":"leite","stock":1000,"requireAmount":0,"require":false},"4":{"price":150,"gunlicense":false,"item":"cafe","stock":1000,"require":false,"requireAmount":0},"5":{"price":170,"gunlicense":false,"item":"cafecleite","stock":1000,"requireAmount":0,"require":false},"6":{"price":170,"gunlicense":false,"item":"cafeexpresso","stock":1000,"requireAmount":0,"require":false},"7":{"price":170,"gunlicense":false,"item":"capuccino","stock":1000,"requireAmount":0,"require":false},"8":{"price":170,"gunlicense":false,"item":"chips","stock":1000,"requireAmount":0,"require":false},"9":{"price":170,"gunlicense":false,"item":"sanduiche","stock":1000,"requireAmount":0,"require":false}}'),
      ('shopTen', 'Lojinha', 1960.3, 3742.15, 32.35, 1650000, '{"1":{"price":20,"gunlicense":false,"item":"agua","stock":10000,"requireAmount":0,"require":false},"2":{"price":30,"gunlicense":false,"item":"garrafa-vazia","stock":1000,"require":false,"requireAmount":0},"3":{"price":110,"gunlicense":false,"item":"leite","stock":1000,"requireAmount":0,"require":false},"4":{"price":150,"gunlicense":false,"item":"cafe","stock":1000,"require":false,"requireAmount":0},"5":{"price":170,"gunlicense":false,"item":"cafecleite","stock":1000,"requireAmount":0,"require":false},"6":{"price":170,"gunlicense":false,"item":"cafeexpresso","stock":1000,"requireAmount":0,"require":false},"7":{"price":170,"gunlicense":false,"item":"capuccino","stock":1000,"requireAmount":0,"require":false},"8":{"price":170,"gunlicense":false,"item":"chips","stock":1000,"requireAmount":0,"require":false},"9":{"price":170,"gunlicense":false,"item":"sanduiche","stock":1000,"requireAmount":0,"require":false}}'),
      ('shopEleven', 'Lojinha', 2677.2, 3281.35, 55.25, 1650000, '{"1":{"price":20,"gunlicense":false,"item":"agua","stock":10000,"requireAmount":0,"require":false},"2":{"price":30,"gunlicense":false,"item":"garrafa-vazia","stock":1000,"require":false,"requireAmount":0},"3":{"price":110,"gunlicense":false,"item":"leite","stock":1000,"requireAmount":0,"require":false},"4":{"price":150,"gunlicense":false,"item":"cafe","stock":1000,"require":false,"requireAmount":0},"5":{"price":170,"gunlicense":false,"item":"cafecleite","stock":1000,"requireAmount":0,"require":false},"6":{"price":170,"gunlicense":false,"item":"cafeexpresso","stock":1000,"requireAmount":0,"require":false},"7":{"price":170,"gunlicense":false,"item":"capuccino","stock":1000,"requireAmount":0,"require":false},"8":{"price":170,"gunlicense":false,"item":"chips","stock":1000,"requireAmount":0,"require":false},"9":{"price":170,"gunlicense":false,"item":"sanduiche","stock":1000,"requireAmount":0,"require":false}}'),
      ('shopTwelve', 'Lojinha', 1698.23, 4924.69, 42.07, 1650000, '{"1":{"price":20,"gunlicense":false,"item":"agua","stock":10000,"requireAmount":0,"require":false},"2":{"price":30,"gunlicense":false,"item":"garrafa-vazia","stock":1000,"require":false,"requireAmount":0},"3":{"price":110,"gunlicense":false,"item":"leite","stock":1000,"requireAmount":0,"require":false},"4":{"price":150,"gunlicense":false,"item":"cafe","stock":1000,"require":false,"requireAmount":0},"5":{"price":170,"gunlicense":false,"item":"cafecleite","stock":1000,"requireAmount":0,"require":false},"6":{"price":170,"gunlicense":false,"item":"cafeexpresso","stock":1000,"requireAmount":0,"require":false},"7":{"price":170,"gunlicense":false,"item":"capuccino","stock":1000,"requireAmount":0,"require":false},"8":{"price":170,"gunlicense":false,"item":"chips","stock":1000,"requireAmount":0,"require":false},"9":{"price":170,"gunlicense":false,"item":"sanduiche","stock":1000,"requireAmount":0,"require":false}}'),
      ('shopThirteen', 'Lojinha', -1820.38, 792.53, 138.12, 1650000, '{"1":{"price":20,"gunlicense":false,"item":"agua","stock":10000,"requireAmount":0,"require":false},"2":{"price":30,"gunlicense":false,"item":"garrafa-vazia","stock":1000,"require":false,"requireAmount":0},"3":{"price":110,"gunlicense":false,"item":"leite","stock":1000,"requireAmount":0,"require":false},"4":{"price":150,"gunlicense":false,"item":"cafe","stock":1000,"require":false,"requireAmount":0},"5":{"price":170,"gunlicense":false,"item":"cafecleite","stock":1000,"requireAmount":0,"require":false},"6":{"price":170,"gunlicense":false,"item":"cafeexpresso","stock":1000,"requireAmount":0,"require":false},"7":{"price":170,"gunlicense":false,"item":"capuccino","stock":1000,"requireAmount":0,"require":false},"8":{"price":170,"gunlicense":false,"item":"chips","stock":1000,"requireAmount":0,"require":false},"9":{"price":170,"gunlicense":false,"item":"sanduiche","stock":1000,"requireAmount":0,"require":false}}'),
      ('shopFourteen', 'Lojinha', 1392.69, 3604.61, 34.99, 1650000, '{"1":{"price":20,"gunlicense":false,"item":"agua","stock":10000,"requireAmount":0,"require":false},"2":{"price":30,"gunlicense":false,"item":"garrafa-vazia","stock":1000,"require":false,"requireAmount":0},"3":{"price":110,"gunlicense":false,"item":"leite","stock":1000,"requireAmount":0,"require":false},"4":{"price":150,"gunlicense":false,"item":"cafe","stock":1000,"require":false,"requireAmount":0},"5":{"price":170,"gunlicense":false,"item":"cafecleite","stock":1000,"requireAmount":0,"require":false},"6":{"price":170,"gunlicense":false,"item":"cafeexpresso","stock":1000,"requireAmount":0,"require":false},"7":{"price":170,"gunlicense":false,"item":"capuccino","stock":1000,"requireAmount":0,"require":false},"8":{"price":170,"gunlicense":false,"item":"chips","stock":1000,"requireAmount":0,"require":false},"9":{"price":170,"gunlicense":false,"item":"sanduiche","stock":1000,"requireAmount":0,"require":false}}'),
      ('shopFifteen', 'Lojinha', -2967.87, 390.92, 15.05, 1650000, '{"1":{"price":20,"gunlicense":false,"item":"agua","stock":10000,"requireAmount":0,"require":false},"2":{"price":30,"gunlicense":false,"item":"garrafa-vazia","stock":1000,"require":false,"requireAmount":0},"3":{"price":110,"gunlicense":false,"item":"leite","stock":1000,"requireAmount":0,"require":false},"4":{"price":150,"gunlicense":false,"item":"cafe","stock":1000,"require":false,"requireAmount":0},"5":{"price":170,"gunlicense":false,"item":"cafecleite","stock":1000,"requireAmount":0,"require":false},"6":{"price":170,"gunlicense":false,"item":"cafeexpresso","stock":1000,"requireAmount":0,"require":false},"7":{"price":170,"gunlicense":false,"item":"capuccino","stock":1000,"requireAmount":0,"require":false},"8":{"price":170,"gunlicense":false,"item":"chips","stock":1000,"requireAmount":0,"require":false},"9":{"price":170,"gunlicense":false,"item":"sanduiche","stock":1000,"requireAmount":0,"require":false}}'),
      ('shopSixteen', 'Lojinha', -3040.95, 585.18, 7.91, 1650000, '{"1":{"price":20,"gunlicense":false,"item":"agua","stock":10000,"requireAmount":0,"require":false},"2":{"price":30,"gunlicense":false,"item":"garrafa-vazia","stock":1000,"require":false,"requireAmount":0},"3":{"price":110,"gunlicense":false,"item":"leite","stock":1000,"requireAmount":0,"require":false},"4":{"price":150,"gunlicense":false,"item":"cafe","stock":1000,"require":false,"requireAmount":0},"5":{"price":170,"gunlicense":false,"item":"cafecleite","stock":1000,"requireAmount":0,"require":false},"6":{"price":170,"gunlicense":false,"item":"cafeexpresso","stock":1000,"requireAmount":0,"require":false},"7":{"price":170,"gunlicense":false,"item":"capuccino","stock":1000,"requireAmount":0,"require":false},"8":{"price":170,"gunlicense":false,"item":"chips","stock":1000,"requireAmount":0,"require":false},"9":{"price":170,"gunlicense":false,"item":"sanduiche","stock":1000,"requireAmount":0,"require":false}}'),
      ('shopSeventeen', 'Lojinha', 1135.79, -981.8, 46.42, 1650000, '{"1":{"price":20,"gunlicense":false,"item":"agua","stock":10000,"requireAmount":0,"require":false},"2":{"price":30,"gunlicense":false,"item":"garrafa-vazia","stock":1000,"require":false,"requireAmount":0},"3":{"price":110,"gunlicense":false,"item":"leite","stock":1000,"requireAmount":0,"require":false},"4":{"price":150,"gunlicense":false,"item":"cafe","stock":1000,"require":false,"requireAmount":0},"5":{"price":170,"gunlicense":false,"item":"cafecleite","stock":1000,"requireAmount":0,"require":false},"6":{"price":170,"gunlicense":false,"item":"cafeexpresso","stock":1000,"requireAmount":0,"require":false},"7":{"price":170,"gunlicense":false,"item":"capuccino","stock":1000,"requireAmount":0,"require":false},"8":{"price":170,"gunlicense":false,"item":"chips","stock":1000,"requireAmount":0,"require":false},"9":{"price":170,"gunlicense":false,"item":"sanduiche","stock":1000,"requireAmount":0,"require":false}}'),
      ('shopEighteen', 'Lojinha', 1166.01, 2709.17, 38.16, 1650000, '{"1":{"price":20,"gunlicense":false,"item":"agua","stock":10000,"requireAmount":0,"require":false},"2":{"price":30,"gunlicense":false,"item":"garrafa-vazia","stock":1000,"require":false,"requireAmount":0},"3":{"price":110,"gunlicense":false,"item":"leite","stock":1000,"requireAmount":0,"require":false},"4":{"price":150,"gunlicense":false,"item":"cafe","stock":1000,"require":false,"requireAmount":0},"5":{"price":170,"gunlicense":false,"item":"cafecleite","stock":1000,"requireAmount":0,"require":false},"6":{"price":170,"gunlicense":false,"item":"cafeexpresso","stock":1000,"requireAmount":0,"require":false},"7":{"price":170,"gunlicense":false,"item":"capuccino","stock":1000,"requireAmount":0,"require":false},"8":{"price":170,"gunlicense":false,"item":"chips","stock":1000,"requireAmount":0,"require":false},"9":{"price":170,"gunlicense":false,"item":"sanduiche","stock":1000,"requireAmount":0,"require":false}}'),
      ('shopNineteen', 'Lojinha', -1487.13, -379.17, 40.17, 1650000, '{"1":{"price":20,"gunlicense":false,"item":"agua","stock":10000,"requireAmount":0,"require":false},"2":{"price":30,"gunlicense":false,"item":"garrafa-vazia","stock":1000,"require":false,"requireAmount":0},"3":{"price":110,"gunlicense":false,"item":"leite","stock":1000,"requireAmount":0,"require":false},"4":{"price":150,"gunlicense":false,"item":"cafe","stock":1000,"require":false,"requireAmount":0},"5":{"price":170,"gunlicense":false,"item":"cafecleite","stock":1000,"requireAmount":0,"require":false},"6":{"price":170,"gunlicense":false,"item":"cafeexpresso","stock":1000,"requireAmount":0,"require":false},"7":{"price":170,"gunlicense":false,"item":"capuccino","stock":1000,"requireAmount":0,"require":false},"8":{"price":170,"gunlicense":false,"item":"chips","stock":1000,"requireAmount":0,"require":false},"9":{"price":170,"gunlicense":false,"item":"sanduiche","stock":1000,"requireAmount":0,"require":false}}'),
      ('shopTwenty', 'Lojinha', -1223.18, -907.3, 12.33, 1650000, '{"1":{"price":20,"gunlicense":false,"item":"agua","stock":10000,"requireAmount":0,"require":false},"2":{"price":30,"gunlicense":false,"item":"garrafa-vazia","stock":1000,"require":false,"requireAmount":0},"3":{"price":110,"gunlicense":false,"item":"leite","stock":1000,"requireAmount":0,"require":false},"4":{"price":150,"gunlicense":false,"item":"cafe","stock":1000,"require":false,"requireAmount":0},"5":{"price":170,"gunlicense":false,"item":"cafecleite","stock":1000,"requireAmount":0,"require":false},"6":{"price":170,"gunlicense":false,"item":"cafeexpresso","stock":1000,"requireAmount":0,"require":false},"7":{"price":170,"gunlicense":false,"item":"capuccino","stock":1000,"requireAmount":0,"require":false},"8":{"price":170,"gunlicense":false,"item":"chips","stock":1000,"requireAmount":0,"require":false},"9":{"price":170,"gunlicense":false,"item":"sanduiche","stock":1000,"requireAmount":0,"require":false}}'),
      ('gunshopOne', 'Ammunation', 1692.56, 3759.04, 34.71, 1650000, '{"6":{"price":5000,"gunlicense":false,"item":"WEAPON_FLAREGUN","stock":100,"requireAmount":0,"require":false},"5":{"price":1000,"gunlicense":false,"item":"WEAPON_FLAREGUN_AMMO","stock":10000,"require":false,"requireAmount":0},"4":{"price":2500,"gunlicense":false,"item":"GADGET_PARACHUTE","stock":1000,"requireAmount":0,"require":false},"3":{"price":200,"gunlicense":false,"item":"WEAPON_PISTOL_AMMO","stock":10000,"require":false,"requireAmount":0},"2":{"price":110000,"gunlicense":true,"item":"WEAPON_PISTOL","stock":100,"requireAmount":0,"require":false},"1":{"price":10000,"gunlicense":false,"item":"mochila-grande","stock":1000,"require":false,"requireAmount":0}}'),
      ('gunshopThree', 'Ammunation', 843.59, -1033.91, 28.2, 1650000, '{"6":{"price":5000,"gunlicense":false,"item":"WEAPON_FLAREGUN","stock":100,"requireAmount":0,"require":false},"5":{"price":1000,"gunlicense":false,"item":"WEAPON_FLAREGUN_AMMO","stock":10000,"require":false,"requireAmount":0},"4":{"price":2500,"gunlicense":false,"item":"GADGET_PARACHUTE","stock":1000,"requireAmount":0,"require":false},"3":{"price":200,"gunlicense":false,"item":"WEAPON_PISTOL_AMMO","stock":10000,"require":false,"requireAmount":0},"2":{"price":110000,"gunlicense":true,"item":"WEAPON_PISTOL","stock":100,"requireAmount":0,"require":false},"1":{"price":10000,"gunlicense":false,"item":"mochila-grande","stock":1000,"require":false,"requireAmount":0}}'),
      ('gunshopFour', 'Ammunation', -331.72, 6082.91, 31.46, 1650000, '{"6":{"price":5000,"gunlicense":false,"item":"WEAPON_FLAREGUN","stock":100,"requireAmount":0,"require":false},"5":{"price":1000,"gunlicense":false,"item":"WEAPON_FLAREGUN_AMMO","stock":10000,"require":false,"requireAmount":0},"4":{"price":2500,"gunlicense":false,"item":"GADGET_PARACHUTE","stock":1000,"requireAmount":0,"require":false},"3":{"price":200,"gunlicense":false,"item":"WEAPON_PISTOL_AMMO","stock":10000,"require":false,"requireAmount":0},"2":{"price":110000,"gunlicense":true,"item":"WEAPON_PISTOL","stock":100,"requireAmount":0,"require":false},"1":{"price":10000,"gunlicense":false,"item":"mochila-grande","stock":1000,"require":false,"requireAmount":0}}'),
      ('gunshopFive', 'Ammunation', -663.77, -934.99, 21.83, 1650000, '{"6":{"price":5000,"gunlicense":false,"item":"WEAPON_FLAREGUN","stock":100,"requireAmount":0,"require":false},"5":{"price":1000,"gunlicense":false,"item":"WEAPON_FLAREGUN_AMMO","stock":10000,"require":false,"requireAmount":0},"4":{"price":2500,"gunlicense":false,"item":"GADGET_PARACHUTE","stock":1000,"requireAmount":0,"require":false},"3":{"price":200,"gunlicense":false,"item":"WEAPON_PISTOL_AMMO","stock":10000,"require":false,"requireAmount":0},"2":{"price":110000,"gunlicense":true,"item":"WEAPON_PISTOL","stock":100,"requireAmount":0,"require":false},"1":{"price":10000,"gunlicense":false,"item":"mochila-grande","stock":1000,"require":false,"requireAmount":0}}'),
      ('gunshopSix', 'Ammunation', -1305.4, -393.05, 36.7, 1650000, '{"6":{"price":5000,"gunlicense":false,"item":"WEAPON_FLAREGUN","stock":100,"requireAmount":0,"require":false},"5":{"price":1000,"gunlicense":false,"item":"WEAPON_FLAREGUN_AMMO","stock":10000,"require":false,"requireAmount":0},"4":{"price":2500,"gunlicense":false,"item":"GADGET_PARACHUTE","stock":1000,"requireAmount":0,"require":false},"3":{"price":200,"gunlicense":false,"item":"WEAPON_PISTOL_AMMO","stock":10000,"require":false,"requireAmount":0},"2":{"price":110000,"gunlicense":true,"item":"WEAPON_PISTOL","stock":100,"requireAmount":0,"require":false},"1":{"price":10000,"gunlicense":false,"item":"mochila-grande","stock":1000,"require":false,"requireAmount":0}}'),
      ('gunshopSeven', 'Ammunation', -1119.04, 2697.78, 18.56, 1650000, '{"6":{"price":5000,"gunlicense":false,"item":"WEAPON_FLAREGUN","stock":100,"requireAmount":0,"require":false},"5":{"price":1000,"gunlicense":false,"item":"WEAPON_FLAREGUN_AMMO","stock":10000,"require":false,"requireAmount":0},"4":{"price":2500,"gunlicense":false,"item":"GADGET_PARACHUTE","stock":1000,"requireAmount":0,"require":false},"3":{"price":200,"gunlicense":false,"item":"WEAPON_PISTOL_AMMO","stock":10000,"require":false,"requireAmount":0},"2":{"price":110000,"gunlicense":true,"item":"WEAPON_PISTOL","stock":100,"requireAmount":0,"require":false},"1":{"price":10000,"gunlicense":false,"item":"mochila-grande","stock":1000,"require":false,"requireAmount":0}}'),
      ('gunshopEight', 'Ammunation', 2569.38, 293.99, 108.74, 1650000, '{"6":{"price":5000,"gunlicense":false,"item":"WEAPON_FLAREGUN","stock":100,"requireAmount":0,"require":false},"5":{"price":1000,"gunlicense":false,"item":"WEAPON_FLAREGUN_AMMO","stock":10000,"require":false,"requireAmount":0},"4":{"price":2500,"gunlicense":false,"item":"GADGET_PARACHUTE","stock":1000,"requireAmount":0,"require":false},"3":{"price":200,"gunlicense":false,"item":"WEAPON_PISTOL_AMMO","stock":10000,"require":false,"requireAmount":0},"2":{"price":110000,"gunlicense":true,"item":"WEAPON_PISTOL","stock":100,"requireAmount":0,"require":false},"1":{"price":10000,"gunlicense":false,"item":"mochila-grande","stock":1000,"require":false,"requireAmount":0}}'),
      ('gunshopNine', 'Ammunation', -3172.68, 1086.74, 20.84, 1650000, '{"6":{"price":5000,"gunlicense":false,"item":"WEAPON_FLAREGUN","stock":100,"requireAmount":0,"require":false},"5":{"price":1000,"gunlicense":false,"item":"WEAPON_FLAREGUN_AMMO","stock":10000,"require":false,"requireAmount":0},"4":{"price":2500,"gunlicense":false,"item":"GADGET_PARACHUTE","stock":1000,"requireAmount":0,"require":false},"3":{"price":200,"gunlicense":false,"item":"WEAPON_PISTOL_AMMO","stock":10000,"require":false,"requireAmount":0},"2":{"price":110000,"gunlicense":true,"item":"WEAPON_PISTOL","stock":100,"requireAmount":0,"require":false},"1":{"price":10000,"gunlicense":false,"item":"mochila-grande","stock":1000,"require":false,"requireAmount":0}}'),
      ('gunshopTeen', 'Ammunation', 20.89, -1106.31, 29.8, 1650000, '{"6":{"price":5000,"gunlicense":false,"item":"WEAPON_FLAREGUN","stock":100,"requireAmount":0,"require":false},"5":{"price":1000,"gunlicense":false,"item":"WEAPON_FLAREGUN_AMMO","stock":10000,"require":false,"requireAmount":0},"4":{"price":2500,"gunlicense":false,"item":"GADGET_PARACHUTE","stock":1000,"requireAmount":0,"require":false},"3":{"price":200,"gunlicense":false,"item":"WEAPON_PISTOL_AMMO","stock":10000,"require":false,"requireAmount":0},"2":{"price":110000,"gunlicense":true,"item":"WEAPON_PISTOL","stock":100,"requireAmount":0,"require":false},"1":{"price":10000,"gunlicense":false,"item":"mochila-grande","stock":1000,"require":false,"requireAmount":0}}'),
      ('gunshopEleven', 'Ammunation', 811.37, -2157.55, 29.62, 1650000, '{"6":{"price":5000,"gunlicense":false,"item":"WEAPON_FLAREGUN","stock":100,"requireAmount":0,"require":false},"5":{"price":1000,"gunlicense":false,"item":"WEAPON_FLAREGUN_AMMO","stock":10000,"require":false,"requireAmount":0},"4":{"price":2500,"gunlicense":false,"item":"GADGET_PARACHUTE","stock":1000,"requireAmount":0,"require":false},"3":{"price":200,"gunlicense":false,"item":"WEAPON_PISTOL_AMMO","stock":10000,"require":false,"requireAmount":0},"2":{"price":110000,"gunlicense":true,"item":"WEAPON_PISTOL","stock":100,"requireAmount":0,"require":false},"1":{"price":10000,"gunlicense":false,"item":"mochila-grande","stock":1000,"require":false,"requireAmount":0}}'),
      ('digitalshopOne', 'Digitalden', -656.8, -857.49, 24.5, 1650000, '{"1":{"price":3000,"gunlicense":false,"item":"jbl","stock":1000,"requireAmount":0,"require":false},"2":{"price":500,"gunlicense":false,"item":"calculadora","stock":1000,"requireAmount":0,"require":false},"3":{"price":5000,"gunlicense":false,"item":"tablet","stock":1000,"requireAmount":0,"require":false},"4":{"price":5000,"gunlicense":false,"item":"notebook","stock":10000,"requireAmount":0,"require":false},"5":{"price":5000,"gunlicense":false,"item":"controleremoto","stock":1000,"requireAmount":0,"require":false},"6":{"price":5000,"gunlicense":false,"item":"baterias","stock":500,"requireAmount":0,"require":false},"7":{"price":3000,"gunlicense":false,"item":"radio","stock":500,"requireAmount":0,"require":false},"8":{"price":3000,"gunlicense":false,"item":"maquininha","stock":1500,"requireAmount":0,"require":false}}'),
      ('ifruitshopOne', 'IFruit', -626.67, -279.85, 35.58, 1650000, '{"1":{"price":5000,"gunlicense":false,"item":"celular","stock":1000,"requireAmount":0,"require":false},"2":{"price":8500,"gunlicense":false,"item":"celular-pro","stock":1000,"requireAmount":0,"require":false}}'),
      ('skinshopOne', 'Loja de Roupas', 427.0, -806.29, 29.5, 1650000, '{"1":{"price":5000,"gunlicense":false,"item":"mochila-pequena","stock":1000,"requireAmount":0,"require":false},"2":{"price":8500,"gunlicense":false,"item":"mochila-media","stock":1000,"requireAmount":0,"require":false},"3":{"price":8500,"gunlicense":false,"item":"mochila-grande","stock":1000,"requireAmount":0,"require":false},"4":{"price":8500,"gunlicense":false,"item":"chapeu","stock":1000,"requireAmount":0,"require":false},"5":{"price":8500,"gunlicense":false,"item":"mascara","stock":1000,"requireAmount":0,"require":false},"6":{"price":8500,"gunlicense":false,"item":"oculos","stock":1000,"requireAmount":0,"require":false}}'),
      ('skinshopTwo', 'Loja de Roupas', 73.98, -1393.03, 29.38, 1650000, '{"1":{"price":5000,"gunlicense":false,"item":"mochila-pequena","stock":1000,"requireAmount":0,"require":false},"2":{"price":8500,"gunlicense":false,"item":"mochila-media","stock":1000,"requireAmount":0,"require":false},"3":{"price":8500,"gunlicense":false,"item":"mochila-grande","stock":1000,"requireAmount":0,"require":false},"4":{"price":8500,"gunlicense":false,"item":"chapeu","stock":1000,"requireAmount":0,"require":false},"5":{"price":8500,"gunlicense":false,"item":"mascara","stock":1000,"requireAmount":0,"require":false},"6":{"price":8500,"gunlicense":false,"item":"oculos","stock":1000,"requireAmount":0,"require":false}}'),
      ('skinshopThree', 'Loja de Roupas',-823.08, -1072.25, 11.33, 1650000, '{"1":{"price":5000,"gunlicense":false,"item":"mochila-pequena","stock":1000,"requireAmount":0,"require":false},"2":{"price":8500,"gunlicense":false,"item":"mochila-media","stock":1000,"requireAmount":0,"require":false},"3":{"price":8500,"gunlicense":false,"item":"mochila-grande","stock":1000,"requireAmount":0,"require":false},"4":{"price":8500,"gunlicense":false,"item":"chapeu","stock":1000,"requireAmount":0,"require":false},"5":{"price":8500,"gunlicense":false,"item":"mascara","stock":1000,"requireAmount":0,"require":false},"6":{"price":8500,"gunlicense":false,"item":"oculos","stock":1000,"requireAmount":0,"require":false}}'),
      ('skinshopFour', 'Loja de Roupas', -1193.98, -766.82, 17.32, 1650000, '{"1":{"price":5000,"gunlicense":false,"item":"mochila-pequena","stock":1000,"requireAmount":0,"require":false},"2":{"price":8500,"gunlicense":false,"item":"mochila-media","stock":1000,"requireAmount":0,"require":false},"3":{"price":8500,"gunlicense":false,"item":"mochila-grande","stock":1000,"requireAmount":0,"require":false},"4":{"price":8500,"gunlicense":false,"item":"chapeu","stock":1000,"requireAmount":0,"require":false},"5":{"price":8500,"gunlicense":false,"item":"mascara","stock":1000,"requireAmount":0,"require":false},"6":{"price":8500,"gunlicense":false,"item":"oculos","stock":1000,"requireAmount":0,"require":false}}'),
      ('skinshopFive', 'Loja de Roupas', -164.56, -301.68, 39.74, 1650000, '{"1":{"price":5000,"gunlicense":false,"item":"mochila-pequena","stock":1000,"requireAmount":0,"require":false},"2":{"price":8500,"gunlicense":false,"item":"mochila-media","stock":1000,"requireAmount":0,"require":false},"3":{"price":8500,"gunlicense":false,"item":"mochila-grande","stock":1000,"requireAmount":0,"require":false},"4":{"price":8500,"gunlicense":false,"item":"chapeu","stock":1000,"requireAmount":0,"require":false},"5":{"price":8500,"gunlicense":false,"item":"mascara","stock":1000,"requireAmount":0,"require":false},"6":{"price":8500,"gunlicense":false,"item":"oculos","stock":1000,"requireAmount":0,"require":false}}'),
      ('skinshopSix', 'Loja de Roupas', 127.03, -224.24, 54.56, 1650000, '{"1":{"price":5000,"gunlicense":false,"item":"mochila-pequena","stock":1000,"requireAmount":0,"require":false},"2":{"price":8500,"gunlicense":false,"item":"mochila-media","stock":1000,"requireAmount":0,"require":false},"3":{"price":8500,"gunlicense":false,"item":"mochila-grande","stock":1000,"requireAmount":0,"require":false},"4":{"price":8500,"gunlicense":false,"item":"chapeu","stock":1000,"requireAmount":0,"require":false},"5":{"price":8500,"gunlicense":false,"item":"mascara","stock":1000,"requireAmount":0,"require":false},"6":{"price":8500,"gunlicense":false,"item":"oculos","stock":1000,"requireAmount":0,"require":false}}'),
      ('skinshopSeven', 'Loja de Roupas', -708.25, -153.02, 37.42, 1650000, '{"1":{"price":5000,"gunlicense":false,"item":"mochila-pequena","stock":1000,"requireAmount":0,"require":false},"2":{"price":8500,"gunlicense":false,"item":"mochila-media","stock":1000,"requireAmount":0,"require":false},"3":{"price":8500,"gunlicense":false,"item":"mochila-grande","stock":1000,"requireAmount":0,"require":false},"4":{"price":8500,"gunlicense":false,"item":"chapeu","stock":1000,"requireAmount":0,"require":false},"5":{"price":8500,"gunlicense":false,"item":"mascara","stock":1000,"requireAmount":0,"require":false},"6":{"price":8500,"gunlicense":false,"item":"oculos","stock":1000,"requireAmount":0,"require":false}}'),
      ('skinshopEight', 'Loja de Roupas', -1449.87, -239.04, 49.82, 1650000, '{"1":{"price":5000,"gunlicense":false,"item":"mochila-pequena","stock":1000,"requireAmount":0,"require":false},"2":{"price":8500,"gunlicense":false,"item":"mochila-media","stock":1000,"requireAmount":0,"require":false},"3":{"price":8500,"gunlicense":false,"item":"mochila-grande","stock":1000,"requireAmount":0,"require":false},"4":{"price":8500,"gunlicense":false,"item":"chapeu","stock":1000,"requireAmount":0,"require":false},"5":{"price":8500,"gunlicense":false,"item":"mascara","stock":1000,"requireAmount":0,"require":false},"6":{"price":8500,"gunlicense":false,"item":"oculos","stock":1000,"requireAmount":0,"require":false}}'),
      ('skinshopNine', 'Loja de Roupas', -3169.37, 1043.19, 20.87, 1650000, '{"1":{"price":5000,"gunlicense":false,"item":"mochila-pequena","stock":1000,"requireAmount":0,"require":false},"2":{"price":8500,"gunlicense":false,"item":"mochila-media","stock":1000,"requireAmount":0,"require":false},"3":{"price":8500,"gunlicense":false,"item":"mochila-grande","stock":1000,"requireAmount":0,"require":false},"4":{"price":8500,"gunlicense":false,"item":"chapeu","stock":1000,"requireAmount":0,"require":false},"5":{"price":8500,"gunlicense":false,"item":"mascara","stock":1000,"requireAmount":0,"require":false},"6":{"price":8500,"gunlicense":false,"item":"oculos","stock":1000,"requireAmount":0,"require":false}}'),
      ('skinshopTeen', 'Loja de Roupas', -1102.65, 2711.47, 19.11, 1650000, '{"1":{"price":5000,"gunlicense":false,"item":"mochila-pequena","stock":1000,"requireAmount":0,"require":false},"2":{"price":8500,"gunlicense":false,"item":"mochila-media","stock":1000,"requireAmount":0,"require":false},"3":{"price":8500,"gunlicense":false,"item":"mochila-grande","stock":1000,"requireAmount":0,"require":false},"4":{"price":8500,"gunlicense":false,"item":"chapeu","stock":1000,"requireAmount":0,"require":false},"5":{"price":8500,"gunlicense":false,"item":"mascara","stock":1000,"requireAmount":0,"require":false},"6":{"price":8500,"gunlicense":false,"item":"oculos","stock":1000,"requireAmount":0,"require":false}}'),
      ('skinshopEleven', 'Loja de Roupas', 612.94, 2762.77, 42.09, 1650000, '{"1":{"price":5000,"gunlicense":false,"item":"mochila-pequena","stock":1000,"requireAmount":0,"require":false},"2":{"price":8500,"gunlicense":false,"item":"mochila-media","stock":1000,"requireAmount":0,"require":false},"3":{"price":8500,"gunlicense":false,"item":"mochila-grande","stock":1000,"requireAmount":0,"require":false},"4":{"price":8500,"gunlicense":false,"item":"chapeu","stock":1000,"requireAmount":0,"require":false},"5":{"price":8500,"gunlicense":false,"item":"mascara","stock":1000,"requireAmount":0,"require":false},"6":{"price":8500,"gunlicense":false,"item":"oculos","stock":1000,"requireAmount":0,"require":false}}'),
      ('skinshopTwelve', 'Loja de Roupas', 1196.42, 2711.73, 38.23, 1650000, '{"1":{"price":5000,"gunlicense":false,"item":"mochila-pequena","stock":1000,"requireAmount":0,"require":false},"2":{"price":8500,"gunlicense":false,"item":"mochila-media","stock":1000,"requireAmount":0,"require":false},"3":{"price":8500,"gunlicense":false,"item":"mochila-grande","stock":1000,"requireAmount":0,"require":false},"4":{"price":8500,"gunlicense":false,"item":"chapeu","stock":1000,"requireAmount":0,"require":false},"5":{"price":8500,"gunlicense":false,"item":"mascara","stock":1000,"requireAmount":0,"require":false},"6":{"price":8500,"gunlicense":false,"item":"oculos","stock":1000,"requireAmount":0,"require":false}}'),
      ('skinshopThirteen', 'Loja de Roupas', 1695.27, 4823.25, 42.07, 1650000, '{"1":{"price":5000,"gunlicense":false,"item":"mochila-pequena","stock":1000,"requireAmount":0,"require":false},"2":{"price":8500,"gunlicense":false,"item":"mochila-media","stock":1000,"requireAmount":0,"require":false},"3":{"price":8500,"gunlicense":false,"item":"mochila-grande","stock":1000,"requireAmount":0,"require":false},"4":{"price":8500,"gunlicense":false,"item":"chapeu","stock":1000,"requireAmount":0,"require":false},"5":{"price":8500,"gunlicense":false,"item":"mascara","stock":1000,"requireAmount":0,"require":false},"6":{"price":8500,"gunlicense":false,"item":"oculos","stock":1000,"requireAmount":0,"require":false}}'),
      ('skinshopFourteen', 'Loja de Roupas', 5.99, 6511.53, 31.88, 1650000, '{"1":{"price":5000,"gunlicense":false,"item":"mochila-pequena","stock":1000,"requireAmount":0,"require":false},"2":{"price":8500,"gunlicense":false,"item":"mochila-media","stock":1000,"requireAmount":0,"require":false},"3":{"price":8500,"gunlicense":false,"item":"mochila-grande","stock":1000,"requireAmount":0,"require":false},"4":{"price":8500,"gunlicense":false,"item":"chapeu","stock":1000,"requireAmount":0,"require":false},"5":{"price":8500,"gunlicense":false,"item":"mascara","stock":1000,"requireAmount":0,"require":false},"6":{"price":8500,"gunlicense":false,"item":"oculos","stock":1000,"requireAmount":0,"require":false}}')
  ]]  
)

vRP.prepare('vRP/create_orgs',
  [[
    CREATE TABLE IF NOT EXISTS `orgs` (
      `organization` varchar(255) NOT NULL,
      `owner` int(11) NOT NULL DEFAULT 0,
      `members` text NOT NULL DEFAULT '[]',
      `vault` int(11) NOT NULL DEFAULT 0,
      PRIMARY KEY (`organization`) USING BTREE
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
  ]]
)

vRP.prepare('vRP/create_coins',
  [[
    CREATE TABLE IF NOT EXISTS `coins` (
      `id` int(11) NOT NULL AUTO_INCREMENT,
      `user_id` int(11) NOT NULL,
      `product` text DEFAULT NULL,
      `expirate` timestamp NULL DEFAULT NULL,
      PRIMARY KEY (`id`) USING BTREE
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
  ]]
)

vRP.prepare('vRP/create_chests',
  [[
    CREATE TABLE IF NOT EXISTS `chests` (
      `permission` varchar(50) DEFAULT NULL,
      `name` varchar(50) DEFAULT NULL,
      `x` text NOT NULL,
      `y` text NOT NULL,
      `z` text NOT NULL,
      `grid` int(11) NOT NULL DEFAULT 0,
      `weight` int(11) NOT NULL DEFAULT 0,
      `slots` int(11) NOT NULL DEFAULT 0
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8;
  ]]
)

vRP.prepare('vRP/create_bank',
  [[
    CREATE TABLE IF NOT EXISTS `bank` (
        `account` int(11) NOT NULL AUTO_INCREMENT,
        `user_id` int(11) NOT NULL,
        `username` varchar(255) NOT NULL,
        `password` varchar(255) NOT NULL,
        `balance` int(11) NOT NULL DEFAULT 0,
        `score` int(11) NOT NULL DEFAULT 30,
        `pix` varchar(255) NOT NULL,
        `loan_available` int(11) NOT NULL DEFAULT 0,
        `loan_contracted` int(11) NOT NULL DEFAULT 0,
        `loan_last_payment` int(11) NOT NULL,
        `loan_data` text NOT NULL,
        `credit_available` int(11) NOT NULL DEFAULT 0,
        `credit_used` int(11) NOT NULL DEFAULT 0,
        `credit_last_payment` int(11) NOT NULL,
        `credit_data` text NOT NULL,
        `invoices` text NOT NULL,
        `transactions` text NOT NULL,
        PRIMARY KEY (`account`),
        KEY `user_id` (`user_id`),
        KEY `username` (`username`),
        KEY `pix` (`pix`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
  ]]
)

vRP.prepare('vRP/create_dealership',
[[
  CREATE TABLE IF NOT EXISTS `dealership` (
  `name` varchar(60) NOT NULL,
  `model` varchar(60) NOT NULL,
  `price` int(11) NOT NULL,
  `category` varchar(60) DEFAULT NULL,
  `stock` int(11) DEFAULT 0,
  PRIMARY KEY (`model`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
]])

vRP.prepare('vRP/create_dealership_basic',
[[
  INSERT IGNORE INTO dealership (name, model, price, category, stock) VALUES
	('Adder', 'adder', 200000, 'super', 99),
	('Akuma', 'akuma', 15000, 'motos', 99),
	('Alpha', 'alpha', 100000, 'sports', 99),
	('Ardent', 'ardent', 50000, 'sportsclassics', 99),
	('Asea', 'asea', 10000, 'sedans', 99),
	('Asterope', 'asterope', 30000, 'sedans', 99),
	('Autarch', 'autarch', 1000000, 'super', 99),
	('Avarus', 'avarus', 19000, 'motos', 99),
	('Baller', 'baller', 300000, 'suvs', 99),
	('Baller Super', 'baller4', 350000, 'suvs', 99),
	('Banshee', 'banshee', 90000, 'sports', 99),
	('Banshee 900R', 'banshee2', 300000, 'super', 99),
	('Bati', 'bati', 50000, 'motos', 99),
	('Bestia GTS', 'bestiagts', 78000, 'sports', 99),
	('Bf Injection', 'bfinjection', 15000, 'offroad', 99),
	('Bifta', 'bifta', 18000, 'offroad', 99),
	('Bison', 'bison', 250000, 'vans', 99),
	('BJXL', 'bjxl', 150000, 'suvs', 99),
	('Blade', 'blade', 50000, 'muscle', 99),
	('Blista', 'blista', 50000, 'compacts', 99),
	('Blista S', 'blista2', 60000, 'sports', 99),
	('Blista GT', 'blista3', 65000, 'sports', 99),
	('Bobcatxl', 'bobcatxl', 300000, 'vans', 99),
	('Brawler', 'brawler', 150000, 'offroad', 99),
	('Brioso', 'brioso', 62000, 'compacts', 99),
	('Btype', 'btype', 90000, 'sportsclassics', 99),
	('Btype SC', 'btype2', 95000, 'sportsclassics', 99),
	('Btype S', 'btype3', 99000, 'sportsclassics', 99),
	('Buccaneer', 'buccaneer', 155000, 'muscle', 99),
	('Buffalo', 'buffalo', 68000, 'sports', 99),
	('Buffalo GT', 'buffalo3', 70000, 'sports', 99),
	('Bullet', 'bullet', 95000, 'super', 99),
	('Camper', 'camper', 60000, 'vans', 99),
	('Carboni', 'carbonizzare', 195000, 'sports', 99),
	('Carbonr S', 'carbonrs', 31200, 'motos', 99),
	('Casco', 'casco', 42000, 'sportsclassics', 99),
	('Cavalcade', 'cavalcade', 92000, 'suvs', 99),
	('Cheetah', 'cheetah', 2500000, 'super', 99),
	('Cheetah SC', 'cheetah2', 2800000, 'sportsclassics', 99),
	('Chino', 'chino', 70000, 'muscle', 99),
	('Chino S', 'chino2', 75000, 'muscle', 99),
	('Cliff hanger', 'cliffhanger', 15800, 'motos', 99),
	('COG55', 'cog55', 210000, 'sedans', 99),
	('Cogcabrio', 'cogcabrio', 70000, 'coupes', 99),
	('Cognoscenti', 'cognoscenti', 200000, 'sedans', 99),
	('Comet SX', 'comet2', 120000, 'sports', 99),
	('Contender', 'contender', 300000, 'suvs', 99),
	('Coquette', 'coquette', 75000, 'sports', 99),
	('Coquette SC', 'coquette2', 74000, 'sportsclassics', 99),
	('Coquette GM', 'coquette3', 80000, 'muscle', 99),
	('Cyclone', 'cyclone', 3000000, 'super', 99),
	('Daemon', 'daemon', 18100, 'motos', 99),
	('Defiler', 'defiler', 25000, 'motos', 99),
	('Diablous', 'diablous', 45000, 'motos', 99),
	('Diablous S', 'Diablous2', 50000, 'motos', 99),
	('Dilettante', 'dilettante', 40000, 'compacts', 99),
	('Dominator', 'dominator', 55000, 'muscle', 99),
	('Double', 'double', 35000, 'motos', 99),
	('Dubsta', 'dubsta', 95000, 'suvs', 99),
	('Dukes', 'dukes', 67000, 'muscle', 99),
	('Elegy', 'elegy', 300000, 'sports', 99),
	('Elegy S', 'elegy2', 330000, 'sports', 99),
	('Emperor', 'emperor', 8000, 'sedans', 99),
	('Entity XF', 'entityxf', 300000, 'super', 99),
	('Ess key', 'esskey', 14000, 'motos', 99),
	('Exemplar', 'exemplar', 90000, 'coupes', 99),
	('F620', 'f620', 300000, 'coupes', 99),
	('Faction', 'faction', 110000, 'muscle', 99),
	('Faggio S', 'faggio', 5500, 'motos', 99),
	('FCR', 'fcr', 13500, 'motos', 99),
	('FCR S', 'fcr2', 19600, 'motos', 99),
	('Felon', 'felon', 100000, 'coupes', 99),
	('Felon S', 'felon2', 150000, 'coupes', 99),
	('Feltzer S', 'feltzer2', 113100, 'sports', 99),
	('Feltzer SC', 'feltzer3', 80000, 'sportsclassics', 99),
	('FMJ', 'fmj', 330000, 'super', 99),
	('FQ2', 'fq2', 253000, 'suvs', 99),
	('Fugitive', 'fugitive', 66000, 'sedans', 99),
	('Furore GT', 'furoregt', 100000, 'sports', 99),
	('Fusilade', 'fusilade', 66000, 'sports', 99),
	('Futo', 'futo', 75000, 'sports', 99),
	('Gargoyle', 'gargoyle', 34000, 'motos', 99),
	('Gauntlet', 'gauntlet', 80000, 'muscle', 99),
	('Glendale', 'glendale', 150000, 'sedans', 99),
	('GPL', 'gp1', 300000, 'super', 99),
	('Granger', 'granger', 120000, 'suvs', 99),
	('Gresley', 'gresley', 250000, 'suvs', 99),
	('GT500', 'gt500', 130000, 'sportsclassics', 99),
	('Habanero', 'habanero', 62000, 'suvs', 99),
	('Hakuchou', 'hakuchou', 150000, 'motos', 99),
	('Hermes', 'hermes', 53000, 'muscle', 99),
	('Hexer', 'hexer', 19500, 'motos', 99),
	('Hotknife', 'hotknife', 50000, 'muscle', 99),
	('Huntley', 'huntley', 250000, 'suvs', 99),
	('Infernus', 'infernus', 130000, 'super', 99),
	('Infernus SC', 'infernus2', 70000, 'sportsclassics', 99),
	('Ingot', 'ingot', 45000, 'sedans', 99),
	('Innovation', 'innovation', 32000, 'motos', 99),
	('Intruder', 'intruder', 53000, 'sedans', 99),
	('Issi S', 'issi2', 38500, 'compacts', 99),
	('Italigtb', 'italigtb', 500000, 'super', 99),
	('Jackal', 'jackal', 92000, 'coupes', 99),
	('Jester', 'jester', 400000, 'sports', 99),
	('Journey', 'journey', 80000, 'vans', 99),
	('Khamelion', 'khamelion', 83000, 'sports', 99),
	('Kuruma', 'kuruma', 98000, 'sports', 99),
	('Lands Talker', 'landstalker', 85000, 'suvs', 99),
	('LE7B', 'le7b', 450000, 'super', 99),
	('Lectro', 'lectro', 40000, 'motos', 99),
	('Lynx S', 'lynx2', 173000, 'sports', 99),
	('Mamba', 'mamba', 90000, 'sportsclassics', 99),
	('Manana', 'manana', 66000, 'sportsclassics', 99),
	('Massacro', 'massacro', 88000, 'sports', 99),
	('Mesa S', 'mesa', 98000, 'suvs', 99),
	('Mesa OR', 'mesa3', 75000, 'offroad', 99),
	('Minivan', 'minivan', 100000, 'vans', 99),
	('Minivan2', 'minivan2', 130000, 'vans', 99),
	('Monroe', 'monroe', 84000, 'sportsclassics', 99),
	('Moon Beam', 'moonbeam', 150000, 'muscle', 99),
	('Neon', 'neon', 150000, 'sports', 99),
	('Nero', 'nero', 2500000, 'super', 99),
	('Nightblade', 'nightblade', 25000, 'motos', 99),
	('Night Shade', 'nightshade', 72300, 'muscle', 99),
	('Ninef', 'ninef', 63000, 'sports', 99),
	('Omnis', 'omnis', 68000, 'sports', 99),
	('Oracle S', 'oracle', 82000, 'coupes', 99),
	('Oracle', 'oracle2', 87000, 'coupes', 99),
	('Osiris', 'osiris', 300000, 'super', 99),
	('Panto', 'panto', 22000, 'compacts', 99),
	('Pariah', 'pariah', 72200, 'sports', 99),
	('Patriot', 'patriot', 70000, 'suvs', 99),
	('PCJ', 'pcj', 13500, 'motos', 99),
	('Penetrator', 'penetrator', 380000, 'super', 99),
	('Penumbra', 'penumbra', 66500, 'sports', 99),
	('Peyote', 'peyote', 86500, 'sportsclassics', 99),
	('Pfister', 'pfister811', 1304000, 'super', 99),
	('Picador', 'picador', 45000, 'muscle', 99),
	('Pigalle', 'pigalle', 20000, 'sportsclassics', 99),
	('Prairie', 'prairie', 430000, 'compacts', 99),
	('Premier', 'premier', 35000, 'sedans', 99),
	('Primo', 'primo', 100000, 'sedans', 99),
	('Prototipo', 'prototipo', 3000000, 'super', 99),
	('Radi', 'radi', 74000, 'suvs', 99),
	('Raiden', 'raiden', 68800, 'sports', 99),
	('Rancher XL', 'rancherxl', 79000, 'offroad', 99),
	('Rapid GT', 'rapidgt', 35000, 'sports', 99),
	('Rapidgt Turbo', 'rapidgt2', 82500, 'sports', 99),
	('Rapid GTSC', 'rapidgt3', 38000, 'sportsclassics', 99),
	('raptor', 'raptor', 84000, 'sports', 99),
	('Ratloader MS', 'ratloader2', 18000, 'muscle', 99),
	('Reaper', 'reaper', 300000, 'super', 99),
	('Rebel OR', 'rebel2', 20000, 'offroad', 99),
	('Regina', 'regina', 22500, 'sedans', 99),
	('Retinue', 'retinue', 78000, 'sportsclassics', 99),
	('Revolter', 'revolter', 200000, 'sports', 99),
	('Rhapsody', 'rhapsody', 30000, 'compacts', 99),
	('Rocoto', 'rocoto', 110000, 'suvs', 99),
	('Ruffian', 'ruffian', 10000, 'motos', 99),
	('Ruiner', 'ruiner', 54000, 'muscle', 99),
	('Rumpo VN', 'rumpo3', 250000, 'vans', 99),
	('ruston', 'ruston', 93200, 'sports', 99),
	('Sabre GT', 'sabregt', 87000, 'muscle', 99),
	('Sadler', 'sadler', 169000, 'suvs', 99),
	('Sanchez', 'sanchez2', 15000, 'motos', 99),
	('Savestra', 'savestra', 85000, 'sportsclassics', 99),
	('SCL', 'sc1', 100000, 'super', 99),
	('Schafter SD', 'schafter2', 45000, 'sedans', 99),
	('Schafter ST', 'schafter3', 40000, 'sports', 99),
	('Schwarzer', 'schwarzer', 65350, 'sports', 99),
	('Seminole', 'seminole', 97000, 'suvs', 99),
	('sentinel', 'sentinel', 100000, 'coupes', 99),
	('Serrano', 'serrano', 78000, 'suvs', 99),
	('Seven 70', 'seven70', 93000, 'sports', 99),
	('Sheava', 'sheava', 250000, 'super', 99),
	('Slam Van', 'slamvan', 80000, 'muscle', 99),
	('Specter', 'specter', 88750, 'sports', 99),
	('Speedo', 'speedo', 230000, 'vans', 99),
	('stalion', 'stalion', 42000, 'muscle', 99),
	('Stanier', 'stanier', 40000, 'sedans', 99),
	('Stinger', 'stinger', 76000, 'sportsclassics', 99),
	('Stratum', 'stratum', 63000, 'sedans', 99),
	('Streiter', 'streiter', 120000, 'sports', 99),
	('Stretch', 'stretch', 1300000, 'sedans', 99),
	('Stromberg', 'stromberg', 77000, 'sportsclassics', 99),
	('Sultan', 'sultan', 54642, 'sports', 99),
	('sultanrs', 'sultanrs', 95000, 'super', 99),
	('Superd', 'superd', 42000, 'sedans', 99),
	('Surano', 'surano', 71350, 'sports', 99),
	('Surge', 'surge', 30000, 'sedans', 99),
	('T20', 't20', 2800000, 'super', 99),
	('Tailgater', 'tailgater', 86000, 'sedans', 99),
	('Tampa GT', 'tampa', 90000, 'muscle', 99),
	('Tampa ST', 'tampa2', 43500, 'sports', 99),
	('Tempesta', 'tempesta', 900000, 'super', 99),
	('Torero', 'torero', 79000, 'sportsclassics', 99),
	('Tornado', 'tornado', 68000, 'sportsclassics', 99),
	('Tropos', 'tropos', 95000, 'sports', 99),
	('Turismo SC', 'turismo2', 1200000, 'sportsclassics', 99),
	('Turismor', 'turismor', 2200000, 'super', 99),
	('Tyrus', 'tyrus', 2300000, 'super', 99),
	('Vacca', 'vacca', 800000, 'super', 99),
	('Vader', 'vader', 11700, 'motos', 99),
	('Vagner', 'vagner', 3500000, 'super', 99),
	('Verlierer ST', 'verlierer2', 96000, 'sports', 99),
	('Vigero', 'vigero', 78000, 'muscle', 99),
	('Virgo', 'virgo', 75000, 'muscle', 99),
	('Viseris', 'viseris', 200000, 'sportsclassics', 99),
	('Visione', 'visione', 2250000, 'super', 99),
	('Voltic', 'voltic', 100000, 'super', 99),
	('Voodoo', 'voodoo', 150000, 'muscle', 99),
	('Vortex', 'vortex', 13356, 'motos', 99),
	('Warrener', 'warrener', 64000, 'sedans', 99),
	('Washington', 'washington', 25000, 'sedans', 99),
	('Windsor', 'windsor', 500000, 'coupes', 99),
	('windsor S', 'windsor2', 550000, 'coupes', 99),
	('Wolfsbane', 'wolfsbane', 27000, 'motos', 99),
	('XA21', 'xa21', 2375000, 'super', 99),
	('XLS', 'xls', 253000, 'suvs', 99),
	('Yosemite', 'yosemite', 475000, 'muscle', 99),
	('Youga', 'Youga', 24000, 'vans', 99),
	('Youga VN', 'youga2', 300000, 'vans', 99),
	('Zentorno', 'zentorno', 725000, 'super', 99),
	('zion', 'zion', 75000, 'coupes', 99),
	('zion S', 'zion2', 80000, 'coupes', 99),
	('Ztype', 'ztype', 200000, 'sportsclassics', 99);
]])

vRP.prepare('vRP/create_player', 'INSERT INTO players(steam, discord) VALUES(@steam, @discord)')
vRP.prepare('vRP/create_player_whitout_discord', 'INSERT INTO players(steam) VALUES(@steam)')

vRP.prepare('vRP/get_player', 'SELECT * FROM players WHERE steam = @steam')
vRP.prepare('vRP/get_priority', 'SELECT steam, priority FROM players')
vRP.prepare('vRP/update_priority','UPDATE players SET premium = 0, premium_days = 0, priority = 0 WHERE steam = @steam')

vRP.prepare('vRP/get_user', 'SELECT * FROM users WHERE user_id = @user_id AND deleted = 0')
vRP.prepare('vRP/get_user_by_steam', 'SELECT * FROM users WHERE steam = @steam AND deleted = 0')
vRP.prepare('vRP/update_user', 'UPDATE users SET registration = @registration, phone = @phone WHERE user_id = @user_id')
vRP.prepare('vRP/get_registration', 'SELECT user_id FROM users WHERE registration = @registration')
vRP.prepare('vRP/get_user_by_phone', 'SELECT user_id FROM users WHERE phone = @phone')
vRP.prepare('vRP/create_user', 'INSERT INTO users(steam, name, firstname) VALUES(@steam, @name, @firstname)')
vRP.prepare('vRP/remove_user', 'UPDATE users SET deleted = 1 WHERE user_id = @user_id')
vRP.prepare('vRP/rename_user', 'UPDATE users SET name = @name, firstname = @firstname WHERE user_id = @user_id')

vRP.prepare('vRP/get_vehicle_by_plate', 'SELECT * FROM vehicles WHERE plate = @plate')
vRP.prepare('vRP/update_vehicle', 'UPDATE vehicles SET engine = @engine, body = @body, fuel = @fuel WHERE plate = @plate AND vehicle = @vehicle')
vRP.prepare('vRP/set_arrested', 'UPDATE vehicles SET arrested = @arrested, arrested_time = @arrested_time WHERE plate = @plate AND vehicle = @vehicle')
vRP.prepare('vRP/move_vehicle', 'UPDATE vehicles SET user_id = @nuser_id WHERE user_id = @user_id AND vehicle = @vehicle')
vRP.prepare('vRP/add_vehicle', 'INSERT INTO vehicles (user_id, vehicle, plate, tax) VALUES (@user_id, @vehicle, @plate, @tax)')
vRP.prepare('vRP/con_maxvehs', 'SELECT COUNT(vehicle) as qtd FROM vehicles WHERE user_id = @user_id')
vRP.prepare('vRP/update_vehicle_plate', 'UPDATE vehicles SET plate = @new_plate WHERE plate = @plate AND vehicle = @vehicle')

vRP.prepare('vRP/update_garages', 'UPDATE users SET garage = garage + 1 WHERE user_id = @user_id')

vRP.prepare('vRP/set_user_data', 'REPLACE INTO users_data(user_id, dkey, dvalue) VALUES(@user_id, @key, @value)')
vRP.prepare('vRP/get_user_data', 'SELECT dvalue FROM users_data WHERE user_id = @user_id AND dkey = @key')

vRP.prepare('vRP/set_server_data', 'REPLACE INTO server_data(dkey, dvalue) VALUES(@key, @value)')
vRP.prepare('vRP/get_server_data', 'SELECT dvalue FROM server_data WHERE dkey = @key')
vRP.prepare('vRP/rem_server_data', 'DELETE FROM server_data WHERE dkey = @key')

vRP.prepare('vRP/get_group', 'SELECT * FROM permissions WHERE user_id = @user_id AND permission = @permission')
vRP.prepare('vRP/add_group', 'INSERT INTO permissions(user_id, permission) VALUES(@user_id, @permission)')
vRP.prepare('vRP/del_group', 'DELETE FROM permissions WHERE user_id = @user_id AND permission = @permission')

vRP.prepare('vRP/add_coins', 'UPDATE players SET coins = coins + @coins WHERE steam = @steam')
vRP.prepare('vRP/rem_coins', 'UPDATE players SET coins = coins - @coins WHERE steam = @steam')

vRP.prepare('vRP/add_weapon', 'INSERT INTO weapons(user_id, weapon, ammo) VALUES(@user_id, @weapon, @ammo)')
vRP.prepare('vRP/get_weapon', 'SELECT * FROM weapons WHERE user_id = @user_id')
vRP.prepare('vRP/update_weapon', 'UPDATE weapons SET ammo = @ammo WHERE user_id = @user_id and weapon = @weapon')
vRP.prepare('vRP/del_weapon', 'DELETE FROM weapons WHERE user_id = @user_id AND weapon = @weapon')

vRP.prepare('vRP/get_home', 'SELECT * FROM homes WHERE user_id = @user_id AND home = @home')
vRP.prepare('vRP/get_home_by_id', 'SELECT * FROM homes WHERE user_id = @user_id')
vRP.prepare('vRP/get_home_owner', 'SELECT * FROM homes WHERE user_id = @user_id AND home = @home AND owner = 1')
vRP.prepare('vRP/get_home_owner_by_id', 'SELECT * FROM homes WHERE home = @home AND owner = 1')
vRP.prepare('vRP/get_home_permissions', 'SELECT * FROM homes WHERE home = @home')
vRP.prepare('vRP/add_home_permissions', 'INSERT IGNORE INTO homes(home, user_id) VALUES(@home, @user_id)')
vRP.prepare('vRP/buy_home_permissions', 'INSERT IGNORE INTO homes(home, user_id, owner, vault) VALUES(@home, @user_id, 1, @vault)')
vRP.prepare('vRP/count_home_permissions', 'SELECT COUNT(*) as qtd FROM homes WHERE home = @home')
vRP.prepare('vRP/count_homes', 'SELECT COUNT(*) as qtd FROM homes WHERE user_id = @user_id')
vRP.prepare('vRP/rem_permissions', 'DELETE FROM homes WHERE home = @home AND user_id = @user_id')
vRP.prepare('vRP/rem_allpermissions', 'DELETE FROM homes WHERE home = @home')
vRP.prepare('vRP/upd_vaulthomes', 'UPDATE homes SET vault = vault + @vault WHERE home = @home AND owner = 1')
vRP.prepare('vRP/transfer_homes', 'UPDATE homes SET user_id = @nuser_id WHERE user_id = @user_id AND home = @home')


vRP.prepare('vRP/get_vehicles', 'SELECT * FROM vehicles WHERE plate = @plate AND vehicle = @vehicle')
vRP.prepare('vRP/get_vehicles_by_id', 'SELECT * FROM vehicles WHERE user_id = @user_id AND vehicle = @vehicle')
vRP.prepare('vRP/set_update_vehicles', 'UPDATE vehicles SET engine = @engine, body = @body, fuel = @fuel WHERE plate = @plate AND vehicle = @vehicle')
vRP.prepare('vRP/set_arrest', 'UPDATE vehicles SET arrested = @arrested, arrested_time = @arrested_time WHERE plate = @plate AND vehicle = @vehicle')
vRP.prepare('vRP/set_tax','UPDATE vehicles SET tax = @tax WHERE plate = @plate AND vehicle = @vehicle')

vRP.prepare('vRP/get_vehicle', 'SELECT * FROM vehicles WHERE user_id = @user_id')
vRP.prepare('vRP/get_vehicle_plate', 'SELECT * FROM vehicles WHERE plate = @plate')
vRP.prepare('vRP/get_vehicle_phone', 'SELECT * FROM vehicles WHERE phone = @phone')
vRP.prepare('vRP/rem_vehicle', 'DELETE FROM vehicles WHERE user_id = @user_id AND vehicle = @vehicle')
vRP.prepare('vRP/move_vehicle', 'UPDATE vehicles SET user_id = @nuser_id WHERE user_id = @user_id AND vehicle = @vehicle')
vRP.prepare('vRP/con_maxvehs', 'SELECT COUNT(vehicle) as qtd FROM vehicles WHERE user_id = @user_id AND work = false')
vRP.prepare('vRP/rem_srv_data', 'DELETE FROM srv_data WHERE dkey = @dkey')
vRP.prepare('vRP/update_garages', 'UPDATE users SET garage = garage + 1 WHERE id = @id')
vRP.prepare('vRP/update_plate_vehicle', 'UPDATE vehicles SET plate = @plate WHERE user_id = @user_id AND vehicle = @vehicle')
vRP.prepare('vRP/get_plateUser', 'SELECT plate FROM vehicles WHERE user_id = @user_id AND vehicle = @vehicle')

vRP.prepare('vRP/insert_org','INSERT INTO orgs(owner, organization, members, vault) VALUES(@owner, @organization, @members, @vault)')
vRP.prepare('vRP/insert_member','UPDATE orgs SET members = @members WHERE organization = @organization')
vRP.prepare('vRP/get_org_members', 'SELECT members FROM orgs WHERE organization = @organization')
vRP.prepare('vRP/get_org_balance', 'SELECT vault FROM orgs WHERE organization = @organization')
vRP.prepare('vRP/set_org_balance','UPDATE orgs SET vault = @vault WHERE organization = @organization')
vRP.prepare('vRP/select_org','SELECT * FROM orgs')

vRP.prepare('vRP/insertTemporaryData', 'INSERT INTO coins(user_id,product,expirate) VALUES (@user_id, @product, @expirate)')
vRP.prepare('vRP/getAppointaments', 'SELECT * FROM coins WHERE DATEDIFF(NOW(), expirate) <= 0')
vRP.prepare('vRP/deleteAppointament', 'DELETE FROM coins WHERE id = @id')

vRP.prepare('vRP/getCoins', 'SELECT coins FROM players WHERE steam = @steam')
vRP.prepare('vRP/updateCoins', 'UPDATE players SET coins = @coins WHERE steam = @steam')
vRP.prepare('vRP/giveCoins', 'UPDATE players SET coins = coins + @coins WHERE steam = @steam')
vRP.prepare('vRP/removeCoins', 'UPDATE players SET coins = coins - @coins WHERE steam = @steam')

vRP.prepare('vRP/getExistChest', 'SELECT * FROM chests WHERE name = @name')
vRP.prepare('vRP/get_alltable', 'SELECT * FROM chests')
vRP.prepare('vRP/addChest', 'INSERT INTO chests (permission, name, x, y, z, weight, slots) VALUES (@permission, @name, @x, @y, @z, @weight, @slots)')

vRP.prepare('vRP/get_bank_account', 'SELECT * FROM bank WHERE account = @account')
vRP.prepare('vRP/get_bank_id', 'SELECT * FROM bank WHERE user_id = @user_id')
vRP.prepare('vRP/get_bank_username', 'SELECT * FROM bank WHERE username = @username')
vRP.prepare('vRP/get_bank_pix', 'SELECT * FROM bank WHERE pix = @pix')
vRP.prepare('vRP/del_bank', 'UPDATE bank SET balance = balance - @balance WHERE account = @account')
vRP.prepare('vRP/add_bank', 'UPDATE bank SET balance = balance + @balance WHERE account = @account')






vRP.prepare('vRP/create_bank_acount','INSERT INTO bank(user_id, balance, username, password) VALUES(@user_id, @balance, @username, @password)')
vRP.prepare('vRP/get_account_by_user', 'SELECT account FROM bank WHERE user_id = @user_id')
vRP.prepare('vRP/get_account_by_username', 'SELECT account, password FROM bank WHERE username = @username')
vRP.prepare('vRP/get_account_by_pix', 'SELECT account FROM bank WHERE pix = @pix')
vRP.prepare('vRP/get_owner_by_pix', 'SELECT user_id FROM bank WHERE pix = @pix')
vRP.prepare('vRP/insert_account_password','UPDATE bank SET password = @password WHERE account = @account')

vRP.prepare('vRP/get_account_balance', 'SELECT balance FROM bank WHERE account = @account')
vRP.prepare('vRP/insert_account_balance','UPDATE bank SET balance = @balance WHERE account = @account')

vRP.prepare('vRP/get_account_score', 'SELECT score FROM bank WHERE account = @account')
vRP.prepare('vRP/insert_account_score','UPDATE bank SET score = @score WHERE account = @account')

vRP.prepare('vRP/get_account_pix', 'SELECT pix FROM bank WHERE account = @account')
vRP.prepare('vRP/get_pix_key', 'SELECT pix FROM bank WHERE pix = @pix')
vRP.prepare('vRP/insert_account_pix','UPDATE bank SET pix = @pix WHERE account = @account')

vRP.prepare('vRP/insert_loan_data','UPDATE bank SET loan_data = @loan_data WHERE account = @account')
vRP.prepare('vRP/get_loan_data', 'SELECT loan_data FROM bank WHERE account = @account')
vRP.prepare('vRP/get_loan_payday', 'SELECT loan_last_payment FROM bank WHERE account = @account')
vRP.prepare('vRP/insert_loan_payday','UPDATE bank SET loan_last_payment = @loan_last_payment WHERE account = @account')
vRP.prepare('vRP/insert_loan_available','UPDATE bank SET loan_available = @loan_available WHERE account = @account')
vRP.prepare('vRP/insert_loan_contracted','UPDATE bank SET loan_contracted = @loan_contracted WHERE account = @account')
vRP.prepare('vRP/get_loan_available', 'SELECT loan_available FROM bank WHERE account = @account')
vRP.prepare('vRP/get_loan_contracted', 'SELECT loan_contracted FROM bank WHERE account = @account')

vRP.prepare('vRP/insert_credit_data','UPDATE bank SET credit_data = @credit_data WHERE account = @account')
vRP.prepare('vRP/get_credit_data', 'SELECT credit_data FROM bank WHERE account = @account')
vRP.prepare('vRP/get_credit_payday', 'SELECT credit_last_payment FROM bank WHERE account = @account')
vRP.prepare('vRP/insert_credit_payday','UPDATE bank SET credit_last_payment = @credit_last_payment WHERE account = @account')
vRP.prepare('vRP/insert_credit_available','UPDATE bank SET credit_available = @credit_available WHERE account = @account')
vRP.prepare('vRP/insert_credit_used','UPDATE bank SET credit_used = @credit_used WHERE account = @account')
vRP.prepare('vRP/get_credit_available', 'SELECT credit_available FROM bank WHERE account = @account')
vRP.prepare('vRP/get_credit_used', 'SELECT credit_used FROM bank WHERE account = @account')

vRP.prepare('vRP/insert_invoices','UPDATE bank SET invoices = @invoices WHERE account = @account')
vRP.prepare('vRP/get_invoices', 'SELECT invoices FROM bank WHERE account = @account')

vRP.prepare('vRP/insert_transactions','UPDATE bank SET transactions = @transactions WHERE account = @account')
vRP.prepare('vRP/get_transactions', 'SELECT transactions FROM bank WHERE account = @account')

vRP.prepare('vRP/get_homeuser', 'SELECT * FROM homes WHERE user_id = @user_id AND home = @home')
vRP.prepare('vRP/get_homeuserid', 'SELECT * FROM homes WHERE user_id = @user_id')
vRP.prepare('vRP/get_homeuserowner', 'SELECT * FROM homes WHERE user_id = @user_id AND home = @home AND owner = 1')
vRP.prepare('vRP/get_homeuseridowner', 'SELECT * FROM homes WHERE home = @home AND owner = 1')
vRP.prepare('vRP/get_homepermissions', 'SELECT * FROM homes WHERE home = @home')
vRP.prepare('vRP/add_permissions', 'INSERT IGNORE INTO homes(home, user_id) VALUES(@home, @user_id)')
vRP.prepare('vRP/buy_permissions', 'INSERT IGNORE INTO homes(home, user_id, owner, vault, slots) VALUES(@home, @user_id, 1, @vault, @slots)')
vRP.prepare('vRP/count_homepermissions', 'SELECT COUNT() as qtd FROM homes WHERE home = @home')
vRP.prepare('vRP/count_homes', 'SELECT COUNT(*) as qtd FROM homes WHERE user_id = @user_id')
vRP.prepare('vRP/rem_permissions', 'DELETE FROM homes WHERE home = @home AND user_id = @user_id')
vRP.prepare('vRP/rem_allpermissions', 'DELETE FROM homes WHERE home = @home')
vRP.prepare('vRP/upd_vaulthomes', 'UPDATE homes SET vault = vault + @vault WHERE home = @home AND owner = 1')
vRP.prepare('vRP/upd_slotshomes', 'UPDATE homes SET slots = slots + @slots WHERE home = @home AND owner = 1')
vRP.prepare('vRP/transfer_homes', 'UPDATE homes SET user_id = @nuser_id WHERE user_id = @user_id AND home = @home')

vRP.prepare("vRP/add_veh", "INSERT INTO dealership(name, model, price, category, stock) VALUES(@name, @model, @price, @category, @stock)")
vRP.prepare("vRP/rem_veh", "DELETE FROM dealership WHERE model = @model")
vRP.prepare("vRP/select_veh", "SELECT * FROM dealership WHERE model = @model")
vRP.prepare("vRP/update_stock", "UPDATE dealership SET stock = @stock WHERE model = @model")

vRP.prepare('vRP/create_police',
  [[
    CREATE TABLE IF NOT EXISTS `police` (
    `incident` int NOT NULL AUTO_INCREMENT,
    `user_id` int NOT NULL,
    `officer` int NOT NULL,
    `occurrence` varchar(255) NOT NULL,
    `description` text NOT NULL,
    `evidence` varchar(255) NOT NULL,
    `fine` int NOT NULL DEFAULT 0,
    `date` datetime DEFAULT NULL,
    PRIMARY KEY (`incident`),
    KEY `user_id` (`user_id`),
    KEY `occurrence` (`occurrence`)
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
]])

vRP.prepare('vRP/select_all', 'SELECT * FROM police WHERE occurrence = @occurrence')
vRP.prepare('vRP/select', 'SELECT incident, user_id, officer, occurrence, description, date FROM police WHERE user_id = @user_id AND occurrence = @occurrence')
vRP.prepare('vRP/set_register', 'INSERT INTO police (user_id, officer, occurrence, description, evidence, fine, date) VALUES (@user_id, @officer, @occurrence, @description, @evidence, @fine, @date)')

vRP.prepare('vRP/get_fines', 'SELECT * FROM police WHERE user_id = @user_id AND occurrence = "Multa"')
vRP.prepare('vRP/add_fines', 'INSERT INTO police (user_id, officer, occurrence, description, evidence, fine, date) VALUE (@user_id, @officer, "Multa", @description, @evidence, @fine, @date)')

CreateThread(function()
  vRP.execute('vRP/create_players')
  vRP.execute('vRP/create_users')
  vRP.execute('vRP/create_users_data')
  vRP.execute('vRP/create_server_data')
  vRP.execute('vRP/create_permissions')
  vRP.execute('vRP/create_vehicles')
  vRP.execute('vRP/create_weapons')
  vRP.execute('vRP/create_homes')
  vRP.execute('vRP/create_shops')
  vRP.execute('vRP/create_shops_basic')
  vRP.execute('vRP/create_orgs')
  vRP.execute('vRP/create_coins')
  vRP.execute('vRP/create_chests')
  vRP.execute('vRP/create_bank')
  vRP.execute('vRP/create_dealership')
  vRP.execute('vRP/create_dealership_basic')
  vRP.execute('vRP/create_police')
end)