local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

local DISCORD_LINK = "https://discord.gg/DHeCNzTypH"
local VALID_KEYS = {"ilyguys"}
local KEY_FILE = "IBdihPHub_SavedKey.txt"
local BASE_URL = "https://raw.githubusercontent.com/hersheyzchoco-cmyk/ggs/refs/heads/main/games/"
local LOBBY_PLACE_IDS = {87810101348327}
local HUB_ICON = "rbxassetid://86226894545369"
local GAME_COUNT = 66

local SCRIPTS = {
    { Name = "+1 Wood per Click", Icon = "🪵", File = "%2B1-wood-per-click.lua", GameId = 112231208081788 },
    { Name = "+1 Slayer Blade", Icon = "🗡️", File = "%2B1-slayer-blade.lua", GameId = 15744137588 },
    
    { Name = "1 Keyboard = 1$/s", Icon = "⌨️", File = "1keyboard%3D1%24s.lua", GameId = 121003786627094 },
    
    { Name = "Airline Idle", Icon = "🛩️", File = "airline-idle.lua", GameId = 70437719899064 },
    { Name = "Anime Astral Simulator", Icon = "🔥", File = "anime-astral-simulator.lua", GameId = 102072869879193 },
    { Name = "Anime Battles", Icon = "🤺", File = "anime-battles.lua", GameId = 126229277218112 },
    { Name = "Anime Capture", Icon = "🖐", File = "anime-capture.lua", GameId = 94717504417144 },
    { Name = "Anime Card Farm", Icon = "🃏", File = "anime-card-farm.lua", GameId = 125039473548047 },
    { Name = "Anime Dimensions Simulator - Battle", Icon = "⚔️", File = "anime-dimensions-simulator.lua", GameId = 6990129309 },
    { Name = "Anime Dimensions Simulator - High Level Lobby", Icon = "⚔️", File = "anime-dimensions-simulator.lua", GameId = 7274690025 },
    { Name = "Anime Dimensions Simulator - Lobby", Icon = "⚔️", File = "anime-dimensions-simulator.lua", GameId = 6938803436 },
    { Name = "Anime Dimensions Simulator - Raid", Icon = "⚔️", File = "anime-dimensions-simulator.lua", GameId = 7338881230 },
    { Name = "Anime Duelists", Icon = "⚔️", File = "anime-duelists.lua", GameId = 135858844777165 },
    { Name = "Anime Dungeons - Boss Rush", Icon = "🏰", File = "anime-dungeons.lua", GameId = 71585686583516 },
    { Name = "Anime Dungeons - Demon Train Dungeon", Icon = "🏰", File = "anime-dungeons.lua", GameId = 127204771568038 },
    { Name = "Anime Dungeons - Frozen Forest Dungeon", Icon = "🏰", File = "anime-dungeons.lua", GameId = 123509790592616 },
    { Name = "Anime Dungeons - Glacial Fortress", Icon = "🏰", File = "anime-dungeons.lua", GameId = 85662046383338 },
    { Name = "Anime Dungeons - Lobby", Icon = "🏰", File = "anime-dungeons-lobby.lua", GameId = 70863683083739 },
    { Name = "Anime Dungeons - Ninja Village Dungeon", Icon = "🏰", File = "anime-dungeons.lua", GameId = 109955310601194 },
    { Name = "Anime Dungeons - Raids", Icon = "🏰", File = "anime-dungeons.lua", GameId = 122377279703567 },
    { Name = "Anime Dungeons - Soul Valley Dungeon", Icon = "🏰", File = "anime-dungeons.lua", GameId = 82475659339476 },
    { Name = "Anime Dungeons - Trials", Icon = "🏰", File = "anime-dungeons.lua", GameId = 70972455539417 },
    { Name = "Anime Powerscaling Card Collection", Icon = "🌟", File = "anime-powerscaling-card-collection.lua", GameId = 85580552562948 },
    { Name = "Anime RNG Defense", Icon = "🏰", File = "anime-rng-defense.lua", GameId = 104693964860826 },
    { Name = "Anime Stars", Icon = "🌠", File = "anime-stars.lua", GameId = 122553263569744 },
    { Name = "Anime Stars Card Collection", Icon = "🌸", File = "anime-stars-card-collection.lua", GameId = 109715918987082 },
    { Name = "Anime Universe", Icon = "🌌", File = "anime-universe.lua", GameId = 95992966043247 },
    
    { Name = "Become an Anime Billionaire", Icon = "💸", File = "become-an-anime-billionaire.lua", GameId = 96891089305948 },
    { Name = "Bomb Fishing", Icon = "🎣", File = "bomb-fishing.lua", GameId = 118677256126351 },
    { Name = "Build a Base and Steal", Icon = "🏯", File = "build-a-base-and-steal.lua", GameId = 132016691802922 },
    { Name = "Build a Base and Steal", Icon = "🏯", File = "build-a-base-and-steal.lua", GameId = 82441325527385 },
    { Name = "Build a Gun Army", Icon = "🔫", File = "build-a-gun-army.lua", GameId = 134162299584012 },
    
    { Name = "Catch and Tame", Icon = "🐒", File = "catch-and-tame.lua", GameId = 96645548064314 },
    { Name = "Chicken Farm", Icon = "🐓", File = "chicken-farm.lua", GameId = 137233438285284 },
    { Name = "Clean the Squishies", Icon = "😻", File = "clean-the-squishies.lua", GameId = 84016394196827 },
    { Name = "Crab Tycoon", Icon = "🦀", File = "crab-tycoon.lua", GameId = 92605157087535 },
    { Name = "Crunch my Butter", Icon = "🧈", File = "crunch-my-butter.lua", GameId = 87555052900625 },
    
    { Name = "Digimon Era", Icon = "🦖", File = "digimon-era.lua", GameId = 77192431769439 },
    { Name = "Dungeon Leveling Origin", Icon = "🏰", File = "dungeon-leveling-origin.lua", GameId = 113526284476060 },
    
    { Name = "Egg Case Farm", Icon = "🥚", File = "egg-case-farm.lua", GameId = 74144293690546 },
    { Name = "Elemental Dungeons - Dungeon", Icon = "🏰", File = "elemental-dungeons.lua", GameId = 10771129745 },
    { Name = "Elemental Dungeons - Raids", Icon = "🏰", File = "elemental-dungeons.lua", GameId = 15278089327 },
    
    { Name = "Fantasy RNG", Icon = "🧚‍♂️", File = "fantasy-rng.lua", GameId = 85167011669131 },
    { Name = "Farm an Island", Icon = "🧑‍🌾", File = "farm-an-island.lua", GameId = 78769336859161 },
    
    { Name = "Grow it RNG", Icon = "🪴", File = "grow-it-rng.lua", GameId = 78292727217500 },
    
    { Name = "Hatch a Dragon", Icon = "🐲", File = "hatch-a-dragon.lua", GameId = 105420216739306 },
    
    { Name = "Jump to Steal Soccer Players", Icon = "⚽️", File = "jump-to-steal-soccer-players.lua", GameId = 133294838637122 },
    
    { Name = "Loot RNG", Icon = "🗡️", File = "loot-rng.lua", GameId = 118575129990331 },
    
    { Name = "Make a Drill Farm", Icon = "⛏️", File = "make-a-drill-farm.lua", GameId = 79315121100812 },
    { Name = "Make Hotsauce", Icon = "🌶️", File = "make-hotsauce.lua", GameId = 122391683154858 },
    { Name = "Merge a Blackhole", Icon = "🪐", File = "merge-a-blackhole.lua", GameId = 118605709428489 },
    { Name = "Mine a Mountain", Icon = "🏔️", File = "mine-a-mountain.lua", GameId = 125927821145949 },
    { Name = "Mine a Planet", Icon = "🌎", File = "mine-a-planet.lua", GameId = 121125129560252 },
    { Name = "Missiles vs Cities", Icon = "🚀", File = "missiles-vs-cities.lua", GameId = 112641748896693 },
    { Name = "Mount RNG", Icon = "🐶", File = "mount-rng.lua", GameId = 133341016381877 },
    { Name = "My Fishing Anime", Icon = "🪝", File = "my-fishing-anime.lua", GameId = 112244246405144 },
    { Name = "My Giant Sandwich", Icon = "🥪", File = "my-giant-sandwich.lua", GameId = 139546619723000 },
    { Name = "My Shrimp Farm", Icon = "🦐", File = "my-shrimp-farm.lua", GameId = 104065269680557 },
    { Name = "My Sword Empire", Icon = "🗡️", File = "my-sword-empire.lua", GameId = 108364799245223 },
    { Name = "My Wood Farm", Icon = "🪵", File = "my-wood-farm.lua", GameId = 79267089300389 },
    
    { Name = "Own a Cafe", Icon = "🍵", File = "own-a-cafe.lua", GameId = 131906518201863 },
    
    { Name = "Pack RNG", Icon = "📦", File = "pack-rng.lua", GameId = 117752943664280 },
    { Name = "Penguin Tycoon", Icon = "🐧", File = "penguin-tycoon.lua", GameId = 89561601601392 },
    { Name = "Place the Keycaps", Icon = "⌨️", File = "place-the-keycaps.lua", GameId = 103984418130080 },
    
    { Name = "RNG Heroes", Icon = "🦸", File = "rng-heroes.lua", GameId = 108307565942574 },
    { Name = "Roll a Keycap", Icon = "⌨️", File = "roll-a-keycap.lua", GameId = 91679585668032 },
    { Name = "Roll Anime", Icon = "🎲", File = "roll-anime.lua", GameId = 107706720875645 },
    { Name = "Roll Anime Fighters", Icon = "🎲", File = "roll-anime-fighters.lua", GameId = 115113242795436 },
    { Name = "Roll to Defend", Icon = "🛡️", File = "roll-to-defend.lua", GameId = 129559579789369 },
    
    { Name = "Scratchy Loot", Icon = "🎰", File = "scratchy-loot.lua", GameId = 78105732598311 },
    { Name = "Snowcone Stand", Icon = "❄️", File = "snowcone-stand.lua", GameId = 76113971506717 },
    { Name = "Soccer Manager", Icon = "🏟️", File = "soccer-manager.lua", GameId = 83988958116126 },
    { Name = "Spin a Car", Icon = "🏎️", File = "spin-a-car.lua", GameId = 136758055891411 },
    { Name = "Spin a Duel Monster", Icon = "🧌", File = "spin-a-duel-monster.lua", GameId = 86789126516616 },
    
    { Name = "Tap Incremental", Icon = "👆", File = "tap-incremental.lua", GameId = 82103875404639 },
    { Name = "Throw a Coin - World 1", Icon = "🪙", File = "throw-a-coin.lua", GameId = 115681808123944 },
    { Name = "Throw a Coin - World 2", Icon = "🪙", File = "throw-a-coin.lua", GameId = 72042130041700 },
    { Name = "Throw a Coin - World 3", Icon = "🪙", File = "throw-a-coin.lua", GameId = 100875131717601 },
    { Name = "Throw a Coin - World 4", Icon = "🪙", File = "throw-a-coin.lua", GameId = 81335362752013 },
    
    { Name = "World Cup Album", Icon = "🏆", File = "world-cup-album.lua", GameId = 71724366181884 },
    
    { Name = "Youtuber Card Collection", Icon = "💻", File = "youtuber-card-collection.lua", GameId = 81440501385895 },
    
    { Name = "Zombie Turret Farm", Icon = "🧟‍♂️", File = "zombie-turret-farm.lua", GameId = 70790155462881 },
}

