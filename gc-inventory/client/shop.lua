local shopData = nil

Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}
RegisterNetEvent("policeinventory")
AddEventHandler("policeinventory", function(type, shopinventory)
    OpenShopInv("policeshop")
end)

local Licenses = {}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        player = PlayerPedId()
        coords = GetEntityCoords(player)
        if IsInRegularShopZone(coords) or IsInRobsLiquorZone(coords) or IsInIlegalShopZone(coords) or IsInYouToolZone(coords) or IsInPrisonShopZone(coords) or IsInWeaponShopZone(coords) or IsInPoliceShopZone(coords) then
            if IsInRegularShopZone(coords) then
                if IsControlJustReleased(0, Keys["E"]) then
                    OpenShopInv("regular")
                    Citizen.Wait(2000)
                end
            end
            if IsInIlegalShopZone(coords) then
                if IsControlJustReleased(0, Keys["E"]) then
                    OpenShopInv("ilegal")
                    Citizen.Wait(2000)
                end
            end
            if IsInRobsLiquorZone(coords) then
                if IsControlJustReleased(0, Keys["E"]) then
                    if Licenses['weapon'] ~= nil then
                    OpenShopInv("robsliquor")
                    Citizen.Wait(2000)
                    else
                        exports['mythic_notify']:SendAlert('error', 'You need a Fire Arms license before you can buy weapons')
                    end
                end
            end
            if IsInYouToolZone(coords) then
                if IsControlJustReleased(0, Keys["E"]) then
                    OpenShopInv("youtool")
                    Citizen.Wait(2000)
                end
            end
            if IsInPrisonShopZone(coords) then
                --if ESX.GetPlayerData().job.name == police then
                    if IsControlJustReleased(0, Keys["E"]) then
                        OpenShopInv("prison")
                       Citizen.Wait(2000)
                    end
                --end
            end
            if IsInWeaponShopZone(coords) then
                if IsControlJustReleased(0, Keys["E"]) then
                   -- if Licenses['weapon'] ~= nil then
                        OpenShopInv("weaponshop")
                        Citizen.Wait(2000)
                    --else
                    --    exports['mythic_notify']:DoHudText('error', 'You need a Fire Arms license before you can buy weapons')
                    --end
                end
            end
            --[[if IsInPoliceShopZone(coords) then
                if IsControlJustReleased(0, Keys["E"]) then
                    if ESX.GetPlayerData().job.name == "police" then
                    --if Licenses['weapon'] ~= nil the
                        OpenShopInv("policeshop")
                        Citizen.Wait(2000)
                   -- else
                    --    exports['mythic_notify']:DoHudText('error', 'You need a Fire Arms license before you can buy weapons')
                   -- end
                    end
                end
            end]]
        else
            Citizen.Wait(1500)
        end
    end
end)

function OpenShopInv(shoptype)
    --text = "Store"
    
if shoptype == 'weaponshop' then
    text = 'Crafting'
elseif shoptype == 'robsliquor' then
    text = 'Weapon Shop'
elseif shoptype == 'youtool' then
    text = 'ToolShop'
elseif shoptype == 'regular' then
    text = 'Shop'
elseif shoptype == 'ilegal' then
    text = 'Bar'
elseif shoptype == 'policeshop' then
    text = 'Police Armory'
elseif shoptype == 'prison' then
    text = 'Pharmacy'
else
    text = 'shop'
end
data = {text = text}
inventory = {}
    ESX.TriggerServerCallback("suku:getShopItems", function(shopInv)
        for i = 1, #shopInv, 1 do
            table.insert(inventory, shopInv[i])
        end
        TriggerEvent("gc-inventory:openShopInventory", data, inventory)
    end, shoptype)
end

RegisterNetEvent("suku:OpenCustomShopInventory")
AddEventHandler("suku:OpenCustomShopInventory", function(type, shopinventory)
    text = "shop"
    data = {text = text}
    inventory = {}

    ESX.TriggerServerCallback("suku:getCustomShopItems", function(shopInv)
        for i = 1, #shopInv, 1 do
            table.insert(inventory, shopInv[i])
        end
        TriggerEvent("gc-inventory:openShopInventory", data, inventory)
    end, type, shopinventory)
end)

