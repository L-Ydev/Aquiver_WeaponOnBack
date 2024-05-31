-- Ce script met certaines armes lourdes sur le dos d'un joueur lorsqu'elles ne sont pas sélectionnées mais sont encore dans la roue des armes.
-- Adapté pour l'inventaire Aquiver

local SETTINGS = {
    back_bone = 24816,
    x = 0.075,
    y = -0.15,
    z = -0.02,
    x_rotation = 0.0,
    y_rotation = 165.0,
    z_rotation = 0.0,
    compatable_weapon_hashes = {}
}

-- Catégories d'armes
local melee_weapons = {
    ["w_me_bat"] = -1786099057,
    ["prop_ld_jerrycan_01"] = 883325847
}

local assault_rifles = {
    ["w_ar_carbinerifle"] = -2084633992,
    ["w_ar_carbineriflemk2"] = GetHashKey("WEAPON_CARBINERIFLE_MK2"),
    ["w_ar_assaultrifle"] = -1074790547,
    ["w_ar_specialcarbine"] = -1063057011,
    ["w_ar_bullpuprifle"] = 2132975508,
    ["w_ar_advancedrifle"] = -1357824103
}

local sub_machine_guns = {
    ["w_sb_microsmg"] = 324215364,
    ["w_sb_assaultsmg"] = -270015777,
    ["w_sb_smg"] = 736523883,
    ["w_sb_smgmk2"] = GetHashKey("WEAPON_SMG_MK2"),
    ["w_sb_gusenberg"] = 1627465347
}

local sniper_rifles = {
    ["w_sr_sniperrifle"] = 100416529
}

local shotguns = {
    ["w_sg_assaultshotgun"] = -494615257,
    ["w_sg_bullpupshotgun"] = -1654528753,
    ["w_sg_pumpshotgun"] = 487013001,
    ["w_ar_musket"] = -1466123874,
    ["w_sg_heavyshotgun"] = GetHashKey("WEAPON_HEAVYSHOTGUN")
}

local launchers = {
    ["w_lr_firework"] = 2138347493
}

-- Combinaison des catégories d'armes
for category, weapons in pairs({melee_weapons, assault_rifles, sub_machine_guns, sniper_rifles, shotguns, launchers}) do
    for name, hash in pairs(weapons) do
        SETTINGS.compatable_weapon_hashes[name] = hash
    end
end

local attached_weapons = {}

Citizen.CreateThread(function()
    while true do
        local me = PlayerPedId()
        local inventoryItems = exports["avp_inv_4"]:GetInventoryItems()

        -- Convert inventory items to a set of weapon hashes
        local weaponHashes = {}
        for _, item in ipairs(inventoryItems) do
            if item.type == "weapon" then
                weaponHashes[GetHashKey(item.name)] = true
            end
        end
        
        -- Attacher si le joueur a une grande arme
        for wep_name, wep_hash in pairs(SETTINGS.compatable_weapon_hashes) do
            if weaponHashes[wep_hash] and GetSelectedPedWeapon(me) ~= wep_hash then
                if not attached_weapons[wep_name] then
                    AttachWeapon(wep_name, wep_hash, SETTINGS.back_bone, SETTINGS.x, SETTINGS.y, SETTINGS.z, SETTINGS.x_rotation, SETTINGS.y_rotation, SETTINGS.z_rotation, isMeleeWeapon(wep_name))
                end
            end
        end
        
        -- Supprimer du dos si équipé / abandonné
        for name, attached_object in pairs(attached_weapons) do
            if GetSelectedPedWeapon(me) == attached_object.hash or not weaponHashes[attached_object.hash] then
                DeleteObject(attached_object.handle)
                attached_weapons[name] = nil
            end
        end
        
        Wait(0)
    end
end)

function AttachWeapon(attachModel, modelHash, boneNumber, x, y, z, xR, yR, zR, isMelee)
    local bone = GetPedBoneIndex(PlayerPedId(), boneNumber)
    RequestModel(attachModel)
    while not HasModelLoaded(attachModel) do
        Wait(100)
    end

    attached_weapons[attachModel] = {
        hash = modelHash,
        handle = CreateObject(GetHashKey(attachModel), 1.0, 1.0, 1.0, true, true, false)
    }

    if isMelee then 
        x = 0.11 
        y = -0.14 
        z = 0.0 
        xR = -75.0 
        yR = 185.0 
        zR = 92.0 
    end
    
    if attachModel == "prop_ld_jerrycan_01" then 
        x = x + 0.3 
    end

    SetEntityCollision(attached_weapons[attachModel].handle, false, false)
    AttachEntityToEntity(attached_weapons[attachModel].handle, PlayerPedId(), bone, x, y, z, xR, yR, zR, 1, 1, 0, 0, 2, 1)
end

function isMeleeWeapon(wep_name)
    return melee_weapons[wep_name] ~= nil
end