local BANNED_USERS = {"8kruo"}

-- helper functions
local function trim(s) 
    return s:gsub("^%s+", ""):gsub("%s+$", "") 
end

local function isKeyValid(key)
    if not key or key == "" then return false end
    key = trim(key)
    for _, k in ipairs(VALID_KEYS) do
        if key == k then return true end
    end
    return false
end

local function saveKey(key) 
    pcall(function() 
        if writefile then writefile(KEY_FILE, key) end 
    end) 
end

local function loadKey()
    local ok, res = pcall(function()
        return (isfile and readfile and isfile(KEY_FILE)) and readfile(KEY_FILE) or nil
    end)
    return ok and res or nil
end

local function isLobbyPlace()
    for _, id in ipairs(LOBBY_PLACE_IDS) do
        if game.PlaceId == id then return true end
    end
    return false
end

local function isUserBanned()
    local name = LocalPlayer.Name:lower()
    for _, banned in ipairs(BANNED_USERS) do
        if name == banned:lower() then return true end
    end
    return false
end

local function getGameScript()
    for _, s in ipairs(SCRIPTS) do
        if s.GameId == game.PlaceId then return s end
    end
end

local function launch(scriptData)
    pcall(function() 
        loadstring(game:HttpGet(BASE_URL .. scriptData.File))() 
    end)
end

-- UI instantiation utilities
local function new(class, props)
    local inst = Instance.new(class)
    for k, v in pairs(props) do
        if k ~= "Parent" then 
            pcall(function() inst[k] = v end) 
        end
    end
    if props.Parent then inst.Parent = props.Parent end
    return inst
end

local function corner(p, r) 
    return new("UICorner", { CornerRadius = UDim.new(0, r or 8), Parent = p }) 
end

local function tween(obj, props, dur, style, dir)
    if not obj or not obj.Parent then return end
    TweenService:Create(obj, TweenInfo.new(dur or 0.25, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out), props):Play()
end

