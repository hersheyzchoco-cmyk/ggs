local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Options = Library.Options
local Toggles = Library.Toggles

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer

-- Remote Events Setup
local SharedEvents = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Events")
local collectPlotRemote = SharedEvents:WaitForChild("CollectPlot")
local buyPackRemote = SharedEvents:WaitForChild("BuyPack")
local stickCardRemote = SharedEvents:WaitForChild("StickCard")
local openPackRemote = SharedEvents:WaitForChild("OpenPack")
local sellAllDupesRemote = SharedEvents:WaitForChild("SellAllDupes")
local equipBestRemote = SharedEvents:WaitForChild("EquipBest")

-- State variables
local autoCollectRunning = false
local autoBuyRunning = false
local autoOpenRunning = false
local autoStickRunning = false
local autoSellRunning = false
local autoEquipRunning = false
local antiAfkRunning = false

-- Pack mappings
local packDisplayToInternal = {
    ["World Cup Pack"] = "pack_bronze",
    ["Pack Box"] = "pack_silver", 
    ["Pack Bundle"] = "pack_gold",
    ["Pack Set"] = "pack_robux"
}

local packInternalToDisplay = {
    ["pack_bronze"] = "World Cup Pack",
    ["pack_silver"] = "Pack Box",
    ["pack_gold"] = "Pack Bundle",
    ["pack_robux"] = "Pack Set"
}

-- Helper Functions
local function getGridContainer()
    local success, result = pcall(function()
        return LocalPlayer.PlayerGui.GUI.IndexPanelNew.GridContainer.Grid
    end)
    return success and result or nil
end

local function getPackStock(packType)
    local success, result = pcall(function()
        local shopFrame = LocalPlayer.PlayerGui.GUI.PackShopPanel.ScrollingFrame
        local packFrameName = ""
        
        -- Map pack type to frame name
        if packType == "pack_bronze" then
            return 999 -- World Cup Pack is always unlimited
        elseif packType == "pack_silver" then
            packFrameName = "SilverPack" 
        elseif packType == "pack_gold" then
            packFrameName = "GoldPack"
        end
        
        if packFrameName ~= "" then
            local packFrame = shopFrame:FindFirstChild(packFrameName)
            if packFrame then
                local stockLabel = packFrame:FindFirstChild("PackInStock")
                if stockLabel then
                    local stockText = stockLabel.Text
                    -- Check if it says "Out of Stock"
                    if stockText:lower():find("out of stock") then
                        return 0
                    end
                    -- Extract number from text like "5x In Stock"
                    local stock = tonumber(stockText:match("%d+"))
                    return stock or 0
                end
            end
        end
        
        return 0
    end)
    return success and result or 0
end

local function canStickCard(cardFrame)
    local success, result = pcall(function()
        local sellButton = cardFrame:FindFirstChild("SellButton")
        if sellButton then
            local btnLabel = sellButton:FindFirstChild("BtnLabel")
            if btnLabel then
                -- Only stick if the button says "Label", not "SELL $XX"
                return btnLabel.Text == "Label"
            end
        end
        return false
    end)
    return success and result or false
end

local function extractCardId(frameName)
    -- Extract card ID from frame name like "Inv_germany_p02" -> "germany_p02"
    if frameName:sub(1, 4) == "Inv_" then
        return frameName:sub(5) -- Remove "Inv_" prefix
    end
    return frameName
end

-- Automation Functions
local function autoCollectMoney()
    spawn(function()
        while autoCollectRunning do
            for i = 1, 10 do
                if not autoCollectRunning then break end
                
                local success, err = pcall(function()
                    collectPlotRemote:FireServer(tostring(i))
                end)
                
                if not success then
                    warn("Failed to collect plot " .. i .. ": " .. tostring(err))
                end
                
                wait(0.1)
            end
            wait(2)
        end
    end)
end

