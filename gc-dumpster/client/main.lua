local Keys = {
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

ESX                           = nil


Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

local dumpsterType = {}

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)
RegisterNetEvent('lavda:dump')
AddEventHandler('lavda:dump', function(job)
	OpendumpsterInventoryMenu({job = 'mechanic'})
end)
function OpendumpsterInventoryMenu(data)
	
		dumpsterType = data
		ESX.TriggerServerCallback(
			"monster_dumpster:getdumpsterInventory",
			function(inventory)
				if not inventory then
					exports['mythic_notify']:SendAlert('error', 'Not have license card')
				else
					TriggerEvent("monster_inventoryhud:opendumpsterInventory", inventory)
				end
			end,
			data
		)
end




function getMonsterdumpsterLicense()
	return dumpsterType
end




------------------------------DUMPSTER-----------------------------------------
------------------------------DUMPSTER-----------------------------------------
------------------------------DUMPSTER-----------------------------------------
------------------------------DUMPSTER-----------------------------------------
------------------------------DUMPSTER-----------------------------------------
local searched = {3423423424}
local canSearch = true
local dumpsters = {218085040, 666561306, -58485588, -206690185, 1511880420, 682791951}
local searchTime = 14000
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if canSearch then
            local ped = GetPlayerPed(-1)
            local pos = GetEntityCoords(ped)
            local dumpsterFound = false

            for i = 1, #dumpsters do
                local dumpster = GetClosestObjectOfType(pos.x, pos.y, pos.z, 1.0, dumpsters[i], false, false, false)
                local dumpPos = GetEntityCoords(dumpster)
                local dist = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, dumpPos.x, dumpPos.y, dumpPos.z, true)

                if dist < 1.8 then
                    DrawText3Ds(dumpPos.x, dumpPos.y, dumpPos.z + 1.0, 'Open Inventory to dumpster dive')
                    DisableControlAction(0, 289, true)
                    if IsDisabledControlJustPressed(1, 289) and GetLastInputMethod(0) then
                        for i = 1, #searched do
                            if searched[i] == dumpster then
                                dumpsterFound = true
                            end
                            if i == #searched and dumpsterFound then
                                exports['mythic_notify']:DoHudText('error', 'This dumpster has already been searched')
                            elseif i == #searched and not dumpsterFound then
								TriggerEvent('lavda:dump')
								TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BUM_SHOPPING_CART", 0, true)
                        		TriggerScreenblurFadeIn(0)
                            end
                        end
                    end
                end
            end
        end
    end
end)