-- screen build template
local function buildInfoCard(guiName, accent, icon, title, titleColor, message, subText, subColor, btnText, btnColor, btnHover, btnAction, footer)
    for _, name in ipairs({"IBdihPLoader", guiName}) do
        if CoreGui:FindFirstChild(name) then 
            CoreGui[name]:Destroy() 
        end
    end

    local gui = new("ScreenGui", { Name = guiName, ResetOnSpawn = false, IgnoreGuiInset = true, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, Parent = CoreGui })
    local backdrop = new("Frame", { Size = UDim2.new(1,0,1,0), BackgroundColor3 = Color3.fromRGB(0,0,0), BackgroundTransparency = 1, ZIndex = 1, Parent = gui })

    local card = new("Frame", {
        Size = UDim2.new(0,480,0,0),
        Position = UDim2.new(0.5,0,0.5,0), AnchorPoint = Vector2.new(0.5,0.5),
        BackgroundColor3 = Color3.fromRGB(15,10,10), BackgroundTransparency = 1,
        ClipsDescendants = true, ZIndex = 2, Parent = gui,
    })
    corner(card, 16)
    local stroke = new("UIStroke", { Color = accent, Thickness = 2, Transparency = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = card })

    local bar = new("Frame", { Size = UDim2.new(1,0,0,4), BackgroundColor3 = accent, BorderSizePixel = 0, ZIndex = 15, Parent = card })
    local grad = new("UIGradient", { Parent = bar })
    
    task.spawn(function()
        local t = 0
        while bar and bar.Parent do
            t = t + 0.03
            grad.Offset = Vector2.new(math.sin(t) * 0.4, 0)
            RunService.RenderStepped:Wait()
        end
    end)

    new("TextLabel", { Size = UDim2.new(1,0,0,60), Position = UDim2.new(0,0,0,18), BackgroundTransparency = 1, Text = icon, TextColor3 = Color3.fromRGB(255,255,255), TextSize = 44, Font = Enum.Font.GothamBold, ZIndex = 6, Parent = card })
    local titleLbl = new("TextLabel", { Size = UDim2.new(1,-40,0,30), Position = UDim2.new(0,20,0,82), BackgroundTransparency = 1, Text = title, TextColor3 = titleColor, TextSize = 24, Font = Enum.Font.GothamBold, ZIndex = 6, Parent = card })
    new("Frame", { Size = UDim2.new(0.6,0,0,1), Position = UDim2.new(0.2,0,0,118), BackgroundColor3 = accent, BackgroundTransparency = 0.5, BorderSizePixel = 0, ZIndex = 6, Parent = card })
    new("TextLabel", { Size = UDim2.new(1,-60,0,40), Position = UDim2.new(0,30,0,128), BackgroundTransparency = 1, Text = message, TextColor3 = Color3.fromRGB(220,220,220), TextSize = 15, Font = Enum.Font.GothamMedium, TextWrapped = true, ZIndex = 6, Parent = card })
    new("TextLabel", { Size = UDim2.new(1,-60,0,20), Position = UDim2.new(0,30,0,172), BackgroundTransparency = 1, Text = subText, TextColor3 = subColor, TextSize = 12, Font = Enum.Font.GothamMedium, ZIndex = 6, Parent = card })

    local btn = new("TextButton", { Size = UDim2.new(0,190,0,38), Position = UDim2.new(0.5,-95,0,200), BackgroundColor3 = btnColor, Text = btnText, TextColor3 = Color3.fromRGB(255,255,255), TextSize = 14, Font = Enum.Font.GothamBold, AutoButtonColor = false, ZIndex = 8, Parent = card })
    corner(btn, 10)
    
    btn.MouseEnter:Connect(function() tween(btn, { BackgroundColor3 = btnHover }, 0.15) end)
    btn.MouseLeave:Connect(function() tween(btn, { BackgroundColor3 = btnColor }, 0.2) end)
    btn.MouseButton1Click:Connect(function() btnAction(btn, card, backdrop, stroke) end)

    new("TextLabel", { Size = UDim2.new(1,-40,0,16), Position = UDim2.new(0,20,1,-26), BackgroundTransparency = 1, Text = footer, TextColor3 = Color3.fromRGB(80,50,50), TextSize = 11, Font = Enum.Font.GothamMedium, ZIndex = 6, Parent = card })

    task.wait(0.2)
    tween(backdrop, { BackgroundTransparency = 0.3 }, 0.6)
    task.wait(0.1)
    tween(card, { Size = UDim2.new(0, 480, 0, 268), BackgroundTransparency = 0 }, 0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    tween(stroke, { Transparency = 0 }, 0.5)

    task.spawn(function()
        while titleLbl and titleLbl.Parent do
            tween(titleLbl, { TextTransparency = 0.6 }, 0.08)
            task.wait(0.1)
            tween(titleLbl, { TextTransparency = 0 }, 0.08)
            task.wait(math.random(20, 60) / 10)
        end
    end)
end

local function buildBanScreen()
    buildInfoCard(
        "IBdihPBanned",
        Color3.fromRGB(255, 50, 50),
        "❗️", "BANNED!", Color3.fromRGB(255, 60, 60),
        "early christmas gift! 🎁💞",
        "account: " .. LocalPlayer.Name .. " (" .. tostring(LocalPlayer.UserId) .. ")",
        Color3.fromRGB(120, 80, 80),
        "💬  Join Discord", Color3.fromRGB(88, 101, 242), Color3.fromRGB(110, 122, 255),
        function(btn)
            pcall(function() if setclipboard then setclipboard(DISCORD_LINK) end end)
            btn.Text = "✓  Copied!"
            task.delay(2, function() 
                if btn and btn.Parent then btn.Text = "💬  Join Discord" end 
            end)
        end,
        "access permanently revoked — appeals will not be accepted"
    )
end

local function buildLobbyScreen()
    buildInfoCard(
        "IBdihPLobby",
        Color3.fromRGB(255, 200, 60),
        "⚠️", "YOU'RE IN THE LOBBY", Color3.fromRGB(255, 200, 60),
        "please execute inside one of the gamemodes!\nthe script cannot run from the lobby.",
        "current place: " .. tostring(game.PlaceId) .. " (lobby)",
        Color3.fromRGB(120, 110, 60),
        "✕  Close", Color3.fromRGB(60, 55, 30), Color3.fromRGB(80, 75, 40),
        function(_, card, backdrop, stroke)
            tween(card, { Size = UDim2.new(0,480,0,0), BackgroundTransparency = 1 }, 0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In)
            tween(backdrop, { BackgroundTransparency = 1 }, 0.35)
            tween(stroke, { Transparency = 1 }, 0.3)
            task.wait(0.4)
            if CoreGui:FindFirstChild("IBdihPLobby") then 
                CoreGui.IBdihPLobby:Destroy() 
            end
        end,
        "select a gamemode first, then re-execute the script"
    )
end

-- safety and location checks
if isUserBanned() then buildBanScreen(); return end
if isLobbyPlace() then buildLobbyScreen(); return end

local savedKey = loadKey()
local gameScript = getGameScript()

if isKeyValid(savedKey) and gameScript then
    launch(gameScript)
    return
end

-- setup main hub interface
if CoreGui:FindFirstChild("IBdihPLoader") then 
    CoreGui.IBdihPLoader:Destroy() 
end

local Gui = new("ScreenGui", { Name = "IBdihPLoader", ResetOnSpawn = false, IgnoreGuiInset = true, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, Parent = CoreGui })
local Backdrop = new("Frame", { Size = UDim2.new(1,0,1,0), BackgroundColor3 = Color3.fromRGB(0,0,0), BackgroundTransparency = 1, ZIndex = 1, Parent = Gui })

local Board = new("Frame", {
    Size = UDim2.new(0, 560, 0, 0), Position = UDim2.new(0.5,0,0.5,0), AnchorPoint = Vector2.new(0.5,0.5),
    BackgroundColor3 = Color3.fromRGB(45,35,28), BackgroundTransparency = 1,
    ClipsDescendants = true, ZIndex = 10, Parent = Gui,
})
corner(Board, 14)
local boardStroke = new("UIStroke", { Color = Color3.fromRGB(70,55,38), Thickness = 3, Transparency = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = Board })

local Cork = new("Frame", { Size = UDim2.new(1,0,1,0), BackgroundColor3 = Color3.fromRGB(160,125,80), ZIndex = 11, Parent = Board })
corner(Cork, 14)
new("UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(170,135,85)),
        ColorSequenceKeypoint.new(0.3, Color3.fromRGB(155,120,75)),
        ColorSequenceKeypoint.new(0.7, Color3.fromRGB(165,130,82)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(150,115,70)),
    }),
    Rotation = 25, Parent = Cork,
})

