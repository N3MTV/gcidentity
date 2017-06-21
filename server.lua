--====================================================================================
-- #Author: Jonathan D & Charlie @ charli62128
-- 
-- Développée pour la communauté n3mtv
--      https://www.twitch.tv/n3mtv
--      https://twitter.com/n3m_tv
--      https://www.facebook.com/lan3mtv
--====================================================================================

-- Configuration BDD
require "resources/essentialmode/lib/MySQL"
MySQL:open("127.0.0.1", "gta5_gamemode_essential", "root", "monpasse")

--====================================================================================
--  Teste si un joueurs a donnée ces infomation identitaire
--====================================================================================
function hasIdentity(source)
    local identifier = GetPlayerIdentifiers(source)[1]
    local executed_query, result = MySQL:executeQuery("select nom, prenom from users where identifier = '@identifier'", {
        ['@identifier'] = identifier
    })
    local result = MySQL:getResults(executed_query, {"nom", "prenom"})
    local user = result[1]
    return not (user['nom'] == '' or user['prenom'] == '')
end

function getIdentity(source)
    local identifier = GetPlayerIdentifiers(source)[1]
    local executed_query, result = MySQL:executeQuery("select users.* , jobs.job_name as jobs  from users join jobs WHERE users.job = jobs.job_id and users.identifier = '@identifier'", {
        ['@identifier'] = identifier
    })
    local result = MySQL:getResults(executed_query, {"nom", "prenom", "dateNaissance", "sexe", "taille", "jobs"})
    if #result == 1 then
        result[1]['id'] = source
        return result[1]
    else
        return nil
    end
end

function setIdentity(identifier, data)
    MySQL:executeQuery("UPDATE users SET nom = '@nom', prenom = '@prenom', dateNaissance = '@dateNaissance', sexe = '@sexe', taille = '@taille' WHERE identifier = '@identifier'", {
        ['@nom'] = data.nom,
        ['@prenom'] = data.prenom,
        ['@dateNaissance'] = data.dateNaissance,
        ['@sexe'] = data.sexe,
        ['@taille'] = data.taille,
        ['@identifier'] = identifier
    })
    
end

function convertSQLData(data)
    return {
        nom = data.nom,
        prenom = data.prenom,
        sexe = data.sexe,
        dateNaissance = tostring(data.dateNaissance),
        -- dateNaissance = os.date("%x",os.time(data.dateNaissance)), -- mysql async 
        jobs = data.jobs,
        taille = data.taille,
        id = data.id
    }
end

function openIdentity(source, data)
    if data ~= nil then 
        TriggerClientEvent('gcIdentity:showIdentity', source, convertSQLData(data))
    end
end

AddEventHandler('es:playerLoaded', function(source)
    print('identity playerLoaded')
    local identity = getIdentity(source)
    for k,v in pairs(identity) do 
        print(k .. ' -> ' .. v)
    end
    if identity == nil or identity.nom == '' then
        TriggerClientEvent('gcIdentity:showRegisterIdentity', source)
    else
    print('identity setIdentity')
        TriggerClientEvent('gcIdentity:setIdentity', source, convertSQLData(identity))
    end
end)

RegisterServerEvent('gcIdentity:openIdentity')
AddEventHandler('gcIdentity:openIdentity',function(other)
    local data = getIdentity(source)
    openIdentity(other, data)
end)

RegisterServerEvent('gcIdentity:openMeIdentity')
AddEventHandler('gcIdentity:openMeIdentity',function()
    local data = getIdentity(source)
    openIdentity(source, data)
end)


RegisterServerEvent('gcIdentity:setIdentity')
AddEventHandler('gcIdentity:setIdentity', function(data)
    setIdentity(GetPlayerIdentifiers(source)[1], data)
end)