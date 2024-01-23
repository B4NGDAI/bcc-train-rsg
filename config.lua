Config = {}

--trainjob
Config.defaultlang = 'en_lang'

Config.CruiseControl = true --set true if you want to allow cruise control

Config.FuelSettings = {
    TrainFuelItem = 'charcoal', --db name of the item needed to fuel the train
    TrainFuelItemDisplayName = 'Bag of Coal', --display name of the item
    TrainFuelItemAmount = 5, --How many of the item it will take to fuel the train
    FuelDecreaseTime = 30000, --time in ms of how often the trains fuel goes down
    FuelDecreaseAmount = 5 --amount of fuel to decrease
}

Config.ConditionSettings = {
    TrainCondItem = 'trainoil', --db name of the item needed to repair the train
    TrainCondItemDisplayName = 'Train Oil', --display name of the item
    TrainCondItemAmount = 5, --How many of the item it will take to repair the train
    CondDecreaseTime = 30000, --time in ms of how often the trains condition goes down
    CondDecreaseAmount = 5 --amount of cond to decrease
}

Config.BacchusBridgeDestroying = {
    enabled = true, --if true you will be able to blow up bacchus bridge!
    coords = {x = 492.01, y = 1774.41, z = 182.5}, --coords of where you have to  place the dynamite
    dynamiteItem = 'dynamite', --db name of the dynamite item
    dynamiteItemAmount = 2, --amount needed to explode the bridge
    explosionTimer = 30000 --time before the explosion happens
}

Config.Trains = {
    {
        model = 'appleseed_config', --model name of the train - DO NOT CHANGE
        label = 'appleseed', -- displayed name of the train
        cost = 200, --cost to buy the train
        maxFuel = 100, --the maximum fuel amount the train can have
        maxCondition = 100, --tha maximum condition the train can be at
        maxSpeed = 30, --max speed the train can go 30 is highest game allows
    }, --You can add more trains by copy pasting this table and changing what you need (if you add more models/trains I can not garuntee they work as they have not been tested)
    {
        model = 'bountyhunter_config',
        label = 'bountyhunter',
        cost = 200,
        maxFuel = 100,
        maxCondition = 100,
        maxSpeed = 10, --max speed the train can go 30 is highest game allows
    },
    {
        model = 'engine_config',
        label = 'engine',
        cost = 200,
        maxFuel = 100,
        maxCondition = 100,
        maxSpeed = 10, --max speed the train can go 30 is highest game allows
    },
    {
        model = 'ghost_train_config',
        label = 'ghost_train',
        cost = 200,
        maxFuel = 100,
        maxCondition = 100,
        maxSpeed = 10, --max speed the train can go 30 is highest game allows
    },
    {
        model = 'gunslinger3_config',
        label = 'gunslinger3',
        cost = 200,
        maxFuel = 100,
        maxCondition = 100,
        maxSpeed = 10, --max speed the train can go 30 is highest game allows
    },
    {
        model = 'gunslinger4_config',
        label = 'gunslinger4',
        cost = 200,
        maxFuel = 100,
        maxCondition = 100,
        maxSpeed = 10, --max speed the train can go 30 is highest game allows
    },
    {
        model = 'handcart_config',
        label = 'handcart',
        cost = 200,
        maxFuel = 100,
        maxCondition = 100,
        maxSpeed = 10, --max speed the train can go 30 is highest game allows
    },
    {
        model = 'prisoner_escort_config',
        label = 'prisoner_escort',
        cost = 200,
        maxFuel = 100,
        maxCondition = 100,
        maxSpeed = 10, --max speed the train can go 30 is highest game allows
    },
    {
        model = 'trolley_config',
        label = 'trolley',
        cost = 200,
        maxFuel = 100,
        maxCondition = 100,
        maxSpeed = 10, --max speed the train can go 30 is highest game allows
    },
    {
        model = 'winter4_config',
        label = 'winter4',
        cost = 200,
        maxFuel = 100,
        maxCondition = 100,
        maxSpeed = 10, --max speed the train can go 30 is highest game allows
    }
}
Config.TrainDespawnDist = 200 --the maximum dist the conductor can be before the train despawns