RegisterNetEvent("gc-inventory:openShopInventory")
AddEventHandler("gc-inventory:openShopInventory", function(data, inventory)
    setShopInventoryData(data, inventory, weapons)
    openShopInventory()
end)

function setShopInventoryData(data, inventory)
    shopData = data

    SendNUIMessage(
            {
                action = "setInfoText",
                text = data.text
            }
    )

    items = {}

    SendNUIMessage(
            {
                action = "setShopInventoryItems",
                itemList = inventory
            }
    )
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        player = GetPlayerPed(-1)
        coords = GetEntityCoords(player)

        if GetDistanceBetweenCoords(coords, Config.WeaponLiscence.x, Config.WeaponLiscence.y, Config.WeaponLiscence.z, true) < 3.0 then
            DrawText3Ds(Config.WeaponLiscence.x,  Config.WeaponLiscence.y, Config.WeaponLiscence.z , "Press ~b~[E]~s~ to Register License")
            if IsControlJustReleased(0, 38) then
                if Licenses['weapon'] == nil then
                    OpenBuyLicenseMenu()
                else
                    exports['mythic_notify']:SendAlert('error', 'You already have a Fire arms license!')
                end
                Citizen.Wait(2000)
            end
        end
    end
end)

function openShopInventory()
    loadPlayerInventory()
    isInInventory = true

    SendNUIMessage(
            {
                action = "display",
                type = "shop"
            }
    )

    SetNuiFocus(true, true)
end

RegisterNUICallback("TakeFromShop", function(data, cb)
    if IsPedSittingInAnyVehicle(playerPed) then
        return
    end

    if type(data.number) == "number" and math.floor(data.number) == data.number then
        TriggerServerEvent("suku:SellItemToPlayer", GetPlayerServerId(PlayerId()), data.item.type, data.item.name, tonumber(data.number))
    end

    Wait(150)
    loadPlayerInventory()

    cb("ok")
end
)

RegisterNetEvent("suku:AddAmmoToWeapon")
AddEventHandler("suku:AddAmmoToWeapon", function(hash, amount)
    AddAmmoToPed(PlayerPedId(), hash, amount)
end)

function IsInRegularShopZone(coords)
    RegularShop = Config.Shops.RegularShop.Locations
    for i = 1, #RegularShop, 1 do
        if GetDistanceBetweenCoords(coords, RegularShop[i].x, RegularShop[i].y, RegularShop[i].z, true) < 1.5 then
            return true
        end
    end
    return false
end
function IsInIlegalShopZone(coords)
    IlegalShop = Config.Shops.IlegalShop.Locations
    for i = 1, #IlegalShop, 1 do
        if GetDistanceBetweenCoords(coords, IlegalShop[i].x, IlegalShop[i].y, IlegalShop[i].z, true) < 1.5 then
            return true
        end
    end
    return false
end

function IsInRobsLiquorZone(coords)
    RobsLiquor = Config.Shops.RobsLiquor.Locations
    for i = 1, #RobsLiquor, 1 do
        if GetDistanceBetweenCoords(coords, RobsLiquor[i].x, RobsLiquor[i].y, RobsLiquor[i].z, true) < 1.5 then
            return true
        end
    end
    return false
end

function IsInYouToolZone(coords)
    YouTool = Config.Shops.YouTool.Locations
    for i = 1, #YouTool, 1 do
        if GetDistanceBetweenCoords(coords, YouTool[i].x, YouTool[i].y, YouTool[i].z, true) < 1.5 then
            return true
        end
    end
    return false
end

function IsInPrisonShopZone(coords)
    PrisonShop = Config.Shops.PrisonShop.Locations
    for i = 1, #PrisonShop, 1 do
        if GetDistanceBetweenCoords(coords, PrisonShop[i].x, PrisonShop[i].y, PrisonShop[i].z, true) < 1.5 then
            return true
        end
    end
    return false
end

