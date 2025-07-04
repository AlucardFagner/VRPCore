
local Tunnel = module('vrp', 'lib/Tunnel')
local Proxy = module('vrp', 'lib/Proxy')
vRP = Proxy.getInterface('vRP')
vRPclient = Tunnel.getInterface('vRP')

zSERVER = {}
Tunnel.bindInterface('zHomes', zSERVER)
zCLIENT = Tunnel.getInterface('zHomes')
zSkinShops = Tunnel.getInterface('zSkinShops')

local homeEnter = {}
local chestOpen = {}
local unlocked = {}

local noStore = {
	['cola'] = true,
	['soda'] = true,
	['coffee'] = true,
	['water'] = true,
	['dirtywater'] = true,
	['emptybottle'] = true,
	['hamburger'] = true,
	['tacos'] = true,
	['chocolate'] = true,
	['donut'] = true
}

local networkHouses = {}
local theftTimers = {}

local mobileTheft = {
	['MOBILE01'] = {
		[1] = { 'joint', math.random(10) },
		[2] = { 'dollars', math.random(500, 999) },
		[3] = { 'postit', math.random(4) },
		[4] = { 'plastic', math.random(10, 15) },
		[5] = { 'glass', math.random(10, 15) },
		[6] = { 'rubber', math.random(10, 15) },
		[7] = { 'aluminum', math.random(5, 10) },
		[8] = { 'copper', math.random(5, 10) },
		[9] = { 'keyboard', 1 },
		[10] = { 'mouse', 1 },
		[11] = { 'ring', 1 },
		[12] = { 'watch', 1 },
		[13] = { 'playstation', 1 },
		[14] = { 'xbox', 1 },
		[15] = { 'legos', 1 },
		[16] = { 'ominitrix', 1 },
		[17] = { 'bracelet', 1 },
		[18] = { 'dildo', 1 }
	},
	['MOBILE02'] = {
		[1] = { 'joint', math.random(10) },
		[2] = { 'dollars', math.random(500, 999) },
		[3] = { 'postit', math.random(4) },
		[4] = { 'plastic', math.random(10, 15) },
		[5] = { 'glass', math.random(10, 15) },
		[6] = { 'rubber', math.random(10, 15) },
		[7] = { 'aluminum', math.random(5, 10) },
		[8] = { 'copper', math.random(5, 10) },
		[9] = { 'keyboard', 1 },
		[10] = { 'mouse', 1 },
		[11] = { 'ring', 1 },
		[12] = { 'watch', 1 },
		[13] = { 'playstation', 1 },
		[14] = { 'xbox', 1 },
		[15] = { 'legos', 1 },
		[16] = { 'ominitrix', 1 },
		[17] = { 'bracelet', 1 },
		[18] = { 'dildo', 1 }
	},
	['MOBILE03'] = {
		[1] = { 'joint', math.random(10) },
		[2] = { 'dollars', math.random(500, 999) },
		[3] = { 'postit', math.random(4) },
		[4] = { 'plastic', math.random(10, 15) },
		[5] = { 'glass', math.random(10, 15) },
		[6] = { 'rubber', math.random(10, 15) },
		[7] = { 'aluminum', math.random(5, 10) },
		[8] = { 'copper', math.random(5, 10) },
		[9] = { 'keyboard', 1 },
		[10] = { 'mouse', 1 },
		[11] = { 'ring', 1 },
		[12] = { 'watch', 1 },
		[13] = { 'playstation', 1 },
		[14] = { 'xbox', 1 },
		[15] = { 'legos', 1 },
		[16] = { 'ominitrix', 1 },
		[17] = { 'bracelet', 1 },
		[18] = { 'dildo', 1 }
	},
	['MOBILE04'] = {
		[1] = { 'joint', math.random(10) },
		[2] = { 'dollars', math.random(500, 999) },
		[3] = { 'postit', math.random(4) },
		[4] = { 'plastic', math.random(10, 15) },
		[5] = { 'glass', math.random(10, 15) },
		[6] = { 'rubber', math.random(10, 15) },
		[7] = { 'aluminum', math.random(5, 10) },
		[8] = { 'copper', math.random(5, 10) },
		[9] = { 'keyboard', 1 },
		[10] = { 'mouse', 1 },
		[11] = { 'ring', 1 },
		[12] = { 'watch', 1 },
		[13] = { 'playstation', 1 },
		[14] = { 'xbox', 1 },
		[15] = { 'legos', 1 },
		[16] = { 'ominitrix', 1 },
		[17] = { 'bracelet', 1 },
		[18] = { 'dildo', 1 }
	},
	['MOBILE05'] = {
		[1] = { 'joint', math.random(10) },
		[2] = { 'dollars', math.random(500, 999) },
		[3] = { 'postit', math.random(4) },
		[4] = { 'plastic', math.random(10, 15) },
		[5] = { 'glass', math.random(10, 15) },
		[6] = { 'rubber', math.random(10, 15) },
		[7] = { 'aluminum', math.random(5, 10) },
		[8] = { 'copper', math.random(5, 10) },
		[9] = { 'keyboard', 1 },
		[10] = { 'mouse', 1 },
		[11] = { 'ring', 1 },
		[12] = { 'watch', 1 },
		[13] = { 'playstation', 1 },
		[14] = { 'xbox', 1 },
		[15] = { 'legos', 1 },
		[16] = { 'ominitrix', 1 },
		[17] = { 'bracelet', 1 },
		[18] = { 'dildo', 1 }
	},
	['MOBILE06'] = {
		[1] = { 'joint', math.random(10) },
		[2] = { 'dollars', math.random(500, 999) },
		[3] = { 'postit', math.random(4) },
		[4] = { 'plastic', math.random(10, 15) },
		[5] = { 'glass', math.random(10, 15) },
		[6] = { 'rubber', math.random(10, 15) },
		[7] = { 'aluminum', math.random(5, 10) },
		[8] = { 'copper', math.random(5, 10) },
		[9] = { 'keyboard', 1 },
		[10] = { 'mouse', 1 },
		[11] = { 'ring', 1 },
		[12] = { 'watch', 1 },
		[13] = { 'playstation', 1 },
		[14] = { 'xbox', 1 },
		[15] = { 'legos', 1 },
		[16] = { 'ominitrix', 1 },
		[17] = { 'bracelet', 1 },
		[18] = { 'dildo', 1 }
	},
	['MOBILE07'] = {
		[1] = { 'joint', math.random(10) },
		[2] = { 'dollars', math.random(500, 999) },
		[3] = { 'postit', math.random(4) },
		[4] = { 'plastic', math.random(10, 15) },
		[5] = { 'glass', math.random(10, 15) },
		[6] = { 'rubber', math.random(10, 15) },
		[7] = { 'aluminum', math.random(5, 10) },
		[8] = { 'copper', math.random(5, 10) },
		[9] = { 'keyboard', 1 },
		[10] = { 'mouse', 1 },
		[11] = { 'ring', 1 },
		[12] = { 'watch', 1 },
		[13] = { 'playstation', 1 },
		[14] = { 'xbox', 1 },
		[15] = { 'legos', 1 },
		[16] = { 'ominitrix', 1 },
		[17] = { 'bracelet', 1 },
		[18] = { 'dildo', 1 }
	},
	['MOBILE08'] = {
		[1] = { 'joint', math.random(10) },
		[2] = { 'dollars', math.random(500, 999) },
		[3] = { 'postit', math.random(4) },
		[4] = { 'plastic', math.random(10, 15) },
		[5] = { 'glass', math.random(10, 15) },
		[6] = { 'rubber', math.random(10, 15) },
		[7] = { 'aluminum', math.random(5, 10) },
		[8] = { 'copper', math.random(5, 10) },
		[9] = { 'keyboard', 1 },
		[10] = { 'mouse', 1 },
		[11] = { 'ring', 1 },
		[12] = { 'watch', 1 },
		[13] = { 'playstation', 1 },
		[14] = { 'xbox', 1 },
		[15] = { 'legos', 1 },
		[16] = { 'ominitrix', 1 },
		[17] = { 'bracelet', 1 },
		[18] = { 'dildo', 1 }
	},
	['MOBILE09'] = {
		[1] = { 'joint', math.random(10) },
		[2] = { 'dollars', math.random(500, 999) },
		[3] = { 'postit', math.random(4) },
		[4] = { 'plastic', math.random(10, 15) },
		[5] = { 'glass', math.random(10, 15) },
		[6] = { 'rubber', math.random(10, 15) },
		[7] = { 'aluminum', math.random(5, 10) },
		[8] = { 'copper', math.random(5, 10) },
		[9] = { 'keyboard', 1 },
		[10] = { 'mouse', 1 },
		[11] = { 'ring', 1 },
		[12] = { 'watch', 1 },
		[13] = { 'playstation', 1 },
		[14] = { 'xbox', 1 },
		[15] = { 'legos', 1 },
		[16] = { 'ominitrix', 1 },
		[17] = { 'bracelet', 1 },
		[18] = { 'dildo', 1 }
	},
	['MOBILE10'] = {
		[1] = { 'joint', math.random(10) },
		[2] = { 'dollars', math.random(500, 999) },
		[3] = { 'postit', math.random(4) },
		[4] = { 'plastic', math.random(10, 15) },
		[5] = { 'glass', math.random(10, 15) },
		[6] = { 'rubber', math.random(10, 15) },
		[7] = { 'aluminum', math.random(5, 10) },
		[8] = { 'copper', math.random(5, 10) },
		[9] = { 'keyboard', 1 },
		[10] = { 'mouse', 1 },
		[11] = { 'ring', 1 },
		[12] = { 'watch', 1 },
		[13] = { 'playstation', 1 },
		[14] = { 'xbox', 1 },
		[15] = { 'legos', 1 },
		[16] = { 'ominitrix', 1 },
		[17] = { 'bracelet', 1 },
		[18] = { 'dildo', 1 }
	},
	['MOBILE11'] = {
		[1] = { 'joint', math.random(10) },
		[2] = { 'dollars', math.random(500, 999) },
		[3] = { 'postit', math.random(4) },
		[4] = { 'plastic', math.random(10, 15) },
		[5] = { 'glass', math.random(10, 15) },
		[6] = { 'rubber', math.random(10, 15) },
		[7] = { 'aluminum', math.random(5, 10) },
		[8] = { 'copper', math.random(5, 10) },
		[9] = { 'keyboard', 1 },
		[10] = { 'mouse', 1 },
		[11] = { 'ring', 1 },
		[12] = { 'watch', 1 },
		[13] = { 'playstation', 1 },
		[14] = { 'xbox', 1 },
		[15] = { 'legos', 1 },
		[16] = { 'ominitrix', 1 },
		[17] = { 'bracelet', 1 },
		[18] = { 'dildo', 1 },
		[19] = { 'bluecard', 1 },
		[20] = { 'blackcard', 1 }
	},
	['MOBILE12'] = {
		[1] = { 'joint', math.random(10) },
		[2] = { 'dollars', math.random(500, 999) },
		[3] = { 'postit', math.random(4) },
		[4] = { 'plastic', math.random(10, 15) },
		[5] = { 'glass', math.random(10, 15) },
		[6] = { 'rubber', math.random(10, 15) },
		[7] = { 'aluminum', math.random(5, 10) },
		[8] = { 'copper', math.random(5, 10) },
		[9] = { 'keyboard', 1 },
		[10] = { 'mouse', 1 },
		[11] = { 'ring', 1 },
		[12] = { 'watch', 1 },
		[13] = { 'playstation', 1 },
		[14] = { 'xbox', 1 },
		[15] = { 'legos', 1 },
		[16] = { 'ominitrix', 1 },
		[17] = { 'bracelet', 1 },
		[18] = { 'dildo', 1 },
		[19] = { 'bluecard', 1 },
		[20] = { 'blackcard', 1 }
	},
	['MOBILE13'] = {
		[1] = { 'joint', math.random(10) },
		[2] = { 'dollars', math.random(500, 999) },
		[3] = { 'postit', math.random(4) },
		[4] = { 'plastic', math.random(10, 15) },
		[5] = { 'glass', math.random(10, 15) },
		[6] = { 'rubber', math.random(10, 15) },
		[7] = { 'aluminum', math.random(5, 10) },
		[8] = { 'copper', math.random(5, 10) },
		[9] = { 'keyboard', 1 },
		[10] = { 'mouse', 1 },
		[11] = { 'ring', 1 },
		[12] = { 'watch', 1 },
		[13] = { 'playstation', 1 },
		[14] = { 'xbox', 1 },
		[15] = { 'legos', 1 },
		[16] = { 'ominitrix', 1 },
		[17] = { 'bracelet', 1 },
		[18] = { 'dildo', 1 },
		[19] = { 'bluecard', 1 },
		[20] = { 'blackcard', 1 }
	},
	['LOCKER'] = {
		[1] = { 'dollars', math.random(1500, 3000) },
		[2] = { 'ring', math.random(4, 8) },
		[3] = { 'watch', math.random(4, 8) },
		[4] = { 'bluecard', 1 },
		[5] = { 'blackcard', 1 },
		[6] = { 'lockpick', 1 },
		[7] = { 'toolbox', 1 },
		[8] = { 'bracelet', 1 },
		[9] = { 'pager', 1 }
	}
}

