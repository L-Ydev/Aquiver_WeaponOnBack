-- Adapté pour l'inventaire Aquiver

local SETTINGS = {
    back_bone = 24816,
    x = 0.075,
    y = -0.15,
    z = -0.02,
    x_rotation = 0.0,
    y_rotation = 165.0,
    z_rotation = 0.0,
    compatible_weapon_hashes = {
        -- Ajoutez vos armes compatibles ici
        ["w_me_bat"] = -1786099057,
        ["prop_ld_jerrycan_01"] = 883325847,
        ["w_ar_carbinerifle"] = -2084633992,
        ["w_ar_carbineriflemk2"] = GetHashKey("WEAPON_CARBINERIFLE_MK2"),
        ["w_ar_assaultrifle"] = -1074790547,
        ["w_ar_specialcarbine"] = -1063057011,
        ["w_ar_bullpuprifle"] = 2132975508,
        ["w_ar_advancedrifle"] = -1357824103,
        ["w_sb_microsmg"] = 324215364,
        ["w_sb_assaultsmg"] = -270015777,
        ["w_sb_smg"] = 736523883,
        ["w_sb_smgmk2"] = GetHashKey("WEAPON_SMG_MK2"),
        ["w_sb_gusenberg"] = 1627465347,
        ["w_sr_sniperrifle"] = 100416529,
        ["w_sg_assaultshotgun"] = -494615257,
        ["w_sg_bullpupshotgun"] = -1654528753,
        ["w_sg_pumpshotgun"] = 487013001,
        ["w_ar_musket"] = -1466123874,
        ["w_sg_heavyshotgun"] = GetHashKey("WEAPON_HEAVYSHOTGUN"),
        ["w_lr_firework"] = 2138347493
    }
}

local attached_weapons = {}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000) 

        local me = PlayerPedId()
        local inventoryItems = exports["avp_inv_4"]:GetInventoryItems()

        local weaponHashes = {}
        for _, item in ipairs(inventoryItems) do
            if item.type == "weapon" then
                weaponHashes[GetHashKey(item.name)] = true
            end
        end

        print("Armes dans l'inventaire:")
        for weaponHash, _ in pairs(weaponHashes) do
            print(weaponHash)
        end

        for wep_name, wep_hash in pairs(SETTINGS.compatible_weapon_hashes) do
            if weaponHashes[wep_hash] then
                if not attached_weapons[wep_name] and GetSelectedPedWeapon(me) ~= wep_hash then
                    print("Attacher l'arme:", wep_name)
                    AttachWeapon(wep_name, wep_hash, SETTINGS.back_bone, SETTINGS.x, SETTINGS.y, SETTINGS.z, SETTINGS.x_rotation, SETTINGS.y_rotation, SETTINGS.z_rotation)
                else
                    print("L'arme est déjà attachée ou sélectionnée:", wep_name)
                end
            else
                print("Le joueur ne possède pas l'arme:", wep_name)
            end
        end
    end
end)

function AttachWeapon(attachModel, modelHash, boneNumber, x, y, z, xR, yR, zR)
    local bone = GetPedBoneIndex(PlayerPedId(), boneNumber)
    RequestModel(attachModel)
    while not HasModelLoaded(attachModel) do
        Wait(100)
    end

    attached_weapons[attachModel] = {
        hash = modelHash,
        handle = CreateObject(GetHashKey(attachModel), 1.0, 1.0, 1.0, true, true, false)
    }

    SetEntityCollision(attached_weapons[attachModel].handle, false, false)
    AttachEntityToEntity(attached_weapons[attachModel].handle, PlayerPedId(), bone, x, y, z, xR, yR, zR, 1, 1, 0, 0, 2, 1)

    print("Arme attachée:", attachModel)
end