function IsInWeaponShopZone(coords)
    WeaponShop = Config.Shops.WeaponShop.Locations
    for i = 1, #WeaponShop, 1 do
        if GetDistanceBetweenCoords(coords, WeaponShop[i].x, WeaponShop[i].y, WeaponShop[i].z, true) < 1.5 then
            return true
        end
    end
    return false
end


function IsInPoliceShopZone(coords)
    PoliceShop = Config.Shops.PoliceShop.Locations
    for i = 1, #PoliceShop, 1 do
        if GetDistanceBetweenCoords(coords, PoliceShop[i].x, PoliceShop[i].y, PoliceShop[i].z, true) < 1.5 then
            return true
        end
    end
    return false
end

Citizen.CreateThread(function()
    player = PlayerPedId()
    coords = GetEntityCoords(player)
    for k, v in pairs(Config.Shops.RegularShop.Locations) do
        CreateBlip(vector3(Config.Shops.RegularShop.Locations[k].x, Config.Shops.RegularShop.Locations[k].y, Config.Shops.RegularShop.Locations[k].z ), "Shops", 3.0, Config.Color, Config.ShopBlipID)
    end

    for k, v in pairs(Config.Shops.RobsLiquor.Locations) do
     --   CreateBlip(vector3(Config.Shops.RobsLiquor.Locations[k].x, Config.Shops.RobsLiquor.Locations[k].y, Config.Shops.RobsLiquor.Locations[k].z ), "Tabacaria", 3.0, Config.Color, Config.LiquorBlipID)
    end

    for k, v in pairs(Config.Shops.YouTool.Locations) do
       ---- CreateBlip(vector3(Config.Shops.YouTool.Locations[k].x, Config.Shops.YouTool.Locations[k].y, Config.Shops.YouTool.Locations[k].z ), "U Ferramentas", 3.0, Config.Color, Config.YouToolBlipID)
    end

    for k, v in pairs(Config.Shops.YouTool.Locations) do
      ---  CreateBlip(vector3(Config.Shops.PrisonShop.Locations[k].x, Config.Shops.PrisonShop.Locations[k].y, Config.Shops.PrisonShop.Locations[k].z), "Prison Commissary", 3.0, Config.Color, Config.PrisonShopBlipID)
    end

    for k, v in pairs(Config.Shops.WeaponShop.Locations) do
       -- CreateBlip(vector3(Config.Shops.WeaponShop.Locations[k].x, Config.Shops.WeaponShop.Locations[k].y, Config.Shops.WeaponShop.Locations[k].z), "Ammunation", 3.0, Config.WeaponColor, Config.WeaponShopBlipID)
    end

    --CreateBlip(vector3(-755.79, 5596.07, 41.67), "Teleférico", 3.0, 4, 36)
end)