local homesTheft = {
	['Middle001'] = { 996.77, -729.57, 57.82 },
	['Middle002'] = { 979.11, -716.28, 58.23 },
	['Middle003'] = { 970.8, -701.51, 58.49 },
	['Middle004'] = { 959.96, -669.86, 58.45 },
	['Middle005'] = { 943.34, -653.23, 58.63 },
	['Middle006'] = { 928.77, -639.79, 58.25 },
	['Middle007'] = { 902.95, -615.47, 58.46 },
	['Middle008'] = { 886.76, -608.17, 58.45 },
	['Middle009'] = { 861.73, -583.64, 58.16 },
	['Middle010'] = { 844.12, -562.53, 58.0 },
	['Middle011'] = { 850.18, -532.6, 57.93 },
	['Middle012'] = { 861.55, -508.91, 57.73 },
	['Middle013'] = { 878.4, -497.92, 58.1 },
	['Middle014'] = { 906.31, -489.35, 59.44 },
	['Middle015'] = { 921.92, -477.77, 61.09 },
	['Middle016'] = { 944.52, -463.13, 61.56 },
	['Middle017'] = { 967.16, -451.56, 62.79 },
	['Middle018'] = { 987.46, -432.89, 64.05 },
	['Middle019'] = { 1010.44, -423.38, 65.35 },
	['Middle020'] = { 1028.78, -408.3, 66.35 },
	['Middle021'] = { 1060.47, -378.12, 68.24 },
	['Middle022'] = { 980.24, -627.72, 59.24 },
	['Middle023'] = { 964.39, -596.16, 59.91 },
	['Middle024'] = { 976.65, -580.67, 59.86 },
	['Middle025'] = { 1009.61, -572.45, 60.6 },
	['Middle026'] = { 999.54, -593.92, 59.64 },
	['Middle027'] = { 919.77, -569.56, 58.37 },
	['Middle028'] = { 893.18, -540.63, 58.51 },
	['Middle029'] = { 924.44, -526.02, 59.79 },
	['Middle030'] = { 945.72, -518.99, 60.83 },
	['Middle031'] = { 970.52, -502.5, 62.15 },
	['Middle032'] = { 1014.5, -469.42, 64.51 },
	['Middle033'] = { 1056.27, -449.02, 66.26 },
	['Middle034'] = { 1051.09, -470.35, 64.3 },
	['Middle035'] = { 1046.2, -498.12, 64.28 },
	['Middle036'] = { 1006.55, -510.96, 61.0 },
	['Middle037'] = { 987.89, -525.73, 60.7 },
	['Middle038'] = { 965.22, -541.93, 59.73 },
	['Middle039'] = { 1090.52, -484.39, 65.67 },
	['Middle040'] = { 1098.71, -464.5, 67.32 },
	['Middle041'] = { 1099.41, -438.64, 67.8 },
	['Middle042'] = { 1101.16, -411.41, 67.56 },
	['Middle043'] = { 1114.42, -391.32, 68.95 },
	['Middle044'] = { 1229.69, -725.44, 60.96 },
	['Middle045'] = { 1223.08, -696.89, 60.81 },
	['Middle046'] = { 1221.46, -669.2, 63.5 },
	['Middle047'] = { 1207.36, -620.35, 66.44 },
	['Middle048'] = { 1203.62, -598.38, 68.07 },
	['Middle049'] = { 1201.1, -575.58, 69.14 },
	['Middle050'] = { 1204.89, -557.77, 69.62 },
	['Middle051'] = { 1241.33, -566.36, 69.66 },
	['Middle052'] = { 1240.52, -601.6, 69.79 },
	['Middle053'] = { 1250.89, -620.83, 69.58 },
	['Middle054'] = { 1265.59, -648.68, 68.13 },
	['Middle055'] = { 1270.91, -683.6, 66.04 },
	['Middle056'] = { 1264.74, -702.74, 64.91 },
	['Middle057'] = { 1250.82, -515.41, 69.35 },
	['Middle058'] = { 1251.43, -494.09, 69.91 },
	['Middle059'] = { 1259.49, -480.2, 70.19 },
	['Middle060'] = { 1265.65, -458.04, 70.52 },
	['Middle061'] = { 1262.33, -429.81, 70.02 },
	['Middle062'] = { 1303.17, -527.43, 71.47 },
	['Middle063'] = { 1328.55, -536.05, 72.45 },
	['Middle064'] = { 1348.42, -546.81, 73.9 },
	['Middle065'] = { 1373.31, -555.8, 74.69 },
	['Middle066'] = { 1388.59, -569.66, 74.5 },
	['Middle067'] = { 1386.27, -593.42, 74.49 },
	['Middle068'] = { 1367.24, -606.62, 74.72 },
	['Middle069'] = { 1341.31, -597.26, 74.71 },
	['Middle070'] = { 1323.37, -583.15, 73.25 },
	['Middle071'] = { 1301.0, -574.31, 71.74 },
	['Middle102'] = { 2634.46, 3292.11, 55.73 },
	['Middle103'] = { 2618.27, 3275.41, 55.74 },
	['Middle104'] = { 2632.21, 3257.86, 55.47 },
	['Middle105'] = { -34.23, -1847.0, 26.2 },
	['Middle106'] = { -20.42, -1858.98, 25.41 },
	['Middle107'] = { -4.75, -1872.17, 24.16 },
	['Middle108'] = { 5.19, -1884.35, 23.7 },
	['Middle109'] = { 23.18, -1896.66, 22.97 },
	['Middle110'] = { 38.98, -1911.5, 21.96 },
	['Middle111'] = { 56.54, -1922.75, 21.92 },
	['Middle112'] = { 72.1, -1939.13, 21.37 },
	['Middle113'] = { 76.29, -1948.07, 21.18 },
	['Middle114'] = { 85.85, -1959.7, 21.13 },
	['Middle115'] = { 114.29, -1961.23, 21.34 },
	['Middle116'] = { 126.82, -1930.06, 21.39 },
	['Middle117'] = { 118.42, -1921.14, 21.33 },
	['Middle118'] = { 101.05, -1912.2, 21.41 },
	['Middle119'] = { 54.46, -1873.06, 22.81 },
	['Middle120'] = { 46.08, -1864.22, 23.28 },
	['Middle121'] = { 29.98, -1854.77, 24.07 },
	['Middle122'] = { 21.39, -1844.71, 24.61 },
	['Middle123'] = { 103.98, -1885.34, 24.32 },
	['Middle124'] = { 115.42, -1887.95, 23.93 },
	['Middle125'] = { 128.22, -1897.06, 23.68 },
	['Middle126'] = { 148.69, -1904.46, 23.54 },
	['Middle127'] = { 179.28, -1923.93, 21.38 },
	['Middle128'] = { 165.11, -1944.87, 20.24 },
	['Middle129'] = { 148.89, -1960.47, 19.46 },
	['Middle130'] = { 144.3, -1968.86, 18.86 },
	['Middle131'] = { 208.56, -1895.36, 24.82 },
	['Middle132'] = { 192.4, -1883.32, 25.06 },
	['Middle133'] = { 171.54, -1871.52, 24.41 },
	['Middle134'] = { 150.1, -1864.69, 24.6 },
	['Middle135'] = { 130.65, -1853.2, 25.24 },
	['Middle136'] = { 152.81, -1823.75, 27.87 },
	['Middle137'] = { 197.58, -1725.76, 29.67 },
	['Middle138'] = { 216.49, -1717.44, 29.68 },
	['Middle139'] = { 222.58, -1702.46, 29.7 },
	['Middle140'] = { 240.65, -1687.7, 29.7 },
	['Middle141'] = { 252.94, -1670.78, 29.67 },
	['Middle142'] = { 250.1, -1730.8, 29.67 },
	['Middle143'] = { 257.66, -1722.84, 29.66 },
	['Middle144'] = { 269.71, -1712.78, 29.67 },
	['Middle145'] = { 282.07, -1694.8, 29.65 },
	['Middle146'] = { 333.04, -1740.83, 29.74 },
	['Middle147'] = { 320.64, -1759.76, 29.64 },
	['Middle148'] = { 304.48, -1775.54, 29.11 },
	['Middle149'] = { 300.25, -1783.68, 28.44 },
	['Middle150'] = { 288.66, -1792.59, 28.09 },
	['Middle151'] = { -1754.11, -708.92, 10.4 },
	['Middle152'] = { -1756.32, -692.6, 10.15 },
	['Middle153'] = { -1777.07, -701.48, 10.53 },
	['Middle154'] = { -1771.12, -677.5, 10.39 },
	['Middle155'] = { -1787.98, -672.06, 10.66 },
	['Middle156'] = { -1793.33, -663.88, 10.61 },
	['Middle157'] = { -1803.88, -661.77, 10.73 },
	['Middle158'] = { -1814.05, -656.68, 10.89 },
	['Middle159'] = { -1812.28, -640.74, 10.95 },
	['Middle160'] = { -1836.41, -631.81, 10.76 },
	['Middle161'] = { -1838.87, -629.36, 11.25 },
	['Middle162'] = { -1864.88, -594.5, 11.84 },
	['Middle163'] = { -1876.99, -584.45, 11.86 },
	['Middle164'] = { -1883.36, -578.99, 11.86 },
	['Middle165'] = { -1901.25, -586.09, 11.88 },
	['Middle166'] = { -1913.46, -574.11, 11.44 },
	['Middle167'] = { -1919.96, -569.72, 11.92 },
	['Middle168'] = { -1918.68, -542.64, 11.83 },
	['Middle169'] = { -1945.77, -544.81, 11.87 },
	['Middle170'] = { -1947.02, -543.98, 11.87 },
	['Middle171'] = { -1944.61, -527.77, 11.83 },
	['Middle172'] = { -1957.81, -528.1, 12.19 },
	['Middle173'] = { -1965.99, -509.78, 11.84 },
	['Middle174'] = { -1979.92, -520.13, 11.89 },
	['Middle175'] = { -3089.35, 221.15, 14.12 },
	['Middle176'] = { -3105.45, 246.7, 12.5 },
	['Middle177'] = { -3105.93, 286.93, 8.98 },
	['Middle178'] = { -3108.51, 303.92, 8.39 },
	['Middle179'] = { -3110.71, 335.09, 7.5 },
	['Middle180'] = { -3093.84, 349.39, 7.55 },
	['Middle181'] = { -3091.58, 379.32, 7.12 },
	['Middle182'] = { -3088.87, 392.28, 11.45 },
	['Middle183'] = { -3059.72, 453.36, 6.36 },
	['Middle184'] = { -3047.7, 483.04, 6.78 },
	['Middle185'] = { -3039.55, 492.94, 6.78 },
	['Middle186'] = { -3031.87, 525.11, 7.43 },
	['Middle187'] = { -3037.05, 544.92, 7.51 },
	['Middle188'] = { -3037.33, 559.18, 7.51 },
	['Middle189'] = { -3030.08, 568.7, 7.89 },
	['Middle190'] = { -3077.99, 658.83, 11.67 },
	['Middle191'] = { -3107.84, 718.88, 20.66 },
	['Middle192'] = { -3101.73, 744.05, 21.29 },
	['Middle193'] = { 405.91, -1751.16, 29.72 },
	['Middle194'] = { 419.13, -1735.46, 29.61 },
	['Middle195'] = { 431.28, -1725.51, 29.61 },
	['Middle196'] = { 443.43, -1707.31, 29.71 },
	['Middle197'] = { 500.77, -1697.21, 29.79 },
	['Middle198'] = { 489.67, -1713.98, 29.71 },
	['Middle199'] = { 479.8, -1735.72, 29.16 },
	['Middle200'] = { 474.45, -1757.59, 29.1 },
	['Middle201'] = { 472.18, -1775.25, 29.08 },
	['Middle202'] = { 495.29, -1823.38, 28.87 },
	['Middle203'] = { 500.43, -1813.18, 28.9 },
	['Middle204'] = { 512.54, -1790.71, 28.92 },
	['Middle205'] = { 514.28, -1780.98, 28.92 },
	['Middle206'] = { 440.58, -1829.64, 28.37 },
	['Middle207'] = { 427.19, -1842.14, 28.47 },
	['Middle208'] = { 412.37, -1856.34, 27.33 },
	['Middle209'] = { 399.24, -1865.06, 26.72 },
	['Middle210'] = { 385.09, -1881.51, 26.04 },
	['Middle211'] = { 368.71, -1895.8, 25.18 },
	['Middle212'] = { 320.33, -1854.12, 27.52 },
	['Middle213'] = { 329.4, -1845.93, 27.75 },
	['Middle214'] = { 338.64, -1829.6, 28.34 },
	['Middle215'] = { 348.73, -1820.99, 28.9 },
	['Middle216'] = { 324.37, -1937.27, 25.02 },
	['Middle217'] = { 311.91, -1956.18, 24.62 },
	['Middle218'] = { 295.75, -1971.73, 22.91 },
	['Middle219'] = { 291.64, -1980.18, 21.61 },
	['Middle220'] = { 279.52, -1993.88, 20.81 },
	['Middle221'] = { 256.43, -2023.4, 19.27 },
	['Middle222'] = { 251.02, -2030.23, 18.71 },
	['Middle223'] = { 235.98, -2046.24, 18.38 },
	['Middle224'] = { 250.8, -1935.03, 24.7 },
	['Middle225'] = { 258.35, -1927.23, 25.45 },
	['Middle226'] = { 270.52, -1917.07, 26.19 },
	['Middle227'] = { 282.81, -1899.11, 27.27 },
	['Middle228'] = { 16.72, -1443.78, 30.95 },
	['Middle229'] = { -2.02, -1442.01, 30.97 },
	['Middle230'] = { -14.11, -1441.8, 31.11 },
	['Middle231'] = { -32.3, -1446.43, 31.9 },
	['Middle232'] = { -45.4, -1445.51, 32.43 },
	['Middle233'] = { -64.5, -1449.61, 32.53 },
	['Middle234'] = { 1286.68, -1604.57, 54.83 },
	['Middle235'] = { 1261.59, -1616.85, 54.75 },
	['Middle236'] = { 1245.33, -1627.02, 53.29 },
	['Middle237'] = { 1214.52, -1644.4, 48.65 },
	['Middle238'] = { 1193.66, -1656.59, 43.03 },
	['Middle239'] = { 1193.5, -1622.31, 45.23 },
	['Middle240'] = { 1210.33, -1606.61, 50.75 },
	['Middle241'] = { 1230.67, -1590.82, 53.77 },
	['Middle242'] = { 1315.72, -1526.51, 51.81 },
	['Middle243'] = { 1338.27, -1524.23, 54.59 },
	['Middle244'] = { 1379.19, -1514.81, 58.44 },
	['Middle245'] = { 1437.5, -1491.86, 63.63 },
	['Middle246'] = { 1381.87, -1544.63, 57.11 },
	['Middle247'] = { 1360.67, -1556.35, 56.35 },
	['Middle248'] = { 1327.58, -1553.21, 54.06 },
	['Middle249'] = { 1341.48, -1577.79, 54.45 },
	['Middle250'] = { 1365.49, -1721.77, 65.64 },
	['Middle251'] = { 1314.41, -1733.06, 54.71 },
	['Middle252'] = { 1294.97, -1739.74, 54.28 },
	['Middle253'] = { 1259.18, -1761.96, 49.66 },
	['Middle254'] = { 1250.78, -1734.28, 52.04 },
	['Middle255'] = { 1289.14, -1710.54, 55.48 },
	['Middle256'] = { 1316.79, -1698.54, 58.24 },
	['Middle257'] = { 1354.91, -1690.57, 60.5 },
	['Middle258'] = { 1351.09, -1747.44, 64.28 }
}



