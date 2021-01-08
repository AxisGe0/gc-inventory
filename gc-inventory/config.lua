Config = {}

Config.Locale = "en"
Config.IncludeCash = false -- Include cash in inventory?
Config.IncludeWeapons = false -- Include weapons in inventory?
Config.IncludeAccounts = false -- Include accounts (bank, black money, ...)?
Config.ExcludeAccountsList = {"bank"} -- List of accounts names to exclude from inventory
Config.OpenControl = 349 -- Key for opening inventory. Edit html/js/config.js to change key for closing it.
Config.MaxWeight = 30000 --SAME AS THE DEFAULT ON ES EXTENDED CONFIG

-- List of item names that will close ui when used
Config.CloseUiItems = {"idcard", "donut", "nugget", "cigarette", "beer", "methburn", "vodka", "bread", "coffee", "radio", "coke", "meth", "medikit", "binoculars", "bulletproof", "oxygenmask", "trailburst", "shotburst", "starburst","fountain", "cuffs", "cuff_keys"}

Config.ShopBlipID = 52
Config.LiquorBlipID = 93
Config.YouToolBlipID = 402
Config.PrisonShopBlipID = 52
Config.WeedStoreBlipID = 140
Config.WeaponShopBlipID = 110
Config.PoliceShopShopBlipID = 110

Config.ShopLength = 14
Config.LiquorLength = 10
Config.YouToolLength = 2
Config.PrisonShopLength = 2
Config.PoliceShopLength = 2

Config.Color = 2
Config.WeaponColor = 1
Config.WeaponLiscence = {x = 12.47, y = -1105.5, z = 29.8}
Config.LicensePrice = 2000