Citizen.CreateThread(function()
    local sleep = 7
    while true do
        Citizen.Wait(sleep)
        player = PlayerPedId()
        coords = GetEntityCoords(player)
        if IsPedOnFoot(player) then
            for k, v in pairs(Config.Shops.RegularShop.Locations) do
                local distance = GetDistanceBetweenCoords(coords, Config.Shops.RegularShop.Locations[k].x, Config.Shops.RegularShop.Locations[k].y, Config.Shops.RegularShop.Locations[k].z, true)
                if distance < 10 then
                    DrawMarker(20, Config.Shops.RegularShop.Locations[k].x, Config.Shops.RegularShop.Locations[k].y, Config.Shops.RegularShop.Locations[k].z+1, 0, 0, 0, 0, 0, 0, 0.601, 1.0001, 0.2001, 255, 255, 255, 255, 0, 1, 0, 0, 0, 0, 0)
                    if distance < 3.0 then 
                        DrawText3Ds(Config.Shops.RegularShop.Locations[k].x, Config.Shops.RegularShop.Locations[k].y, Config.Shops.RegularShop.Locations[k].z + 1.3, "Press [~g~E~w~] to open the shop")
                        near = true
                        break
                    end
                    near = true
                end
            end
            for k, v in pairs(Config.Shops.IlegalShop.Locations) do
                local distance = GetDistanceBetweenCoords(coords, Config.Shops.IlegalShop.Locations[k].x, Config.Shops.IlegalShop.Locations[k].y, Config.Shops.IlegalShop.Locations[k].z, true)
                if distance < 10 then
                    DrawMarker(20, Config.Shops.IlegalShop.Locations[k].x, Config.Shops.IlegalShop.Locations[k].y, Config.Shops.IlegalShop.Locations[k].z+1, 0, 0, 0, 0, 0, 0, 0.601, 1.0001, 0.2001, 255, 255, 255, 255, 0, 1, 0, 0, 0, 0, 0)
                    if distance < 3.0 then 
                        DrawText3Ds(Config.Shops.IlegalShop.Locations[k].x, Config.Shops.IlegalShop.Locations[k].y, Config.Shops.IlegalShop.Locations[k].z + 1.3, "Press [~g~E~w~] to open the shop")
                        near = true
                        break
                    end
                    near = true
                end
            end
            for k, v in pairs(Config.Shops.RobsLiquor.Locations) do
                local distance = GetDistanceBetweenCoords(coords, Config.Shops.RobsLiquor.Locations[k].x, Config.Shops.RobsLiquor.Locations[k].y, Config.Shops.RobsLiquor.Locations[k].z, true)
                if distance < 10 then
                    DrawMarker(20, Config.Shops.RobsLiquor.Locations[k].x, Config.Shops.RobsLiquor.Locations[k].y, Config.Shops.RobsLiquor.Locations[k].z+1, 0, 0, 0, 0, 0, 0, 0.601, 1.0001, 0.2001, 255, 255, 255, 255, 0, 1, 0, 0, 0, 0, 0)
                    if distance < 3.0 then 
                        DrawText3Ds(Config.Shops.RobsLiquor.Locations[k].x, Config.Shops.RobsLiquor.Locations[k].y, Config.Shops.RobsLiquor.Locations[k].z + 1.3, "Press [~g~E~w~] to open the shop")
                        near = true
                        break
                    end
                    near = true
                end
            end
            for k, v in pairs(Config.Shops.YouTool.Locations) do
                local distance = GetDistanceBetweenCoords(coords, Config.Shops.YouTool.Locations[k].x, Config.Shops.YouTool.Locations[k].y, Config.Shops.YouTool.Locations[k].z, true)
                if distance < 10 then
                    DrawMarker(20, Config.Shops.YouTool.Locations[k].x, Config.Shops.YouTool.Locations[k].y, Config.Shops.YouTool.Locations[k].z+1, 0, 0, 0, 0, 0, 0, 0.601, 1.0001, 0.2001, 255, 255, 255, 255, 0, 1, 0, 0, 0, 0, 0)
                    if distance < 3.0 then 
                        DrawText3Ds(Config.Shops.YouTool.Locations[k].x, Config.Shops.YouTool.Locations[k].y, Config.Shops.YouTool.Locations[k].z + 1.3, "Press [~g~E~w~] to open the shop")
                        near = true
                        break
                    end
                    near = true
                end
            end
            for k, v in pairs(Config.Shops.PrisonShop.Locations) do
                local distance = GetDistanceBetweenCoords(coords, Config.Shops.PrisonShop.Locations[k].x, Config.Shops.PrisonShop.Locations[k].y, Config.Shops.PrisonShop.Locations[k].z, true)
                if distance < 10 then
                    DrawMarker(20, Config.Shops.PrisonShop.Locations[k].x, Config.Shops.PrisonShop.Locations[k].y, Config.Shops.PrisonShop.Locations[k].z+1, 0, 0, 0, 0, 0, 0, 0.601, 1.0001, 0.2001, 255, 255, 255, 255, 0, 1, 0, 0, 0, 0, 0)
                    if distance < 3.0 then 
                        DrawText3Ds(Config.Shops.PrisonShop.Locations[k].x, Config.Shops.PrisonShop.Locations[k].y, Config.Shops.PrisonShop.Locations[k].z + 1.3, "Press [~g~E~w~] to open the shop")
                        near = true
                        break
                    end
                    near = true
                end
            end
            for k, v in pairs(Config.Shops.WeaponShop.Locations) do
                local distance = GetDistanceBetweenCoords(coords, Config.Shops.WeaponShop.Locations[k].x, Config.Shops.WeaponShop.Locations[k].y, Config.Shops.WeaponShop.Locations[k].z, true)
                if distance < 10 then
                    DrawMarker(20, Config.Shops.WeaponShop.Locations[k].x, Config.Shops.WeaponShop.Locations[k].y, Config.Shops.WeaponShop.Locations[k].z+1, 0, 0, 0, 0, 0, 0, 0.601, 1.0001, 0.2001, 255, 255, 255, 255, 0, 1, 0, 0, 0, 0, 0)
                    if distance < 3.0 then 
                        DrawText3Ds(Config.Shops.WeaponShop.Locations[k].x, Config.Shops.WeaponShop.Locations[k].y, Config.Shops.WeaponShop.Locations[k].z + 1.3, "Press [~g~E~w~] to Craft Items")
                        near = true
                        break
                    end
                    near = true
                end
            end
            --[[for k, v in pairs(Config.Shops.PoliceShop.Locations) do
                local distance = GetDistanceBetweenCoords(coords, Config.Shops.PoliceShop.Locations[k].x, Config.Shops.PoliceShop.Locations[k].y, Config.Shops.PoliceShop.Locations[k].z, true)
                if distance < 10 then
                    DrawMarker(20, Config.Shops.PoliceShop.Locations[k].x, Config.Shops.PoliceShop.Locations[k].y, Config.Shops.PoliceShop.Locations[k].z+1, 0, 0, 0, 0, 0, 0, 0.601, 1.0001, 0.2001, 255, 255, 255, 255, 0, 1, 0, 0, 0, 0, 0)
                    if distance < 3.0 then 
                        DrawText3Ds(Config.Shops.PoliceShop.Locations[k].x, Config.Shops.PoliceShop.Locations[k].y, Config.Shops.PoliceShop.Locations[k].z + 1.3, "Press [~g~E~w~] to open the shop")
                        near = true
                        break
                    end
                    near = true
                end
            end]]
            if not near then 
                sleep = 1500
            else
                sleep = 7
            end
            near = false
        else
            Citizen.Wait(1500)
        end
    end
end)