local function autoBuyPacks()
    spawn(function()
        while autoBuyRunning do
            local selectedPacks = Options.BuyPackTypes.Value
            
            for packDisplay, enabled in pairs(selectedPacks) do
                if not autoBuyRunning then break end
                
                if enabled then
                    local packType = packDisplayToInternal[packDisplay]
                    if packType then
                        local stock = getPackStock(packType)
                        
                        if stock > 0 then
                            local success, err = pcall(function()
                                local args = { packType }
                                buyPackRemote:FireServer(unpack(args))
                            end)
                            
                            if not success then
                                warn("Failed to buy " .. packDisplay .. ": " .. tostring(err))
                            end
                        end
                    end
                end
                
                wait(0.25)
            end
            wait(0.25)
        end
    end)
end

local function autoOpenPacks()
    spawn(function()
        while autoOpenRunning do
            local selectedPacks = Options.OpenPackTypes.Value
            
            for packDisplay, enabled in pairs(selectedPacks) do
                if not autoOpenRunning then break end
                
                if enabled then
                    local packType = packDisplayToInternal[packDisplay]
                    if packType then
                        local success, err = pcall(function()
                            local args = { packType }
                            openPackRemote:FireServer(unpack(args))
                        end)
                        
                        if not success then
                            warn("Failed to open " .. packDisplay .. ": " .. tostring(err))
                        end
                        
                        wait(0.1)
                    end
                end
            end
            wait(0.1)
        end
    end)
end

local function autoStickCards()
    spawn(function()
        while autoStickRunning do
            local gridContainer = getGridContainer()
            
            if gridContainer then
                for _, cardFrame in pairs(gridContainer:GetChildren()) do
                    if not autoStickRunning then break end
                    
                    if cardFrame:IsA("Frame") and cardFrame.Name:sub(1, 4) == "Inv_" then
                        if canStickCard(cardFrame) then
                            local cardId = extractCardId(cardFrame.Name)
                            
                            local success, err = pcall(function()
                                local args = { cardId }
                                stickCardRemote:FireServer(unpack(args))
                            end)
                            
                            if not success then
                                warn("Failed to stick card " .. cardId .. ": " .. tostring(err))
                            end
                            
                            wait(0.1)
                        end
                    end
                end
            end
            wait(0.25)
        end
    end)
end

local function autoSellDuplicates()
    spawn(function()
        while autoSellRunning do
            local success, err = pcall(function()
                sellAllDupesRemote:FireServer()
            end)
            
            if not success then
                warn("Failed to sell duplicates: " .. tostring(err))
            end
            
            wait(5)
        end
    end)
end

local function autoEquipBest()
    spawn(function()
        while autoEquipRunning do
            local success, err = pcall(function()
                equipBestRemote:FireServer()
            end)
            
            if not success then
                warn("Failed to equip best: " .. tostring(err))
            end
            
            wait(1)
        end
    end)
end

local function antiAfk()
    spawn(function()
        while antiAfkRunning do
            local success, err = pcall(function()
                VirtualInputManager:SendKeyEvent(true, "Q", false, game)
                wait(0.1)
                VirtualInputManager:SendKeyEvent(false, "Q", false, game)
            end)
            
            if not success then
                warn("Failed to send anti-AFK input: " .. tostring(err))
            end
            
            wait(60)
        end
    end)
end

-- UI Setup
local Window = Library:CreateWindow({
    Title = "IBDihP Hub",
    Footer = "By Hersheys - Version 3.0",
    MobileButtonSide = "Right",
    Icon = 114748833858413,
    NotifySide = "Right",
    ShowCustomCursor = true,
})

local Tabs = {
    Main = Window:AddTab("Main", "star"),
    Settings = Window:AddTab("Settings", "settings"),
}

-- Full Width Discord Banner
local BannerGroup = Tabs.Main:AddLeftGroupbox("🌐 JOIN DISCORD FOR ACTIVE COMMUNITY", "users")
BannerGroup:AddLabel("Suggestions • Bug Fixes • Updates • Community Support", true)
BannerGroup:AddButton({
    Text = "📋 COPY DISCORD INVITE LINK",
    Func = function()
        setclipboard("https://discord.gg/dhecnztyph")
        Library:Notify({
            Title = "Discord Invite Copied!",
            Description = "Paste the link in your browser to join our community",
            Time = 4,
        })
    end,
    Tooltip = "Copy Discord invite to clipboard",
})
BannerGroup:AddDivider()