Config.Shops = {
    RegularShop = {
        Locations = {
            { x = 373.875, y = 325.896, z = 102.566 },
            { x = -1104.52, y = -821.67, z = 13.28 },
            { x = 2557.458, y = 382.282, z = 107.622 },
            { x = -3038.939, y = 585.954, z = 6.908 },
            { x = -3241.927, y = 1001.462, z = 11.830 },
            { x = 547.431, y = 2671.710, z = 41.156 },
            { x = 1961.464, y = 3740.672, z = 31.343 },
            { x = 2678.916, y = 3280.671, z = 54.241 },
            { x = 1729.216, y = 6414.131, z = 34.037 },
            { x = -48.519, y = -1757.514, z = 28.421 },
            { x = 1163.373, y = -323.801, z = 68.205 },
            { x = -707.501, y = -914.260, z = 18.215 },
            { x = -1820.523, y = 792.518, z = 137.118 },
            { x = 1698.388, y = 4924.404, z = 41.063 },
            { x = 25.723, y = -1346.966, z = 28.497 },
         --   { x = 268.26, y = -979.44, z = 28.37 },
            { x = 1135.808, y = -982.281, z = 45.415 },
            { x = -1222.915, y = -906.983, z = 11.326 },
            { x = -1487.553, y = -379.107, z = 39.163 },
            { x = -2968.243, y = 390.910, z = 14.043 },
            { x = 1166.024, y = 2708.930, z = 37.157 },
            { x = 1392.562, y = 3604.684, z = 33.980 },
            { x = -1393.409, y = -606.624, z = 29.319 }
        },
        Items = {
           -- { name = 'bread' , price = 1},
            { name = 'water',price = 20 },
            {name = 'bread',price = 20 },
			--{name = 'water',price = 1 },               
			{name = 'hotdog',price = 1 },
			{name = 'phone',price = 1500 },
			{name = 'drugbags',price = 20 },
			{name = 'hqscale',price = 2500 },
			{name = 'rolpaper',price = 20 },
			{name = 'hifi',price = 1000 },
			{name = 'bulletproof',price = 3000 },
			{name = 'bandage',price = 200 },
			{name = 'cigarette',price = 20},
			{name = 'samosa',price = 20},
       
        }
    },

    IlegalShop = {
        Locations = {
			{x = 128.18, y = -1285.26, z = 28.28},
			{x = -560.01, y = 288.28, z = 82.18},
        },
        Items = {
            { name = 'meth1g' , price = 3000},
            { name = 'joint2g' , price = 4000},
            { name = 'coke1g' , price = 5000},
            { name = 'beer' , price = 5000},
            
        }
    },

    RobsLiquor = {------------WEAPON-SHOP
        Locations = {
            { x = -662.180, y = -934.961, z = 20.829 },
            { x = 810.25, y = -2157.60, z = 28.62 },
            { x = 1693.44, y = 3760.16, z = 33.71 },
            { x = -330.24, y = 6083.88, z = 30.45 },
			{ x = 252.63, y = -50.00, z = 68.94 },
			{ x = 22.09, y = -1107.28, z = 28.80 },
            { x = 2567.69, y = 294.38, z = 107.73 },
            { x = -1117.58, y = 2698.61, z = 17.55 },
			{ x = 842.44, y = -1033.42, z = 27.19 },
			{ x = -1520.17, y = 110.04, z = 50.03 }  
        },
        Items = {
            { name = "WEAPON_BAT", price = 200},
            { name = "WEAPON_KNUCKLE", price = 200 },
            { name = "WEAPON_SNSPISTOL", price = 2000 },
			{ name = "WEAPON_BALL", price = 100 },
            { name = "disc_ammo_pistol", price = 1000, count = 1, grade = 0 },
            { name = "disc_ammo_pistol_large", price = 2000, count = 1, grade = 0 },
            { name = "WEAPON_COMBATPISTOL", price = 2000, count = 1, grade = 0 },
            { name = "WEAPON_STUNGUN", price = 500, count = 1, grade = 0 },
            { name = "WEAPON_FLASHLIGHT", price = 100, count = 1, grade = 0 },
            { name = "bulletproof", price = 5000, count = 1, grade = 1 },
			{ name = "WEAPON_DAGGER", price = 600 },
			{ name = "WEAPON_PISTOL", price = 2500 },
			{ name = "GADGET_PARACHUTE", price = 2500 },
			{ name = "cuffs", price = 2000 },
			{ name = "cuff_keys", price = 200 },
			{ name = "WEAPON_HEAVYPISTOL", price = 15000 },
			
        }
    },

    YouTool = {
        Locations = {
            {x = -1305.6,  y = -394.89,  z = 35.89},
        },
        Items = {
            { name = "phone", price = 1500, count = 1 },
            { name = "raspberry", price = 3000, count = 1 },
            { name = "blowtorch", price = 100, count = 1 },
            --{ name = "c4_bank", price = 10000, count = 1 },
            { name = "lockpick", price = 350, count = 1 },
           -- { name = "drugItem", price = 1000, count = 1 },
            { name = "hackerDevice", price = 1000, count = 1 },
            { name = "hqscale", price = 2500, count = 1 },
			--{ name = "WEAPON_PETROLCAN", price = 2000, count = 1 },
			{ name = "radio", price = 6000, count = 1, grade = 1 },
			{ name = "repairkit", price = 1800, count = 1, grade = 1 },
			{ name = "oxygenmask", price = 12000, count = 1 },
        }
    },

    PrisonShop = {
        Locations = {
            {x = 316.62, y = -589.05, z = 42.39},
        },
        Items = {
			{name = 'bandage', price = 200},
            {name = 'medkit', price = 2500},
            {name = 'gauze', price = 200},
            {name = 'vicodin', price = 350},
            {name = 'chips'}
        }
    },

    WeaponShop = {
        Locations = {
            {x = -564.32, y = 5325.09, z = 120},
        },
        Items = {
			{ name = 'WEAPON_ASSAULTRIFLE' , price = 500},
			{ name = 'WEAPON_PUMPSHOTGUN' , price = 500},
        }
	},
	--[[Crafting = {
        Locations = {
            {x = 962.5, y = -1585.5, z = 29.6},
        },
        Items = {
			{ name = 'WEAPON_ASSAULTRIFLE' , price = 500},
			{ name = 'WEAPON_ASSAULTRIFLE' , price = 500},
        }
    },]]
    PoliceShop = {
        Locations = {
             { x = 455.83, y = -980.34, z = 29.69 },
 
         },
         Items = {
            { name = "disc_ammo_pistol", price = 0, count = 1, grade = 0 },
            { name = "disc_ammo_pistol_large", price = 0, count = 1, grade = 0 },
            { name = "disc_ammo_rifle", price = 0, count = 1, grade = 0 },
            { name = "disc_ammo_rifle_large", price = 0, count = 1, grade = 0 },
            { name = "disc_ammo_shotgun", price = 0, count = 1, grade = 0 },
            { name = "disc_ammo_smg", price = 0, count = 1, grade = 0 },
            { name = "disc_ammo_snp", price = 0, count = 1, grade = 0 },
			{ name = "WEAPON_COMBATPISTOL", price = 0, count = 1, grade = 0 },
			{ name = "WEAPON_SMG", price = 0, count = 1, grade = 0 },
            { name = "WEAPON_STUNGUN", price = 0, count = 1, grade = 0 },
            { name = "WEAPON_NIGHTSTICK", price = 0, count = 1, grade = 0 },
            { name = "WEAPON_FLASHLIGHT", price = 0, count = 1, grade = 0 },
            { name = "WEAPON_FLARE", price = 0, count = 1, grade = 0 },
            { name = "WEAPON_PUMPSHOTGUN", price = 0, count = 1, grade = 2 },
            { name = "WEAPON_CARBINERIFLE", price = 0, count = 1, grade = 3 },
			{ name = "WEAPON_FLARE", price = 0, count = 1, grade = 1 },
			{ name = "radio", price = 0, count = 1, grade = 1 },
			{ name = "WEAPON_HEAVYPISTOL", price = 0 },
        }
}
}