function DrawText3Ds(x, y, z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)

    local scale = 0.3

    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(true)
        AddTextComponentString(text)
        SetDrawOrigin(x,y,z, 0)
        DrawText(0.0, 0.0)
        local factor = (string.len(text)) / 370
        DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
        DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
        DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
        ClearDrawOrigin()
    end
end

function CreateBlip(coords, text, radius, color, sprite)
    local blip = AddBlipForCoord(coords)
    SetBlipSprite(blip, sprite)
    SetBlipColour(blip, color)
    SetBlipScale(blip, 0.6)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(text)
    EndTextCommandSetBlipName(blip)
end

Citizen.CreateThread(function()
    RequestModel(GetHashKey("a_f_y_bevhills_03"))
	
    while not HasModelLoaded(GetHashKey("a_f_y_bevhills_03")) do
        Wait(1)
    end
	
	if true then
		for _, item in pairs(Config.Locations) do
			local npc = CreatePed(4, 0x20C8012F, item.x, item.y, item.z, item.heading, false, true)
			
			SetEntityHeading(npc, item.heading)
			FreezeEntityPosition(npc, true)
			SetEntityInvincible(npc, true)
			SetBlockingOfNonTemporaryEvents(npc, true)
		end
    end
end)

RegisterNetEvent('suku:GetLicenses')
AddEventHandler('suku:GetLicenses', function (licenses)
    for i = 1, #licenses, 1 do
        Licenses[licenses[i].type] = true
    end
end)

function OpenBuyLicenseMenu()
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_license',{
        title = 'Register a License',
        elements = {
          {label = 'yes' ..' ($' .. Config.LicensePrice ..')', value = 'yes'},
          {label = 'no', value = 'no' },
     }}, function (data, menu)
        if data.current.value == 'yes' then
            TriggerServerEvent('suku:buyLicense')
        end
        menu.close()
    end, function (data, menu)
        menu.close()
    end)
end