RegisterCommand(config.CommandOutfit, function(source, args, rawCommand)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local myResult = vRP.query('vRP/get_homeuser', { user_id = parseInt(user_id), home = tostring(homeEnter[user_id]) })
		if myResult[1] then
			local data = vRP.getSData('wardrobe:'..tostring(homeEnter[user_id]))
			local result = json.decode(data) or {}
			if data and result ~= nil then
				if args[1] == 'save' and args[2] then
					local custom = vSKINSHOP.getCustomization(source)
					if custom then
						local outname = sanitizeString(rawCommand:sub(14), 'abcdefghijklmnopqrstuvwxyz', true)
						if result[outname] == nil and string.len(outname) > 0 then
							result[outname] = custom
							vRP.setSData('wardrobe:'..tostring(homeEnter[user_id]), json.encode(result))
							TriggerClientEvent('Notify', source, 'sucesso', 'Outfit <b>'..outname..'</b> adicionado com sucesso.', 5000)
						else
							TriggerClientEvent('Notify', source, 'aviso', 'O nome escolhido já existe na lista de <b>outfits</b>.', 5000)
						end
					end
				elseif args[1] == 'rem' and args[2] then
					local outname = sanitizeString(rawCommand:sub(13), 'abcdefghijklmnopqrstuvwxyz', true)
					if result[outname] ~= nil and string.len(outname) > 0 then
						result[outname] = nil
						vRP.setSData('wardrobe:'..tostring(homeEnter[user_id]), json.encode(result))
						TriggerClientEvent('Notify', source, 'sucesso', 'Outfit <b>'..outname..'</b> removido com sucesso.', 5000)
					else
						TriggerClientEvent('Notify', source, 'negado', 'Nome escolhido não encontrado na lista de <b>outfits</b>.', 5000)
					end
				elseif args[1] == 'apply' and args[2] then
					local outname = sanitizeString(rawCommand:sub(15), 'abcdefghijklmnopqrstuvwxyz', true)
					if result[outname] ~= nil and string.len(outname) > 0 then
						TriggerClientEvent('updateRoupas', source, result[outname])
						TriggerClientEvent('Notify', source, 'sucesso', 'Outfit <b>'..outname..'</b> aplicado com sucesso.', 5000)
					else
						TriggerClientEvent('Notify', source, 'negado', 'Nome escolhido não encontrado na lista de <b>outfits</b>.', 5000)
					end
				else
					for k, v in pairs(result) do
						TriggerClientEvent('Notify', source, 'importante', '<b>Outfit:</b> '..k, 20000)
						Citizen.Wait(1)
					end
				end
			end
		end
	end
end)

