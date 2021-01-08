ESX = nil
Items = {}
local DataStoresIndex = {}
local DataStores = {}
local SharedDataStores = {}

local listPlate = Config.VehiclePlate

TriggerEvent("esx:getSharedObject", function(obj)
    ESX = obj
end)

AddEventHandler("onMySQLReady", function()
    local result = MySQL.Sync.fetchAll("SELECT * FROM glovebox_inventory")
    local data = nil
    if #result ~= 0 then
		for i = 1, #result, 1 do
			local plate = result[i].plate
			local owned = result[i].owned
			local data = (result[i].data == nil and {} or json.decode(result[i].data))
			local dataStore = CreateDataStore(plate, owned, data)
			SharedDataStores[plate] = dataStore
		end
    end
end)

function loadInvent(plate)
	local result =
	MySQL.Sync.fetchAll(
		"SELECT * FROM glovebox_inventory WHERE plate = @plate",
		{
			["@plate"] = plate
		}
	)
	local data = nil
	if #result ~= 0 then
		for i = 1, #result, 1 do
			local plate = result[i].plate
			local owned = result[i].owned
			local data = (result[i].data == nil and {} or json.decode(result[i].data))
			local dataStore = CreateDataStore(plate, owned, data)
			SharedDataStores[plate] = dataStore
		end
	end
end

function getOwnedVehicle(plate)
	found = true
	return found
end

function MakeDataStore(plate)
	local data = {}
	local owned = getOwnedVehicle(plate)
	local dataStore = CreateDataStore(plate, owned, data)
	SharedDataStores[plate] = dataStore
	MySQL.Async.execute(
	"INSERT INTO glovebox_inventory(plate,data,owned) VALUES (@plate,'{}',@owned)",
		{
			["@plate"] = plate,
			["@owned"] = owned
		}
	)
	loadInvent(plate)
end

function GetSharedDataStore(plate)
	if SharedDataStores[plate] == nil then
		MakeDataStore(plate)
	end
	return SharedDataStores[plate]
end

AddEventHandler("esx_glovebox:getSharedDataStore", function(plate, cb)
    cb(GetSharedDataStore(plate))
end)
