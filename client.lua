-- Adapté pour l'inventaire Aquiver
local SETTINGS = {
    back_bone = 24816,
    x = 0.075,
    y = -0.15,
    z = -0.02,
    x_rotation = 0.0,
    y_rotation = 165.0,
    z_rotation = 0.0,
    compatible_weapons = {
        {name = "WEAPON_BAT", hash = -1786099057},
        {name = "WEAPON_CARBINERIFLE", hash = -2084633992},
        {name = "WEAPON_CARBINERIFLE_MK2", hash = GetHashKey("WEAPON_CARBINERIFLE_MK2")},
        {name = "WEAPON_ASSAULTRIFLE", hash = -1074790547},
        {name = "WEAPON_SPECIALCARBINE", hash = -1063057011},
        {name = "WEAPON_BULLPUPRIFLE", hash = 2132975508},
        {name = "WEAPON_ADVANCEDRIFLE", hash = -1357824103},
        {name = "WEAPON_MICROSMG", hash = 324215364},
        {name = "WEAPON_ASSAULTSMG", hash = -270015777},
        {name = "WEAPON_SMG", hash = 736523883},
        {name = "WEAPON_SMG_MK2", hash = GetHashKey("WEAPON_SMG_MK2")},
        {name = "WEAPON_GUSENBERG", hash = 1627465347},
        {name = "WEAPON_SNIPERRIFLE", hash = 100416529},
        {name = "WEAPON_ASSAULTSHOTGUN", hash = -494615257},
        {name = "WEAPON_BULLPUPSHOTGUN", hash = -1654528753},
        {name = "WEAPON_PUMPSHOTGUN", hash = 487013001},
        {name = "WEAPON_MUSKET", hash = -1466123874},
        {name = "WEAPON_HEAVYSHOTGUN", hash = GetHashKey("WEAPON_HEAVYSHOTGUN")},
        {name = "WEAPON_FIREWORK", hash = 2138347493}
    }
}

local attached_weapons = {}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)  

        local me = PlayerPedId()

        for _, weaponData in ipairs(SETTINGS.compatible_weapons) do
            local res = exports["avp_inv_4"]:GetItemBy({
                name = weaponData.name
            })

            if res then
                AttachWeapon(weaponData.hash, SETTINGS.back_bone, SETTINGS.x, SETTINGS.y, SETTINGS.z, SETTINGS.x_rotation, SETTINGS.y_rotation, SETTINGS.z_rotation)
            end
        end
    end
end)

function AttachWeapon(modelHash, boneNumber, x, y, z, xR, yR, zR)
    local bone = GetPedBoneIndex(PlayerPedId(), boneNumber)
    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
        Wait(100)
    end

    local handle = CreateObject(modelHash, 1.0, 1.0, 1.0, true, true, false)

    SetEntityCollision(handle, false, false)
    AttachEntityToEntity(handle, PlayerPedId(), bone, x, y, z, xR, yR, zR, 1, 1, 0, 0, 2, 1)

    table.insert(attached_weapons, handle)
end
