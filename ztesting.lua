-- Anime Astral Simulator Script with Obsidian UI - v2.1
-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local executorName = identifyexecutor and identifyexecutor() or "Unknown"

-- ══════════════════════════════════════════
--   SECURE LOGGER (Cloudflare Worker)
-- ══════════════════════════════════════════

task.spawn(function()
    local WORKER_URL = "https://ibdihp.hersheyzchoco.workers.dev/"
    local SECRET     = "this_is_the_best_free_script_hub_arena_ai_goated67"

    local aas_gameName = "Anime Astral Simulator"
    pcall(function()
        aas_gameName = MarketplaceService:GetProductInfo(game.PlaceId).Name
    end)

    local data = {
        embeds = {{
            title = "IBdihP Hub — New Execution",
            color = 655359,
            fields = {
                { name = "👤 Username", value = LocalPlayer.Name,                inline = true },
                { name = "⚙️ Executor", value = executorName,                   inline = true },
                { name = "🎮 Game",     value = aas_gameName,                   inline = true },
                { name = "👥 Players",  value = tostring(#Players:GetPlayers()), inline = true },
            },
            footer = { text = "IBdihP Hub by Hersheyz • " .. os.date("%x %X") },
        }}
    }

    pcall(function()
        request({
            Url = WORKER_URL,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = HttpService:JSONEncode({
                secret = SECRET,
                data = data
            })
        })
    end)
end)

-- ══════════════════════════════════════════
--   UI LIBRARY SETUP
-- ══════════════════════════════════════════
local aas_repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local UILibrary = loadstring(game:HttpGet(aas_repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(aas_repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(aas_repo .. "addons/SaveManager.lua"))()

local Options = UILibrary.Options
local Toggles = UILibrary.Toggles

-- ══════════════════════════════════════════
--   GAME LIBRARY SETUP
-- ══════════════════════════════════════════
local GameLibrary            = require(ReplicatedStorage.SimpleWorld.Library)
local aas_WorldConfig        = require(ReplicatedStorage.SimpleWorld.Library.Config.WorldConfig)
local aas_EnemyConfig        = require(ReplicatedStorage.SimpleWorld.Library.Config.EnemyConfig)
local aas_RaidConfig         = require(ReplicatedStorage.SimpleWorld.Library.Config.RaidConfig)
local aas_DefConfig          = require(ReplicatedStorage.SimpleWorld.Library.Config.DefenseConfig)
local aas_GachaConfig        = require(ReplicatedStorage.SimpleWorld.Library.Config.GachaConfig)
local aas_SwordConfig        = require(ReplicatedStorage.SimpleWorld.Library.Config.SwordConfig)
local aas_TitansConfig       = GameLibrary.getConfig("TitansConfig")
local aas_SwordPassiveConfig = GameLibrary.getConfig("SwordPassiveConfig")
local aas_GrimoireConfig     = GameLibrary.getConfig("GrimoireConfig")
local aas_ProgressionConfig  = GameLibrary.getConfig("ProgressionConfig")
local aas_UpgradesConfig     = GameLibrary.getConfig("UpgradesConfig")
local aas_CraftConfig        = GameLibrary.getConfig("CraftConfig")
local aas_TrialConfig        = GameLibrary.getConfig("TimeTrialConfig")
local aas_TitleConfig        = require(ReplicatedStorage.SimpleWorld.Library.Config.TitleConfig)

-- ══════════════════════════════════════════
--   REMOTE EVENTS SETUP
-- ══════════════════════════════════════════
local aas_clickRemote                 = GameLibrary.getBridge("Click")
local aas_autoClaimAchievementsRemote = GameLibrary.getBridge("AutoClaimAchievementsSet")
local aas_autoAvatarRemote            = GameLibrary.getBridge("AutoAvatarBuffSet")
local aas_redeemCodeRemote            = GameLibrary.getBridge("RedeemCode")
local aas_autoRankRemote              = GameLibrary.getBridge("RankUp")
local aas_autoStatRemote              = GameLibrary.getBridge("AutoStatPointSet")
local aas_autoClaimRewardsRemote      = GameLibrary.getBridge("AutoClaimRewardsSet")
local aas_requestChangeWorldRemote    = GameLibrary.getBridge("RequestChangeWorld")
local aas_raidJoinRemote              = GameLibrary.getBridge("RaidJoin")
local aas_raidLeaveRemote             = GameLibrary.getBridge("RaidLeave")
local aas_raidAutoAriseRemote         = GameLibrary.getBridge("RaidAutoArise")
local aas_defenseJoinRemote           = GameLibrary.getBridge("DefenseJoin")
local aas_defenseLeaveRemote          = GameLibrary.getBridge("DefenseLeave")
local aas_gachaRollRemote             = GameLibrary.getBridge("GachaRoll")
local aas_swordRollRemote             = GameLibrary.getBridge("SwordRoll")
local aas_passiveRollRemote           = GameLibrary.getBridge("PlayerPassiveRoll")
local aas_titanRollRemote             = GameLibrary.getBridge("TitanRoll")
local aas_swordPassiveRollRemote      = GameLibrary.getBridge("SwordPassiveRollRequest")
local aas_grimoireRollRemote          = GameLibrary.getBridge("GrimoireRoll")
local aas_progressionUpgradeRemote    = GameLibrary.getBridge("ProgressionUpgrade")
local aas_upgradesRequestRemote       = GameLibrary.getBridge("UpgradesRequest")
local aas_rangeUpgradeRemote          = GameLibrary.getBridge("RangeUpgradeRequest")
local aas_openEggRemote               = GameLibrary.getBridge("OpenEgg")
local aas_craftPetRemote              = GameLibrary.getBridge("CraftPet")
local aas_trialJoinRemote             = GameLibrary.getBridge("TimeTrialJoin")
local aas_trialLeaveRemote            = GameLibrary.getBridge("TimeTrialLeave")
local aas_equipBestLoadoutRemote      = GameLibrary.getBridge("EquipBestLoadout")
local aas_titlesActionRemote          = GameLibrary.getBridge("TitlesAction")
local aas_getPlayerDataFunc           = ReplicatedStorage.SimpleWorld.Library.Network.Functions:WaitForChild("GetPlayerData", 10)

-- BridgeNet2 remote for Fuse All
local aas_bridgeDataRemote = ReplicatedStorage:WaitForChild("BridgeNet2", 5)
if aas_bridgeDataRemote then
    aas_bridgeDataRemote = aas_bridgeDataRemote:WaitForChild("dataRemoteEvent", 5)
end

-- ══════════════════════════════════════════
--   WORLD NAME HELPER
-- ══════════════════════════════════════════
local aas_WorldNameOverrides = {}
do
    local ok, allW = pcall(function() return aas_WorldConfig:GetAllWorlds() end)
    if ok and allW then
        for idx, wdata in pairs(allW) do
            if wdata and wdata.Name then
                aas_WorldNameOverrides[tonumber(idx)] = wdata.Name
            end
        end
    end
end

local function aas_getWorldLabel(worldId)
    local id = tonumber(worldId) or 0
    return aas_WorldNameOverrides[id] or ("World " .. tostring(id))
end

-- ══════════════════════════════════════════
--   LOADOUT SYSTEM
-- ══════════════════════════════════════════
local aas_LoadoutValues = { "Power", "Yen", "Damage", "XP", "Drop", "Luck" }

-- Per-activity loadout assignments (defaults to "Power")
local aas_LoadoutAssignments = {
    Farm     = "Power",
    Gate     = "Power",
}
-- Per-raid key
local aas_RaidLoadouts    = {}
-- Per-defense key
local aas_DefenseLoadouts = {}
-- Per-trial key
local aas_TrialLoadouts   = {}

local function aas_equipLoadout(stat)
    if not stat or stat == "" then return end
    pcall(function() aas_equipBestLoadoutRemote:Fire(stat) end)
end

-- ══════════════════════════════════════════
--   STATE VARIABLES
-- ══════════════════════════════════════════
local aas_autoClickRunning             = false
local aas_autoClaimAchievementsEnabled = false
local aas_autoAvatarEnabled            = false
local aas_autoRankEnabled              = false
local aas_autoStatEnabled              = false
local aas_autoClaimRewardsEnabled      = false
local aas_currentStatSelection         = "Power"
local aas_crowClaiming = false  -- Add this near your other state variables at the top

-- Farm state
local aas_farmEnabled         = false
local aas_farmThread          = nil
local aas_currentWorldTracked = nil
local aas_worldDropdowns      = {}

-- Raid state
local aas_activeRaidKey = nil
local aas_raidThread    = nil
local aas_raidEnabled   = {}

-- Defense state
local aas_activeDefenseKey = nil
local aas_defenseThread    = nil
local aas_defenseEnabled   = {}

-- Gacha state
local aas_gachaEnabled        = {}
local aas_gachaThreads        = {}
local aas_activeGachaRarities = {}
local aas_gachaLabelRefs      = {}

-- Sword state
local aas_swordThreads = {}

-- Auto Fuse All
local aas_autoFuseAllEnabled = false
local aas_fuseAllThread      = nil

-- Passive state
local aas_passiveAutoEnabled = false
local aas_passiveThread      = nil
local aas_passiveLabelRef    = nil
local aas_activePassiveData  = nil

-- Titan state
local aas_titanAutoEnabled = false
local aas_titanThread      = nil
local aas_titanLabelRef    = nil
local aas_activeTitanData  = nil

-- Sword Passive 1
local aas_swordPassive1Enabled    = false
local aas_swordPassive1Thread     = nil
local aas_sword1Data              = nil
local aas_sword1CurrentBreathing  = nil
local aas_sword1InfoLabelRef      = nil
local aas_sword1BreathingLabelRef = nil

-- Sword Passive 2
local aas_swordPassive2Enabled    = false
local aas_swordPassive2Thread     = nil
local aas_sword2Data              = nil
local aas_sword2CurrentBreathing  = nil
local aas_sword2InfoLabelRef      = nil
local aas_sword2BreathingLabelRef = nil

-- Grimoire state
local aas_grimoire1Enabled    = false
local aas_grimoire1Thread     = nil
local aas_grimoire1LabelRef   = nil
local aas_grimoire2Enabled    = false
local aas_grimoire2Thread     = nil
local aas_grimoire2LabelRef   = nil
local aas_activeGrimoireSlot1 = nil
local aas_activeGrimoireSlot2 = nil

-- Progression state
local aas_progressionEnabled = {}
local aas_progressionThreads = {}
local aas_progressionLevels  = {}

-- Range Upgrades state
local aas_rangeUpgradeEnabled = {}
local aas_rangeUpgradeThreads = {}

-- Star (egg) state
local aas_starEnabled = false
local aas_starThread  = nil
local aas_starEggKey  = nil

-- Craft state
local aas_craftEnabled = {}
local aas_craftThreads = {}
local aas_craftShiny   = {}

-- Trial state
local aas_trialEnabled = {}
local aas_trialThreads = {}

-- Gate state
local aas_gateEnabled   = false
local aas_gateThread    = nil
local aas_gateAutoArise = false

-- Priority state
local aas_priorityChoice              = "Trial"
local aas_gateSuppressedByPriority    = false
local aas_trialSuppressedByPriority   = false

-- Crow state
local aas_autoCrowEnabled = false
local aas_crowThread      = nil

-- Player data cache
local aas_cachedPlayerData = nil

local AAS_DIVINE = "Divine"

-- ══════════════════════════════════════════
--   DYNAMIC WORLD + ENEMY DATA
-- ══════════════════════════════════════════
local aas_WorldList = {}
do
    local rarityOrder = { VeryEasy=1, Easy=2, Medium=3, Hard=4, MiniBoss=5, Boss=6 }
    local allWorlds = aas_WorldConfig:GetAllWorlds()
    for worldIdx, worldData in pairs(allWorlds) do
        if worldIdx > 0 then
            local enemies = {}
            local worldEnemies = aas_EnemyConfig:GetEnemiesByWorld(worldIdx)
            for modelName, enemyData in pairs(worldEnemies) do
                table.insert(enemies, { Name=enemyData.Name, ModelName=modelName, Type=enemyData.Type })
            end
            table.sort(enemies, function(a,b)
                return (rarityOrder[a.Type] or 99) < (rarityOrder[b.Type] or 99)
            end)
            aas_WorldList[worldIdx] = { name=worldData.Name, enemies=enemies }
        end
    end
end

local aas_sortedWorldIndices = {}
for idx in pairs(aas_WorldList) do table.insert(aas_sortedWorldIndices, idx) end
table.sort(aas_sortedWorldIndices)

-- ══════════════════════════════════════════
--   DYNAMIC RAID DATA
-- ══════════════════════════════════════════
local aas_RaidList       = {}
local aas_sortedRaidKeys = {}
do
    local allRaids = aas_RaidConfig:GetAllRaids()
    for raidKey, raidData in pairs(allRaids) do
        if raidData.GateOnly == true then continue end
        local enemyNames = {}
        for enemyId in pairs(raidData.Enemies or {}) do table.insert(enemyNames, enemyId) end
        aas_RaidList[raidKey] = {
            Name=raidData.Name, WorldId=raidData.WorldId,
            TotalWaves=raidData.TotalWaves, enemies=enemyNames
        }
    end
    for k in pairs(aas_RaidList) do table.insert(aas_sortedRaidKeys, k) end
    table.sort(aas_sortedRaidKeys, function(a,b)
        return (aas_RaidList[a].WorldId or 0) < (aas_RaidList[b].WorldId or 0)
    end)
end

-- ══════════════════════════════════════════
--   DYNAMIC GATE DATA
-- ══════════════════════════════════════════
local aas_GateData  = nil
local aas_GateRanks = {}
do
    local allRaids = aas_RaidConfig:GetAllRaids()
    for raidKey, raidData in pairs(allRaids) do
        if raidData.GateOnly == true then
            aas_GateData = {
                Key=raidKey, Name=raidData.Name,
                WorldId=raidData.WorldId, TotalWaves=raidData.TotalWaves or 50,
                GateRanks=raidData.GateRanks or {}
            }
            for _, rankInfo in ipairs(raidData.GateRanks or {}) do
                if rankInfo.Rank then table.insert(aas_GateRanks, rankInfo.Rank) end
            end
            break
        end
    end
    table.sort(aas_GateRanks)
end

-- ══════════════════════════════════════════
--   DYNAMIC DEFENSE DATA
-- ══════════════════════════════════════════
local aas_DefenseList       = {}
local aas_sortedDefenseKeys = {}
do
    local allDefenses = aas_DefConfig:GetAllDefenses()
    for defKey, defData in pairs(allDefenses) do
        local enemyNames = {}
        for enemyId in pairs(defData.Enemies or {}) do table.insert(enemyNames, enemyId) end
        aas_DefenseList[defKey] = {
            Name=defData.Name, WorldId=defData.WorldId,
            TotalWaves=defData.TotalWaves, enemies=enemyNames
        }
    end
    for k in pairs(aas_DefenseList) do table.insert(aas_sortedDefenseKeys, k) end
    table.sort(aas_sortedDefenseKeys, function(a,b)
        return (aas_DefenseList[a].WorldId or 0) < (aas_DefenseList[b].WorldId or 0)
    end)
end

-- ══════════════════════════════════════════
--   DYNAMIC GACHA DATA
-- ══════════════════════════════════════════
local aas_GachaList       = {}
local aas_sortedGachaKeys = {}
do
    local allGachas = aas_GachaConfig.Gachas or {}
    for gachaKey, gachaData in pairs(allGachas) do
        local worldNum = tonumber(gachaKey:match("World(%d+)")) or 0
        aas_GachaList[gachaKey] = {
            Name=gachaData.Name, WorldId=worldNum,
            ItemCostId=gachaData.ItemCost and gachaData.ItemCost.ItemId or "Unknown",
            ItemCostAmount=gachaData.ItemCost and gachaData.ItemCost.Amount or 10,
        }
    end
    for k in pairs(aas_GachaList) do table.insert(aas_sortedGachaKeys, k) end
    table.sort(aas_sortedGachaKeys, function(a,b)
        return (tonumber(a:match("%d+")) or 0) < (tonumber(b:match("%d+")) or 0)
    end)
end

-- ══════════════════════════════════════════
--   DYNAMIC SWORD DATA
-- ══════════════════════════════════════════
local aas_SwordList       = {}
local aas_sortedSwordKeys = {}
do
    local allSwords = aas_SwordConfig.Swords or {}
    for swordKey, swordData in pairs(allSwords) do
        aas_SwordList[swordKey] = {
            Name=swordData.Name,
            ItemCostId=swordData.ItemCost and swordData.ItemCost.ItemId or "Unknown",
            ItemCostAmount=swordData.ItemCost and swordData.ItemCost.Amount or 10,
        }
    end
    for k in pairs(aas_SwordList) do table.insert(aas_sortedSwordKeys, k) end
    table.sort(aas_sortedSwordKeys, function(a,b)
        return (tonumber(a:match("%d+")) or 0) < (tonumber(b:match("%d+")) or 0)
    end)
end

-- ══════════════════════════════════════════
--   DYNAMIC PROGRESSION DATA
-- ══════════════════════════════════════════
local aas_ProgressionList       = {}
local aas_sortedProgressionKeys = {}
do
    local allProgressions = aas_ProgressionConfig and aas_ProgressionConfig.Progressions or {}
    for progKey, progData in pairs(allProgressions) do
        local worldNum = tonumber(progKey:match("%d+")) or 0
        aas_ProgressionList[progKey] = {
            Name=progData.Name or progKey, MaxLevel=progData.MaxLevel or 45,
            ItemCostId=progData.ItemCost and progData.ItemCost.ItemId or "Unknown",
            WorldId=progData.WorldId or worldNum,
        }
    end
    for k in pairs(aas_ProgressionList) do table.insert(aas_sortedProgressionKeys, k) end
    table.sort(aas_sortedProgressionKeys, function(a,b)
        return (tonumber(a:match("%d+")) or 0) < (tonumber(b:match("%d+")) or 0)
    end)
end

-- ══════════════════════════════════════════
--   DYNAMIC UPGRADES DATA
-- ══════════════════════════════════════════
local aas_UpgradeSystemList       = {}
local aas_sortedUpgradeSystemKeys = {}
do
    local allSystems = aas_UpgradesConfig and aas_UpgradesConfig:GetAllSystems() or {}
    for sysKey, sysData in pairs(allSystems) do
        aas_UpgradeSystemList[sysKey] = {
            Name=sysData.Name or sysKey, WorldId=sysData.WorldId or 0,
            CostItemId=sysData.CostItemId or "TrialShard",
        }
    end
    for k in pairs(aas_UpgradeSystemList) do table.insert(aas_sortedUpgradeSystemKeys, k) end
    table.sort(aas_sortedUpgradeSystemKeys, function(a,b)
        return (aas_UpgradeSystemList[a].WorldId or 0) < (aas_UpgradeSystemList[b].WorldId or 0)
    end)
end

local aas_UpgradeStatKeys = { "Damage", "Drop", "Xp", "Luck", "Power", "Yen" }

-- ══════════════════════════════════════════
--   DYNAMIC STAR / EGG DATA
-- ══════════════════════════════════════════
local aas_StarWorldList       = {}
local aas_sortedStarWorldKeys = {}
do
    local allWorlds = aas_WorldConfig:GetAllWorlds()
    for worldIdx, worldData in pairs(allWorlds) do
        if worldIdx > 0 then
            local key = "World" .. worldIdx
            aas_StarWorldList[key] = { Name=worldData.Name or key, WorldId=worldIdx }
        end
    end
    for k in pairs(aas_StarWorldList) do table.insert(aas_sortedStarWorldKeys, k) end
    table.sort(aas_sortedStarWorldKeys, function(a,b)
        return (tonumber(a:match("%d+")) or 0) < (tonumber(b:match("%d+")) or 0)
    end)
end

-- ══════════════════════════════════════════
--   DYNAMIC CRAFT DATA
-- ══════════════════════════════════════════
local aas_CraftList       = {}
local aas_sortedCraftKeys = {}
do
    local allRecipes = aas_CraftConfig and aas_CraftConfig.Recipes or {}
    for craftKey, recipeData in pairs(allRecipes) do
        aas_CraftList[craftKey] = {
            Name=craftKey, PetId=recipeData.PetId, PetAmount=recipeData.PetAmount or 3,
            ItemId=recipeData.ItemId, ItemAmount=recipeData.ItemAmount or 25,
            ShinyCraftedPrice=recipeData.ShinyCraftedPrice or 75,
            ResultPetId=recipeData.ResultPetId,
            WorldId=tonumber(craftKey:match("%d+")) or 0,
        }
    end
    for k in pairs(aas_CraftList) do table.insert(aas_sortedCraftKeys, k) end
    table.sort(aas_sortedCraftKeys, function(a,b)
        return (tonumber(a:match("%d+")) or 0) < (tonumber(b:match("%d+")) or 0)
    end)
end

-- ══════════════════════════════════════════
--   DYNAMIC TRIAL DATA
-- ══════════════════════════════════════════
local aas_TrialList       = {}
local aas_sortedTrialKeys = {}
do
    local allTrials = aas_TrialConfig and aas_TrialConfig:GetAllTrials() or {}
    for trialKey, trialData in pairs(allTrials) do
        aas_TrialList[trialKey] = {
            Name=trialData.Name or trialKey, TotalRooms=trialData.TotalRooms or 50,
            WorldId=trialData.WorldId or 1,
        }
    end
    for k in pairs(aas_TrialList) do table.insert(aas_sortedTrialKeys, k) end
    table.sort(aas_sortedTrialKeys)
end

-- ══════════════════════════════════════════
--   RARITY ORDERS
-- ══════════════════════════════════════════
local aas_TitanRarityOrder = aas_TitansConfig and aas_TitansConfig.Rarity_Order or {
    "Common","Uncommon","Rare","Epic","Legendary","Mythical","Secret"
}
local aas_SwordPassiveRarityOrder = aas_SwordPassiveConfig and aas_SwordPassiveConfig.Rarity_Order or {
    "Common","Uncommon","Rare","Epic","Legendary","Mythical","Secret","Divine"
}
local aas_GrimoireRarityOrder = aas_GrimoireConfig and aas_GrimoireConfig.Rarity_Order or {
    "Common","Uncommon","Rare","Epic","Legendary","Mythical","Secret","Divine"
}

-- ══════════════════════════════════════════
--   AUTOMATION FUNCTIONS
-- ══════════════════════════════════════════

local function aas_autoClick()
    task.spawn(function()
        while aas_autoClickRunning do
            pcall(function() aas_clickRemote:Fire() end)
            task.wait(0.05)
        end
    end)
end

local function aas_toggleAutoClaimAchievements(enabled)
    return pcall(function() aas_autoClaimAchievementsRemote:Fire(enabled) end)
end

local function aas_toggleAutoAvatar(enabled)
    return pcall(function() aas_autoAvatarRemote:Fire(enabled) end)
end

local function aas_toggleAutoRank(enabled)
    return pcall(function() aas_autoRankRemote:Fire("SetAutoRankUp", enabled) end)
end

local function aas_toggleAutoStat(statName, enabled)
    return pcall(function() aas_autoStatRemote:Fire(statName, enabled) end)
end

local function aas_toggleAutoClaimRewards(enabled)
    return pcall(function() aas_autoClaimRewardsRemote:Fire(enabled) end)
end

local function aas_redeemAllCodes()
    local aas_codes = {
        "RELEASE","1KPLAYERS","2.5KPLAYERS","3.5KPLAYERS","4KPLAYERS",
        "SORRYFORSHUTDOWN","100KVISITS","200KVISITS","1KLIKES","5KPLAYERS",
        "6KPLAYERS","6.5KPLAYERS","500KVISITS","20KMEMBERS","EXCHANGE",
        "SORRYFORSHUTDOWN2","7KPLAYERS","10KPLAYERS","13KPLAYERS","15KPLAYERS",
        "NPCNERF","2.5KLIKES","5KLIKES","1MVISITS","1.5MVISITS",
        "SORRYFORDELAY","UPDATE1","3MVISITS","3.5MVISITS","8KLIKES",
        "4KFAVS","UPDATE1.5","3KEVENT","18KPLAYERS","19KPLAYERS",
        "20KPLAYERS","24KPLAYERS","25KPLAYERS","6.5MVISITS","7MVISITS",
        "UPDATE2","BATTLEPASS","SORRYFORDELAY2","SORRYFORSHUTDOWN5","27.5KPLAYERS",
        "28KPLAYERS","GO30K?","7.5MVISITS","8MVISITS","30KPLAYERS",
        "SORRYFORSHUTDOWN6","UPDATE2.5","9.5MVISITS","10MVISITS","MOUNTS",
        "TRACKER","SORRYFORDELAY3","15MVISTS","GRIMOIRES","UPDATE3",
        "WAIFU","15KLIKES","20KLIKES","SORRYFORSHUTDOWN7","SORRYFORGRIMOIRES",
        "WEARESOSORRY!","TRIALMEDIUM","UPDATE3.5","60KINTERESTED","17.5MVISITS",
        "18MVISITS","SORRYFORSHUTDOWN8","21.5MVISITS","22MVISITS","UPDATE4",
        "SUMMEREVENT","SUMMERMOUNT","18KFAVORITES","25KLIKES","UPDATE4.5","20KFAVORITES",
        "27MVISITS","DIVINEPASSIVES","SORRYFORSHUTDOWN9",
    }

    UILibrary:Notify({ Title="Redeeming Codes", Description="Starting to redeem "..#aas_codes.." codes...", Time=3 })
    task.spawn(function()
        local successCount = 0
        for _, code in ipairs(aas_codes) do
            local ok = pcall(function() aas_redeemCodeRemote:Fire(code) end)
            if ok then successCount = successCount + 1 end
            task.wait(1)
        end
        UILibrary:Notify({ Title="Codes Redeemed", Description="Submitted "..successCount.."/"..#aas_codes.." codes!", Time=4 })
    end)
end

-- ══════════════════════════════════════════
--   LOADOUT HELPER
-- ══════════════════════════════════════════
local function aas_equipBestTitleForStat(stat)
    if not stat or stat == "" then return end

    local statMapping = {
        Power  = "Power",
        Damage = "Damage",
        Yen    = "Yen",
        Luck   = "Luck",
        XP     = "Xp",
        Xp     = "Xp",
        Drop   = "Drop",
    }

    local buffKey = statMapping[stat]
    if not buffKey then return end

    local ok, data = pcall(function() return aas_getPlayerDataFunc:InvokeServer() end)
    if not ok or type(data) ~= "table" then return end

    local ownedTitles = data.Titles
    if type(ownedTitles) ~= "table" or not next(ownedTitles) then return end

    local allTitles = aas_TitleConfig:GetAllTitles()

    -- Find best title for this specific stat (highest buff value)
    local bestTitle = nil
    local bestValue = 0

    for _, titleData in ipairs(allTitles) do
        local id = titleData.Id
        if ownedTitles[id] then
            local buffs = titleData.Buffs
            if type(buffs) == "table" and buffs[buffKey] then
                local value = tonumber(buffs[buffKey]) or 0
                if value > bestValue then
                    bestValue = value
                    bestTitle = id
                end
            end
        end
    end

    -- Fallback: if no title buffs this stat, equip highest Order title owned
    if not bestTitle then
        local bestOrder = -1
        for _, titleData in ipairs(allTitles) do
            local id = titleData.Id
            if ownedTitles[id] then
                local order = titleData.Order or 0
                if order > bestOrder then
                    bestOrder = order
                    bestTitle = id
                end
            end
        end
    end

    if bestTitle then
        pcall(function()
            aas_titlesActionRemote:Fire("Equip", bestTitle)
        end)
        task.wait(0.3)
        pcall(function()
            aas_titlesActionRemote:Fire("EquipDisplay", bestTitle)
        end)
    end
end

local function aas_equipLoadout(stat)
    if not stat or stat == "" then return end
    pcall(function() aas_equipBestLoadoutRemote:Fire(stat) end)
    pcall(function() aas_equipBestTitleForStat(stat) end)
    task.wait(0.5)
end

-- ══════════════════════════════════════════
--   SHARED TELEPORT & WAIT HELPERS
-- ══════════════════════════════════════════
local function aas_teleportToMob(mob)
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local mobRoot = mob:FindFirstChild("HumanoidRootPart")
        or mob:FindFirstChild("PrimaryPart")
        or mob:FindFirstChildOfClass("BasePart")
    if not mobRoot then return end
    hrp.CFrame = mobRoot.CFrame * CFrame.new(0, 0, 4)
end

local function aas_waitForDead(mob, timeoutSecs)
    timeoutSecs = timeoutSecs or 30
    local deadline = tick() + timeoutSecs
    while tick() < deadline do
        if not mob or not mob.Parent then return true end
        if mob:GetAttribute("EnemyDead") == true then return true end
        task.wait(0.1)
    end
    return false
end

local function aas_findMobsInFolder(enemiesFolder, selectedNames)
    if not enemiesFolder then return {} end
    local found = {}
    if selectedNames and #selectedNames > 0 then
        local nameSet = {}
        for _, n in ipairs(selectedNames) do nameSet[n] = true end
        for _, child in ipairs(enemiesFolder:GetChildren()) do
            if nameSet[child.Name] and child:GetAttribute("EnemyDead") ~= true then
                table.insert(found, child)
            end
        end
    else
        for _, child in ipairs(enemiesFolder:GetChildren()) do
            if child:GetAttribute("EnemyDead") ~= true then
                table.insert(found, child)
            end
        end
    end
    return found
end

local function aas_teleportToWorld(worldIdx)
    pcall(function() aas_requestChangeWorldRemote:Fire(worldIdx) end)
    task.wait(2.5)
end

-- ══════════════════════════════════════════
--   FARM HELPERS
-- ══════════════════════════════════════════
local function aas_getSelectedForWorld(worldIdx)
    local key = aas_worldDropdowns[worldIdx]
    if not key then return {} end
    local opt = Options[key]
    if not opt then return {} end
    local selected = {}
    for name, state in pairs(opt.Value or {}) do
        if state and name ~= "None" then table.insert(selected, name) end
    end
    return selected
end

local function aas_getWorldsWithSelections()
    local worlds = {}
    for _, worldIdx in ipairs(aas_sortedWorldIndices) do
        if #aas_getSelectedForWorld(worldIdx) > 0 then
            table.insert(worlds, worldIdx)
        end
    end
    return worlds
end

local function aas_findMobsInWorld(worldIdx, selectedNames)
    local worldFolder = workspace:FindFirstChild("Worlds")
    if not worldFolder then return {} end
    local wChild = worldFolder:FindFirstChild(tostring(worldIdx))
    if not wChild then return {} end
    return aas_findMobsInFolder(wChild:FindFirstChild("Enemies"), selectedNames)
end

-- ══════════════════════════════════════════
--   SNAPSHOT / RESUME
-- ══════════════════════════════════════════
local function aas_snapshotAndPauseActivities()
    local snapshot = { farmWasActive=false, raidKey=nil, defenseKey=nil }

    if aas_farmEnabled then
        snapshot.farmWasActive = true
        aas_farmEnabled = false
        if aas_farmThread then task.cancel(aas_farmThread) aas_farmThread = nil end
        aas_currentWorldTracked = nil
    end

    if aas_activeRaidKey then
        snapshot.raidKey = aas_activeRaidKey
        local rk = snapshot.raidKey
        aas_raidEnabled[rk] = false
        if aas_raidThread then task.cancel(aas_raidThread) aas_raidThread = nil end
        pcall(function() aas_raidLeaveRemote:Fire() end)
        task.wait(5)
        aas_activeRaidKey = nil
    end

    if aas_activeDefenseKey then
        snapshot.defenseKey = aas_activeDefenseKey
        local dk = snapshot.defenseKey
        aas_defenseEnabled[dk] = false
        if aas_defenseThread then task.cancel(aas_defenseThread) aas_defenseThread = nil end
        pcall(function() aas_defenseLeaveRemote:Fire() end)
        task.wait(5)
        aas_activeDefenseKey = nil
    end

    return snapshot
end

local function aas_resumeFromSnapshot(snapshot)
    if not snapshot then return end
    task.wait(5)

    if snapshot.farmWasActive then
        aas_equipLoadout(aas_LoadoutAssignments.Farm)
        aas_farmEnabled = true
        if aas_farmThread then task.cancel(aas_farmThread) end
        aas_farmThread = task.spawn(function() aas_farmLoop() end)
    end

    if snapshot.raidKey then
        local rk = snapshot.raidKey
        if Toggles["AutoRaid_"..rk] and Toggles["AutoRaid_"..rk].Value then
            aas_equipLoadout(aas_RaidLoadouts[rk] or "Power")
            aas_raidEnabled[rk] = true
            aas_activeRaidKey = rk
            if aas_raidThread then task.cancel(aas_raidThread) end
            aas_raidThread = task.spawn(function() aas_raidLoop(rk) end)
        end
    end

    if snapshot.defenseKey then
        local dk = snapshot.defenseKey
        if Toggles["AutoDefense_"..dk] and Toggles["AutoDefense_"..dk].Value then
            aas_equipLoadout(aas_DefenseLoadouts[dk] or "Power")
            aas_defenseEnabled[dk] = true
            aas_activeDefenseKey = dk
            if aas_defenseThread then task.cancel(aas_defenseThread) end
            aas_defenseThread = task.spawn(function() aas_defenseLoop(dk) end)
        end
    end
end

-- ══════════════════════════════════════════
--   CROW SYSTEM
-- ══════════════════════════════════════════
local aas_crowPaused     = false
local aas_crowSnapshotSaved = nil

local function aas_getCorvo()
    local folder = workspace:FindFirstChild("World6Corvos")
    if not folder then return nil end
    for _, child in ipairs(folder:GetChildren()) do
        if child.Name:match("^Corvo_") then
            return child
        end
    end
    return nil
end

local function aas_claimCrow(corvo)
    -- Find the part to teleport to
    local target = nil
    if corvo:IsA("BasePart") then
        target = corvo
    elseif corvo:IsA("Model") then
        target = corvo.PrimaryPart or corvo:FindFirstChildOfClass("BasePart")
    end
    if not target then
        -- Recursive search
        for _, v in ipairs(corvo:GetDescendants()) do
            if v:IsA("BasePart") then
                target = v
                break
            end
        end
    end
    if not target then
        warn("[Crow] Could not find a BasePart inside: " .. corvo.Name)
        return
    end

    -- Teleport character directly on top of the corvo
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    hrp.CFrame = target.CFrame * CFrame.new(0, 3, 0)
    hrp.AssemblyLinearVelocity = Vector3.zero
    task.wait(0.5)

    -- Hold E for 3 seconds
    game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.E, false, game)
    task.wait(3)
    game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.E, false, game)
end

local function aas_crowMonitorLoop()
    while aas_autoCrowEnabled do
        if aas_crowClaiming then
            task.wait(1)
            continue
        end

        local corvo = aas_getCorvo()
        if corvo then
            aas_crowClaiming = true

            UILibrary:Notify({
                Title       = "🌟 CROW DETECTED!",
                Description = "Pausing all activities to claim: " .. corvo.Name,
                Time        = 6,
            })

            -- Pause farm / raid / defense
            local snapshot = aas_snapshotAndPauseActivities()

            -- Stop active trial threads
            for tk, t in pairs(aas_trialThreads) do
                task.cancel(t)
                aas_trialThreads[tk] = nil
            end

            -- Stop gate thread
            if aas_gateThread then
                task.cancel(aas_gateThread)
                aas_gateThread = nil
            end

            -- Leave any active raid/trial/defense
            pcall(function() aas_raidLeaveRemote:Fire() end)
            pcall(function() aas_trialLeaveRemote:Fire() end)
            pcall(function() aas_defenseLeaveRemote:Fire() end)
            task.wait(3)

            -- Step 1: Fire world change remote to World 6
            pcall(function() aas_requestChangeWorldRemote:Fire(6) end)
            task.wait(3)

            -- Step 2: Wait for corvo to appear (up to 15s)
            local waited = 0
            local foundCorvo = aas_getCorvo()
            while not foundCorvo and waited < 15 do
                task.wait(1)
                waited = waited + 1
                foundCorvo = aas_getCorvo()
            end

            if foundCorvo then
                -- Step 3: Teleport to corvo and hold E
                aas_claimCrow(foundCorvo)
                task.wait(2)
                UILibrary:Notify({
                    Title       = "✅ Crow Claimed!",
                    Description = "Resuming previous activities...",
                    Time        = 4,
                })
            else
                UILibrary:Notify({
                    Title       = "❌ Crow Lost",
                    Description = "Corvo disappeared before we could claim it.",
                    Time        = 4,
                })
            end

            -- Resume trial threads
            for _, tk in ipairs(aas_sortedTrialKeys) do
                if aas_trialEnabled[tk] then
                    aas_trialThreads[tk] = task.spawn(function()
                        aas_trialLoop(tk)
                    end)
                end
            end

            -- Resume gate thread
            if aas_gateEnabled then
                aas_gateThread = task.spawn(aas_gateLoop)
            end

            -- Resume farm / raid / defense
            aas_resumeFromSnapshot(snapshot)

            -- Wait until corvo folder is empty before monitoring again
            local clearDeadline = tick() + 30
            while tick() < clearDeadline do
                local c = aas_getCorvo()
                if not c then break end
                task.wait(1)
            end

            task.wait(5)
            aas_crowClaiming = false
        end

        task.wait(1)
    end
    aas_crowClaiming = false
end

-- ══════════════════════════════════════════
--   ACTIVE CHECK HELPERS
-- ══════════════════════════════════════════
local function aas_anyRaidActive()    return aas_activeRaidKey ~= nil end
local function aas_anyDefenseActive() return aas_activeDefenseKey ~= nil end
local function aas_anyTrialActive()
    for _, k in ipairs(aas_sortedTrialKeys) do
        if aas_trialEnabled[k] then return true end
    end
    return false
end

-- ══════════════════════════════════════════
--   FARM LOOP
-- ══════════════════════════════════════════
function aas_farmLoop()
    aas_currentWorldTracked = nil
    while aas_farmEnabled do
        local worlds = aas_getWorldsWithSelections()
        if #worlds == 0 then task.wait(0.5) continue end
        for _, worldIdx in ipairs(worlds) do
            if not aas_farmEnabled then break end
            if aas_currentWorldTracked ~= worldIdx then
                aas_teleportToWorld(worldIdx)
                aas_currentWorldTracked = worldIdx
            end
            local selectedNames = aas_getSelectedForWorld(worldIdx)
            if #selectedNames == 0 then continue end
            local mobs = aas_findMobsInWorld(worldIdx, selectedNames)
            if #mobs == 0 then task.wait(1) continue end
            for _, mob in ipairs(mobs) do
                if not aas_farmEnabled then break end
                local currentSelected = aas_getSelectedForWorld(worldIdx)
                local stillWanted = false
                for _, n in ipairs(currentSelected) do
                    if n == mob.Name then stillWanted = true break end
                end
                if not stillWanted then continue end
                if not mob.Parent or mob:GetAttribute("EnemyDead") == true then continue end
                aas_teleportToMob(mob)
                aas_waitForDead(mob, 25)
                task.wait(0.15)
            end
        end
        task.wait(0.2)
    end
    aas_currentWorldTracked = nil
end

-- ══════════════════════════════════════════
--   RAID HELPERS
-- ══════════════════════════════════════════
local function aas_getCurrentRaidWave()
    local ok, result = pcall(function()
        return LocalPlayer.PlayerGui.RaidGui.Main.Wave.Text
    end)
    if not ok or type(result) ~= "string" then return 0 end
    return tonumber(result:match("Wave%s+(%d+)/")) or 0
end

local function aas_getRaidLeaveAtWave(raidKey)
    local opt = Options["RaidLeaveWave_"..raidKey]
    if not opt then return 0 end
    local v = tostring(opt.Value or "")
    if v:match("Never") then return 0 end
    return tonumber(v:match("%d+")) or 0
end

local function aas_raidArenaExists(raidKey)
    local arenas = workspace:FindFirstChild("RaidArenas")
    return arenas and arenas:FindFirstChild(raidKey) ~= nil
end

local function aas_getRaidEnemiesFolder(raidKey)
    local arenas = workspace:FindFirstChild("RaidArenas")
    if not arenas then return nil end
    local arena = arenas:FindFirstChild(raidKey)
    if not arena then return nil end
    return arena:FindFirstChild("Enemies")
end

local function aas_joinOrCreateRaid(raidKey)
    if aas_raidArenaExists(raidKey) then
        pcall(function() aas_raidJoinRemote:Fire("Join", raidKey) end)
    else
        pcall(function() aas_raidJoinRemote:Fire("Create", raidKey) end)
    end
end

local function aas_leaveRaid()
    pcall(function() aas_raidLeaveRemote:Fire() end)
end

local function aas_waitForRaidArena(raidKey, timeoutSecs)
    timeoutSecs = timeoutSecs or 10
    local deadline = tick() + timeoutSecs
    while tick() < deadline do
        if aas_raidArenaExists(raidKey) then return true end
        task.wait(0.5)
    end
    return false
end

local function aas_disableOtherRaids(exceptKey)
    for _, rk in ipairs(aas_sortedRaidKeys) do
        if rk ~= exceptKey and aas_raidEnabled[rk] then
            aas_raidEnabled[rk] = false
            local tk = "AutoRaid_"..rk
            if Toggles[tk] then Toggles[tk]:SetValue(false) end
        end
    end
end

local function aas_disableAllDefenses()
    for _, dk in ipairs(aas_sortedDefenseKeys) do
        if aas_defenseEnabled[dk] then
            aas_defenseEnabled[dk] = false
            local tk = "AutoDefense_"..dk
            if Toggles[tk] then Toggles[tk]:SetValue(false) end
        end
    end
    if aas_defenseThread then task.cancel(aas_defenseThread) aas_defenseThread = nil end
    aas_activeDefenseKey = nil
end

local function aas_disableAllGachas()
    for _, gk in ipairs(aas_sortedGachaKeys) do
        if aas_gachaEnabled[gk] then
            aas_gachaEnabled[gk] = false
            local tk = "AutoGacha_"..gk
            if Toggles[tk] then Toggles[tk]:SetValue(false) end
        end
        if aas_gachaThreads[gk] then
            task.cancel(aas_gachaThreads[gk])
            aas_gachaThreads[gk] = nil
        end
    end
end

-- ══════════════════════════════════════════
--   RAID LOOP
-- ══════════════════════════════════════════
function aas_raidLoop(raidKey)
    local raidData = aas_RaidList[raidKey]
    if not raidData then return end
    aas_equipLoadout(aas_RaidLoadouts[raidKey] or "Power")
    aas_joinOrCreateRaid(raidKey)
    aas_waitForRaidArena(raidKey, 10)
    task.wait(5)
    while aas_raidEnabled[raidKey] do
        local leaveAt = aas_getRaidLeaveAtWave(raidKey)
        if leaveAt > 0 then
            local currentWave = aas_getCurrentRaidWave()
            if currentWave > 0 and currentWave >= leaveAt then
                aas_leaveRaid()
                task.wait(6)
                if not aas_raidEnabled[raidKey] then break end
                aas_joinOrCreateRaid(raidKey)
                aas_waitForRaidArena(raidKey, 10)
                task.wait(5)
                continue
            end
        end
        if not aas_raidArenaExists(raidKey) then
            task.wait(6)
            if not aas_raidEnabled[raidKey] then break end
            aas_joinOrCreateRaid(raidKey)
            aas_waitForRaidArena(raidKey, 10)
            task.wait(5)
            continue
        end
        local mobs = aas_findMobsInFolder(aas_getRaidEnemiesFolder(raidKey), nil)
        if #mobs == 0 then task.wait(0.5) continue end
        for _, mob in ipairs(mobs) do
            if not aas_raidEnabled[raidKey] then break end
            local leaveAtNow = aas_getRaidLeaveAtWave(raidKey)
            if leaveAtNow > 0 then
                local waveNow = aas_getCurrentRaidWave()
                if waveNow > 0 and waveNow >= leaveAtNow then break end
            end
            if not aas_raidArenaExists(raidKey) then break end
            if not mob.Parent or mob:GetAttribute("EnemyDead") == true then continue end
            aas_teleportToMob(mob)
            aas_waitForDead(mob, 30)
            task.wait(0.15)
        end
        task.wait(0.2)
    end
    if aas_raidArenaExists(raidKey) then aas_leaveRaid() end
    aas_activeRaidKey = nil
end

-- ══════════════════════════════════════════
--   DEFENSE HELPERS
-- ══════════════════════════════════════════
local function aas_getCurrentDefenseWave()
    local ok, result = pcall(function()
        return LocalPlayer.PlayerGui.DefenseGui.Main.Wave.Text
    end)
    if not ok or type(result) ~= "string" then return 0 end
    return tonumber(result:match("Wave%s+(%d+)/")) or 0
end

local function aas_getDefenseLeaveAtWave(defKey)
    local opt = Options["DefLeaveWave_"..defKey]
    if not opt then return 0 end
    local v = tostring(opt.Value or "")
    if v:match("Never") then return 0 end
    return tonumber(v:match("%d+")) or 0
end

local function aas_defenseArenaExists(defKey)
    local arenas = workspace:FindFirstChild("DefenseArenas")
    return arenas and arenas:FindFirstChild(defKey) ~= nil
end

local function aas_getDefenseEnemiesFolder(defKey)
    local arenas = workspace:FindFirstChild("DefenseArenas")
    if not arenas then return nil end
    local arena = arenas:FindFirstChild(defKey)
    if not arena then return nil end
    return arena:FindFirstChild("Enemies")
end

local function aas_joinOrCreateDefense(defKey)
    if aas_defenseArenaExists(defKey) then
        pcall(function() aas_defenseJoinRemote:Fire("Join", defKey) end)
    else
        pcall(function() aas_defenseJoinRemote:Fire("Create", defKey) end)
    end
end

local function aas_leaveDefense()
    pcall(function() aas_defenseLeaveRemote:Fire() end)
end

local function aas_waitForDefenseArena(defKey, timeoutSecs)
    timeoutSecs = timeoutSecs or 10
    local deadline = tick() + timeoutSecs
    while tick() < deadline do
        if aas_defenseArenaExists(defKey) then return true end
        task.wait(0.5)
    end
    return false
end

-- ══════════════════════════════════════════
--   DEFENSE LOOP
-- ══════════════════════════════════════════
function aas_defenseLoop(defKey)
    local defData = aas_DefenseList[defKey]
    if not defData then return end
    aas_equipLoadout(aas_DefenseLoadouts[defKey] or "Power")
    aas_joinOrCreateDefense(defKey)
    aas_waitForDefenseArena(defKey, 10)
    task.wait(5)
    while aas_defenseEnabled[defKey] do
        local leaveAt = aas_getDefenseLeaveAtWave(defKey)
        if leaveAt > 0 then
            local currentWave = aas_getCurrentDefenseWave()
            if currentWave > 0 and currentWave >= leaveAt then
                aas_leaveDefense()
                task.wait(6)
                if not aas_defenseEnabled[defKey] then break end
                aas_joinOrCreateDefense(defKey)
                aas_waitForDefenseArena(defKey, 10)
                task.wait(5)
                continue
            end
        end
        if not aas_defenseArenaExists(defKey) then
            task.wait(6)
            if not aas_defenseEnabled[defKey] then break end
            aas_joinOrCreateDefense(defKey)
            aas_waitForDefenseArena(defKey, 10)
            task.wait(5)
            continue
        end
        local mobs = aas_findMobsInFolder(aas_getDefenseEnemiesFolder(defKey), nil)
        if #mobs == 0 then task.wait(0.5) continue end
        for _, mob in ipairs(mobs) do
            if not aas_defenseEnabled[defKey] then break end
            local leaveAtNow = aas_getDefenseLeaveAtWave(defKey)
            if leaveAtNow > 0 then
                local waveNow = aas_getCurrentDefenseWave()
                if waveNow > 0 and waveNow >= leaveAtNow then break end
            end
            if not aas_defenseArenaExists(defKey) then break end
            if not mob.Parent or mob:GetAttribute("EnemyDead") == true then continue end
            aas_teleportToMob(mob)
            aas_waitForDead(mob, 30)
            task.wait(0.15)
        end
        task.wait(0.2)
    end
    if aas_defenseArenaExists(defKey) then aas_leaveDefense() end
    aas_activeDefenseKey = nil
end

-- ══════════════════════════════════════════
--   TRIAL HELPERS
-- ══════════════════════════════════════════
local function aas_trialArenaExists(trialKey)
    local arenas = workspace:FindFirstChild("TimeTrialArenas")
    return arenas and arenas:FindFirstChild(trialKey) ~= nil
end

local function aas_getTrialEnemiesFolder(trialKey)
    local arenas = workspace:FindFirstChild("TimeTrialArenas")
    if not arenas then return nil end
    local arena = arenas:FindFirstChild(trialKey)
    if not arena then return nil end
    return arena:FindFirstChild("Enemies")
end

local function aas_getCurrentTrialRoom(trialKey)
    local ok, result = pcall(function()
        return LocalPlayer.PlayerGui.TrialGui.Main.Room.Text
    end)
    if not ok or type(result) ~= "string" then return 0 end
    return tonumber(result:match("Room%s+(%d+)/")) or 0
end

local function aas_getTrialLeaveAtRoom(trialKey)
    local opt = Options["TrialLeaveRoom_"..trialKey]
    if not opt then return 0 end
    local v = tostring(opt.Value or "")
    if v == "0 (Never Leave)" then return 0 end
    return tonumber(v:match("^(%d+)")) or 0
end

local function aas_joinTrial(trialKey)
    pcall(function() aas_trialJoinRemote:Fire("Join", trialKey) end)
end

local function aas_leaveTrial()
    pcall(function() aas_trialLeaveRemote:Fire() end)
end

-- ══════════════════════════════════════════
--   GATE HELPERS
-- ══════════════════════════════════════════
local function aas_gateArenaExists()
    local arenas = workspace:FindFirstChild("RaidArenas")
    return arenas and arenas:FindFirstChild("World5") ~= nil
end

local function aas_getGateEnemiesFolder()
    local arenas = workspace:FindFirstChild("RaidArenas")
    if not arenas then return nil end
    local arena = arenas:FindFirstChild("World5")
    if not arena then return nil end
    return arena:FindFirstChild("Enemies")
end

local function aas_isActiveGatePresent()
    local ok, result = pcall(function()
        return workspace.Worlds["5"].Systems.RaidStation:FindFirstChild("ActiveGate") ~= nil
    end)
    return ok and result
end

local function aas_isWorld5SystemsLoaded()
    local ok, result = pcall(function()
        local systems = workspace.Worlds["5"].Systems
        return systems ~= nil and #systems:GetChildren() > 0
    end)
    return ok and result
end

local function aas_getActiveGateRank()
    local ok2, rankText = pcall(function()
        return workspace.Worlds["5"].Systems.RaidStation.Gui.Main.Rank.Text
    end)
    if not ok2 or type(rankText) ~= "string" then return nil end
    return rankText:match("GATE RANK:%s*(%S+)")
end

local function aas_getGateLeaveAtWave(rank)
    local opt = Options["GateLeaveWave_"..rank]
    if not opt then return 0 end
    local v = tostring(opt.Value or "")
    if v:match("Never") then return 0 end
    return tonumber(v:match("%d+")) or 0
end

local function aas_isGateRankWanted(rank)
    local opt = Options["GateRankSelect"]
    if not opt then return false end
    for r, state in pairs(opt.Value or {}) do
        if state and r == rank then return true end
    end
    return false
end

local function aas_teleportToRaidStation()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    -- Step 1: Make sure we are in World 5
    pcall(function() aas_requestChangeWorldRemote:Fire(5) end)
    task.wait(3)

    -- Step 2: Find RaidStation and physically move character to it
    local ok, stationPart = pcall(function()
        local station = workspace.Worlds["5"].Systems.RaidStation
        -- Try PrimaryPart first, then any BasePart
        if station.PrimaryPart then return station.PrimaryPart end
        for _, v in ipairs(station:GetDescendants()) do
            if v:IsA("BasePart") then return v end
        end
        return nil
    end)

    if ok and stationPart then
        hrp.CFrame = stationPart.CFrame * CFrame.new(0, 0, 3)
        task.wait(0.5)
        -- Teleport again in case of server correction
        hrp.CFrame = stationPart.CFrame * CFrame.new(0, 0, 3)
    end
end

-- ══════════════════════════════════════════
--   PRIORITY SYSTEM
-- ══════════════════════════════════════════
local function aas_applyPriority_GateVsTrial(trialKey)
    if aas_priorityChoice == "Trial" then
        if aas_gateEnabled and not aas_gateSuppressedByPriority then
            aas_gateSuppressedByPriority = true
            UILibrary:Notify({ Title="Priority: Trial", Description="Gate suppressed — trial is active.", Time=4 })
        end
    elseif aas_priorityChoice == "Gate" then
        if trialKey and aas_trialEnabled[trialKey] and not aas_trialSuppressedByPriority then
            aas_trialSuppressedByPriority = true
            UILibrary:Notify({ Title="Priority: Gate", Description="Trial suppressed — gate is active.", Time=4 })
        end
    end
end

-- ══════════════════════════════════════════
--   GATE LOOP (Fixed: properly teleports to RaidStation)
-- ══════════════════════════════════════════
local aas_gateCooldown = false

function aas_gateLoop()
    while aas_gateEnabled do
        -- Cooldown after a gate session (1 minute)
        if aas_gateCooldown then
            task.wait(1)
            continue
        end

        -- Make sure World 5 systems are accessible
        if not aas_isWorld5SystemsLoaded() then
            task.wait(1)
            continue
        end

        -- Priority suppression check
        if aas_gateSuppressedByPriority then
            local anyTrialInSession = false
            for _, tk in ipairs(aas_sortedTrialKeys) do
                if aas_trialEnabled[tk] and aas_trialArenaExists(tk) then
                    anyTrialInSession = true
                    break
                end
            end
            if anyTrialInSession then
                task.wait(1)
                continue
            else
                aas_gateSuppressedByPriority = false
            end
        end

        -- Check if active gate exists
        if not aas_isActiveGatePresent() then
            task.wait(0.5)
            continue
        end

        -- Get gate rank
        local rank = aas_getActiveGateRank()
        if not rank or not aas_isGateRankWanted(rank) then
            task.wait(1)
            continue
        end

        -- Wait 5s to check if a trial also spawns
        local monitorStart = tick()
        local trialAlsoDetected = nil
        while tick() - monitorStart < 5 do
            for _, tk in ipairs(aas_sortedTrialKeys) do
                if aas_trialEnabled[tk] and aas_trialArenaExists(tk) then
                    trialAlsoDetected = tk
                    break
                end
            end
            if trialAlsoDetected then break end
            task.wait(0.5)
        end

        if trialAlsoDetected then
            aas_applyPriority_GateVsTrial(trialAlsoDetected)
            if aas_gateSuppressedByPriority then
                task.wait(1)
                continue
            end
        end

        -- ══════════════════════════════════════════
        -- GATE SESSION STARTS
        -- ══════════════════════════════════════════

        local snapshot = aas_snapshotAndPauseActivities()

        -- Equip per-rank loadout
        local gateLoadoutOptKey = "LoadoutGateRank_" .. rank
        local gateLoadout = "Power"
        if Options[gateLoadoutOptKey] then
            gateLoadout = Options[gateLoadoutOptKey].Value or "Power"
        end
        aas_equipLoadout(gateLoadout)

        -- Step 1: Fire RequestChangeWorld to World 5
        pcall(function() aas_requestChangeWorldRemote:Fire(5) end)
        task.wait(3)

        -- Step 2: Physically teleport to RaidStation
        -- (exactly like the working standalone script)
        local function teleportToStation()
            local char = LocalPlayer.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            local ok, raidStation = pcall(function()
                return workspace.Worlds["5"].Systems.RaidStation
            end)
            if ok and raidStation then
                hrp.CFrame = raidStation.CFrame + Vector3.new(0, 5, 0)
                hrp.AssemblyLinearVelocity = Vector3.zero
            end
        end

        teleportToStation()
        task.wait(1)

        -- Step 3: Keep teleporting every second until arena loads (max 20s)
        local arenaDeadline = tick() + 20
        while tick() < arenaDeadline do
            if aas_gateArenaExists() then break end
            teleportToStation()
            task.wait(1)
        end

        -- If arena never loaded, give up and resume
        if not aas_gateArenaExists() then
            UILibrary:Notify({
                Title       = "Auto Gate",
                Description = "Gate arena did not load after teleporting. Skipping.",
                Time        = 4,
            })
            aas_resumeFromSnapshot(snapshot)
            aas_trialSuppressedByPriority = false
            task.wait(2)
            continue
        end

        -- Enable Auto Arise if toggled
        if aas_gateAutoArise and aas_raidAutoAriseRemote then
            pcall(function() aas_raidAutoAriseRemote:Fire(true) end)
        end

        -- ══════════════════════════════════════════
        -- GATE FARMING LOOP
        -- ══════════════════════════════════════════
        local sessionActive = true
        while aas_gateEnabled and sessionActive do
            if not aas_gateArenaExists() then
                sessionActive = false
                break
            end

            local leaveAt = aas_getGateLeaveAtWave(rank)
            if leaveAt > 0 then
                local currentWave = aas_getCurrentRaidWave()
                if currentWave > 0 and currentWave >= leaveAt then
                    aas_leaveRaid()
                    task.wait(5)
                    sessionActive = false
                    break
                end
            end

            local mobs = aas_findMobsInFolder(aas_getGateEnemiesFolder(), nil)
            if #mobs == 0 then
                task.wait(0.5)
                continue
            end

            for _, mob in ipairs(mobs) do
                if not aas_gateEnabled then sessionActive = false break end
                if not aas_gateArenaExists() then sessionActive = false break end

                local leaveAtNow = aas_getGateLeaveAtWave(rank)
                if leaveAtNow > 0 then
                    local waveNow = aas_getCurrentRaidWave()
                    if waveNow > 0 and waveNow >= leaveAtNow then
                        sessionActive = false
                        break
                    end
                end

                if not mob.Parent or mob:GetAttribute("EnemyDead") == true then continue end
                aas_teleportToMob(mob)
                aas_waitForDead(mob, 30)
                task.wait(0.15)
            end

            if sessionActive then
                local leaveAtFinal = aas_getGateLeaveAtWave(rank)
                if leaveAtFinal > 0 then
                    local waveNow = aas_getCurrentRaidWave()
                    if waveNow > 0 and waveNow >= leaveAtFinal then
                        aas_leaveRaid()
                        task.wait(5)
                        sessionActive = false
                    end
                end
            end

            task.wait(0.2)
        end

        -- ══════════════════════════════════════════
        -- GATE SESSION ENDS
        -- ══════════════════════════════════════════

        if aas_gateAutoArise and aas_raidAutoAriseRemote then
            pcall(function() aas_raidAutoAriseRemote:Fire(false) end)
        end

        -- Start 1 minute cooldown so we dont re-enter immediately
        aas_gateCooldown = true
        task.spawn(function()
            task.wait(60)
            aas_gateCooldown = false
        end)

        aas_resumeFromSnapshot(snapshot)
        aas_trialSuppressedByPriority = false
        task.wait(1)
    end

    -- Cleanup on toggle off
    if aas_gateAutoArise and aas_raidAutoAriseRemote then
        pcall(function() aas_raidAutoAriseRemote:Fire(false) end)
    end
    aas_gateCooldown = false
end

-- ══════════════════════════════════════════
--   TRIAL LOOP (Fixed: fast room-check every 0.1s)
-- ══════════════════════════════════════════
function aas_trialLoop(trialKey)
    local trialData = aas_TrialList[trialKey]
    if not trialData then return end

    while aas_trialEnabled[trialKey] do
        if aas_trialSuppressedByPriority then
            if aas_gateEnabled and aas_gateArenaExists() then
                task.wait(1)
                continue
            else
                aas_trialSuppressedByPriority = false
            end
        end

        if not aas_trialArenaExists(trialKey) then
            task.wait(1)
            continue
        end

        -- Check if gate also spawns within 5s
        local monitorStart = tick()
        local gateAlsoDetected = false
        while tick() - monitorStart < 5 do
            if aas_gateEnabled and aas_isActiveGatePresent() then
                gateAlsoDetected = true
                break
            end
            task.wait(0.5)
        end

        if gateAlsoDetected then
            aas_applyPriority_GateVsTrial(trialKey)
            if aas_trialSuppressedByPriority then
                task.wait(1)
                continue
            end
        end

        local sessionSnapshot = aas_snapshotAndPauseActivities()

        -- Equip trial loadout
        aas_equipLoadout(aas_TrialLoadouts[trialKey] or "Power")

        aas_joinTrial(trialKey)
        task.wait(5)

        local sessionActive = true
        local needsLeave = false

        while aas_trialEnabled[trialKey] and sessionActive do
            if not aas_trialArenaExists(trialKey) then
                sessionActive = false
                needsLeave = false
                break
            end

            -- Fast leave-at-room check (every 0.1s via tight loop)
            local leaveAt = aas_getTrialLeaveAtRoom(trialKey)
            if leaveAt > 0 then
                local currentRoom = aas_getCurrentTrialRoom(trialKey)
                if currentRoom > 0 and currentRoom >= leaveAt then
                    needsLeave = true
                    sessionActive = false
                    break
                end
            end

            local enemiesFolder = aas_getTrialEnemiesFolder(trialKey)
            local mobs = aas_findMobsInFolder(enemiesFolder, nil)

            if #mobs == 0 then
                task.wait(0.1)
                continue
            end

            for _, mob in ipairs(mobs) do
                if not aas_trialEnabled[trialKey] then
                    sessionActive = false
                    break
                end
                if not aas_trialArenaExists(trialKey) then
                    sessionActive = false
                    break
                end

                local leaveAtNow = aas_getTrialLeaveAtRoom(trialKey)
                if leaveAtNow > 0 then
                    local roomNow = aas_getCurrentTrialRoom(trialKey)
                    if roomNow > 0 and roomNow >= leaveAtNow then
                        needsLeave = true
                        sessionActive = false
                        break
                    end
                end

                if not mob.Parent or mob:GetAttribute("EnemyDead") == true then continue end
                aas_teleportToMob(mob)
                aas_waitForDead(mob, 30)

                -- Immediate check after mob dies
                local leaveCheck = aas_getTrialLeaveAtRoom(trialKey)
                if leaveCheck > 0 then
                    local roomCheck = aas_getCurrentTrialRoom(trialKey)
                    if roomCheck > 0 and roomCheck >= leaveCheck then
                        needsLeave = true
                        sessionActive = false
                        break
                    end
                end

                task.wait(0.05)
            end

            if sessionActive then
                local leaveAtFinal = aas_getTrialLeaveAtRoom(trialKey)
                if leaveAtFinal > 0 then
                    local roomFinal = aas_getCurrentTrialRoom(trialKey)
                    if roomFinal > 0 and roomFinal >= leaveAtFinal then
                        needsLeave = true
                        sessionActive = false
                    end
                end
            end
        end

        if needsLeave and aas_trialArenaExists(trialKey) then
            aas_leaveTrial()
            task.wait(5)
        end

        aas_resumeFromSnapshot(sessionSnapshot)
        aas_gateSuppressedByPriority = false
        task.wait(1)
    end

    aas_trialSuppressedByPriority = false
end

-- ══════════════════════════════════════════
--   PLAYER DATA SYNC
-- ══════════════════════════════════════════
local function aas_getRarityIndex(rarityOrder, rarity)
    for i, r in ipairs(rarityOrder) do
        if r == rarity then return i end
    end
    return 0
end

local aas_progressionLevelLabelRefs = {}

local function aas_updateSword1Labels()
    if aas_sword1InfoLabelRef then
        if aas_sword1Data then
            local stars = string.rep("⭐", aas_sword1Data.Level or 0)
            if stars == "" then stars = "0" end
            pcall(function()
                aas_sword1InfoLabelRef:SetText("Sword 1: "..tostring(aas_sword1Data.Rarity).." | Stars: "..stars)
            end)
        else
            pcall(function() aas_sword1InfoLabelRef:SetText("Sword 1: Not Found") end)
        end
    end
    if aas_sword1BreathingLabelRef then
        local breathingText = "Breathing: None"
        if aas_sword1CurrentBreathing then
            breathingText = "Breathing: "..tostring(aas_sword1CurrentBreathing.Name or "Unknown")
                .." ("..tostring(aas_sword1CurrentBreathing.Rarity or "?")..")"
        end
        pcall(function() aas_sword1BreathingLabelRef:SetText(breathingText) end)
    end
end

local function aas_updateSword2Labels()
    if aas_sword2InfoLabelRef then
        if aas_sword2Data then
            local stars = string.rep("⭐", aas_sword2Data.Level or 0)
            if stars == "" then stars = "0" end
            pcall(function()
                aas_sword2InfoLabelRef:SetText("Sword 2: "..tostring(aas_sword2Data.Rarity).." | Stars: "..stars)
            end)
        else
            pcall(function() aas_sword2InfoLabelRef:SetText("Sword 2: Not Found") end)
        end
    end
    if aas_sword2BreathingLabelRef then
        local breathingText = "Breathing: None"
        if aas_sword2CurrentBreathing then
            breathingText = "Breathing: "..tostring(aas_sword2CurrentBreathing.Name or "Unknown")
                .." ("..tostring(aas_sword2CurrentBreathing.Rarity or "?")..")"
        end
        pcall(function() aas_sword2BreathingLabelRef:SetText(breathingText) end)
    end
end

local function aas_updateGrimoireLabels()
    if aas_grimoire1LabelRef then
        pcall(function() aas_grimoire1LabelRef:SetText("Slot 1: "..(aas_activeGrimoireSlot1 or "None")) end)
    end
    if aas_grimoire2LabelRef then
        pcall(function() aas_grimoire2LabelRef:SetText("Slot 2: "..(aas_activeGrimoireSlot2 or "None")) end)
    end
end

local function aas_updateProgressionLabels()
    for _, progKey in ipairs(aas_sortedProgressionKeys) do
        local labelRef = aas_progressionLevelLabelRefs[progKey]
        if labelRef then
            local level = aas_progressionLevels[progKey] or 0
            local maxLevel = aas_ProgressionList[progKey] and aas_ProgressionList[progKey].MaxLevel or "?"
            pcall(function()
                labelRef:SetText("Level: "..tostring(level).." / "..tostring(maxLevel))
            end)
        end
    end
end

local function aas_syncAllPlayerData()
    if not aas_getPlayerDataFunc then return end
    local ok, data = pcall(function() return aas_getPlayerDataFunc:InvokeServer() end)
    if not ok or type(data) ~= "table" then return end
    aas_cachedPlayerData = data

    local activeGachas = data.ActiveGachas
    if type(activeGachas) == "table" then
        for gachaKey, rarity in pairs(activeGachas) do
            aas_activeGachaRarities[gachaKey] = tostring(rarity)
            local labelRef = aas_gachaLabelRefs[gachaKey]
            if labelRef then
                pcall(function() labelRef:SetText("Current: "..tostring(rarity)) end)
            end
        end
    end

    local activePassive = data.ActivePassive
    if type(activePassive) == "table" and activePassive.Name and activePassive.Rarity then
        aas_activePassiveData = activePassive
        if aas_passiveLabelRef then
            pcall(function()
                aas_passiveLabelRef:SetText("Active: "..tostring(activePassive.Name).." | "..tostring(activePassive.Rarity))
            end)
        end
    else
        aas_activePassiveData = nil
        if aas_passiveLabelRef then
            pcall(function() aas_passiveLabelRef:SetText("Active: None") end)
        end
    end

    local activeTitans = data.ActiveTitans
    if type(activeTitans) == "table" then
        local bestRarity = nil
        local bestIdx = 0
        for _, titanData in pairs(activeTitans) do
            if type(titanData) == "table" and titanData.Rarity then
                local idx = aas_getRarityIndex(aas_TitanRarityOrder, titanData.Rarity)
                if idx > bestIdx then
                    bestIdx = idx
                    bestRarity = titanData.Rarity
                end
            end
        end
        aas_activeTitanData = bestRarity and { rarity=bestRarity } or nil
        if aas_titanLabelRef then
            local titanText = aas_activeTitanData and ("Active Titan: "..aas_activeTitanData.rarity) or "Active Titan: None"
            pcall(function() aas_titanLabelRef:SetText(titanText) end)
        end
    end

    local sword1Raw = data.EquippedSword
    aas_sword1Data = type(sword1Raw) == "table" and {
        SwordKey=sword1Raw.SwordKey or "World0", Rarity=sword1Raw.Rarity or "Common",
        Level=sword1Raw.Level or 0, Index=sword1Raw.Index or 1,
    } or nil

    local sword2Raw = data.EquippedSword2
    aas_sword2Data = type(sword2Raw) == "table" and {
        SwordKey=sword2Raw.SwordKey or "World0", Rarity=sword2Raw.Rarity or "Common",
        Level=sword2Raw.Level or 0, Index=sword2Raw.Index or 1,
    } or nil

    local swordPassives = data.SwordPassives
    if type(swordPassives) == "table" then
        if aas_sword1Data then
            local key1 = string.format("World0_%s_%d_%d",
                aas_sword1Data.Rarity, aas_sword1Data.Level, aas_sword1Data.Index)
            aas_sword1CurrentBreathing = type(swordPassives[key1]) == "table" and swordPassives[key1] or nil
        end
        if aas_sword2Data then
            local key2 = string.format("World0_%s_%d_%d",
                aas_sword2Data.Rarity, aas_sword2Data.Level, aas_sword2Data.Index)
            aas_sword2CurrentBreathing = type(swordPassives[key2]) == "table" and swordPassives[key2] or nil
        end
    end

    local activeGrimoires = data.ActiveGrimoires
    if type(activeGrimoires) == "table" then
        local world7 = activeGrimoires["World7"]
        if type(world7) == "table" then
            aas_activeGrimoireSlot1 = type(world7.Slot1) == "string" and world7.Slot1 or nil
            aas_activeGrimoireSlot2 = type(world7.Slot2) == "string" and world7.Slot2 or nil
        else
            aas_activeGrimoireSlot1 = nil
            aas_activeGrimoireSlot2 = nil
        end
    end

    local activeProgressions = data.ActiveProgressions
    if type(activeProgressions) == "table" then
        for progKey, level in pairs(activeProgressions) do
            aas_progressionLevels[progKey] = tonumber(level) or 0
        end
    end

    aas_updateSword1Labels()
    aas_updateSword2Labels()
    aas_updateGrimoireLabels()
    aas_updateProgressionLabels()
end

task.spawn(function()
    while true do
        task.wait(15)
        pcall(aas_syncAllPlayerData)
    end
end)

-- ══════════════════════════════════════════
--   GACHA LOOP
-- ══════════════════════════════════════════
local function aas_gachaLoop(gachaKey)
    while aas_gachaEnabled[gachaKey] do
        if aas_activeGachaRarities[gachaKey] == AAS_DIVINE then
            aas_gachaEnabled[gachaKey] = false
            local tk = "AutoGacha_"..gachaKey
            if Toggles[tk] then Toggles[tk]:SetValue(false) end
            UILibrary:Notify({
                Title=(aas_GachaList[gachaKey] and aas_GachaList[gachaKey].Name or gachaKey),
                Description="Reached Divine! Auto Gacha stopped.", Time=5
            })
            break
        end
        pcall(function() aas_gachaRollRemote:Fire(gachaKey) end)
        task.wait(0.65)
        pcall(aas_syncAllPlayerData)
        if aas_activeGachaRarities[gachaKey] == AAS_DIVINE then
            aas_gachaEnabled[gachaKey] = false
            local tk = "AutoGacha_"..gachaKey
            if Toggles[tk] then Toggles[tk]:SetValue(false) end
            UILibrary:Notify({
                Title=(aas_GachaList[gachaKey] and aas_GachaList[gachaKey].Name or gachaKey),
                Description="Reached Divine! Auto Gacha stopped.", Time=5
            })
            break
        end
    end
end

-- ══════════════════════════════════════════
--   SWORD LOOPS (Hardcoded)
-- ══════════════════════════════════════════

-- Regular sword (World0)
local aas_swordWorld0Enabled = false
local aas_swordWorld0Thread  = nil

local function aas_swordWorld0Loop()
    while aas_swordWorld0Enabled do
        pcall(function() aas_swordRollRemote:Fire("World0") end)
        task.wait(0.65)
    end
end

-- Summer sword (World8)
local aas_swordWorld8Enabled = false
local aas_swordWorld8Thread  = nil

local function aas_swordWorld8Loop()
    while aas_swordWorld8Enabled do
        pcall(function() aas_swordRollRemote:Fire("World8") end)
        task.wait(0.65)
    end
end

-- ══════════════════════════════════════════
--   AUTO FUSE ALL LOOP
-- ══════════════════════════════════════════
local function aas_fuseAllLoop()
    while aas_autoFuseAllEnabled do
        if aas_bridgeDataRemote then
            pcall(function()
                aas_bridgeDataRemote:FireServer({ [2] = "Q" })
            end)
        end
        task.wait(5)
    end
end

-- ══════════════════════════════════════════
--   PASSIVE LOOP
-- ══════════════════════════════════════════
local function aas_passiveLoop()
    while aas_passiveAutoEnabled do
        pcall(function() aas_passiveRollRemote:Fire() end)
        task.wait(0.65)
    end
end

-- ══════════════════════════════════════════
--   TITAN LOOP
-- ══════════════════════════════════════════
local function aas_titanLoop()
    while aas_titanAutoEnabled do
        pcall(function() aas_titanRollRemote:Fire("World4") end)
        task.wait(0.65)
        pcall(aas_syncAllPlayerData)
    end
end

-- ══════════════════════════════════════════
--   SWORD PASSIVE HELPERS
-- ══════════════════════════════════════════
local function aas_getSword1StopRarities()
    local opt = Options["SwordPassive1StopRarities"]
    if not opt then return {} end
    local selected = {}
    for rarity, state in pairs(opt.Value or {}) do
        if state then table.insert(selected, rarity) end
    end
    return selected
end

local function aas_getSword2StopRarities()
    local opt = Options["SwordPassive2StopRarities"]
    if not opt then return {} end
    local selected = {}
    for rarity, state in pairs(opt.Value or {}) do
        if state then table.insert(selected, rarity) end
    end
    return selected
end

local function aas_swordPassiveRarityReached(currentPassive, stopRarities)
    if not currentPassive or #stopRarities == 0 then return false end
    local currentRarity = currentPassive.Rarity or ""
    for _, r in ipairs(stopRarities) do
        if r == currentRarity then return true end
    end
    return false
end

-- ══════════════════════════════════════════
--   SWORD PASSIVE 1 LOOP
-- ══════════════════════════════════════════
local function aas_swordPassive1Loop()
    while aas_swordPassive1Enabled do
        pcall(aas_syncAllPlayerData)
        local stopRarities = aas_getSword1StopRarities()
        if aas_swordPassiveRarityReached(aas_sword1CurrentBreathing, stopRarities) then
            aas_swordPassive1Enabled = false
            if Toggles["AutoSwordPassive1Enabled"] then Toggles["AutoSwordPassive1Enabled"]:SetValue(false) end
            UILibrary:Notify({ Title="Sword Passive 1 Stopped",
                Description="Reached: "..(aas_sword1CurrentBreathing and aas_sword1CurrentBreathing.Name or "Unknown"), Time=5 })
            break
        end
        if not aas_sword1Data then task.wait(1) continue end
        local args = {
            SwordKey=aas_sword1Data.SwordKey or "World0",
            Rarity=aas_sword1Data.Rarity,
            Level=aas_sword1Data.Level or 0,
            Index=aas_sword1Data.Index or 1,
            SystemKey="World6",
        }
        pcall(function() aas_swordPassiveRollRemote:Fire(args) end)
        task.wait(1.1)
        pcall(aas_syncAllPlayerData)
        if aas_swordPassiveRarityReached(aas_sword1CurrentBreathing, stopRarities) then
            aas_swordPassive1Enabled = false
            if Toggles["AutoSwordPassive1Enabled"] then Toggles["AutoSwordPassive1Enabled"]:SetValue(false) end
            UILibrary:Notify({ Title="Sword Passive 1 Stopped",
                Description="Reached: "..(aas_sword1CurrentBreathing and aas_sword1CurrentBreathing.Name or "Unknown"), Time=5 })
            break
        end
    end
end

-- ══════════════════════════════════════════
--   SWORD PASSIVE 2 LOOP
-- ══════════════════════════════════════════
local function aas_swordPassive2Loop()
    while aas_swordPassive2Enabled do
        pcall(aas_syncAllPlayerData)
        local stopRarities = aas_getSword2StopRarities()
        if aas_swordPassiveRarityReached(aas_sword2CurrentBreathing, stopRarities) then
            aas_swordPassive2Enabled = false
            if Toggles["AutoSwordPassive2Enabled"] then Toggles["AutoSwordPassive2Enabled"]:SetValue(false) end
            UILibrary:Notify({ Title="Sword Passive 2 Stopped",
                Description="Reached: "..(aas_sword2CurrentBreathing and aas_sword2CurrentBreathing.Name or "Unknown"), Time=5 })
            break
        end
        if not aas_sword2Data then task.wait(1) continue end
        local args = {
            SwordKey=aas_sword2Data.SwordKey or "World0",
            Rarity=aas_sword2Data.Rarity,
            Level=aas_sword2Data.Level or 0,
            Index=aas_sword2Data.Index or 1,
            SystemKey="World6",
        }
        pcall(function() aas_swordPassiveRollRemote:Fire(args) end)
        task.wait(1.1)
        pcall(aas_syncAllPlayerData)
        if aas_swordPassiveRarityReached(aas_sword2CurrentBreathing, stopRarities) then
            aas_swordPassive2Enabled = false
            if Toggles["AutoSwordPassive2Enabled"] then Toggles["AutoSwordPassive2Enabled"]:SetValue(false) end
            UILibrary:Notify({ Title="Sword Passive 2 Stopped",
                Description="Reached: "..(aas_sword2CurrentBreathing and aas_sword2CurrentBreathing.Name or "Unknown"), Time=5 })
            break
        end
    end
end

-- ══════════════════════════════════════════
--   GRIMOIRE LOOPS
-- ══════════════════════════════════════════
local function aas_grimoire1Loop()
    while aas_grimoire1Enabled do
        pcall(aas_syncAllPlayerData)
        if aas_activeGrimoireSlot1 == AAS_DIVINE then
            aas_grimoire1Enabled = false
            if Toggles["AutoGrimoire1Enabled"] then Toggles["AutoGrimoire1Enabled"]:SetValue(false) end
            UILibrary:Notify({ Title="Auto Grimoire Slot 1 Stopped", Description="Reached Divine!", Time=5 })
            break
        end
        pcall(function() aas_grimoireRollRemote:Fire("World7", "Slot1") end)
        task.wait(1.1)
        pcall(aas_syncAllPlayerData)
        if aas_activeGrimoireSlot1 == AAS_DIVINE then
            aas_grimoire1Enabled = false
            if Toggles["AutoGrimoire1Enabled"] then Toggles["AutoGrimoire1Enabled"]:SetValue(false) end
            UILibrary:Notify({ Title="Auto Grimoire Slot 1 Stopped", Description="Reached Divine!", Time=5 })
            break
        end
    end
end

local function aas_grimoire2Loop()
    while aas_grimoire2Enabled do
        pcall(aas_syncAllPlayerData)
        if aas_activeGrimoireSlot2 == AAS_DIVINE then
            aas_grimoire2Enabled = false
            if Toggles["AutoGrimoire2Enabled"] then Toggles["AutoGrimoire2Enabled"]:SetValue(false) end
            UILibrary:Notify({ Title="Auto Grimoire Slot 2 Stopped", Description="Reached Divine!", Time=5 })
            break
        end
        pcall(function() aas_grimoireRollRemote:Fire("World7", "Slot2") end)
        task.wait(1.1)
        pcall(aas_syncAllPlayerData)
        if aas_activeGrimoireSlot2 == AAS_DIVINE then
            aas_grimoire2Enabled = false
            if Toggles["AutoGrimoire2Enabled"] then Toggles["AutoGrimoire2Enabled"]:SetValue(false) end
            UILibrary:Notify({ Title="Auto Grimoire Slot 2 Stopped", Description="Reached Divine!", Time=5 })
            break
        end
    end
end

-- ══════════════════════════════════════════
--   PROGRESSION LOOP
-- ══════════════════════════════════════════
local function aas_progressionLoop(progKey)
    local progData = aas_ProgressionList[progKey]
    if not progData then return end
    while aas_progressionEnabled[progKey] do
        local currentLevel = aas_progressionLevels[progKey] or 0
        if currentLevel >= (progData.MaxLevel or 45) then
            aas_progressionEnabled[progKey] = false
            local tk = "AutoProgression_"..progKey
            if Toggles[tk] then Toggles[tk]:SetValue(false) end
            UILibrary:Notify({
                Title=progData.Name.." Stopped",
                Description="Reached max level "..tostring(progData.MaxLevel).."!", Time=5
            })
            break
        end
        pcall(function() aas_progressionUpgradeRemote:Fire(progKey) end)
        task.wait(1.1)
        pcall(aas_syncAllPlayerData)
    end
end

-- ══════════════════════════════════════════
--   RANGE UPGRADE LOOP
-- ══════════════════════════════════════════
local function aas_rangeUpgradeLoop(sysKey)
    while aas_rangeUpgradeEnabled[sysKey] do
        pcall(function() aas_rangeUpgradeRemote:Fire(sysKey) end)
        task.wait(1.0)
    end
end

-- ══════════════════════════════════════════
--   STAR / EGG LOOP
-- ══════════════════════════════════════════
local function aas_starLoop()
    while aas_starEnabled do
        local eggKey = aas_starEggKey
        if not eggKey then task.wait(0.5) continue end
        pcall(function() aas_openEggRemote:Fire(eggKey) end)
        task.wait(0.65)
    end
end

-- ══════════════════════════════════════════
--   CRAFT LOOP
-- ══════════════════════════════════════════
local function aas_craftLoop(craftKey)
    local craftData = aas_CraftList[craftKey]
    if not craftData then return end
    while aas_craftEnabled[craftKey] do
        local isShiny = aas_craftShiny[craftKey] == true
        pcall(function() aas_craftPetRemote:Fire(craftKey, isShiny) end)
        task.wait(1.1)
    end
end

-- ══════════════════════════════════════════
--   CLEANUP FUNCTION
-- ══════════════════════════════════════════
local function aas_cleanup()
    aas_farmEnabled = false
    if aas_farmThread then task.cancel(aas_farmThread) aas_farmThread = nil end

    for rk in pairs(aas_raidEnabled) do aas_raidEnabled[rk] = false end
    if aas_raidThread then task.cancel(aas_raidThread) aas_raidThread = nil end
    if aas_activeRaidKey and aas_raidArenaExists(aas_activeRaidKey) then aas_leaveRaid() end
    aas_activeRaidKey = nil

    for dk in pairs(aas_defenseEnabled) do aas_defenseEnabled[dk] = false end
    if aas_defenseThread then task.cancel(aas_defenseThread) aas_defenseThread = nil end
    if aas_activeDefenseKey and aas_defenseArenaExists(aas_activeDefenseKey) then aas_leaveDefense() end
    aas_activeDefenseKey = nil

    for tk in pairs(aas_trialEnabled) do aas_trialEnabled[tk] = false end
    for tk, t in pairs(aas_trialThreads) do task.cancel(t) aas_trialThreads[tk] = nil end

    aas_gateEnabled = false
    if aas_gateThread then task.cancel(aas_gateThread) aas_gateThread = nil end
    if aas_gateAutoArise and aas_raidAutoAriseRemote then
        pcall(function() aas_raidAutoAriseRemote:Fire(false) end)
    end

    aas_disableAllGachas()

    for sk, t in pairs(aas_swordThreads) do
        task.cancel(t)
        aas_swordThreads[sk] = nil
    end

    aas_autoFuseAllEnabled = false
    if aas_fuseAllThread then task.cancel(aas_fuseAllThread) aas_fuseAllThread = nil end

    aas_autoCrowEnabled = false
    if aas_crowThread then task.cancel(aas_crowThread) aas_crowThread = nil end

    aas_passiveAutoEnabled = false
    if aas_passiveThread then task.cancel(aas_passiveThread) aas_passiveThread = nil end

    aas_titanAutoEnabled = false
    if aas_titanThread then task.cancel(aas_titanThread) aas_titanThread = nil end

    aas_swordPassive1Enabled = false
    if aas_swordPassive1Thread then task.cancel(aas_swordPassive1Thread) aas_swordPassive1Thread = nil end
    aas_swordPassive2Enabled = false
    if aas_swordPassive2Thread then task.cancel(aas_swordPassive2Thread) aas_swordPassive2Thread = nil end

    aas_grimoire1Enabled = false
    if aas_grimoire1Thread then task.cancel(aas_grimoire1Thread) aas_grimoire1Thread = nil end
    aas_grimoire2Enabled = false
    if aas_grimoire2Thread then task.cancel(aas_grimoire2Thread) aas_grimoire2Thread = nil end

    for k in pairs(aas_progressionEnabled) do aas_progressionEnabled[k] = false end
    for k, t in pairs(aas_progressionThreads) do task.cancel(t) aas_progressionThreads[k] = nil end

    for k in pairs(aas_rangeUpgradeEnabled) do aas_rangeUpgradeEnabled[k] = false end
    for k, t in pairs(aas_rangeUpgradeThreads) do task.cancel(t) aas_rangeUpgradeThreads[k] = nil end

    for k in pairs(aas_craftEnabled) do aas_craftEnabled[k] = false end
    for k, t in pairs(aas_craftThreads) do task.cancel(t) aas_craftThreads[k] = nil end

    aas_starEnabled = false
    if aas_starThread then task.cancel(aas_starThread) aas_starThread = nil end

    aas_autoClickRunning = false
    -- inside aas_cleanup(), add this line:
    aas_gateCooldown = false
    aas_toggleAutoClaimAchievements(false)
    aas_toggleAutoAvatar(false)
    aas_toggleAutoRank(false)
    aas_toggleAutoStat(aas_currentStatSelection, false)
    aas_toggleAutoClaimRewards(false)
        -- Hardcoded sword cleanup
    aas_swordWorld0Enabled = false
    if aas_swordWorld0Thread then task.cancel(aas_swordWorld0Thread) aas_swordWorld0Thread = nil end
    aas_swordWorld8Enabled = false
    if aas_swordWorld8Thread then task.cancel(aas_swordWorld8Thread) aas_swordWorld8Thread = nil end
    aas_crowClaiming = false

    print("Anime Astral Simulator script unloaded!")
end

-- ══════════════════════════════════════════
--   WINDOW SETUP
-- ══════════════════════════════════════════
local aas_Window = UILibrary:CreateWindow({
    Title             = "IBDihP Hub",
    Footer            = "By Hersheys - Version 2.1",
    MobileButtonsSide = "Right",
    Icon              = "rbxassetid://114748833858413",
    NotifySide        = "Right",
    ShowCustomCursor  = true,
})

-- ══════════════════════════════════════════
--   TABS
-- ══════════════════════════════════════════
local aas_Tabs = {
    Main        = aas_Window:AddTab("Main",                "star"),
    Farm        = aas_Window:AddTab("Auto Farm Mob",       "sword"),
    RaidDef     = aas_Window:AddTab("Auto Raid / Defense", "shield"),
    Trial       = aas_Window:AddTab("Auto Trial / Gate",   "clock"),
    Loadouts    = aas_Window:AddTab("Loadouts",            "layout"),
    Gacha       = aas_Window:AddTab("Auto Gacha",          "sparkles"),
    Progression = aas_Window:AddTab("Auto Progression",    "trending-up"),
    Star        = aas_Window:AddTab("Auto Star",           "star"),
    Settings    = aas_Window:AddTab("Settings",            "settings"),
}

-- ══════════════════════════════════════════
--   MAIN TAB
-- ══════════════════════════════════════════
local aas_BannerGroup = aas_Tabs.Main:AddLeftGroupbox("🌐 JOIN DISCORD FOR ACTIVE COMMUNITY", "users")
aas_BannerGroup:AddLabel("Suggestions • Bug Fixes • Updates • Community Support", true)
aas_BannerGroup:AddButton({
    Text    = "📋 COPY DISCORD INVITE LINK",
    Func    = function()
        setclipboard("https://discord.gg/dhecnztyph")
        UILibrary:Notify({ Title="Discord Invite Copied!", Description="Paste the link in your browser to join our community", Time=4 })
    end,
    Tooltip = "Copy Discord invite to clipboard",
})
aas_BannerGroup:AddDivider()

local aas_MainGroup = aas_Tabs.Main:AddLeftGroupbox("Main Automation", "zap")

aas_MainGroup:AddToggle("AutoClick", {
    Text    = "Auto Click",
    Tooltip = "Automatically clicks every 0.05 seconds (20 clicks/sec)",
    Default = false,
    Callback = function(value)
        aas_autoClickRunning = value
        if value then
            aas_autoClick()
            UILibrary:Notify({ Title="Auto Click", Description="Started!", Time=3 })
        else
            UILibrary:Notify({ Title="Auto Click", Description="Stopped.", Time=3 })
        end
    end,
})

aas_MainGroup:AddToggle("AutoClaimAchievements", {
    Text    = "Auto Claim Achievements",
    Tooltip = "Automatically claims achievements when completed",
    Default = false,
    Callback = function(value)
        aas_autoClaimAchievementsEnabled = value
        if aas_toggleAutoClaimAchievements(value) then
            UILibrary:Notify({ Title="Auto Claim Achievements", Description=value and "Enabled!" or "Disabled", Time=3 })
        else
            UILibrary:Notify({ Title="Auto Claim Achievements", Description="Failed to toggle", Time=4 })
            Toggles.AutoClaimAchievements:SetValue(not value)
        end
    end,
})

aas_MainGroup:AddToggle("AutoAvatar", {
    Text    = "Auto Equip Best Avatar",
    Tooltip = "Automatically equips the best avatar for buffs",
    Default = false,
    Callback = function(value)
        aas_autoAvatarEnabled = value
        if aas_toggleAutoAvatar(value) then
            UILibrary:Notify({ Title="Auto Equip Avatar", Description=value and "Enabled!" or "Disabled", Time=3 })
        else
            UILibrary:Notify({ Title="Auto Equip Avatar", Description="Failed to toggle", Time=4 })
            Toggles.AutoAvatar:SetValue(not value)
        end
    end,
})

aas_MainGroup:AddToggle("AutoRank", {
    Text    = "Auto Rank Up",
    Tooltip = "Automatically ranks up when you have enough power",
    Default = false,
    Callback = function(value)
        aas_autoRankEnabled = value
        if aas_toggleAutoRank(value) then
            UILibrary:Notify({ Title="Auto Rank Up", Description=value and "Enabled!" or "Disabled", Time=3 })
        else
            UILibrary:Notify({ Title="Auto Rank Up", Description="Failed to toggle", Time=4 })
            Toggles.AutoRank:SetValue(not value)
        end
    end,
})

aas_MainGroup:AddToggle("AutoClaimRewards", {
    Text    = "Auto Claim Time Rewards",
    Tooltip = "Automatically claims time-based rewards when ready",
    Default = false,
    Callback = function(value)
        aas_autoClaimRewardsEnabled = value
        if aas_toggleAutoClaimRewards(value) then
            UILibrary:Notify({ Title="Auto Claim Rewards", Description=value and "Enabled!" or "Disabled", Time=3 })
        else
            UILibrary:Notify({ Title="Auto Claim Rewards", Description="Failed to toggle", Time=4 })
            Toggles.AutoClaimRewards:SetValue(not value)
        end
    end,
})

-- ── Auto Crow ──────────────────────────────
local aas_CrowGroup = aas_Tabs.Main:AddLeftGroupbox("Auto Crow", "feather")
aas_CrowGroup:AddLabel(
    "⚠ IMPORTANT: You MUST have manually visited\nWorld 6 at least once before enabling this!\n"..
    "When a crow spawns, ALL active farming will\nbe paused, crow will be claimed, then resumed.",
    true
)
aas_CrowGroup:AddToggle("AutoCrow", {
    Text    = "Enable Auto Crow (World 6)",
    Tooltip = "Monitors workspace.World6Corvos for crows. Pauses all activities to claim the crow, then resumes.",
    Default = false,
    Callback = function(value)
        aas_autoCrowEnabled = value
        if value then
            if aas_crowThread then task.cancel(aas_crowThread) end
            aas_crowThread = task.spawn(aas_crowMonitorLoop)
            UILibrary:Notify({ Title="Auto Crow", Description="Enabled! Monitoring World 6 Corvos...", Time=5 })
        else
            if aas_crowThread then task.cancel(aas_crowThread) end
            UILibrary:Notify({ Title="Auto Crow", Description="Disabled.", Time=3 })
        end
    end,
})

-- ── Auto Stat ─────────────────────────────
local aas_StatGroup = aas_Tabs.Main:AddRightGroupbox("Auto Stat Points", "trending-up")
aas_StatGroup:AddDropdown("StatSelection", {
    Values   = { "Power", "Yen", "Damage", "Luck", "Xp", "Drop" },
    Default  = 1,
    Text     = "Select Stat to Auto Upgrade",
    Tooltip  = "Choose which stat to automatically upgrade",
    Callback = function(value)
        aas_currentStatSelection = value
        if aas_autoStatEnabled then
            if aas_toggleAutoStat(value, true) then
                UILibrary:Notify({ Title="Auto Stat", Description="Switched to "..value, Time=2 })
            end
        end
    end,
})
aas_StatGroup:AddToggle("AutoStat", {
    Text    = "Enable Auto Stat",
    Tooltip = "Automatically upgrade the selected stat when you have points",
    Default = false,
    Callback = function(value)
        aas_autoStatEnabled = value
        if aas_toggleAutoStat(aas_currentStatSelection, value) then
            UILibrary:Notify({ Title="Auto Stat", Description=value and ("Enabled for "..aas_currentStatSelection) or "Disabled", Time=3 })
        else
            UILibrary:Notify({ Title="Auto Stat", Description="Failed to toggle", Time=4 })
            Toggles.AutoStat:SetValue(not value)
        end
    end,
})

-- ── Redeem Codes ──────────────────────────
local aas_CodesGroup = aas_Tabs.Main:AddRightGroupbox("Redeem Codes", "gift")
aas_CodesGroup:AddButton({
    Text    = "🎁 Redeem All Codes",
    Func    = aas_redeemAllCodes,
    Tooltip = "Redeem all available codes automatically",
})

-- ══════════════════════════════════════════
--   LOADOUTS TAB
-- ══════════════════════════════════════════
local aas_LoadoutInfoGroup = aas_Tabs.Loadouts:AddLeftGroupbox("How Loadouts Work", "info")
aas_LoadoutInfoGroup:AddLabel(
    "Assign a stat loadout to each activity.\n"..
    "Before starting each activity, the script fires\n"..
    "EquipBestLoadout with your chosen stat.\n\n"..
    "Example: Set Raid = Damage, Trial = Drop.\n"..
    "Script will equip Damage before each raid,\n"..
    "and Drop before each trial automatically.",
    true
)

local aas_LoadoutGroup = aas_Tabs.Loadouts:AddLeftGroupbox("Activity Loadout Assignments", "shield")

-- Farm loadout
aas_LoadoutGroup:AddDropdown("LoadoutFarm", {
    Values   = { "Power", "Yen", "Damage", "XP", "Drop", "Luck" },
    Default  = 1,
    Text     = "Auto Farm Mob Loadout",
    Tooltip  = "Equip this loadout before auto farming mobs",
    Callback = function(v) aas_LoadoutAssignments.Farm = v end,
})

aas_LoadoutGroup:AddDivider()
aas_LoadoutGroup:AddLabel("Per-Gate-Rank Loadouts:", true)

for _, rank in ipairs(aas_GateRanks) do
    aas_LoadoutGroup:AddDropdown("LoadoutGateRank_" .. rank, {
        Values   = { "Power", "Yen", "Damage", "XP", "Drop", "Luck" },
        Default  = 1,
        Text     = "Gate Rank " .. rank .. " Loadout",
        Tooltip  = "Equip this loadout when entering a Rank " .. rank .. " gate",
        Callback = function(v)
            -- Stored in Options, read directly in gate loop
        end,
    })
end

aas_LoadoutGroup:AddDivider()
aas_LoadoutGroup:AddLabel("Per-Raid Loadouts:", true)

-- Per-raid loadout dropdowns
for _, raidKey in ipairs(aas_sortedRaidKeys) do
    local raidData   = aas_RaidList[raidKey]
    local worldLabel = aas_getWorldLabel(raidData.WorldId or 0)
    aas_RaidLoadouts[raidKey] = "Power"

    aas_LoadoutGroup:AddDropdown("LoadoutRaid_"..raidKey, {
        Values   = { "Power", "Yen", "Damage", "XP", "Drop", "Luck" },
        Default  = 1,
        Text     = raidData.Name.." ("..worldLabel..") Loadout",
        Tooltip  = "Equip this loadout when auto-farming "..raidData.Name,
        Callback = function(v) aas_RaidLoadouts[raidKey] = v end,
    })
end

local aas_LoadoutGroupRight = aas_Tabs.Loadouts:AddRightGroupbox("Per-Defense & Trial Loadouts", "shield")
aas_LoadoutGroupRight:AddLabel("Per-Defense Loadouts:", true)

-- Per-defense loadout dropdowns
for _, defKey in ipairs(aas_sortedDefenseKeys) do
    local defData    = aas_DefenseList[defKey]
    local worldLabel = aas_getWorldLabel(defData.WorldId or 0)
    aas_DefenseLoadouts[defKey] = "Power"

    aas_LoadoutGroupRight:AddDropdown("LoadoutDef_"..defKey, {
        Values   = { "Power", "Yen", "Damage", "XP", "Drop", "Luck" },
        Default  = 1,
        Text     = defData.Name.." ("..worldLabel..") Loadout",
        Tooltip  = "Equip this loadout when auto-farming "..defData.Name,
        Callback = function(v) aas_DefenseLoadouts[defKey] = v end,
    })
end

aas_LoadoutGroupRight:AddDivider()
aas_LoadoutGroupRight:AddLabel("Per-Trial Loadouts:", true)

-- Per-trial loadout dropdowns
for _, trialKey in ipairs(aas_sortedTrialKeys) do
    local trialData = aas_TrialList[trialKey]
    aas_TrialLoadouts[trialKey] = "Power"

    aas_LoadoutGroupRight:AddDropdown("LoadoutTrial_"..trialKey, {
        Values   = { "Power", "Yen", "Damage", "XP", "Drop", "Luck" },
        Default  = 1,
        Text     = trialData.Name.." Loadout",
        Tooltip  = "Equip this loadout when entering "..trialData.Name,
        Callback = function(v) aas_TrialLoadouts[trialKey] = v end,
    })
end

-- ══════════════════════════════════════════
--   AUTO FARM MOB TAB
-- ══════════════════════════════════════════
local aas_FarmControlGroup = aas_Tabs.Farm:AddLeftGroupbox("Farm Control", "zap")
aas_FarmControlGroup:AddToggle("AutoFarmEnabled", {
    Text    = "Enable Auto Farm",
    Tooltip = "Starts/stops the auto farm loop for all selected mobs",
    Default = false,
    Callback = function(value)
        if value then
            if aas_anyRaidActive() then
                Toggles.AutoFarmEnabled:SetValue(false)
                UILibrary:Notify({ Title="Blocked", Description="Cannot enable Auto Farm while a raid is active.", Time=4 })
                return
            end
            if aas_anyDefenseActive() then
                Toggles.AutoFarmEnabled:SetValue(false)
                UILibrary:Notify({ Title="Blocked", Description="Cannot enable Auto Farm while a defense is active.", Time=4 })
                return
            end
        end
        aas_farmEnabled = value
        if value then
            aas_equipLoadout(aas_LoadoutAssignments.Farm)
            if aas_farmThread then task.cancel(aas_farmThread) end
            aas_farmThread = task.spawn(aas_farmLoop)
            UILibrary:Notify({ Title="Auto Farm", Description="Farm started!", Time=3 })
        else
            if aas_farmThread then task.cancel(aas_farmThread) aas_farmThread = nil end
            aas_currentWorldTracked = nil
            UILibrary:Notify({ Title="Auto Farm", Description="Farm stopped.", Time=3 })
        end
    end,
})
aas_FarmControlGroup:AddDivider()
aas_FarmControlGroup:AddLabel("Click a world button to teleport there.", true)
aas_FarmControlGroup:AddLabel("Select 'None' to stop farming that world.", true)

for i, worldIdx in ipairs(aas_sortedWorldIndices) do
    local worldData = aas_WorldList[worldIdx]
    local dropKey   = "FarmWorld_"..worldIdx
    aas_worldDropdowns[worldIdx] = dropKey

    local enemyNames = { "None" }
    for _, e in ipairs(worldData.enemies) do table.insert(enemyNames, e.Name) end

    local aas_WorldGroup
    if i % 2 == 1 then
        aas_WorldGroup = aas_Tabs.Farm:AddRightGroupbox(aas_getWorldLabel(worldIdx), "map-pin")
    else
        aas_WorldGroup = aas_Tabs.Farm:AddLeftGroupbox(aas_getWorldLabel(worldIdx), "map-pin")
    end

    local capturedIdx = worldIdx
    aas_WorldGroup:AddButton({
        Text    = "Teleport to "..aas_getWorldLabel(worldIdx),
        Func    = function()
            aas_teleportToWorld(capturedIdx)
            UILibrary:Notify({ Title="Teleporting", Description="Teleporting to "..aas_getWorldLabel(capturedIdx).."...", Time=2 })
        end,
        Tooltip = "Teleport to "..aas_getWorldLabel(worldIdx),
    })

    if #enemyNames <= 1 then
        aas_WorldGroup:AddLabel("No enemies found for this world.", true)
    else
        aas_WorldGroup:AddDropdown(dropKey, {
            Values     = enemyNames,
            Multi      = true,
            Default    = nil,
            Text       = "Select Mobs to Farm",
            Tooltip    = "Choose which mobs to farm in "..worldData.name,
            Searchable = #enemyNames > 6,
            Callback   = function(_) end,
        })
    end
end

-- ══════════════════════════════════════════
--   AUTO RAID / DEFENSE TAB
-- ══════════════════════════════════════════
local aas_RaidInfoGroup = aas_Tabs.RaidDef:AddLeftGroupbox("Auto Raid", "shield")
aas_RaidInfoGroup:AddLabel("Active raid blocks farm mob and defense.", true)
aas_RaidInfoGroup:AddDivider()

for _, raidKey in ipairs(aas_sortedRaidKeys) do
    local raidData   = aas_RaidList[raidKey]
    local toggleKey  = "AutoRaid_"..raidKey
    local waveOptKey = "RaidLeaveWave_"..raidKey
    aas_raidEnabled[raidKey] = false
    aas_RaidLoadouts[raidKey] = aas_RaidLoadouts[raidKey] or "Power"

    local worldLabel = aas_getWorldLabel(raidData.WorldId or 0)
    local aas_RaidGroup = aas_Tabs.RaidDef:AddLeftGroupbox(raidData.Name.." ("..worldLabel..")", "zap")

    local waveValues = { "0 (Never Leave)" }
    for w = 1, raidData.TotalWaves do table.insert(waveValues, tostring(w)) end
    aas_RaidGroup:AddDropdown(waveOptKey, {
        Values     = waveValues,
        Default    = 1,
        Text       = "Leave at Wave",
        Tooltip    = "Leave and rejoin at this wave (0 = never leave early)",
        Searchable = raidData.TotalWaves > 20,
        Callback   = function(_) end,
    })
    aas_RaidGroup:AddToggle(toggleKey, {
        Text    = "Enable "..raidData.Name,
        Tooltip = "Auto farm "..raidData.Name.." continuously",
        Default = false,
        Callback = function(value)
            if value then
                if aas_farmEnabled then
                    Toggles[toggleKey]:SetValue(false)
                    UILibrary:Notify({ Title="Blocked", Description="Disable Auto Farm Mob first.", Time=4 })
                    return
                end
                if aas_anyDefenseActive() then
                    Toggles[toggleKey]:SetValue(false)
                    UILibrary:Notify({ Title="Blocked", Description="Disable active defense before starting a raid.", Time=4 })
                    return
                end
                if aas_activeRaidKey and aas_activeRaidKey ~= raidKey then
                    Toggles[toggleKey]:SetValue(false)
                    UILibrary:Notify({ Title="Blocked", Description="Disable "..aas_RaidList[aas_activeRaidKey].Name.." first.", Time=4 })
                    return
                end
                aas_disableOtherRaids(raidKey)
                aas_raidEnabled[raidKey] = true
                aas_activeRaidKey = raidKey
                if aas_raidThread then task.cancel(aas_raidThread) aas_raidThread = nil end
                aas_raidThread = task.spawn(function() aas_raidLoop(raidKey) end)
                UILibrary:Notify({ Title=raidData.Name, Description="Auto Raid started!", Time=3 })
            else
                aas_raidEnabled[raidKey] = false
                if aas_activeRaidKey == raidKey then aas_activeRaidKey = nil end
                if aas_raidThread then task.cancel(aas_raidThread) aas_raidThread = nil end
                UILibrary:Notify({ Title=raidData.Name, Description="Auto Raid stopped.", Time=3 })
            end
        end,
    })
end

local aas_DefInfoGroup = aas_Tabs.RaidDef:AddRightGroupbox("Auto Defense", "shield")
aas_DefInfoGroup:AddLabel("Active defense blocks farm mob and raids.", true)
aas_DefInfoGroup:AddDivider()

for _, defKey in ipairs(aas_sortedDefenseKeys) do
    local defData    = aas_DefenseList[defKey]
    local toggleKey  = "AutoDefense_"..defKey
    local waveOptKey = "DefLeaveWave_"..defKey
    aas_defenseEnabled[defKey] = false
    aas_DefenseLoadouts[defKey] = aas_DefenseLoadouts[defKey] or "Power"

    local worldLabel = aas_getWorldLabel(defData.WorldId or 0)
    local aas_DefGroup = aas_Tabs.RaidDef:AddRightGroupbox(defData.Name.." ("..worldLabel..")", "zap")

    local waveValues = { "0 (Never Leave)" }
    for w = 1, defData.TotalWaves do table.insert(waveValues, tostring(w)) end
    aas_DefGroup:AddDropdown(waveOptKey, {
        Values     = waveValues,
        Default    = 1,
        Text       = "Leave at Wave",
        Tooltip    = "Leave and rejoin at this wave (0 = never leave early)",
        Searchable = defData.TotalWaves > 20,
        Callback   = function(_) end,
    })
    aas_DefGroup:AddToggle(toggleKey, {
        Text    = "Enable "..defData.Name,
        Tooltip = "Auto farm "..defData.Name.." continuously",
        Default = false,
        Callback = function(value)
            if value then
                if aas_farmEnabled then
                    Toggles[toggleKey]:SetValue(false)
                    UILibrary:Notify({ Title="Blocked", Description="Disable Auto Farm Mob first.", Time=4 })
                    return
                end
                if aas_anyRaidActive() then
                    Toggles[toggleKey]:SetValue(false)
                    UILibrary:Notify({ Title="Blocked", Description="Disable active raid before starting a defense.", Time=4 })
                    return
                end
                if aas_activeDefenseKey and aas_activeDefenseKey ~= defKey then
                    Toggles[toggleKey]:SetValue(false)
                    UILibrary:Notify({ Title="Blocked", Description="Disable "..aas_DefenseList[aas_activeDefenseKey].Name.." first.", Time=4 })
                    return
                end
                aas_disableAllDefenses()
                aas_defenseEnabled[defKey] = true
                aas_activeDefenseKey = defKey
                if aas_defenseThread then task.cancel(aas_defenseThread) aas_defenseThread = nil end
                aas_defenseThread = task.spawn(function() aas_defenseLoop(defKey) end)
                UILibrary:Notify({ Title=defData.Name, Description="Auto Defense started!", Time=3 })
            else
                aas_defenseEnabled[defKey] = false
                if aas_activeDefenseKey == defKey then aas_activeDefenseKey = nil end
                if aas_defenseThread then task.cancel(aas_defenseThread) aas_defenseThread = nil end
                UILibrary:Notify({ Title=defData.Name, Description="Auto Defense stopped.", Time=3 })
            end
        end,
    })
end

-- ══════════════════════════════════════════
--   AUTO TRIAL / GATE TAB
-- ══════════════════════════════════════════
local aas_PriorityGroup = aas_Tabs.Trial:AddLeftGroupbox("⚠ Priority System (REQUIRED)", "alert-triangle")
aas_PriorityGroup:AddLabel(
    "When both a Trial AND a Gate are available at the same time,\n"..
    "the priority determines which one runs first.\n"..
    "The other will be paused until it finishes.", true
)
aas_PriorityGroup:AddDropdown("TrialGatePriority", {
    Values   = { "Trial", "Gate" },
    Default  = 1,
    Text     = "Priority When Both Available",
    Tooltip  = "If both a trial and a gate spawn at the same time, which one takes priority?",
    Callback = function(val)
        aas_priorityChoice = val
        UILibrary:Notify({ Title="Priority Set", Description="Priority: "..val, Time=2 })
    end,
})
aas_PriorityGroup:AddDivider()

-- LEFT: Auto Trials
local aas_TrialInfoGroup = aas_Tabs.Trial:AddLeftGroupbox("Auto Trial", "clock")
aas_TrialInfoGroup:AddLabel("Trials spawn on a schedule — script waits for them.", true)
aas_TrialInfoGroup:AddLabel("Multiple trials can run simultaneously.", true)
aas_TrialInfoGroup:AddLabel("Trials temporarily pause Farm / Raid / Defense.", true)
aas_TrialInfoGroup:AddDivider()

for _, trialKey in ipairs(aas_sortedTrialKeys) do
    local trialData  = aas_TrialList[trialKey]
    local toggleKey  = "AutoTrial_"..trialKey
    local roomOptKey = "TrialLeaveRoom_"..trialKey
    aas_trialEnabled[trialKey] = false
    aas_TrialLoadouts[trialKey] = aas_TrialLoadouts[trialKey] or "Power"

    local aas_TrialGroup = aas_Tabs.Trial:AddLeftGroupbox(trialData.Name, "zap")

    local roomValues = { "0 (Never Leave)" }
    for r = 1, trialData.TotalRooms do table.insert(roomValues, tostring(r)) end

    aas_TrialGroup:AddDropdown(roomOptKey, {
        Values     = roomValues,
        Default    = 1,
        Text       = "Leave at Room",
        Tooltip    = "Leave the trial at this room and rejoin next spawn. Change takes effect immediately.",
        Searchable = trialData.TotalRooms > 20,
        Callback   = function(_) end,
    })
    aas_TrialGroup:AddToggle(toggleKey, {
        Text    = "Enable "..trialData.Name,
        Tooltip = "Auto farm "..trialData.Name.." — waits for trial to spawn, then farms enemies",
        Default = false,
        Callback = function(value)
            aas_trialEnabled[trialKey] = value
            if value then
                if aas_trialThreads[trialKey] then
                    task.cancel(aas_trialThreads[trialKey])
                    aas_trialThreads[trialKey] = nil
                end
                aas_trialThreads[trialKey] = task.spawn(function() aas_trialLoop(trialKey) end)
                UILibrary:Notify({ Title=trialData.Name, Description="Auto Trial enabled! Waiting for trial to spawn...", Time=4 })
            else
                if aas_trialThreads[trialKey] then
                    task.cancel(aas_trialThreads[trialKey])
                    aas_trialThreads[trialKey] = nil
                end
                UILibrary:Notify({ Title=trialData.Name, Description="Auto Trial stopped.", Time=3 })
            end
        end,
    })
end

-- RIGHT: Auto Gate
local aas_GateInfoGroup = aas_Tabs.Trial:AddRightGroupbox("Auto Gate", "shield")
aas_GateInfoGroup:AddLabel("Gates spawn every ~10 min for 60 seconds.", true)
aas_GateInfoGroup:AddLabel("Script teleports to World 5 RaidStation (portal).", true)
aas_GateInfoGroup:AddLabel("Gate temporarily pauses Farm / Raid / Defense.", true)
aas_GateInfoGroup:AddDivider()

if aas_GateData then
    aas_GateInfoGroup:AddDropdown("GateRankSelect", {
        Values     = aas_GateRanks,
        Multi      = true,
        Default    = nil,
        Text       = "Select Gate Ranks to Farm",
        Tooltip    = "Only enter the gate if its rank matches one of these.",
        Searchable = false,
        Callback   = function(_) end,
    })

    for _, rank in ipairs(aas_GateRanks) do
        local waveOptKey = "GateLeaveWave_"..rank
        local waveValues = { "0 (Never Leave)" }
        for w = 1, (aas_GateData.TotalWaves or 50) do table.insert(waveValues, tostring(w)) end
        aas_GateInfoGroup:AddDropdown(waveOptKey, {
            Values     = waveValues,
            Default    = 1,
            Text       = "Leave at Wave (Rank "..rank..")",
            Tooltip    = "Leave the gate at this wave for Rank "..rank.." gates (0 = never leave)",
            Searchable = (aas_GateData.TotalWaves or 50) > 20,
            Callback   = function(_) end,
        })
    end

    aas_GateInfoGroup:AddToggle("GateAutoArise", {
        Text    = "Enable Auto Arise",
        Tooltip = "Enables Auto Arise for gates.",
        Default = false,
        Callback = function(value)
            aas_gateAutoArise = value
            if aas_gateEnabled and aas_raidAutoAriseRemote then
                pcall(function() aas_raidAutoAriseRemote:Fire(value) end)
            end
            UILibrary:Notify({ Title="Auto Arise", Description=value and "Enabled!" or "Disabled", Time=3 })
        end,
    })

    aas_GateInfoGroup:AddToggle("AutoGateEnabled", {
        Text    = "Enable Auto Gate",
        Tooltip = "Monitors World 5 for gates and farms them automatically. Teleports to RaidStation portal.",
        Default = false,
        Callback = function(value)
            aas_gateEnabled = value
            if value then
                if aas_gateThread then task.cancel(aas_gateThread) aas_gateThread = nil end
                aas_gateThread = task.spawn(aas_gateLoop)
                UILibrary:Notify({ Title="Auto Gate", Description="Enabled! Monitoring World 5 for gates...", Time=4 })
            else
                if aas_gateThread then task.cancel(aas_gateThread) aas_gateThread = nil end
                aas_gateSuppressedByPriority = false
                if aas_gateAutoArise and aas_raidAutoAriseRemote then
                    pcall(function() aas_raidAutoAriseRemote:Fire(false) end)
                end
                UILibrary:Notify({ Title="Auto Gate", Description="Stopped.", Time=3 })
            end
        end,
    })
else
    aas_GateInfoGroup:AddLabel("No gate data found in config.", true)
end

-- ══════════════════════════════════════════
--   AUTO GACHA TAB
-- ══════════════════════════════════════════
task.spawn(function()
    task.wait(2)
    pcall(aas_syncAllPlayerData)
end)

local aas_GachaInfoGroup = aas_Tabs.Gacha:AddLeftGroupbox("Auto Gacha", "sparkles")
aas_GachaInfoGroup:AddLabel("Multiple gachas can run simultaneously.", true)
aas_GachaInfoGroup:AddLabel("Auto stops when Divine is reached.", true)
aas_GachaInfoGroup:AddDivider()

for _, gachaKey in ipairs(aas_sortedGachaKeys) do
    local gachaData = aas_GachaList[gachaKey]
    local toggleKey = "AutoGacha_"..gachaKey
    aas_gachaEnabled[gachaKey] = false

    local worldLabel = aas_getWorldLabel(gachaData.WorldId)
    local aas_GachaGroup = aas_Tabs.Gacha:AddLeftGroupbox(gachaData.Name.." ("..worldLabel..")", "star")

    local currentRarity  = aas_activeGachaRarities[gachaKey] or "Unknown"
    local rarityLabelObj = aas_GachaGroup:AddLabel("Current: "..currentRarity, false, "GachaRarityLabel_"..gachaKey)
    aas_gachaLabelRefs[gachaKey] = Options["GachaRarityLabel_"..gachaKey] or rarityLabelObj

    aas_GachaGroup:AddToggle(toggleKey, {
        Text    = "Enable Auto Roll",
        Tooltip = "Automatically roll "..gachaData.Name.." (stops at Divine)",
        Default = false,
        Callback = function(value)
            aas_gachaEnabled[gachaKey] = value
            if value then
                if aas_gachaThreads[gachaKey] then task.cancel(aas_gachaThreads[gachaKey]) end
                aas_gachaThreads[gachaKey] = task.spawn(function() aas_gachaLoop(gachaKey) end)
                UILibrary:Notify({ Title=gachaData.Name, Description="Auto Gacha started!", Time=3 })
            else
                if aas_gachaThreads[gachaKey] then task.cancel(aas_gachaThreads[gachaKey]) aas_gachaThreads[gachaKey] = nil end
                UILibrary:Notify({ Title=gachaData.Name, Description="Auto Gacha stopped.", Time=3 })
            end
        end,
    })
end

-- ── Auto Swords ───────────────────────────
do
    local aas_SwordGroup = aas_Tabs.Gacha:AddRightGroupbox("Auto Swords", "sword")
    aas_SwordGroup:AddLabel("Roll regular swords or summer swords independently.", true)
    aas_SwordGroup:AddDivider()

    -- Auto Fuse All
    aas_SwordGroup:AddToggle("AutoFuseAll", {
        Text    = "Auto Fuse All Swords",
        Tooltip = "Automatically fires the fuse-all remote every 5 seconds",
        Default = false,
        Callback = function(value)
            aas_autoFuseAllEnabled = value
            if value then
                if aas_fuseAllThread then task.cancel(aas_fuseAllThread) end
                aas_fuseAllThread = task.spawn(aas_fuseAllLoop)
                UILibrary:Notify({ Title = "Auto Fuse All", Description = "Enabled! (every 5s)", Time = 4 })
            else
                if aas_fuseAllThread then task.cancel(aas_fuseAllThread) aas_fuseAllThread = nil end
                UILibrary:Notify({ Title = "Auto Fuse All", Description = "Disabled.", Time = 3 })
            end
        end,
    })

    aas_SwordGroup:AddDivider()

    -- Regular Sword (World0)
    aas_SwordGroup:AddToggle("AutoSword_World0", {
        Text    = "Auto Roll: Sword (World0)",
        Tooltip = "Automatically roll regular swords (World0) continuously",
        Default = false,
        Callback = function(value)
            aas_swordWorld0Enabled = value
            if value then
                if aas_swordWorld0Thread then task.cancel(aas_swordWorld0Thread) end
                aas_swordWorld0Thread = task.spawn(aas_swordWorld0Loop)
                UILibrary:Notify({ Title = "Auto Sword (World0)", Description = "Started!", Time = 3 })
            else
                aas_swordWorld0Enabled = false
                if aas_swordWorld0Thread then task.cancel(aas_swordWorld0Thread) aas_swordWorld0Thread = nil end
                UILibrary:Notify({ Title = "Auto Sword (World0)", Description = "Stopped.", Time = 3 })
            end
        end,
    })

    -- Summer Sword (World8)
    aas_SwordGroup:AddToggle("AutoSword_World8", {
        Text    = "Auto Roll: Summer Sword (World8)",
        Tooltip = "Automatically roll summer swords (World8) continuously",
        Default = false,
        Callback = function(value)
            aas_swordWorld8Enabled = value
            if value then
                if aas_swordWorld8Thread then task.cancel(aas_swordWorld8Thread) end
                aas_swordWorld8Thread = task.spawn(aas_swordWorld8Loop)
                UILibrary:Notify({ Title = "Auto Summer Sword (World8)", Description = "Started!", Time = 3 })
            else
                aas_swordWorld8Enabled = false
                if aas_swordWorld8Thread then task.cancel(aas_swordWorld8Thread) aas_swordWorld8Thread = nil end
                UILibrary:Notify({ Title = "Auto Summer Sword (World8)", Description = "Stopped.", Time = 3 })
            end
        end,
    })
end

-- ── Auto Player Passive ───────────────────
do
    local aas_PassiveGroup = aas_Tabs.Gacha:AddRightGroupbox("Auto Player Passive", "shield")
    local passiveText    = "Active: None"
    if aas_activePassiveData then
        passiveText = "Active: "..aas_activePassiveData.Name.." | "..aas_activePassiveData.Rarity
    end
    local passiveLabelObj = aas_PassiveGroup:AddLabel(passiveText, false, "PassiveActiveLabel")
    aas_passiveLabelRef = Options["PassiveActiveLabel"] or passiveLabelObj

    aas_PassiveGroup:AddToggle("AutoPassiveEnabled", {
        Text    = "Enable Auto Passive Roll",
        Tooltip = "Automatically roll Player Passive continuously",
        Default = false,
        Callback = function(value)
            aas_passiveAutoEnabled = value
            if value then
                if aas_passiveThread then task.cancel(aas_passiveThread) end
                aas_passiveThread = task.spawn(aas_passiveLoop)
                UILibrary:Notify({ Title="Auto Player Passive", Description="Started!", Time=3 })
            else
                if aas_passiveThread then task.cancel(aas_passiveThread) aas_passiveThread = nil end
                UILibrary:Notify({ Title="Auto Player Passive", Description="Stopped.", Time=3 })
            end
        end,
    })
end

-- ── Auto Titan ────────────────────────────
do
    local aas_TitanGroup = aas_Tabs.Gacha:AddRightGroupbox("Auto Titan", "zap")
    local titanLabelObj = aas_TitanGroup:AddLabel("Active Titan: None", false, "TitanActiveLabel")
    aas_titanLabelRef = Options["TitanActiveLabel"] or titanLabelObj

    aas_TitanGroup:AddToggle("AutoTitanEnabled", {
        Text    = "Enable Auto Titan Roll",
        Tooltip = "Automatically roll Titans (World4) continuously",
        Default = false,
        Callback = function(value)
            aas_titanAutoEnabled = value
            if value then
                if aas_titanThread then task.cancel(aas_titanThread) end
                aas_titanThread = task.spawn(aas_titanLoop)
                UILibrary:Notify({ Title="Auto Titan", Description="Started!", Time=3 })
            else
                if aas_titanThread then task.cancel(aas_titanThread) aas_titanThread = nil end
                UILibrary:Notify({ Title="Auto Titan", Description="Stopped.", Time=3 })
            end
        end,
    })
end

-- ── Auto Sword Passive 1 ─────────────────
do
    local aas_SP1Group = aas_Tabs.Gacha:AddRightGroupbox("Auto Sword Passive (Sword 1)", "wind")
    local sp1InfoObj = aas_SP1Group:AddLabel("Sword 1: Loading...", false, "SwordPassive1InfoLabel")
    aas_sword1InfoLabelRef = Options["SwordPassive1InfoLabel"] or sp1InfoObj
    local sp1BreathObj = aas_SP1Group:AddLabel("Breathing: None", false, "SwordPassive1BreathLabel")
    aas_sword1BreathingLabelRef = Options["SwordPassive1BreathLabel"] or sp1BreathObj

    aas_SP1Group:AddDropdown("SwordPassive1StopRarities", {
        Values     = aas_SwordPassiveRarityOrder,
        Multi      = true,
        Default    = nil,
        Text       = "Stop at Breathing Rarity",
        Tooltip    = "Stop rolling when breathing reaches any selected rarity. Empty = roll forever.",
        Searchable = false,
        Callback   = function(_) end,
    })
    aas_SP1Group:AddToggle("AutoSwordPassive1Enabled", {
        Text    = "Enable Auto Roll (Sword 1)",
        Tooltip = "Automatically roll sword passive for your first equipped sword",
        Default = false,
        Callback = function(value)
            aas_swordPassive1Enabled = value
            if value then
                if aas_swordPassive1Thread then task.cancel(aas_swordPassive1Thread) end
                aas_swordPassive1Thread = task.spawn(aas_swordPassive1Loop)
                UILibrary:Notify({ Title="Sword Passive 1", Description="Started!", Time=3 })
            else
                if aas_swordPassive1Thread then task.cancel(aas_swordPassive1Thread) aas_swordPassive1Thread = nil end
                UILibrary:Notify({ Title="Sword Passive 1", Description="Stopped.", Time=3 })
            end
        end,
    })
end

-- ── Auto Sword Passive 2 ─────────────────
do
    local aas_SP2Group = aas_Tabs.Gacha:AddRightGroupbox("Auto Sword Passive (Sword 2)", "wind")
    local sp2InfoObj = aas_SP2Group:AddLabel("Sword 2: Loading...", false, "SwordPassive2InfoLabel")
    aas_sword2InfoLabelRef = Options["SwordPassive2InfoLabel"] or sp2InfoObj
    local sp2BreathObj = aas_SP2Group:AddLabel("Breathing: None", false, "SwordPassive2BreathLabel")
    aas_sword2BreathingLabelRef = Options["SwordPassive2BreathLabel"] or sp2BreathObj

    aas_SP2Group:AddDropdown("SwordPassive2StopRarities", {
        Values     = aas_SwordPassiveRarityOrder,
        Multi      = true,
        Default    = nil,
        Text       = "Stop at Breathing Rarity",
        Tooltip    = "Stop rolling when breathing reaches any selected rarity. Empty = roll forever.",
        Searchable = false,
        Callback   = function(_) end,
    })
    aas_SP2Group:AddToggle("AutoSwordPassive2Enabled", {
        Text    = "Enable Auto Roll (Sword 2)",
        Tooltip = "Automatically roll sword passive for your second equipped sword",
        Default = false,
        Callback = function(value)
            aas_swordPassive2Enabled = value
            if value then
                if aas_swordPassive2Thread then task.cancel(aas_swordPassive2Thread) end
                aas_swordPassive2Thread = task.spawn(aas_swordPassive2Loop)
                UILibrary:Notify({ Title="Sword Passive 2", Description="Started!", Time=3 })
            else
                if aas_swordPassive2Thread then task.cancel(aas_swordPassive2Thread) aas_swordPassive2Thread = nil end
                UILibrary:Notify({ Title="Sword Passive 2", Description="Stopped.", Time=3 })
            end
        end,
    })
end

-- ── Auto Grimoire Slot 1 ──────────────────
do
    local aas_G1Group = aas_Tabs.Gacha:AddRightGroupbox("Auto Grimoires (Slot 1)", "book-open")
    local g1LabelObj = aas_G1Group:AddLabel("Slot 1: None", false, "Grimoire1Label")
    aas_grimoire1LabelRef = Options["Grimoire1Label"] or g1LabelObj

    aas_G1Group:AddToggle("AutoGrimoire1Enabled", {
        Text    = "Enable Auto Roll (Slot 1)",
        Tooltip = "Automatically roll Grimoire Slot 1 (World7) — stops at Divine",
        Default = false,
        Callback = function(value)
            aas_grimoire1Enabled = value
            if value then
                if aas_grimoire1Thread then task.cancel(aas_grimoire1Thread) end
                aas_grimoire1Thread = task.spawn(aas_grimoire1Loop)
                UILibrary:Notify({ Title="Auto Grimoire Slot 1", Description="Started!", Time=3 })
            else
                if aas_grimoire1Thread then task.cancel(aas_grimoire1Thread) aas_grimoire1Thread = nil end
                UILibrary:Notify({ Title="Auto Grimoire Slot 1", Description="Stopped.", Time=3 })
            end
        end,
    })
end

-- ── Auto Grimoire Slot 2 ──────────────────
do
    local aas_G2Group = aas_Tabs.Gacha:AddRightGroupbox("Auto Grimoires (Slot 2)", "book-open")
    local g2LabelObj = aas_G2Group:AddLabel("Slot 2: None", false, "Grimoire2Label")
    aas_grimoire2LabelRef = Options["Grimoire2Label"] or g2LabelObj

    aas_G2Group:AddToggle("AutoGrimoire2Enabled", {
        Text    = "Enable Auto Roll (Slot 2)",
        Tooltip = "Automatically roll Grimoire Slot 2 (World7) — stops at Divine",
        Default = false,
        Callback = function(value)
            aas_grimoire2Enabled = value
            if value then
                if aas_grimoire2Thread then task.cancel(aas_grimoire2Thread) end
                aas_grimoire2Thread = task.spawn(aas_grimoire2Loop)
                UILibrary:Notify({ Title="Auto Grimoire Slot 2", Description="Started!", Time=3 })
            else
                if aas_grimoire2Thread then task.cancel(aas_grimoire2Thread) aas_grimoire2Thread = nil end
                UILibrary:Notify({ Title="Auto Grimoire Slot 2", Description="Stopped.", Time=3 })
            end
        end,
    })
end

-- ══════════════════════════════════════════
--   AUTO PROGRESSION TAB
-- ══════════════════════════════════════════
local aas_ProgInfoGroup = aas_Tabs.Progression:AddLeftGroupbox("Auto Progressions", "trending-up")
aas_ProgInfoGroup:AddLabel("Each auto progression can be run simultaneously.", true)
aas_ProgInfoGroup:AddLabel("Auto stops at max level.", true)
aas_ProgInfoGroup:AddDivider()

for _, progKey in ipairs(aas_sortedProgressionKeys) do
    local progData  = aas_ProgressionList[progKey]
    local toggleKey = "AutoProgression_"..progKey
    aas_progressionEnabled[progKey] = false

    local worldId    = progData.WorldId or (tonumber(progKey:match("%d+")) or 0)
    local worldLabel = aas_getWorldLabel(worldId)
    local aas_ProgGroup = aas_Tabs.Progression:AddLeftGroupbox(worldLabel, "zap")

    local levelLabelObj = aas_ProgGroup:AddLabel(
        "Level: 0 / "..tostring(progData.MaxLevel), false, "ProgLevel_"..progKey
    )
    aas_progressionLevelLabelRefs[progKey] = Options["ProgLevel_"..progKey] or levelLabelObj

    aas_ProgGroup:AddToggle(toggleKey, {
        Text    = "Enable Auto Upgrade",
        Tooltip = "Automatically upgrade "..progData.Name.." until max level",
        Default = false,
        Callback = function(value)
            aas_progressionEnabled[progKey] = value
            if value then
                if aas_progressionThreads[progKey] then task.cancel(aas_progressionThreads[progKey]) end
                aas_progressionThreads[progKey] = task.spawn(function() aas_progressionLoop(progKey) end)
                UILibrary:Notify({ Title=progData.Name, Description="Auto Progression started!", Time=3 })
            else
                if aas_progressionThreads[progKey] then task.cancel(aas_progressionThreads[progKey]) aas_progressionThreads[progKey] = nil end
                UILibrary:Notify({ Title=progData.Name, Description="Auto Progression stopped.", Time=3 })
            end
        end,
    })
end

-- ── Auto Upgrades (Right side) ────────────
local aas_UpgradeInfoGroup = aas_Tabs.Progression:AddRightGroupbox("Auto Upgrades", "zap")
aas_UpgradeInfoGroup:AddLabel("Select a stat and enable to auto-upgrade.", true)
aas_UpgradeInfoGroup:AddDivider()

for _, sysKey in ipairs(aas_sortedUpgradeSystemKeys) do
    local sysData    = aas_UpgradeSystemList[sysKey]
    local worldLabel = aas_getWorldLabel(sysData.WorldId or 0)
    local statDropKey   = "UpgradeStat_"..sysKey
    local upgradeTogKey = "AutoUpgrade_"..sysKey

    -- Each system gets its own groupbox inside the right side
    local aas_UpgradeGroup = aas_Tabs.Progression:AddRightGroupbox(worldLabel.." Upgrades", "arrow-up")

    local currentStatForSys = { value = "Power" }

    aas_UpgradeGroup:AddDropdown(statDropKey, {
        Values   = aas_UpgradeStatKeys,
        Default  = 1,
        Text     = "Stat to Upgrade",
        Tooltip  = "Select which stat to auto-upgrade for "..sysData.Name,
        Callback = function(val) currentStatForSys.value = val end,
    })

    aas_UpgradeGroup:AddToggle(upgradeTogKey, {
        Text    = "Enable Auto Upgrade",
        Tooltip = "Automatically upgrade selected stat for "..sysData.Name,
        Default = false,
        Callback = function(value)
            if value then
                local thread = task.spawn(function()
                    while Toggles[upgradeTogKey] and Toggles[upgradeTogKey].Value do
                        pcall(function() aas_upgradesRequestRemote:Fire(sysKey, currentStatForSys.value) end)
                        task.wait(1.0)
                    end
                end)
                if aas_rangeUpgradeThreads["upgrade_"..sysKey] then
                    task.cancel(aas_rangeUpgradeThreads["upgrade_"..sysKey])
                end
                aas_rangeUpgradeThreads["upgrade_"..sysKey] = thread
                UILibrary:Notify({ Title=sysData.Name, Description="Auto Upgrade started!", Time=3 })
            else
                local t = aas_rangeUpgradeThreads["upgrade_"..sysKey]
                if t then task.cancel(t) aas_rangeUpgradeThreads["upgrade_"..sysKey] = nil end
                UILibrary:Notify({ Title=sysData.Name, Description="Auto Upgrade stopped.", Time=3 })
            end
        end,
    })

    -- Range Upgrade is INSIDE the same groupbox (fixed layout)
    local rangeTogKey = "AutoRangeUpgrade_"..sysKey
    aas_rangeUpgradeEnabled[sysKey] = false

    aas_UpgradeGroup:AddDivider()
    aas_UpgradeGroup:AddToggle(rangeTogKey, {
        Text    = "Enable Auto Range Upgrade",
        Tooltip = "Automatically fire RangeUpgradeRequest for "..sysData.Name,
        Default = false,
        Callback = function(value)
            aas_rangeUpgradeEnabled[sysKey] = value
            if value then
                if aas_rangeUpgradeThreads[sysKey] then task.cancel(aas_rangeUpgradeThreads[sysKey]) end
                aas_rangeUpgradeThreads[sysKey] = task.spawn(function() aas_rangeUpgradeLoop(sysKey) end)
                UILibrary:Notify({ Title=sysData.Name.." Range", Description="Auto Range Upgrade started!", Time=3 })
            else
                if aas_rangeUpgradeThreads[sysKey] then task.cancel(aas_rangeUpgradeThreads[sysKey]) aas_rangeUpgradeThreads[sysKey] = nil end
                UILibrary:Notify({ Title=sysData.Name.." Range", Description="Auto Range Upgrade stopped.", Time=3 })
            end
        end,
    })
end

-- ══════════════════════════════════════════
--   AUTO STAR TAB
-- ══════════════════════════════════════════
local aas_StarInfoGroup = aas_Tabs.Star:AddLeftGroupbox("Auto Star", "star")
aas_StarInfoGroup:AddLabel("Automatically opens eggs from the selected world.", true)
aas_StarInfoGroup:AddDivider()

local aas_starWorldDisplayNames = {}
local aas_starWorldDisplayToKey = {}
for _, key in ipairs(aas_sortedStarWorldKeys) do
    local worldData   = aas_StarWorldList[key]
    local displayName = aas_getWorldLabel(worldData.WorldId)
    table.insert(aas_starWorldDisplayNames, displayName)
    aas_starWorldDisplayToKey[displayName] = key
end

if #aas_sortedStarWorldKeys > 0 then
    aas_starEggKey = aas_sortedStarWorldKeys[1]
end

local aas_StarControlGroup = aas_Tabs.Star:AddLeftGroupbox("Star Control", "zap")
if #aas_starWorldDisplayNames > 0 then
    aas_StarControlGroup:AddDropdown("StarWorldSelect", {
        Values     = aas_starWorldDisplayNames,
        Default    = 1,
        Text       = "Select World (Egg)",
        Tooltip    = "Choose which world's egg to open",
        Searchable = #aas_starWorldDisplayNames > 5,
        Callback   = function(val)
            local key = aas_starWorldDisplayToKey[val]
            if key then
                aas_starEggKey = key
                UILibrary:Notify({ Title="Auto Star", Description="Selected: "..val, Time=2 })
            end
        end,
    })
else
    aas_StarControlGroup:AddLabel("No worlds found in config.", true)
end

aas_StarControlGroup:AddToggle("AutoStarEnabled", {
    Text    = "Enable Auto Star Roll",
    Tooltip = "Automatically open eggs for the selected world",
    Default = false,
    Callback = function(value)
        aas_starEnabled = value
        if value then
            if not aas_starEggKey then
                Toggles["AutoStarEnabled"]:SetValue(false)
                UILibrary:Notify({ Title="Auto Star", Description="No world selected!", Time=4 })
                return
            end
            if aas_starThread then task.cancel(aas_starThread) aas_starThread = nil end
            aas_starThread = task.spawn(aas_starLoop)
            UILibrary:Notify({ Title="Auto Star", Description="Started rolling "..(aas_starEggKey or "?"), Time=3 })
        else
            if aas_starThread then task.cancel(aas_starThread) aas_starThread = nil end
            UILibrary:Notify({ Title="Auto Star", Description="Stopped.", Time=3 })
        end
    end,
})

-- ── Auto Craft ────────────────────────────
local aas_CraftInfoGroup = aas_Tabs.Star:AddRightGroupbox("Auto Craft", "hammer")
aas_CraftInfoGroup:AddLabel("Automatically crafts pets for selected worlds.", true)
aas_CraftInfoGroup:AddLabel("Enable Shiny to craft shiny variants.", true)
aas_CraftInfoGroup:AddDivider()

for _, craftKey in ipairs(aas_sortedCraftKeys) do
    local craftData = aas_CraftList[craftKey]
    local toggleKey = "AutoCraft_"..craftKey
    local shinyKey  = "AutoCraftShiny_"..craftKey
    aas_craftEnabled[craftKey] = false
    aas_craftShiny[craftKey]   = false

    local worldLabel = aas_getWorldLabel(craftData.WorldId or 0)
    local aas_CraftGroup = aas_Tabs.Star:AddRightGroupbox(craftKey.." ("..worldLabel..")", "zap")

    aas_CraftGroup:AddToggle(shinyKey, {
        Text    = "Craft Shiny",
        Tooltip = "Enable to craft shiny version (costs more items)",
        Default = false,
        Callback = function(value) aas_craftShiny[craftKey] = value end,
    })
    aas_CraftGroup:AddToggle(toggleKey, {
        Text    = "Enable Auto Craft",
        Tooltip = "Automatically craft "..craftKey.." continuously",
        Default = false,
        Callback = function(value)
            aas_craftEnabled[craftKey] = value
            if value then
                if aas_craftThreads[craftKey] then task.cancel(aas_craftThreads[craftKey]) end
                aas_craftThreads[craftKey] = task.spawn(function() aas_craftLoop(craftKey) end)
                UILibrary:Notify({ Title=craftKey, Description="Auto Craft started!", Time=3 })
            else
                if aas_craftThreads[craftKey] then task.cancel(aas_craftThreads[craftKey]) aas_craftThreads[craftKey] = nil end
                UILibrary:Notify({ Title=craftKey, Description="Auto Craft stopped.", Time=3 })
            end
        end,
    })
end

-- ══════════════════════════════════════════
--   SETTINGS TAB
-- ══════════════════════════════════════════
local aas_MenuGroup = aas_Tabs.Settings:AddLeftGroupbox("Menu Settings", "settings")

aas_MenuGroup:AddToggle("KeybindMenuOpen", {
    Default  = UILibrary.KeybindFrame.Visible,
    Text     = "Show Keybind Menu",
    Callback = function(value) UILibrary.KeybindFrame.Visible = value end,
})
aas_MenuGroup:AddToggle("ShowCustomCursor", {
    Text     = "Custom Cursor",
    Default  = true,
    Callback = function(Value) UILibrary.ShowCustomCursor = Value end,
})
aas_MenuGroup:AddDropdown("NotificationSide", {
    Values   = { "Left", "Right" },
    Default  = "Right",
    Text     = "Notification Side",
    Callback = function(value) UILibrary:SetNotifySide(value) end,
})
aas_MenuGroup:AddLabel("Menu Keybind"):AddKeyPicker("MenuKeybind", {
    Default = "G",
    NoUI    = true,
    Text    = "Menu toggle keybind",
})
aas_MenuGroup:AddButton({
    Text    = "Unload Script",
    Tooltip = "Completely unload the script",
    Func    = function()
        aas_cleanup()
        UILibrary:Unload()
    end,
})

UILibrary.ToggleKeybind = Options.MenuKeybind

-- ══════════════════════════════════════════
--   THEME AND SAVE MANAGERS
-- ══════════════════════════════════════════
ThemeManager:SetLibrary(UILibrary)
SaveManager:SetLibrary(UILibrary)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })
ThemeManager:SetFolder("IBdihPHub/AnimeAstralSimulator")
SaveManager:SetFolder("IBdihPHub/AnimeAstralSimulator/Settings")
SaveManager:BuildConfigSection(aas_Tabs.Settings)
ThemeManager:ApplyToTab(aas_Tabs.Settings)
SaveManager:LoadAutoloadConfig()

-- ══════════════════════════════════════════
--   CLEANUP ON UNLOAD
-- ══════════════════════════════════════════
UILibrary:OnUnload(aas_cleanup)

-- ══════════════════════════════════════════
--   FINAL NOTIFICATION
-- ══════════════════════════════════════════
UILibrary:Notify({
    Title       = "Script Loaded",
    Description = "Anime Astral Simulator v2.1 is ready!",
    Time        = 5,
})