Config.Throwables = {
    WEAPON_MOLOTOV = 615608432,
    WEAPON_GRENADE = -1813897027,
    WEAPON_STICKYBOMB = 741814745,
    WEAPON_PROXMINE = -1420407917,
    WEAPON_SMOKEGRENADE = -37975472,
    WEAPON_PIPEBOMB = -1169823560,
    WEAPON_FLARE = 1233104067,
    WEAPON_SNOWBALL = 126349499
}

Config.FuelCan = 883325847

Config.PropList = {
    cash = {["model"] = 'prop_cash_pile_02', ["bone"] = 28422, ["x"] = 0.02, ["y"] = 0.02, ["z"] = -0.08, ["xR"] = 270.0, ["yR"] = 180.0, ["zR"] = 0.0}
}
Config.localWeight = {
	radio = 350,
	alive_chicken = 200,
	advancedlockpick = 600,
	bandage = 100,
	beer = 140,
	receipt = 100,
	repairkit = 700,
	bread = 125,
	weed = 100,
	secure_card = 200,
	shotburst = 150,
	soda = 100,
	cigarette = 100,
	starburst = 100,
	stone = 50,
	cocacola = 100,
	cocaine = 100,
	coffee = 100,
	thermal_charge = 200,
	copper = 100,
	binoculars = 350,
	trailburst = 150,
	diamond = 100,
	oxygenmask = 1000,
	nugget = 100,
	medikit = 100,
	lockpick = 300,
	laptop_h = 400,
	fixkit = 100,
	fixtool = 100,
	jewels = 200,
	gold = 100,
	bulletproof = 900,
	hamburger = 100,
	icetea = 100,
	iron = 150,
	leather = 100,
	lighter = 100,
	marijuana = 450,
	fixtool = 1000,
	medikit = 100,
	idcard = 120,
	id_card_f = 150,
	id_card = 100,
	oxygen_mask = 100,
	packaged_chicken = 100,
	packaged_plank = 100,
	petrol = 400,
	petrol_raffin = 100,
	hotdog = 130,
	gold = 200,
	sandwich = 100,
	fountain = 160,
	slaughtered_chicken = 150,
	squid = 100,
	squidbait = 100,
	stone = 100,
	copper = 300,
	diamond = 400,
	turtlebait = 100,
	vodka = 200,
	washedstones = 40,
	water = 100,
	weaponflashlight = 100,
	donut = 100,
	weaponskin = 100,
	weed_pooch = 100,
	whisky = 100,
	wine = 100,
	wood = 100,
	cokebrick = 1200,
	worm = 100,
	nothing = 300,
	porkpackage = 300,
	coke = 150,
	rice_pro = 300,
	rice = 300,
	phone = 500,
	chest_a = 25,
	chest_a = 25,
	nurek = 25,
	honey_b = 25,
	honey_a = 25,
	marijuana = 25,
	cannabis = 125,
	sickle = 25,
	pizza = 25,
	burger = 25,
	pastacarbonara = 25,
	macka = 25,
	cigarett = 25,
	pro_wood = 25,
	wood = 25,
	meth_pooch = 25,
	meth = 25,
	marijuana = 25,
	wool = 25,
	clothe = 25,
	glass = 25,
	sands = 25,
	bcabbage = 25,
	acabbage = 25,
	gold_t = 25,
	gold_o = 25,
	mushroom = 25,
	mushroom_d = 25,
	mushroom_p = 25,
	oil_b = 25,
	oil_a = 25,
	leather_a = 25,
	meat_a = 25,
	meat_w = 25,
	drill = 25,
	medikit = 25,
	medikit = 25,
	bandage = 125,
	gps = 25,
	fishingrod = 25,
	Cottageleaves_box = 25,
	marijuana = 25,
	WEAPON_SMG = 0,
	WEAPON_CARBINERIFLE = 0,
	WEAPON_SPECIALCARBINE = 0,
	WEAPON_ASSAULTRIFLE = 0,
	WEAPON_PUMPSHOTGUN = 0,
	WEAPON_PISTOL = 0,
	WEAPON_APPISTOL = 0,
	WEAPON_MACHINEPISTOL = 0,
	WEAPON_COMBATPISTOL = 0,
	gauze = 25,
	hifi = 25,
	rolpaper = 100,
	drugbags = 10,
	hqscale = 1000
}
Config.Locations = { -- Some Shop NPCs
	{ x = -705.93,  y = -914.33,  z = 18.22, heading = 81.50 },    -- LT Gasoline1
	{ x = -47.14,   y = -1758.82, z = 28.42, heading = 46.58 },    -- LT Gasoline2
	{ x = 2678.57,  y = 3278.88,  z = 54.24, heading = 337.70 },    -- 24/7 Freeway
	{ x = 1960.20,  y = 3739.33,  z = 31.34, heading = 296.50 },    -- 24/7 Sandy Shores
	{ x = 1133.87,  y = -983.21,  z = 45.42, heading = 274.80 },    -- EL Rancho Robs Li
	{ x = 24.20,    y = -1347.60, z = 28.50, heading = 271.32 },    -- Strawberry 24/7
	{ x = 1165.09,  y = -323.51,  z = 69.21, heading = 93.72 },    -- LT Gasoline3
	{ x = -1486.41, y = -377.33,  z = 39.16, heading = 138.12 },    -- Morningwood Robs Li
	{ x = 1165.15,  y = 2711.11,  z = 37.16, heading = 176.58 },    -- Route 68 Robs Li
	{ x = 2557.46,  y = 380.49,   z = 107.62,heading = 4.25 },    -- Mountains Freeway 24/7
	{ x = 1391.82,  y = 3606.29,  z = 33.98, heading = 204.25 },    -- Sandy Shores ACE
	{ x = 549.27,   y = 2671.82,  z = 41.16, heading = 100.35 },    -- Sandy Shores 24/7
	{ x = 1697.35,  y = 4923.32,  z = 41.06, heading = 332.42 },    -- Sandy Shores LT Gasoline4
	{ x = 1727.62,  y = 6415.18,  z = 34.04, heading = 241.98 },    -- Chilliad Freeway 24/7
	{ x = -3241.96, y = 999.86,   z = 11.83, heading = 4.68 },    -- cumash Freeway 24/7
	{ x = -3038.68, y = 584.38,   z = 6.91,  heading = 24.72 },    -- Ocean Freeway 24/7
	{ x = -2966.12, y = 391.35,   z = 14.04, heading = 77.04 },    -- Ocean Freeway LT Gasoline5
	{ x = -1819.51, y = 793.72,   z = 137.08,heading = 134.72 }    -- Ocean Freeway LT Gasoline5
}