-- Main Tab
local CollectGroup = Tabs.Main:AddLeftGroupbox("Collection", "coins")

CollectGroup:AddToggle("AutoCollect", {
    Text = "Auto Collect Money",
    Tooltip = "Automatically collects money from plots 1-10",
    Default = false,
    Callback = function(Value)
        autoCollectRunning = Value
        if Value then
            autoCollectMoney()
            Library:Notify({
                Title = "Auto Collect",
                Description = "Started collecting money from plots",
                Time = 3,
            })
        end
    end,
})

CollectGroup:AddToggle("AutoSell", {
    Text = "Auto Sell Duplicates",
    Tooltip = "Automatically sells duplicate cards every 5 seconds",
    Default = false,
    Callback = function(Value)
        autoSellRunning = Value
        if Value then
            autoSellDuplicates()
            Library:Notify({
                Title = "Auto Sell",
                Description = "Started selling duplicate cards",
                Time = 3,
            })
        end
    end,
})

CollectGroup:AddToggle("AutoEquip", {
    Text = "Auto Equip Best",
    Tooltip = "Automatically equips best cards every 1 second",
    Default = false,
    Callback = function(Value)
        autoEquipRunning = Value
        if Value then
            autoEquipBest()
            Library:Notify({
                Title = "Auto Equip",
                Description = "Started equipping best cards",
                Time = 3,
            })
        end
    end,
})

CollectGroup:AddToggle("AntiAFK", {
    Text = "Anti AFK",
    Tooltip = "Prevents AFK by sending Q key input every 60 seconds",
    Default = false,
    Callback = function(Value)
        antiAfkRunning = Value
        if Value then
            antiAfk()
            Library:Notify({
                Title = "Anti AFK",
                Description = "Started anti-AFK system",
                Time = 3,
            })
        end
    end,
})

-- Pack Management
local PackGroup = Tabs.Main:AddRightGroupbox("Pack Management", "package")

PackGroup:AddDropdown("BuyPackTypes", {
    Values = { "World Cup Pack", "Pack Box", "Pack Bundle" },
    Default = {},
    Multi = true,
    Text = "Auto Buy Pack Types",
    Tooltip = "Select which pack types to automatically buy",
    Callback = function(Value)
        -- Value is a table of selected options
    end,
})

PackGroup:AddToggle("AutoBuy", {
    Text = "Auto Buy Packs",
    Tooltip = "Automatically buys selected pack types when in stock",
    Default = false,
    Callback = function(Value)
        autoBuyRunning = Value
        if Value then
            local selectedCount = 0
            for _, enabled in pairs(Options.BuyPackTypes.Value) do
                if enabled then selectedCount = selectedCount + 1 end
            end
            
            if selectedCount == 0 then
                Library:Notify({
                    Title = "Auto Buy",
                    Description = "Please select pack types to buy first!",
                    Time = 4,
                })
                Toggles.AutoBuy:SetValue(false)
                return
            end
            
            autoBuyPacks()
            Library:Notify({
                Title = "Auto Buy",
                Description = "Started buying selected pack types",
                Time = 3,
            })
        end
    end,
})

PackGroup:AddDropdown("OpenPackTypes", {
    Values = { "World Cup Pack", "Pack Box", "Pack Bundle", "Pack Set" },
    Default = {},
    Multi = true,
    Text = "Auto Open Pack Types",
    Tooltip = "Select which pack types to automatically open",
    Callback = function(Value)
        -- Value is a table of selected options
    end,
})

PackGroup:AddToggle("AutoOpen", {
    Text = "Auto Open Packs",
    Tooltip = "Automatically opens selected pack types repeatedly",
    Default = false,
    Callback = function(Value)
        autoOpenRunning = Value
        if Value then
            local selectedCount = 0
            for _, enabled in pairs(Options.OpenPackTypes.Value) do
                if enabled then selectedCount = selectedCount + 1 end
            end
            
            if selectedCount == 0 then
                Library:Notify({
                    Title = "Auto Open",
                    Description = "Please select pack types to open first!",
                    Time = 4,
                })
                Toggles.AutoOpen:SetValue(false)
                return
            end
            
            autoOpenPacks()
            Library:Notify({
                Title = "Auto Open",
                Description = "Started opening selected pack types",
                Time = 3,
            })
        end
    end,
})