task.wait(0.15)
tween(Backdrop, { BackgroundTransparency = 0.45 }, 0.5)
task.wait(0.1)
tween(Board, { Size = UDim2.new(0, 560, 0, 410), BackgroundTransparency = 0 }, 0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
tween(boardStroke, { Transparency = 0 }, 0.5)
task.wait(0.5)

-- subtle coffee stain detail
task.spawn(function()
    task.wait(1.5)
    local stain = new("Frame", {
        Size = UDim2.new(0, 55, 0, 55),
        Position = UDim2.new(0.88, -28, 0.92, -28),
        BackgroundColor3 = Color3.fromRGB(120, 90, 55),
        BackgroundTransparency = 1,
        ZIndex = 12, Parent = Board,
    })
    corner(stain, 28)
    local stainStroke = new("UIStroke", { Color = Color3.fromRGB(105, 75, 45), Thickness = 4, Transparency = 1, Parent = stain })

    local inner = new("Frame", {
        Size = UDim2.new(0, 38, 0, 38),
        Position = UDim2.new(0.5, -19, 0.5, -19),
        BackgroundColor3 = Color3.fromRGB(160, 125, 80),
        BackgroundTransparency = 1,
        ZIndex = 13, Parent = stain,
    })
    corner(inner, 19)

    tween(stain, { BackgroundTransparency = 0.75 }, 2, Enum.EasingStyle.Sine)
    tween(stainStroke, { Transparency = 0.6 }, 2, Enum.EasingStyle.Sine)
    tween(inner, { BackgroundTransparency = 0.15 }, 2, Enum.EasingStyle.Sine)
end)

-- decorative lava lamp blobs
local function createBlob(color, size, startX, startY)
    local blob = new("Frame", {
        Size = UDim2.new(0, size, 0, size),
        Position = UDim2.new(startX, -size/2, startY, -size/2),
        BackgroundColor3 = color, BackgroundTransparency = 0.6,
        ZIndex = 12, Parent = Board,
    })
    corner(blob, size/2)
    
    task.spawn(function()
        while blob and blob.Parent do
            local tx = startX + math.random(-8, 8) / 100
            local ty = startY + math.random(-8, 8) / 100
            local ns = size + math.random(-15, 15)
            tween(blob, {
                Position = UDim2.new(tx, -ns/2, ty, -ns/2),
                Size = UDim2.new(0, ns, 0, ns),
                BackgroundTransparency = 0.5 + math.random() * 0.3,
            }, 3 + math.random() * 2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            task.wait(3 + math.random() * 2)
        end
    end)
end

createBlob(Color3.fromRGB(255, 120, 180), 65, 0.2, 0.3)
createBlob(Color3.fromRGB(120, 180, 255), 55, 0.75, 0.6)
createBlob(Color3.fromRGB(180, 255, 120), 50, 0.5, 0.8)
createBlob(Color3.fromRGB(255, 200, 100), 60, 0.85, 0.25)

-- ambient floating sparkles
task.spawn(function()
    while Board and Board.Parent do
        local sparkle = new("TextLabel", {
            Size = UDim2.new(0, 16, 0, 16),
            Position = UDim2.new(math.random() * 0.9 + 0.05, 0, math.random() * 0.9 + 0.05, 0),
            BackgroundTransparency = 1, Text = "✦",
            TextColor3 = Color3.fromRGB(255, 220 + math.random(35), 100 + math.random(100)),
            TextSize = math.random(10, 16), TextTransparency = 1,
            Rotation = math.random(-30, 30), ZIndex = 22, Parent = Board,
        })
        tween(sparkle, { TextTransparency = 0.3, Rotation = sparkle.Rotation + 90 }, 0.4)
        task.wait(0.5)
        tween(sparkle, { TextTransparency = 1, Rotation = sparkle.Rotation + 180 }, 0.6)
        task.wait(0.7)
        if sparkle and sparkle.Parent then sparkle:Destroy() end
        task.wait(math.random(5, 15) / 10)
    end
end)

-- drift particle system
task.spawn(function()
    while Board and Board.Parent do
        local dust = new("Frame", {
            Size = UDim2.new(0, math.random(2, 4), 0, math.random(2, 4)),
            Position = UDim2.new(math.random() * 0.9 + 0.05, 0, math.random() * 0.3 + 0.65, 0),
            BackgroundColor3 = Color3.fromRGB(200 + math.random(55), 180 + math.random(50), 130 + math.random(50)),
            BackgroundTransparency = 0.5 + math.random() * 0.3,
            ZIndex = 12, Parent = Board,
        })
        corner(dust, 2)

        local driftX = (math.random() - 0.5) * 0.1
        tween(dust, {
            Position = UDim2.new(dust.Position.X.Scale + driftX, 0, dust.Position.Y.Scale - 0.3 - math.random() * 0.2, 0),
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 1, 0, 1),
        }, 4 + math.random() * 3, Enum.EasingStyle.Sine)

        task.delay(8, function() 
            if dust and dust.Parent then dust:Destroy() end 
        end)
        task.wait(math.random(3, 8) / 10)
    end
end)

-- flying paper plane effect
task.spawn(function()
    while Board and Board.Parent do
        task.wait(math.random(8, 16))
        if not (Board and Board.Parent) then break end

        local plane = new("TextLabel", {
            Size = UDim2.new(0, 24, 0, 24),
            Position = UDim2.new(-0.1, 0, math.random() * 0.6 + 0.1, 0),
            BackgroundTransparency = 1,
            Text = "✈️", TextSize = 18,
            Rotation = -15, ZIndex = 23, Parent = Board,
        })

        local startY = plane.Position.Y.Scale
        task.spawn(function()
            local t = 0
            while plane and plane.Parent and t < 3 do
                t = t + RunService.RenderStepped:Wait()
                local progress = t / 3
                local waveY = startY + math.sin(progress * math.pi * 3) * 0.04
                plane.Position = UDim2.new(-0.1 + progress * 1.3, 0, waveY, 0)
                plane.Rotation = -15 + math.sin(progress * math.pi * 4) * 10
            end
            if plane and plane.Parent then plane:Destroy() end
        end)
    end
end)

-- yellow sticky note
local MainNote = new("Frame", {
    Size = UDim2.new(0, 305, 0, 330),
    Position = UDim2.new(0, 20, 0, 42),
    BackgroundColor3 = Color3.fromRGB(255, 245, 157),
    Rotation = -1.5, ZIndex = 15, Parent = Board,
})
corner(MainNote, 3)
new("Frame", { Size = UDim2.new(1, 6, 1, 6), Position = UDim2.new(0, 4, 0, 4), BackgroundColor3 = Color3.fromRGB(0,0,0), BackgroundTransparency = 0.82, ZIndex = 14, Parent = MainNote })

local Tape = new("Frame", { Size = UDim2.new(0, 70, 0, 20), Position = UDim2.new(0.5, -35, 0, -10), BackgroundColor3 = Color3.fromRGB(200,200,175), BackgroundTransparency = 0.25, ZIndex = 18, Rotation = 2, Parent = MainNote })
corner(Tape, 3)

task.spawn(function()
    while Tape and Tape.Parent do
        tween(Tape, { BackgroundTransparency = 0.35 }, 2, Enum.EasingStyle.Sine)
        task.wait(2)
        tween(Tape, { BackgroundTransparency = 0.2 }, 2, Enum.EasingStyle.Sine)
        task.wait(2)
    end
end)

MainNote.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        tween(Tape, { Rotation = 8, Position = UDim2.new(0.5, -35, 0, -14) }, 0.3, Enum.EasingStyle.Back)
    end
end)
MainNote.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        tween(Tape, { Rotation = 2, Position = UDim2.new(0.5, -35, 0, -10) }, 0.4, Enum.EasingStyle.Elastic)
    end
end)