Config.StationBlipHash = 1258184551 --set the blip hash
Config.StationBlipColor = 'BLIP_MODIFIER_MP_COLOR_6' -- Set the blip color here
Config.Stations = {
    { --valentine
        coords = {x = -176.01, y = 627.86, z = 114.09},
        trainSpawnCoords = {x = -163.78, y = 628.17, z = 113.52}, --Make sure the coord here is directly on top of the track you want the train to spawn on!
        radius = 2, --keep this kind of low
        invLimit = 200,
        jobEnabled = false,
        stationName = 'Valentine Station',
        job = {'valentine', 'rhodes', 'strawberry', 'saintdenis', 'blackwater'},
        grade = 0,
        outWest = false --set false if this is not in the desert/western part of the map
    },
    { --emerald station
        coords = {x = 1525.18, y = 442.51, z = 90.68},
        trainSpawnCoords = {x = 1529.67, y = 442.54, z = 90.22}, --Make sure the coord here is directly on top of the track you want the train to spawn on!
        radius = 2,
        invLimit = 50,
        jobEnabled = false,
        stationName = 'Emerald Station',
        job = {'valentine', 'rhodes', 'strawberry', 'saintdenis', 'blackwater'},
        grade = 0,
        outWest = false --set false if this is not in the desert/western part of the map
    },
    { --flatneck station
        coords = {x = -337.13, y = -360.63, z = 88.08},
        trainSpawnCoords = {x = -339.0, y = -350.0, z = 87.81}, --Make sure the coord here is directly on top of the track you want the train to spawn on!
        radius = 2,
        invLimit = 200,
        jobEnabled = false,
        stationName = 'Flatneck Station',
        job = {'valentine', 'rhodes', 'strawberry', 'saintdenis', 'blackwater'},
        grade = 0,
        outWest = false --set false if this is not in the desert/western part of the map
    },
    { --rhodes
        coords = {x = 1225.77, y = -1296.45, z = 76.9},
        trainSpawnCoords = {x = 1226.74, y = -1310.03, z = 76.47}, --Make sure the coord here is directly on top of the track you want the train to spawn on!
        radius = 2,
        invLimit = 200,
        jobEnabled = false,
        stationName = 'Rhodes Station',
        job = {'valentine', 'rhodes', 'strawberry', 'saintdenis', 'blackwater'},
        grade = 0,
        outWest = false --set false if this is not in the desert/western part of the map
    },
    { --Saint Denis
        coords = {x = 2747.5, y = -1398.89, z = 46.18},
        trainSpawnCoords = {x = 2770.08, y = -1414.51, z = 45.98}, --Make sure the coord here is directly on top of the track you want the train to spawn on!
        radius = 2,
        invLimit = 300,
        jobEnabled = false,
        stationName = 'Saint Denis Station',
        job = {'valentine', 'rhodes', 'strawberry', 'saintdenis', 'blackwater'},
        grade = 0,
        outWest = false --set false if this is not in the desert/western part of the map
    },
    { --annesburg
        coords = {x = 2938.98, y = 1282.05, z = 44.65},
        trainSpawnCoords = {x = 2957.25, y = 1281.58, z = 43.95}, --Make sure the coord here is directly on top of the track you want the train to spawn on!
        radius = 2,
        invLimit = 100,
        jobEnabled = false,
        stationName = 'Annesburg Station',
        job = {'valentine', 'rhodes', 'strawberry', 'saintdenis', 'blackwater'},
        grade = 0,
        outWest = false --set false if this is not in the desert/western part of the map
    },
    { --bacchus station
        coords = {x = 582.49, y = 1681.07, z = 187.79},
        trainSpawnCoords = {x = 581.14, y = 1691.8, z = 187.6}, --Make sure the coord here is directly on top of the track you want the train to spawn on!
        radius = 2,
        invLimit = 50,
        jobEnabled = true,
        stationName = 'Bacchus Station',
        job = {'valentine', 'rhodes', 'strawberry', 'saintdenis', 'blackwater'},
        grade = 0,
        outWest = false --set false if this is not in the desert/western part of the map
    },
    { --wallace station
        coords = {x = -1299.39, y = 402.09, z = 95.38},
        trainSpawnCoords = {x = -1307.62, y = 406.83, z = 94.98}, --Make sure the coord here is directly on top of the track you want the train to spawn on!
        radius = 2,
        invLimit = 50,
        jobEnabled = false,
        stationName = 'Wallace Station',
        job = {'valentine', 'rhodes', 'strawberry', 'saintdenis', 'blackwater'},
        grade = 0,
        outWest = false --set false if this is not in the desert/western part of the map
    },
    { --riggs station
        coords = {x = -1093.92, y = -576.97, z = 82.41},
        trainSpawnCoords = {x = -1097.07, y = -583.71, z = 81.67}, --Make sure the coord here is directly on top of the track you want the train to spawn on!
        radius = 2,
        invLimit = 100,
        jobEnabled = false,
        stationName = 'Riggs Station',
        job = {'valentine', 'rhodes', 'strawberry', 'saintdenis', 'blackwater'},
        grade = 0,
        outWest = false --set false if this is not in the desert/western part of the map
    },
    { --armadillo
        coords = {x = -3729.1, y = -2602.83, z = -12.94},
        trainSpawnCoords = {x = -3748.85, y = -2600.8, z = -13.72}, --Make sure the coord here is directly on top of the track you want the train to spawn on!
        radius = 2,
        invLimit = 300,
        jobEnabled = false,
        stationName = 'Armadillo Station',
        job = {'valentine', 'rhodes', 'strawberry', 'saintdenis', 'blackwater'},
        grade = 0,
        outWest = true --set false if this is not in the desert/western part of the map
    },
    { --Benedict Point
        coords = {x = -5230.27, y = -3468.65, z = -20.58},
        trainSpawnCoords = {x = -5235.54, y = -3473.3, z = -21.25}, --Make sure the coord here is directly on top of the track you want the train to spawn on!
        radius = 2,
        invLimit = 100,
        jobEnabled = false,
        stationName = 'Benedict Station',
        job = {'valentine', 'rhodes', 'strawberry', 'saintdenis', 'blackwater'},
        grade = 0,
        outWest = true --set false if this is not in the desert/western part of the map
    }
}

Config.SupplyDeliveryLocations = {
    {
        coords = {x = 483.34, y = 659.47, z = 117.39}, --coords you will have to go to
        pay = 20, --pay it will give
        outWest = false, --set false if this is not in the desert/western part of the map
        radius = 10 --How close you have to be to the coords for it to succeed
    },
    {
        coords = {x = -3749.8, y = -2635.28, z = -13.87},
        pay = 30,
        outWest = true,
        radius = 10
    } --add or remove as many as you want
}