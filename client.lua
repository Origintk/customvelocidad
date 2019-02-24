local inVehicle = false

local setVehicle = nil
local setTorque = 0.0
local setPower = 0.0

Citizen.CreateThread(function()
    while true do

        if IsPedInAnyVehicle(LocalPed(), false) and not inVehicle then
            local vehicle = GetVehiclePedIsIn(LocalPed(), false)

            if DoesVehicleNeedMods(vehicle) then
                local mods = GetVehicleMods(vehicle)
                SetMod(vehicle, mods.tq, mods.pw)
            end

            inVehicle = true
        end

        if not IsPedInAnyVehicle(LocalPed(), false) and inVehicle then
            inVehicle = false
        end

        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    while true do


        if setVehicle ~= nil and inVehicle then
            SetVehicleEngineTorqueMultiplier(setVehicle, setTorque)
            SetVehicleEnginePowerMultiplier(setVehicle, setPower)
        end

        Citizen.Wait(0)
    end
end)

function LocalPed()
    return GetPlayerPed(PlayerId())
end

function DoesVehicleNeedMods(vehicle)
    local vehicles = Vehicles.List
    for a = 1, #vehicles do
        if IsVehicleModel(vehicle, GetHashKey(vehicles[a].model)) then
            return true
        end
    end
    return false
end

function GetVehicleMods(vehicle)
    local torque = 0.0
    local power = 0.0
    local vehicles = Vehicles.List

    for a = 1, #vehicles do
        if IsVehicleModel(vehicle, GetHashKey(vehicles[a].model)) then
            torque = vehicles[a].torque
            power = vehicles[a].power
        end
    end
    return {tq = torque, pw = power}
end

function SetMod(vehicle, torque, power)
    setVehicle = vehicle
    setTorque = torque
    setPower = power
end