PackGroup:AddToggle("AutoStick", {
    Text = "Auto Stick Cards",
    Tooltip = "Automatically sticks non-duplicate cards (Requires Inventory to be open)",
    Default = false,
    Callback = function(Value)
        autoStickRunning = Value
        if Value then
            autoStickCards()
            Library:Notify({
                Title = "Auto Stick",
                Description = "Started sticking cards - Make sure Inventory is open!",
                Time = 4,
            })
        end
    end,
})

-- Stock Display
local StockGroup = Tabs.Main:AddLeftGroupbox("Stock Status", "info")
local stockLabels = {
    Bronze = StockGroup:AddLabel("World Cup Pack: ∞ In Stock", true),
    Silver = StockGroup:AddLabel("Pack Box: Checking...", true), 
    Gold = StockGroup:AddLabel("Pack Bundle: Checking...", true)
}

-- Stock checker
spawn(function()
    while true do
        local silverStock = getPackStock("pack_silver")
        local goldStock = getPackStock("pack_gold")
        
        stockLabels.Silver:SetText("Pack Box: " .. (silverStock > 0 and silverStock .. " In Stock" or "Out of Stock"))
        stockLabels.Gold:SetText("Pack Bundle: " .. (goldStock > 0 and goldStock .. " In Stock" or "Out of Stock"))
        
        wait(5)
    end
end)

-- Instructions
local InstructionGroup = Tabs.Main:AddRightGroupbox("Instructions", "info")
InstructionGroup:AddLabel("1. Select pack types in the dropdown menus", true)
InstructionGroup:AddLabel("2. For Auto Stick to work, keep your Inventory open in-game", true)

-- Settings Tab
local MenuGroup = Tabs.Settings:AddLeftGroupbox("Menu Settings", "settings")

MenuGroup:AddToggle("KeybindMenuOpen", {
    Default = Library.KeybindFrame.Visible,
    Text = "Show Keybind Menu",
    Callback = function(value)
        Library.KeybindFrame.Visible = value
    end,
})

MenuGroup:AddDropdown("NotificationSide", {
    Values = { "Left", "Right" },
    Default = "Right",
    Text = "Notification Side",
    Callback = function(Value)
        Library:SetNotifySide(Value)
    end,
})

MenuGroup:AddLabel("Menu Keybind"):AddKeyPicker("MenuKeybind", { 
    Default = "G", 
    NoUI = true, 
    Text = "Menu toggle keybind" 
})

MenuGroup:AddButton({
    Text = "Unload Script",
    Func = function()
        -- Stop all automations
        autoCollectRunning = false
        autoBuyRunning = false
        autoOpenRunning = false
        autoStickRunning = false
        autoSellRunning = false
        autoEquipRunning = false
        antiAfkRunning = false
        
        Library:Unload()
    end,
    Tooltip = "Completely unload the script",
})

Library.ToggleKeybind = Options.MenuKeybind

-- Theme and Save Managers
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })

ThemeManager:SetFolder("WorldCupAlbum")
SaveManager:SetFolder("WorldCupAlbum/Settings")

SaveManager:BuildConfigSection(Tabs.Settings)
ThemeManager:ApplyToTab(Tabs.Settings)

-- Auto-load config
SaveManager:LoadAutoloadConfig()

Library:Notify({
    Title = "Script Loaded",
    Description = "World Cup Album v3.0 is ready!",
    Time = 5,
})

-- Cleanup on unload
Library:OnUnload(function()
    autoCollectRunning = false
    autoBuyRunning = false
    autoOpenRunning = false
    autoStickRunning = false
    autoSellRunning = false
    autoEquipRunning = false
    antiAfkRunning = false
    print("World Cup Album unloaded!")
end)