task.spawn(function()
    while MainNote and MainNote.Parent do
        tween(MainNote, { Rotation = -2.5 }, 3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        task.wait(3)
        tween(MainNote, { Rotation = -0.5 }, 3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        task.wait(3)
    end
end)

local Greeting = new("TextLabel", {
    Size = UDim2.new(1, -20, 0, 26), Position = UDim2.new(0, 12, 0, 16),
    BackgroundTransparency = 1, Text = "heyyy " .. LocalPlayer.Name .. " 👋",
    TextColor3 = Color3.fromRGB(50, 40, 20), TextSize = 19, Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 16, Parent = MainNote,
})

local Arrow = new("TextLabel", {
    Size = UDim2.new(0, 22, 0, 22), Position = UDim2.new(0, 12, 0, 46),
    BackgroundTransparency = 1, Text = "↓", TextColor3 = Color3.fromRGB(220, 60, 60),
    TextSize = 20, Font = Enum.Font.GothamBold, ZIndex = 16, Parent = MainNote,
})

task.spawn(function()
    while Arrow and Arrow.Parent do
        tween(Arrow, { Position = UDim2.new(0, 12, 0, 54) }, 0.5, Enum.EasingStyle.Sine)
        task.wait(0.5)
        tween(Arrow, { Position = UDim2.new(0, 12, 0, 46) }, 0.5, Enum.EasingStyle.Sine)
        task.wait(0.5)
    end
end)

local SubGreeting = new("TextLabel", {
    Size = UDim2.new(1, -42, 0, 18), Position = UDim2.new(0, 34, 0, 48),
    BackgroundTransparency = 1, Text = "drop ur key to get in!",
    TextColor3 = Color3.fromRGB(90, 75, 40), TextSize = 13, Font = Enum.Font.GothamMedium,
    TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 16, Parent = MainNote,
})

for i = 0, 5 do
    new("Frame", {
        Size = UDim2.new(1, -20, 0, 1), Position = UDim2.new(0, 10, 0, 80 + i * 42),
        BackgroundColor3 = Color3.fromRGB(200, 190, 140), BackgroundTransparency = 0.5,
        BorderSizePixel = 0, ZIndex = 16, Parent = MainNote,
    })
end

local InputBg = new("Frame", {
    Size = UDim2.new(1, -20, 0, 42), Position = UDim2.new(0, 10, 0, 86),
    BackgroundColor3 = Color3.fromRGB(248, 238, 145), ZIndex = 16, Parent = MainNote,
})
corner(InputBg, 6)
new("Frame", { Size = UDim2.new(1, -8, 0, 2), Position = UDim2.new(0, 4, 1, -4), BackgroundColor3 = Color3.fromRGB(180, 170, 115), BorderSizePixel = 0, ZIndex = 17, Parent = InputBg })

local KeyInput = new("TextBox", {
    Size = UDim2.new(1, -16, 1, 0), Position = UDim2.new(0, 8, 0, 0),
    BackgroundTransparency = 1, Text = "",
    PlaceholderText = "type key here...", PlaceholderColor3 = Color3.fromRGB(165, 155, 105),
    TextColor3 = Color3.fromRGB(40, 30, 10), TextSize = 15, Font = Enum.Font.GothamMedium,
    TextXAlignment = Enum.TextXAlignment.Left, ClearTextOnFocus = false, ZIndex = 17, Parent = InputBg,
})

-- typewriter scratching effect
KeyInput:GetPropertyChangedSignal("Text"):Connect(function()
    if not (InputBg and InputBg.Parent) then return end
    if #KeyInput.Text == 0 then return end

    local scratch = new("Frame", {
        Size = UDim2.new(0, math.random(8, 16), 0, 2),
        Position = UDim2.new(math.random() * 0.6 + 0.05, 0, 0.8 + math.random() * 0.15, 0),
        BackgroundColor3 = Color3.fromRGB(160, 150, 110),
        BackgroundTransparency = 0.5,
        Rotation = math.random(-15, 15),
        ZIndex = 17, Parent = InputBg,
    })
    corner(scratch, 1)
    tween(scratch, { BackgroundTransparency = 1 }, 1.5, Enum.EasingStyle.Sine)
    task.delay(1.6, function() 
        if scratch and scratch.Parent then scratch:Destroy() end 
    end)
end)

local StatusLbl = new("TextLabel", {
    Size = UDim2.new(1, -20, 0, 16), Position = UDim2.new(0, 10, 0, 134),
    BackgroundTransparency = 1, Text = "",
    TextColor3 = Color3.fromRGB(200, 60, 60), TextSize = 12, Font = Enum.Font.GothamMedium,
    TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 16, Parent = MainNote,
})

local GoBtn = new("TextButton", {
    Size = UDim2.new(1, -20, 0, 42), Position = UDim2.new(0, 10, 0, 156),
    BackgroundColor3 = Color3.fromRGB(100, 185, 100), Text = "",
    AutoButtonColor = false, ZIndex = 17, Parent = MainNote,
})
corner(GoBtn, 8)

local GoLbl = new("TextLabel", {
    Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
    Text = "let me in! →", TextColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 15, Font = Enum.Font.GothamBold, ZIndex = 18, Parent = GoBtn,
})

GoBtn.MouseEnter:Connect(function() tween(GoBtn, { BackgroundColor3 = Color3.fromRGB(120, 210, 120) }, 0.15) end)
GoBtn.MouseLeave:Connect(function() tween(GoBtn, { BackgroundColor3 = Color3.fromRGB(100, 185, 100) }, 0.2) end)

task.spawn(function()
    while GoBtn and GoBtn.Parent do
        tween(GoBtn, { BackgroundColor3 = Color3.fromRGB(110, 200, 110) }, 1.2, Enum.EasingStyle.Sine)
        task.wait(1.2)
        tween(GoBtn, { BackgroundColor3 = Color3.fromRGB(90, 170, 90) }, 1.2, Enum.EasingStyle.Sine)
        task.wait(1.2)
    end
end)

local SmallBtnRow = new("Frame", { Size = UDim2.new(1, -20, 0, 34), Position = UDim2.new(0, 10, 0, 206), BackgroundTransparency = 1, ZIndex = 16, Parent = MainNote })

local PasteBtn = new("TextButton", { Size = UDim2.new(0.48, 0, 1, 0), Position = UDim2.new(0, 0, 0, 0), BackgroundColor3 = Color3.fromRGB(235, 225, 145), Text = "", AutoButtonColor = false, ZIndex = 17, Parent = SmallBtnRow })
corner(PasteBtn, 6)
new("TextLabel", { Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Text = "📋 paste", TextColor3 = Color3.fromRGB(80, 70, 35), TextSize = 12, Font = Enum.Font.GothamBold, ZIndex = 18, Parent = PasteBtn })

PasteBtn.MouseEnter:Connect(function() tween(PasteBtn, { BackgroundColor3 = Color3.fromRGB(245, 235, 160) }, 0.15) end)
PasteBtn.MouseLeave:Connect(function() tween(PasteBtn, { BackgroundColor3 = Color3.fromRGB(235, 225, 145) }, 0.2) end)
PasteBtn.MouseButton1Click:Connect(function()
    pcall(function() 
        if getclipboard then KeyInput.Text = getclipboard() end 
    end)
end)

local DiscBtn = new("TextButton", { Size = UDim2.new(0.48, 0, 1, 0), Position = UDim2.new(0.52, 0, 0, 0), BackgroundColor3 = Color3.fromRGB(130, 140, 230), Text = "", AutoButtonColor = false, ZIndex = 17, Parent = SmallBtnRow })
corner(DiscBtn, 6)
new("TextLabel", { Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Text = "💬 get key", TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 12, Font = Enum.Font.GothamBold, ZIndex = 18, Parent = DiscBtn })

DiscBtn.MouseEnter:Connect(function() tween(DiscBtn, { BackgroundColor3 = Color3.fromRGB(150, 160, 245) }, 0.15) end)
DiscBtn.MouseLeave:Connect(function() tween(DiscBtn, { BackgroundColor3 = Color3.fromRGB(130, 140, 230) }, 0.2) end)
DiscBtn.MouseButton1Click:Connect(function()
    pcall(function() if setclipboard then setclipboard(DISCORD_LINK) end end)
    StatusLbl.Text = "copied discord link! 💬"
    StatusLbl.TextColor3 = Color3.fromRGB(100, 110, 200)
    task.delay(3, function() 
        if StatusLbl and StatusLbl.Parent then StatusLbl.Text = "" end 
    end)
end)

local FooterLbl = new("TextLabel", {
    Size = UDim2.new(1, -20, 0, 38), Position = UDim2.new(0, 10, 1, -50),
    BackgroundTransparency = 1,
    Text = "(free permanent key from discord ♡)\n(saves automatically, u only do this once!)",
    TextColor3 = Color3.fromRGB(155, 145, 100), TextSize = 12, Font = Enum.Font.GothamMedium,
    TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 16, Parent = MainNote,
})

-- draw decorative star doodle
task.spawn(function()
    task.wait(3)
    local doodlePoints = {
        {0.82, 0.72}, {0.85, 0.62}, {0.88, 0.72},
        {0.93, 0.74}, {0.89, 0.78}, {0.91, 0.85},
        {0.85, 0.80}, {0.79, 0.85}, {0.81, 0.78},
        {0.77, 0.74}, {0.82, 0.72},
    }
    for i, pt in ipairs(doodlePoints) do
        if not (MainNote and MainNote.Parent) then break end
        local dot = new("Frame", {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(pt[1], 0, pt[2], 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = Color3.fromRGB(180, 80, 80),
            BackgroundTransparency = 0.3,
            ZIndex = 17, Parent = MainNote,
        })
        corner(dot, 2)
        tween(dot, { Size = UDim2.new(0, 4, 0, 4) }, 0.1, Enum.EasingStyle.Quad)

        if i > 1 then
            local prev = doodlePoints[i - 1]
            local dx = (pt[1] - prev[1]) * MainNote.AbsoluteSize.X
            local dy = (pt[2] - prev[2]) * MainNote.AbsoluteSize.Y
            local dist = math.sqrt(dx * dx + dy * dy)
            local angle = math.deg(math.atan2(dy, dx))

            local line = new("Frame", {
                Size = UDim2.new(0, 0, 0, 2),
                Position = UDim2.new(prev[1], 0, prev[2], 0),
                AnchorPoint = Vector2.new(0, 0.5),
                Rotation = angle,
                BackgroundColor3 = Color3.fromRGB(180, 80, 80),
                BackgroundTransparency = 0.4,
                ZIndex = 17, Parent = MainNote,
            })
            tween(line, { Size = UDim2.new(0, dist, 0, 2) }, 0.15, Enum.EasingStyle.Linear)
        end
        task.wait(0.12)
    end
end)

-- blue sticky note
local BlueNote = new("Frame", {
    Size = UDim2.new(0, 200, 0, 160), Position = UDim2.new(0, 340, 0, 30),
    BackgroundColor3 = Color3.fromRGB(155, 210, 255), Rotation = 2.5, ZIndex = 15, Parent = Board,
})
corner(BlueNote, 3)
new("Frame", { Size = UDim2.new(1, 5, 1, 5), Position = UDim2.new(0, 3, 0, 3), BackgroundColor3 = Color3.fromRGB(0,0,0), BackgroundTransparency = 0.84, ZIndex = 14, Parent = BlueNote })

local BlueTape = new("Frame", { Size = UDim2.new(0, 55, 0, 18), Position = UDim2.new(0.5, -28, 0, -9), BackgroundColor3 = Color3.fromRGB(200,200,175), BackgroundTransparency = 0.25, ZIndex = 18, Rotation = -4, Parent = BlueNote })
corner(BlueTape, 3)

BlueNote.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        tween(BlueTape, { Rotation = -12, Position = UDim2.new(0.5, -28, 0, -13) }, 0.3, Enum.EasingStyle.Back)
    end
end)
BlueNote.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        tween(BlueTape, { Rotation = -4, Position = UDim2.new(0.5, -28, 0, -9) }, 0.4, Enum.EasingStyle.Elastic)
    end
end)

task.spawn(function()
    while BlueNote and BlueNote.Parent do
        tween(BlueNote, { Rotation = 3.5 }, 2.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        task.wait(2.5)
        tween(BlueNote, { Rotation = 1.5 }, 2.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        task.wait(2.5)
    end
end)

local HubIcon = new("ImageLabel", {
    Size = UDim2.new(0, 42, 0, 42), Position = UDim2.new(0.5, -21, 0, 12),
    BackgroundTransparency = 1, Image = HUB_ICON, ZIndex = 16, Parent = BlueNote,
})
corner(HubIcon, 8)

task.spawn(function()
    while HubIcon and HubIcon.Parent do
        tween(HubIcon, { Size = UDim2.new(0, 46, 0, 46), Position = UDim2.new(0.5, -23, 0, 10) }, 1, Enum.EasingStyle.Sine)
        task.wait(1)
        tween(HubIcon, { Size = UDim2.new(0, 42, 0, 42), Position = UDim2.new(0.5, -21, 0, 12) }, 1, Enum.EasingStyle.Sine)
        task.wait(1)
    end
end)

new("TextLabel", {
    Size = UDim2.new(1, -12, 0, 16), Position = UDim2.new(0, 6, 0, 60),
    BackgroundTransparency = 1, Text = "IBdihP Hub",
    TextColor3 = Color3.fromRGB(25, 60, 100), TextSize = 15, Font = Enum.Font.GothamBold,
    ZIndex = 16, Parent = BlueNote,
})

local CounterLbl = new("TextLabel", {
    Size = UDim2.new(1, -12, 0, 16), Position = UDim2.new(0, 6, 0, 82),
    BackgroundTransparency = 1, Text = "🎮 0 games",
    TextColor3 = Color3.fromRGB(35, 70, 110), TextSize = 12, Font = Enum.Font.GothamMedium,
    TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 16, Parent = BlueNote,
})

task.spawn(function()
    task.wait(1)
    for i = 1, GAME_COUNT do
        if not (CounterLbl and CounterLbl.Parent) then break end
        CounterLbl.Text = "🎮 " .. tostring(i) .. " games"
        task.wait(0.015)
    end
end)

new("TextLabel", {
    Size = UDim2.new(1, -12, 0, 16), Position = UDim2.new(0, 6, 0, 102),
    BackgroundTransparency = 1, Text = "🔑 1 free universal key",
    TextColor3 = Color3.fromRGB(35, 70, 110), TextSize = 12, Font = Enum.Font.GothamMedium,
    TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 16, Parent = BlueNote,
})
new("TextLabel", {
    Size = UDim2.new(1, -12, 0, 16), Position = UDim2.new(0, 6, 0, 122),
    BackgroundTransparency = 1, Text = "⚡ no hassle ever",
    TextColor3 = Color3.fromRGB(35, 70, 110), TextSize = 12, Font = Enum.Font.GothamMedium,
    TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 16, Parent = BlueNote,
})

-- pink sticky note
local PinkNote = new("Frame", {
    Size = UDim2.new(0, 200, 0, 145), Position = UDim2.new(0, 340, 0, 205),
    BackgroundColor3 = Color3.fromRGB(255, 175, 195), Rotation = -2, ZIndex = 15, Parent = Board,
})
corner(PinkNote, 3)
new("Frame", { Size = UDim2.new(1, 5, 1, 5), Position = UDim2.new(0, 3, 0, 3), BackgroundColor3 = Color3.fromRGB(0,0,0), BackgroundTransparency = 0.84, ZIndex = 14, Parent = PinkNote })

local PinkTape = new("Frame", { Size = UDim2.new(0, 52, 0, 18), Position = UDim2.new(0.3, -12, 0, -9), BackgroundColor3 = Color3.fromRGB(200,200,175), BackgroundTransparency = 0.25, ZIndex = 18, Rotation = 6, Parent = PinkNote })
corner(PinkTape, 3)

PinkNote.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        tween(PinkTape, { Rotation = 14, Position = UDim2.new(0.3, -12, 0, -13) }, 0.3, Enum.EasingStyle.Back)
    end
end)
PinkNote.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        tween(PinkTape, { Rotation = 6, Position = UDim2.new(0.3, -12, 0, -9) }, 0.4, Enum.EasingStyle.Elastic)
    end
end)

task.spawn(function()
    while PinkNote and PinkNote.Parent do
        tween(PinkNote, { Rotation = -3 }, 2.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        task.wait(2.8)
        tween(PinkNote, { Rotation = -1 }, 2.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        task.wait(2.8)
    end
end)

local Heart = new("TextLabel", {
    Size = UDim2.new(0, 22, 0, 22), Position = UDim2.new(1, -30, 0, 8),
    BackgroundTransparency = 1, Text = "💜", TextSize = 16, ZIndex = 16, Parent = PinkNote,
})

task.spawn(function()
    while Heart and Heart.Parent do
        tween(Heart, { TextSize = 20 }, 0.4, Enum.EasingStyle.Sine)
        task.wait(0.4)
        tween(Heart, { TextSize = 16 }, 0.4, Enum.EasingStyle.Sine)
        task.wait(1.5)
    end
end)

new("TextLabel", {
    Size = UDim2.new(1, -14, 0, 95), Position = UDim2.new(0, 7, 0, 14),
    BackgroundTransparency = 1,
    Text = "ur key works everywhere\nforever. we don't do\nthat expiring stuff 💅\nnone of dat linkvertise,\nlootlabs or workink stuff.\npure free 💝",
    TextColor3 = Color3.fromRGB(120, 45, 65), TextSize = 11, Font = Enum.Font.GothamMedium,
    TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true, ZIndex = 16, Parent = PinkNote,
})

new("TextLabel", {
    Size = UDim2.new(1, -14, 0, 16), Position = UDim2.new(0, 7, 1, -22),
    BackgroundTransparency = 1, Text = "— with love, IBdihP team",
    TextColor3 = Color3.fromRGB(160, 80, 100), TextSize = 11, Font = Enum.Font.GothamMedium,
    TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 16, Parent = PinkNote,
})

-- initial layout animation trigger
task.spawn(function()
    local mainTarget = UDim2.new(0, 20, 0, 42)
    local blueTarget = UDim2.new(0, 340, 0, 30)
    local pinkTarget = UDim2.new(0, 340, 0, 210)

    MainNote.Position = UDim2.new(-0.7, 0, 0.3, 0)
    MainNote.Rotation = -25
    BlueNote.Position = UDim2.new(1.4, 0, -0.3, 0)
    BlueNote.Rotation = 30
    PinkNote.Position = UDim2.new(1.3, 0, 1.3, 0)
    PinkNote.Rotation = 20

    task.wait(0.2)
    tween(MainNote, { Position = mainTarget, Rotation = -1.5 }, 0.7, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    task.wait(0.22)
    tween(BlueNote, { Position = blueTarget, Rotation = 2.5 }, 0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    task.wait(0.18)
    tween(PinkNote, { Position = pinkTarget, Rotation = -2 }, 0.55, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
end)

-- board pushpins
local allPins = {}
local function pushpin(x, y, col)
    local shadow = new("Frame", { Size = UDim2.new(0, 12, 0, 5), Position = UDim2.new(x, 1, y, 7), BackgroundColor3 = Color3.fromRGB(0,0,0), BackgroundTransparency = 0.8, ZIndex = 20, Parent = Board })
    corner(shadow, 2)
    local pin = new("Frame", { Size = UDim2.new(0, 16, 0, 16), Position = UDim2.new(x, -8, y, -8), BackgroundColor3 = col, ZIndex = 21, Parent = Board })
    corner(pin, 8)
    new("UIStroke", { Color = Color3.fromRGB(0,0,0), Thickness = 1, Transparency = 0.7, Parent = pin })
    local gleam = new("Frame", { Size = UDim2.new(0, 5, 0, 5), Position = UDim2.new(0, 3, 0, 2), BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 0.4, ZIndex = 22, Parent = pin })
    corner(gleam, 2)
    table.insert(allPins, pin)
end

pushpin(0.03, 0.04, Color3.fromRGB(230, 50, 50))
pushpin(0.58, 0.04, Color3.fromRGB(50, 130, 230))
pushpin(0.95, 0.88, Color3.fromRGB(50, 200, 80))

local function wobblePins()
    for _, pin in ipairs(allPins) do
        if pin and pin.Parent then
            task.spawn(function()
                tween(pin, { Rotation = math.random(-20, 20) }, 0.15, Enum.EasingStyle.Quad)
                task.wait(0.15)
                tween(pin, { Rotation = math.random(-15, 15) }, 0.12, Enum.EasingStyle.Quad)
                task.wait(0.12)
                tween(pin, { Rotation = 0 }, 0.3, Enum.EasingStyle.Elastic)
            end)
        end
    end
end

-- border marching ants animation
task.spawn(function()
    local ants = {}
    for i = 1, 8 do
        local ant = new("Frame", {
            Size = UDim2.new(0, 5, 0, 5),
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundColor3 = Color3.fromRGB(30, 25, 18),
            BackgroundTransparency = 0.3,
            ZIndex = 23, Parent = Board,
        })
        corner(ant, 3)
        ants[i] = { frame = ant, progress = (i - 1) / 8 }
    end

    while Board and Board.Parent do
        for _, ant in ipairs(ants) do
            if not (ant.frame and ant.frame.Parent) then break end
            ant.progress = (ant.progress + 0.002) % 1
            local p = ant.progress
            local x, y
            if p < 0.25 then
                x = p / 0.25
                y = 0
            elseif p < 0.5 then
                x = 1
                y = (p - 0.25) / 0.25
            elseif p < 0.75 then
                x = 1 - (p - 0.5) / 0.25
                y = 1
            else
                x = 0
                y = 1 - (p - 0.75) / 0.25
            end
            ant.frame.Position = UDim2.new(x, -3, y, -3)
        end
        RunService.RenderStepped:Wait()
    end
end)

-- UI dismiss button
local CloseBtn = new("TextButton", {
    Size = UDim2.new(0, 34, 0, 34), Position = UDim2.new(1, -44, 0, 8),
    BackgroundColor3 = Color3.fromRGB(120, 95, 65), BackgroundTransparency = 0.5,
    Text = "", AutoButtonColor = false, ZIndex = 26, Parent = Board,
})
corner(CloseBtn, 8)

new("TextLabel", {
    Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
    Text = "✕", TextColor3 = Color3.fromRGB(60, 45, 30),
    TextSize = 18, Font = Enum.Font.GothamBold, ZIndex = 27, Parent = CloseBtn,
})

CloseBtn.MouseEnter:Connect(function() tween(CloseBtn, { BackgroundTransparency = 0, BackgroundColor3 = Color3.fromRGB(200, 70, 70) }, 0.15) end)
CloseBtn.MouseLeave:Connect(function() tween(CloseBtn, { BackgroundTransparency = 0.5, BackgroundColor3 = Color3.fromRGB(120, 95, 65) }, 0.2) end)

local function closeUI()
    tween(MainNote, { Position = UDim2.new(0, -400, 0, 50), Rotation = -25 }, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In)
    tween(BlueNote, { Position = UDim2.new(0, 700, 0, 30), Rotation = 20 }, 0.45, Enum.EasingStyle.Back, Enum.EasingDirection.In)
    tween(PinkNote, { Position = UDim2.new(0, 700, 0, 400), Rotation = 15 }, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In)
    task.wait(0.3)
    tween(Board, { BackgroundTransparency = 1 }, 0.3)
    tween(Backdrop, { BackgroundTransparency = 1 }, 0.3)
    task.wait(0.35)
    Gui:Destroy()
end

CloseBtn.MouseButton1Click:Connect(closeUI)

-- validation UI responses
local function shakeInput()
    local orig = InputBg.Position
    for _ = 1, 4 do
        tween(InputBg, { Position = orig + UDim2.new(0, 6, 0, 0) }, 0.035, Enum.EasingStyle.Linear)
        task.wait(0.04)
        tween(InputBg, { Position = orig - UDim2.new(0, 6, 0, 0) }, 0.035, Enum.EasingStyle.Linear)
        task.wait(0.04)
    end
    tween(InputBg, { Position = orig }, 0.06)
end

local function celebrationSparkles()
    task.spawn(function()
        local emojis = {"✨","🎉","💜","⭐","🌟","🎊","💫","🥳"}
        for _ = 1, 30 do
            local startX = 0.5 + (math.random() - 0.5) * 0.1
            local startY = 0.5 + (math.random() - 0.5) * 0.1
            local endX = startX + (math.random() - 0.5) * 0.9
            local endY = startY + (math.random() - 0.5) * 0.9
            local s = new("TextLabel", {
                Size = UDim2.new(0, 20, 0, 20),
                Position = UDim2.new(startX, 0, startY, 0),
                BackgroundTransparency = 1, Text = emojis[math.random(#emojis)],
                TextSize = math.random(12, 28), TextTransparency = 0,
                Rotation = math.random(-45, 45), ZIndex = 30, Parent = Board,
            })
            tween(s, {
                TextTransparency = 1,
                Position = UDim2.new(endX, 0, endY, 0),
                Rotation = math.random(-360, 360),
                TextSize = s.TextSize + math.random(5, 15),
            }, 1.5 + math.random() * 0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            task.wait(0.03)
            task.delay(2.2, function() 
                if s and s.Parent then s:Destroy() end 
            end)
        end
    end)

    task.spawn(function()
        for _, note in ipairs({MainNote, BlueNote, PinkNote}) do
            if note and note.Parent then
                local origR = note.Rotation
                tween(note, { Rotation = origR + 5 }, 0.15, Enum.EasingStyle.Quad)
                task.wait(0.15)
                tween(note, { Rotation = origR - 5 }, 0.15, Enum.EasingStyle.Quad)
                task.wait(0.15)
                tween(note, { Rotation = origR }, 0.2, Enum.EasingStyle.Elastic)
            end
        end
    end)

    wobblePins()
end

local verifying = false
local function doVerify()
    if verifying then return end
    local key = trim(KeyInput.Text)

    if key == "" then
        StatusLbl.Text = "psst... type the key first 😅"
        StatusLbl.TextColor3 = Color3.fromRGB(180, 140, 40)
        shakeInput()
        return
    end

    verifying = true
    GoLbl.Text = "checking..."
    tween(GoBtn, { BackgroundColor3 = Color3.fromRGB(160, 180, 100) }, 0.15)
    task.wait(0.7)

    if isKeyValid(key) then
        saveKey(key)
        StatusLbl.Text = "yooo ur in!! ✓"
        StatusLbl.TextColor3 = Color3.fromRGB(60, 160, 80)
        GoLbl.Text = "ur in! ✓"
        tween(GoBtn, { BackgroundColor3 = Color3.fromRGB(80, 210, 100) }, 0.2)
        celebrationSparkles()
        task.wait(1.4)

        if gameScript then
            GoLbl.Text = "loading " .. gameScript.Icon .. " " .. gameScript.Name .. "..."
            GoLbl.TextSize = 12
            task.wait(0.7)
            tween(MainNote, { Position = UDim2.new(0, -400, 0, 50), Rotation = -25 }, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In)
            tween(BlueNote, { Position = UDim2.new(0, 700, 0, 30), Rotation = 20 }, 0.45, Enum.EasingStyle.Back, Enum.EasingDirection.In)
            tween(PinkNote, { Position = UDim2.new(0, 700, 0, 400), Rotation = 15 }, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In)
            task.wait(0.4)
            tween(Board, { BackgroundTransparency = 1 }, 0.3)
            tween(Backdrop, { BackgroundTransparency = 1 }, 0.3)
            task.wait(0.4)
            Gui:Destroy()
            launch(gameScript)
        else
            StatusLbl.Text = ""
            InputBg.Visible = false
            Arrow.Visible = false
            SmallBtnRow.Visible = false
            Greeting.Visible = false
            SubGreeting.Visible = false
            FooterLbl.Visible = false

            new("TextLabel", {
                Size = UDim2.new(1, -20, 0, 46), Position = UDim2.new(0, 10, 0, 24),
                BackgroundTransparency = 1, Text = "😔",
                TextSize = 38, ZIndex = 19, Parent = MainNote,
            })
            new("TextLabel", {
                Size = UDim2.new(1, -20, 0, 24), Position = UDim2.new(0, 10, 0, 76),
                BackgroundTransparency = 1, Text = "this game isn't supported yet!",
                TextColor3 = Color3.fromRGB(50, 40, 20), TextSize = 16, Font = Enum.Font.GothamBold,
                ZIndex = 19, Parent = MainNote,
            })
            new("TextLabel", {
                Size = UDim2.new(1, -30, 0, 52), Position = UDim2.new(0, 15, 0, 104),
                BackgroundTransparency = 1,
                Text = "join our discord to request it!\nwe add new games all the time ♡",
                TextColor3 = Color3.fromRGB(90, 75, 40), TextSize = 13, Font = Enum.Font.GothamMedium,
                TextWrapped = true, ZIndex = 19, Parent = MainNote,
            })

            GoLbl.Text = "💬  join discord"
            GoLbl.TextSize = 15
            tween(GoBtn, { BackgroundColor3 = Color3.fromRGB(130, 140, 230) }, 0.3)
            
            GoBtn.MouseEnter:Connect(function() tween(GoBtn, { BackgroundColor3 = Color3.fromRGB(150, 160, 245) }, 0.15) end)
            GoBtn.MouseLeave:Connect(function() tween(GoBtn, { BackgroundColor3 = Color3.fromRGB(130, 140, 230) }, 0.2) end)

            GoBtn.MouseButton1Click:Connect(function()
                pcall(function() if setclipboard then setclipboard(DISCORD_LINK) end end)
                GoLbl.Text = "✓  discord copied!"
                task.delay(2, function() 
                    if GoLbl and GoLbl.Parent then GoLbl.Text = "💬  join discord" end 
                end)
            end)
        end
    else
        StatusLbl.Text = "nah that ain't it 😅"
        StatusLbl.TextColor3 = Color3.fromRGB(200, 60, 60)
        shakeInput()
        local origR = MainNote.Rotation
        tween(MainNote, { Rotation = origR + 4 }, 0.08)
        task.wait(0.1)
        tween(MainNote, { Rotation = origR - 4 }, 0.08)
        task.wait(0.1)
        tween(MainNote, { Rotation = origR }, 0.12)
        wobblePins()
        GoLbl.Text = "let me in! →"
        tween(GoBtn, { BackgroundColor3 = Color3.fromRGB(100, 185, 100) }, 0.2)
        task.delay(3, function() 
            if StatusLbl and StatusLbl.Parent then StatusLbl.Text = "" end 
        end)
        verifying = false
    end
end

GoBtn.MouseButton1Click:Connect(doVerify)
KeyInput.FocusLost:Connect(function(enter) if enter then doVerify() end end)

-- UI drag handlers
local dragging, dragInput, dragStart, startPos
Board.InputBegan:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
        local relY = input.Position.Y - Board.AbsolutePosition.Y
        local relX = input.Position.X - Board.AbsolutePosition.X
        local onClose = (relX > Board.AbsoluteSize.X - 50 and relY < 46)
        if relY <= 30 and not onClose then
            dragging = true
            dragStart = input.Position
            startPos = Board.Position
            wobblePins()
            input.Changed:Connect(function() 
                if input.UserInputState == Enum.UserInputState.End then dragging = false end 
            end)
        end
    end
end)

Board.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local d = input.Position - dragStart
        Board.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
end)