RegisterCommand(config.CommandHomes, function(source, args, rawCommand)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if args[1] == config.SubCommandAddPermission and vRP.housesName(tostring(args[2])) and parseInt(args[3]) > 0 then --- Valor de K
			local myHomes = vRP.query('vRP/get_homeuserowner', { user_id = parseInt(user_id), home = tostring(args[2]) })
			if myHomes[1] then
				local totalResidents = vRP.query('vRP/count_homepermissions', { home = tostring(args[2]) })
				if parseInt(totalResidents[1].qtd) >= parseInt(vRP.housesResidents(tostring(args[2]))) then
					TriggerClientEvent('Notify', source, 'vermelho', 'Residência com o máximo de moradores.', 5000)
					return
				end

				local identity = vRP.getUserIdentity(parseInt(args[3]))
				local totalHomes = vRP.query('vRP/count_homes', { user_id = parseInt(args[3]) })
				if vRP.getPremium(parseInt(args[3])) then
					if parseInt(totalHomes[1].qtd) >= 4 then
						TriggerClientEvent('Notify', source, 'vermelho', 'Você tem o máximo de residências.', 5000)
						return
					end
				else
					if parseInt(totalHomes[1].qtd) >= 2 then
						TriggerClientEvent('Notify', source, 'vermelho', 'Você tem o máximo de residências.', 5000)
						return
					end
				end

				vRP.execute('vRP/add_permissions', { home = tostring(args[2]), user_id = parseInt(args[3]) })
				if identity then
					TriggerClientEvent('Notify', source, 'amarelo', 'Permissão adicionada para <b>'..identity.name..' '..identity.name2..'</b>.', 5000)
				end
			end
		elseif args[1] == config.SubCommandRemovePermission and vRP.housesName(tostring(args[2])) and parseInt(args[3]) > 0 then
			local myHomes = vRP.query('vRP/get_homeuserowner', { user_id = parseInt(user_id), home = tostring(args[2]) })
			if myHomes[1] then
				local userHomes = vRP.query('vRP/get_homeuser', { user_id = parseInt(args[3]), home = tostring(args[2]) })
				if userHomes[1] then
					vRP.execute('vRP/rem_permissions', { home = tostring(args[2]), user_id = parseInt(args[3]) })
					local identity = vRP.getUserIdentity(parseInt(args[3]))
					if identity then
						TriggerClientEvent('Notify', source, 'amarelo', 'Permissão removida de <b>'..identity.name..' '..identity.name2..'</b>.', 5000)
					end
				end
			end
		elseif args[1] == config.SubCommandBuyWeigth and vRP.housesName(tostring(args[2])) then
			local getHome = vRP.query('vRP/get_homeuser',{user_id = user_id, home = tostring(args[2])})
			for a,b in pairs(getHome) do
				local newweigth = b.vault + parseInt(config.AmountBuyWeight)
				if newweigth <= vRP.housesMaxWeight(tostring(args[2])) then
					if vRP.tryPayment(user_id, parseInt(config.PriceBuyWeight)) then
						local buyWeigth = vRP.execute('vRP/upd_vaulthomes',{vault = parseInt(config.AmountBuyWeight), home = tostring(args[2])})
						if buyWeigth then
							TriggerClientEvent('Notify', source, 'verde', 'Compra de mais '..parseInt(config.AmountBuyWeight)..' de espaço para a residência '..tostring(args[2])..' efetuada com sucesso.', 5000)
						end
					else
						TriggerClientEvent('Notify', source, 'vermelho', 'Dólares insuficientes.', 5000)
					end
				else 
					TriggerClientEvent('Notify', source, 'vermelho', 'Tamanho máximo atingido.', 5000)
				end
			end
		elseif args[1] == config.SubCommandBuySlot and vRP.housesName(tostring(args[2])) then
			local getHome = vRP.query('vRP/get_homeuser',{user_id = user_id, home = tostring(args[2])})
			for a,b in pairs(getHome) do
				local newslots = b.slots + parseInt(config.AmountBuySlot)
				if newslots <= vRP.housesMaxSlots(tostring(args[2])) then
					if vRP.tryPayment(user_id, parseInt(config.PriceBuySlot)) then
						local buySlots = vRP.execute('vRP/upd_slotshomes',{slots = parseInt(config.AmountBuySlot), home = tostring(args[2])})
						if buySlots then
							TriggerClientEvent('Notify', source, 'verde', 'Compra de mais '..parseInt(config.AmountBuySlot)..' slots para a residência '..tostring(args[2])..' efetuada com sucesso.', 5000)
						end
					else
						TriggerClientEvent('Notify', source, 'vermelho', 'Dólares insuficientes.', 5000)
					end
				else 
					TriggerClientEvent('Notify', source, 'vermelho', 'Tamanho máximo atingido.', 5000)
				end
			end
		elseif args[1] == config.SubComanCheckPermissions and vRP.housesName(tostring(args[2])) then
			local myHomes = vRP.query('vRP/get_homeuserowner', { user_id = parseInt(user_id), home = tostring(args[2]) })
			if myHomes[1] then
				local userHomes = vRP.query('vRP/get_homepermissions', { home = tostring(args[2]) })
				if parseInt(#userHomes) > 1 then
					local permissoes = ''
					for k, v in pairs(userHomes) do
						if v.user_id ~= user_id then
							local identity = vRP.getUserIdentity(v.user_id)
							permissoes = permissoes..'<b>Nome:</b> '..identity.name..' '..identity.name2..'   -   <b>Passporte:</b> '..v.user_id
							if k ~= #userHomes then
								permissoes = permissoes..'<br>'
							end
						end
					end
					TriggerClientEvent('Notify', source, 'amarelo', 'Autorizações de residência <b>'..tostring(args[2])..'</b>: <br>'..permissoes, 20000)
				else
					TriggerClientEvent('Notify', source, 'amarelo', 'Nenhuma permissão encontrada.', 5000)
				end
			end
		elseif args[1] == config.SubCommandSellHome and vRP.housesName(tostring(args[2])) then
			local myHomes = vRP.query('vRP/get_homeuserowner', { user_id = parseInt(user_id), home = tostring(args[2]) })
			if myHomes[1] then
				vRP.execute('vRP/rem_allpermissions', { home = tostring(args[2]) })
				vRP.execute('vRP/rem_srv_data', { dkey = 'homesVault:'..tostring(args[2]) })
				vRP.execute('vRP/rem_srv_data', { dkey = 'wardrobe:'..tostring(args[2]) })
				vRP.addBank(user_id, parseInt(vRP.housesPrice(tostring(args[2])))*0.7)
			end
		elseif args[1] == config.SubCommandTransferHom and vRP.housesName(tostring(args[2])) and parseInt(args[3]) > 0 then
			local myHomes = vRP.query('vRP/get_homeuserowner', { user_id = parseInt(user_id), home = tostring(args[2]) })
			if myHomes[1] then
				local identity = vRP.getUserIdentity(parseInt(args[3]))
				local totalHomes = vRP.query('vRP/count_homes', { user_id = parseInt(args[3]) })
				if vRP.getPremium(parseInt(args[3])) then
					if parseInt(totalHomes[1].qtd) >= 2 then
						TriggerClientEvent('Notify', source, 'vermelho', '<b>'..identity.name..' '..identity.name2..'</b> tem o máximo de residências.', 5000)
						return
					end
				else
					if parseInt(totalHomes[1].qtd) >= 1 then
						TriggerClientEvent('Notify', source, 'vermelho', '<b>'..identity.name..' '..identity.name2..'</b> tem o máximo de residências.', 5000)
						return
					end
				end

				if identity then
					local ok = vRP.request(source, 'Deseja transferir a residência <b>'..tostring(args[2])..'</b> para <b>'..identity.name..' '..identity.name2..'</b>?', 30)
					if ok then
						local myResult = vRP.query('vRP/get_homeuser', { user_id = parseInt(args[3]), home = tostring(args[2]) })
						if myResult[1] then
							TriggerClientEvent('Notify', source, 'vermelho', 'A pessoa já possui permissão nesta residência.', 5000)
						else
							vRP.execute('vRP/transfer_homes', { home = tostring(args[2]), user_id = parseInt(user_id), nuser_id = parseInt(args[3]) })
							TriggerClientEvent('Notify', source, 'amarelo', 'Residência transferida para <b>'..identity.name..' '..identity.name2..'</b>.', 5000)
						end
					end
				end
			end
		else
			local myHomes = vRP.query('vRP/get_homeuserid', { user_id = parseInt(user_id) })
			if parseInt(#myHomes) >= 1 then
				for k, v in pairs(myHomes) do
					TriggerClientEvent('Notify', source, 'amarelo', '<b>Residência:</b> '..v.home, 10000)
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	local source = source
	Citizen.Wait(1000)
	zCLIENT.updateHomes(-1, vRP.housesList(source))
	zCLIENT.updateHomesTheft(-1, homesTheft)
end)

function zSERVER.checkPermissions(homeName)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local identity = vRP.getUserIdentity(user_id)
		if identity then
			if not vRP.wantedReturn(user_id) then
				local homeResult = vRP.query('vRP/get_homepermissions', { home = tostring(homeName) })
				if parseInt(#homeResult) >= 1 then
					local myResult = vRP.query('vRP/get_homeuser', { user_id = parseInt(user_id), home = tostring(homeName) })
					if myResult[1] then
						return true
					else
						if not unlocked[homeName] then
							TriggerClientEvent('Notify', source, 'amarelo', 'A porta está trancada.', 3000)
							return false
						else
							return true
						end
					end
				else
					vRP.prepare('vRP/count_homes', 'SELECT COUNT(*) as qtd FROM homes WHERE user_id = @user_id')

					local totalHomes = vRP.query('vRP/count_homes', { user_id = parseInt(user_id) })
					if vRP.getPremium(parseInt(user_id)) then
						if parseInt(totalHomes[1].qtd) >= 4 then
							TriggerClientEvent('Notify', source, 'vermelho', 'Você atingiu o máximo de residências.', 3000)
							return false
						end
					else
						if parseInt(totalHomes[1].qtd) >= 2 then
							TriggerClientEvent('Notify', source, 'vermelho', 'Você atingiu o máximo de residências.', 3000)
							return false
						end
					end

					local ok = vRP.request(source, 'Deseja comprar essa casa por <b>$'..vRP.format(parseInt(vRP.housesPrice(tostring(homeName))))..' dólares</b>?', 30)
					if ok then
						if vRP.tryPayment(user_id, parseInt(vRP.housesPrice(tostring(homeName)))) then
							vRP.execute('vRP/buy_permissions', { home = tostring(homeName), user_id = parseInt(user_id), vault = parseInt(vRP.housesWeight(tostring(homeName))), slots = parseInt(vRP.housesSlots(homeName)) })
						else
							TriggerClientEvent('Notify', source, 'vermelho', 'Dólares insuficientes.', 3000)
						end
					end
					return false
				end
			end
		end
	end
	return false
end

function zSERVER.tryUnlock(homeName)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if not vRP.wantedReturn(user_id) then
			local homeResult = vRP.query('vRP/get_homepermissions', { home = tostring(homeName) })
			if parseInt(#homeResult) >= 1 then
				local myResult = vRP.query('vRP/get_homeuser', { user_id = parseInt(user_id), home = tostring(homeName) })
				if myResult[1] then
					if unlocked[homeName] then
						unlocked[homeName] = nil
						TriggerClientEvent('Notify', source, 'locked', 'Porta trancada.', 3000)
					else
						unlocked[homeName] = true
						TriggerClientEvent('Notify', source, 'unlocked', 'Porta destrancada.', 3000)
					end
				end
			end
		end
	end
end

function zSERVER.checkIntPermissions(homeName)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		for k, v in pairs(chestOpen) do
			if v == homeName then
				return false
			end
		end

		if not vRP.wantedReturn(user_id) then
			local myResult = vRP.query('vRP/get_homeuser', { user_id = parseInt(user_id), home = tostring(homeEnter[user_id]) })
			if myResult[1] or vRP.hasPermission(user_id, 'Police') or unlocked[homeName] then
				chestOpen[user_id] = homeName
				return true
			end
		end
	end
	return false
end

function zSERVER.chestClose()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if chestOpen[user_id] then
			chestOpen[user_id] = nil
		end
	end
end

function zSERVER.checkPolice()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id, 'Police') then
			return true
		end
	end
	return false
end

function zSERVER.applyHouseOpen(status)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		homeEnter[user_id] = tostring(status)
	end
end

function zSERVER.removeHouseOpen()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if homeEnter[user_id] then
			homeEnter[user_id] = nil
		end
	end
end

function zSERVER.checkHomeTheft(homeName)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local copAmount = vRP.numPermission('Police')
		if parseInt(#copAmount) >= 5 then
			TriggerClientEvent('Notify', source, 'amarelo', 'Sistema indisponível no momento.', 5000)
			return false
		end

		if parseInt(theftTimers[tostring(homeName)]) > 0 then
			TriggerClientEvent('Notify', source, 'azul', 'Aguarde '..vRP.getTimers(parseInt(theftTimers[tostring(homeName)])), 5000)
			return false
		end
	end
	return true
end

function zSERVER.setNetwork(homeName)
	local source = source

	if networkHouses[homeName] == nil then
		networkHouses[homeName] = {}
	end

	networkHouses[homeName][source] = source
end

function zSERVER.removeNetwork(homeName)
	local source = source
	networkHouses[homeName][source] = nil
end

function zSERVER.getNetwork(homeName)
	return networkHouses[homeName]
end

function zSERVER.paymentTheft(mobile)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local randItem = math.random(#mobileTheft[mobile])
		if math.random(100) <= 90 then
			vRP.tryGiveInventoryItem(user_id, mobileTheft[mobile][randItem][1], parseInt(mobileTheft[mobile][randItem][2]), true)
		else
			TriggerClientEvent('Notify', source, 'amarelo', 'Compartimento vazio.', 5000)
		end

		vRP.upgradeStress(user_id, 1)

		if math.random(1000) >= 950 then
			vRP.wantedTimer(parseInt(user_id), 600)
			TriggerClientEvent('Notify', source, 'amarelo', 'Autoridades foram notificadas.', 3000)
			local x, y, z = vRPclient.getPositions(source)
			local copAmount = vRP.numPermission('Police')
			for k, v in pairs(copAmount) do
				async(function()
					TriggerClientEvent('NotifyPush', v, { time = os.date('%H:%M:%S'), code = 'QTH', title = 'Roubo a Residência', x = x, y = y, z = z, criminal = 'Alarme de segurança', rgba = {160, 108, 15} })
				end)
			end
		end
	end
end



RegisterNetEvent('homes:populateSlot')
AddEventHandler('homes:populateSlot', function(item, slot, target, amount)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if amount == nil then amount = 1 end
		if amount <= 0 then amount = 1 end

		if vRP.tryGetInventoryItem(user_id, item, amount, false, slot) then
			vRP.giveInventoryItem(user_id, item, amount, false, target)
			TriggerClientEvent('homes:Update', source, 'updateVault')
		end
	end
end)

RegisterNetEvent('homes:updateSlot')
AddEventHandler('homes:updateSlot', function(item, slot, target, amount)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if amount == nil then amount = 1 end
		if amount <= 0 then amount = 1 end

		local inv = vRP.getInventory(user_id)
		if inv then
			if inv[tostring(slot)] and inv[tostring(target)] and inv[tostring(slot)].item == inv[tostring(target)].item then
				if vRP.tryGetInventoryItem(user_id, item, amount, false, slot) then
					vRP.giveInventoryItem(user_id, item, amount, false, target)
				end
			else
				vRP.swapSlot(user_id, slot, target)
			end
		end

		TriggerClientEvent('homes:Update', source, 'updateVault')
	end
end)

RegisterNetEvent('homes:sumSlot')
AddEventHandler('homes:sumSlot', function(itemName, slot, amount)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local inv = vRP.getInventory(user_id)
		if inv then
			if inv[tostring(slot)] and inv[tostring(slot)].item == itemName then
				if vRP.tryChestItem(user_id, 'homesVault:'..tostring(chestOpen[user_id]), itemName, amount, slot) then
					TriggerClientEvent('homes:Update', source, 'updateVault')
				end
			end
		end
	end
end)

AddEventHandler('vRP:playerLeave', function(user_id, source)
	local homesList = vRP.housesList()

	if homeEnter[user_id] then
		vRP.updateHomePosition(user_id, homesList[homeEnter[user_id]].x, homesList[homeEnter[user_id]].y, homesList[homeEnter[user_id]].z)
		homeEnter[user_id] = nil
	end

	if chestOpen[user_id] then
		chestOpen[user_id] = nil
	end
	
end)

RegisterServerEvent('vrp:homes:ApplyTime')
AddEventHandler('vrp:homes:ApplyTime', function(homeName)
	theftTimers[tostring(homeName)] = 3600
end)


AddEventHandler('vRP:playerSpawn', function(user_id, source)
	Citizen.Wait(1000)
	zCLIENT.updateHomes(source, vRP.housesList(source))
	zCLIENT.updateHomesTheft(source, homesTheft)
end)

RegisterCommand('zhomes', function(source)
	zCLIENT.updateHomes(source, vRP.housesList(source))
end)



Citizen.CreateThread(function()
	while true do
		for k, v in pairs(theftTimers) do
			if theftTimers[k] > 0 then
				theftTimers[k] = v - 10
			end
		end
		Citizen.Wait(10000)
	end
end)