-- ══════════════════════════════════════════
--   CONFIGURATION
-- ══════════════════════════════════════════
local CONFIG = {
    -- Valid keys (add/remove as needed)
    ValidKeys = {
        "ilyguys",
    },

    KeyLink = "https://discord.gg/DHeCNzTypH",

    -- Scripts per game (PlaceId → raw script URL or loadstring)
    GameScripts = {
        -- Anime Star Card Collection
        [109715918987082] = "https://raw.githubusercontent.com/hersheyzchoco-cmyk/ggs/refs/heads/main/main.lua",
        -- World Cup Album
        [71724366181884] = "https://raw.githubusercontent.com/hersheyzchoco-cmyk/ggs/refs/heads/main/worldcup.lua",
    },

    -- UI Config
    Title = "IBdihP Hub",
    Subtitle = "FREE PERMANENT KEY IN DISCORD",
    Version = "v6.7",
    AccentColor = Color3.fromRGB(138, 97, 255),
    DarkBg = Color3.fromRGB(18, 18, 24),
    CardBg = Color3.fromRGB(25, 25, 35),
    InputBg = Color3.fromRGB(32, 32, 45),
    TextColor = Color3.fromRGB(235, 235, 245),
    SubTextColor = Color3.fromRGB(160, 160, 180),
    ErrorColor = Color3.fromRGB(255, 75, 75),
    SuccessColor = Color3.fromRGB(75, 255, 130),
    WarningColor = Color3.fromRGB(255, 200, 50),
    CornerRadius = UDim.new(0, 10),
    Font = Enum.Font.GothamBold,
    FontLight = Enum.Font.GothamMedium,
}

-- ══════════════════════════════════════════
--   SERVICES
-- ══════════════════════════════════════════
local Players           = game:GetService("Players")
local TweenService      = game:GetService("TweenService")
local RunService        = game:GetService("RunService")
local HttpService       = game:GetService("HttpService")
local LocalPlayer       = Players.LocalPlayer
local PlayerGui         = LocalPlayer:WaitForChild("PlayerGui")

-- ══════════════════════════════════════════
--   EXECUTOR DETECTION
-- ══════════════════════════════════════════
local function getExecutorName()
    if identifyexecutor then
        local name = identifyexecutor()
        return name or "Unknown"
    elseif syn then return "Synapse"
    elseif fluxus then return "Fluxus"
    elseif KRNL_LOADED then return "KRNL"
    elseif pebc_execute then return "Pencil"
    else return "Unknown"
    end
end

-- ══════════════════════════════════════════
--   SAVED KEY SYSTEM
-- ══════════════════════════════════════════
local SAVE_KEY_FILE = "IBdihP_Hub_Key.txt"

local function saveKey(key)
    if writefile then
        pcall(function()
            writefile(SAVE_KEY_FILE, key)
        end)
    end
end

local function loadSavedKey()
    if isfile and readfile then
        local ok, data = pcall(function()
            if isfile(SAVE_KEY_FILE) then
                return readfile(SAVE_KEY_FILE)
            end
            return nil
        end)
        if ok and data and data ~= "" then
            return data
        end
    end
    return nil
end

local function deleteSavedKey()
    if delfile and isfile then
        pcall(function()
            if isfile(SAVE_KEY_FILE) then
                delfile(SAVE_KEY_FILE)
            end
        end)
    end
end

local function validateKey(key)
    if not key or key == "" then return false end
    for _, validKey in ipairs(CONFIG.ValidKeys) do
        if key == validKey then
            return true
        end
    end
    return false
end

-- ══════════════════════════════════════════
--   DESTROY EXISTING GUI
-- ══════════════════════════════════════════
for _, gui in ipairs(PlayerGui:GetChildren()) do
    if gui.Name == "IBdihPLoader" then
        gui:Destroy()
    end
end

-- ══════════════════════════════════════════
--   CREATE SCREEN GUI
-- ══════════════════════════════════════════
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "IBdihPLoader"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 999
ScreenGui.Parent = PlayerGui

-- ══════════════════════════════════════════
--   UTILITY FUNCTIONS
-- ══════════════════════════════════════════
local function create(class, props, children)
    local inst = Instance.new(class)
    for k, v in pairs(props or {}) do
        inst[k] = v
    end
    for _, child in ipairs(children or {}) do
        child.Parent = inst
    end
    return inst
end

local function addCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = radius or CONFIG.CornerRadius
    corner.Parent = parent
    return corner
end

local function addStroke(parent, color, thickness, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or CONFIG.AccentColor
    stroke.Thickness = thickness or 1.5
    stroke.Transparency = transparency or 0.5
    stroke.Parent = parent
    return stroke
end

local function addPadding(parent, top, bottom, left, right)
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, top or 0)
    padding.PaddingBottom = UDim.new(0, bottom or 0)
    padding.PaddingLeft = UDim.new(0, left or 0)
    padding.PaddingRight = UDim.new(0, right or 0)
    padding.Parent = parent
    return padding
end

local function addGradient(parent, c1, c2, rotation)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, c1),
        ColorSequenceKeypoint.new(1, c2),
    })
    gradient.Rotation = rotation or 90
    gradient.Parent = parent
    return gradient
end

local function tweenProperty(obj, props, duration, style, direction)
    local tween = TweenService:Create(obj, TweenInfo.new(
        duration or 0.3,
        style or Enum.EasingStyle.Quart,
        direction or Enum.EasingDirection.Out
    ), props)
    tween:Play()
    return tween
end

-- ══════════════════════════════════════════
--   BACKGROUND OVERLAY
-- ══════════════════════════════════════════
local Overlay = create("Frame", {
    Name = "Overlay",
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundColor3 = Color3.fromRGB(0, 0, 0),
    BackgroundTransparency = 1,
    Parent = ScreenGui,
})

tweenProperty(Overlay, { BackgroundTransparency = 0.4 }, 0.5)

-- ══════════════════════════════════════════
--   ANIMATED BACKGROUND PARTICLES
-- ══════════════════════════════════════════
local function createParticle()
    local size = math.random(2, 6)
    local particle = create("Frame", {
        Size = UDim2.new(0, size, 0, size),
        Position = UDim2.new(math.random() * 0.9 + 0.05, 0, 1.05, 0),
        BackgroundColor3 = CONFIG.AccentColor,
        BackgroundTransparency = math.random(60, 85) / 100,
        Parent = Overlay,
    })
    addCorner(particle, UDim.new(1, 0))

    local duration = math.random(40, 80) / 10
    local targetX = particle.Position.X.Scale + (math.random(-20, 20) / 100)

    tweenProperty(particle, {
        Position = UDim2.new(targetX, 0, -0.05, 0),
        BackgroundTransparency = 1,
        Size = UDim2.new(0, size * 0.3, 0, size * 0.3),
    }, duration, Enum.EasingStyle.Linear)

    task.delay(duration, function()
        particle:Destroy()
    end)
end

task.spawn(function()
    while ScreenGui and ScreenGui.Parent do
        createParticle()
        task.wait(math.random(3, 8) / 10)
    end
end)

-- ══════════════════════════════════════════
--   MAIN CARD
-- ══════════════════════════════════════════
local MainCard = create("Frame", {
    Name = "MainCard",
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.new(0.5, 0, 0.5, 0),
    Size = UDim2.new(0, 0, 0, 0),
    BackgroundColor3 = CONFIG.CardBg,
    BackgroundTransparency = 0,
    Parent = ScreenGui,
})
addCorner(MainCard, UDim.new(0, 14))
addStroke(MainCard, CONFIG.AccentColor, 2, 0.3)

-- Subtle inner glow
local InnerGlow = create("Frame", {
    Size = UDim2.new(1, 0, 0, 120),
    Position = UDim2.new(0, 0, 0, 0),
    BackgroundColor3 = CONFIG.AccentColor,
    BackgroundTransparency = 0.92,
    Parent = MainCard,
})
addCorner(InnerGlow, UDim.new(0, 14))
addGradient(InnerGlow, Color3.fromRGB(255, 255, 255), Color3.fromRGB(0, 0, 0), 90)

-- Animate card in
tweenProperty(MainCard, {
    Size = UDim2.new(0, 420, 0, 520),
}, 0.6, Enum.EasingStyle.Back)

task.wait(0.3)

-- ══════════════════════════════════════════
--   CONTENT CONTAINER
-- ══════════════════════════════════════════
local ContentFrame = create("Frame", {
    Name = "Content",
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Parent = MainCard,
})
addPadding(ContentFrame, 30, 30, 30, 30)

-- ══════════════════════════════════════════
--   LOGO / ICON
-- ══════════════════════════════════════════
local LogoContainer = create("Frame", {
    Size = UDim2.new(1, 0, 0, 70),
    BackgroundTransparency = 1,
    Parent = ContentFrame,
})

local LogoIcon = create("ImageLabel", {
    AnchorPoint = Vector2.new(0.5, 0),
    Position = UDim2.new(0.5, 0, 0, 0),
    Size = UDim2.new(0, 60, 0, 60),
    BackgroundColor3 = CONFIG.AccentColor,
    BackgroundTransparency = 0.85,
    Image = "rbxassetid://114748833858413",
    Parent = LogoContainer,
})
addCorner(LogoIcon, UDim.new(1, 0))
addStroke(LogoIcon, CONFIG.AccentColor, 2, 0.4)

-- Pulse animation on logo
task.spawn(function()
    while LogoIcon and LogoIcon.Parent do
        tweenProperty(LogoIcon, { BackgroundTransparency = 0.7 }, 1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        task.wait(1.5)
        tweenProperty(LogoIcon, { BackgroundTransparency = 0.9 }, 1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        task.wait(1.5)
    end
end)

-- ══════════════════════════════════════════
--   TITLE & SUBTITLE
-- ══════════════════════════════════════════
local TitleLabel = create("TextLabel", {
    Position = UDim2.new(0, 0, 0, 80),
    Size = UDim2.new(1, 0, 0, 32),
    BackgroundTransparency = 1,
    Text = CONFIG.Title,
    TextColor3 = CONFIG.TextColor,
    TextSize = 28,
    Font = CONFIG.Font,
    Parent = ContentFrame,
})

local SubtitleLabel = create("TextLabel", {
    Position = UDim2.new(0, 0, 0, 112),
    Size = UDim2.new(1, 0, 0, 20),
    BackgroundTransparency = 1,
    Text = CONFIG.Subtitle .. "  •  " .. CONFIG.Version,
    TextColor3 = CONFIG.SubTextColor,
    TextSize = 14,
    Font = CONFIG.FontLight,
    Parent = ContentFrame,
})

-- ══════════════════════════════════════════
--   DIVIDER
-- ══════════════════════════════════════════
local Divider = create("Frame", {
    AnchorPoint = Vector2.new(0.5, 0),
    Position = UDim2.new(0.5, 0, 0, 145),
    Size = UDim2.new(0.85, 0, 0, 1),
    BackgroundColor3 = CONFIG.AccentColor,
    BackgroundTransparency = 0.6,
    Parent = ContentFrame,
})

-- ══════════════════════════════════════════
--   INFO LABELS
-- ══════════════════════════════════════════

local InfoFrame = create("Frame", {
    Position = UDim2.new(0, 0, 0, 158),
    Size = UDim2.new(1, 0, 0, 26),
    BackgroundTransparency = 1,
    Parent = ContentFrame,
})

local function createInfoChip(text, posX, icon)
    local chip = create("Frame", {
        Position = UDim2.new(posX, 0, 0, 0),
        Size = UDim2.new(0.48, 0, 0, 22),
        BackgroundColor3 = CONFIG.InputBg,
        BackgroundTransparency = 0.3,
        Parent = InfoFrame,
    })
    addCorner(chip, UDim.new(0, 6))

    create("TextLabel", {
        Size = UDim2.new(1, -8, 1, 0),
        Position = UDim2.new(0, 4, 0, 0),
        BackgroundTransparency = 1,
        Text = icon .. " " .. text,
        TextColor3 = CONFIG.SubTextColor,
        TextSize = 11,
        Font = CONFIG.FontLight,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = chip,
    })

    return chip
end

createInfoChip(LocalPlayer.Name, 0, "👤")
createInfoChip(getExecutorName(), 0.52, "⚙️")

-- ══════════════════════════════════════════
--   KEY INPUT SECTION
-- ══════════════════════════════════════════
local KeySectionY = 220

local KeyLabel = create("TextLabel", {
    Position = UDim2.new(0, 0, 0, KeySectionY),
    Size = UDim2.new(1, 0, 0, 18),
    BackgroundTransparency = 1,
    Text = "🔑  Enter your key below",
    TextColor3 = CONFIG.SubTextColor,
    TextSize = 13,
    Font = CONFIG.FontLight,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = ContentFrame,
})

local InputContainer = create("Frame", {
    Position = UDim2.new(0, 0, 0, KeySectionY + 24),
    Size = UDim2.new(1, 0, 0, 42),
    BackgroundColor3 = CONFIG.InputBg,
    Parent = ContentFrame,
})
addCorner(InputContainer, UDim.new(0, 8))
local inputStroke = addStroke(InputContainer, CONFIG.SubTextColor, 1.5, 0.6)

local KeyInput = create("TextBox", {
    Size = UDim2.new(1, -16, 1, 0),
    Position = UDim2.new(0, 8, 0, 0),
    BackgroundTransparency = 1,
    Text = "",
    PlaceholderText = "Paste your key here...",
    PlaceholderColor3 = Color3.fromRGB(100, 100, 120),
    TextColor3 = CONFIG.TextColor,
    TextSize = 15,
    Font = CONFIG.FontLight,
    TextXAlignment = Enum.TextXAlignment.Left,
    ClearTextOnFocus = false,
    Parent = InputContainer,
})

-- Input focus animations
KeyInput.Focused:Connect(function()
    tweenProperty(inputStroke, { Color = CONFIG.AccentColor, Transparency = 0.2 }, 0.25)
end)

KeyInput.FocusLost:Connect(function()
    tweenProperty(inputStroke, { Color = CONFIG.SubTextColor, Transparency = 0.6 }, 0.25)
end)

-- Pre-fill saved key
local savedKey = loadSavedKey()
if savedKey then
    KeyInput.Text = savedKey
end

-- ══════════════════════════════════════════
--   STATUS LABEL
-- ══════════════════════════════════════════
local StatusLabel = create("TextLabel", {
    Position = UDim2.new(0, 0, 0, KeySectionY + 72),
    Size = UDim2.new(1, 0, 0, 18),
    BackgroundTransparency = 1,
    Text = "",
    TextColor3 = CONFIG.SubTextColor,
    TextSize = 12,
    Font = CONFIG.FontLight,
    Parent = ContentFrame,
})

local function setStatus(text, color, duration)
    StatusLabel.Text = text
    StatusLabel.TextColor3 = color or CONFIG.SubTextColor
    StatusLabel.TextTransparency = 0
    if duration then
        task.delay(duration, function()
            if StatusLabel and StatusLabel.Parent then
                tweenProperty(StatusLabel, { TextTransparency = 1 }, 0.5)
            end
        end)
    end
end

-- ══════════════════════════════════════════
--   BUTTONS
-- ══════════════════════════════════════════
local ButtonY = KeySectionY + 100

local function createButton(text, posY, isPrimary, callback)
    local btnColor = isPrimary and CONFIG.AccentColor or CONFIG.InputBg
    local textColor = isPrimary and Color3.fromRGB(255, 255, 255) or CONFIG.TextColor

    local btn = create("TextButton", {
        Position = UDim2.new(0, 0, 0, posY),
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = btnColor,
        Text = "",
        AutoButtonColor = false,
        Parent = ContentFrame,
    })
    addCorner(btn, UDim.new(0, 8))

    if isPrimary then
        addGradient(btn,
            CONFIG.AccentColor,
            Color3.fromRGB(
                math.clamp(CONFIG.AccentColor.R * 255 - 30, 0, 255) / 255,
                math.clamp(CONFIG.AccentColor.G * 255 - 20, 0, 255) / 255,
                math.clamp(CONFIG.AccentColor.B * 255 + 20, 0, 255) / 255
            ),
            45
        )
    else
        addStroke(btn, CONFIG.SubTextColor, 1, 0.7)
    end

    local btnLabel = create("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = textColor,
        TextSize = 15,
        Font = CONFIG.Font,
        Parent = btn,
    })

    -- Hover effects
    btn.MouseEnter:Connect(function()
        if isPrimary then
            tweenProperty(btn, { BackgroundTransparency = 0.1 }, 0.2)
        else
            tweenProperty(btn, { BackgroundColor3 = Color3.fromRGB(45, 45, 60) }, 0.2)
        end
    end)

    btn.MouseLeave:Connect(function()
        if isPrimary then
            tweenProperty(btn, { BackgroundTransparency = 0 }, 0.2)
        else
            tweenProperty(btn, { BackgroundColor3 = CONFIG.InputBg }, 0.2)
        end
    end)

    btn.MouseButton1Click:Connect(function()
        -- Click effect
        tweenProperty(btn, { Size = UDim2.new(0.97, 0, 0, 38) }, 0.08)
        task.wait(0.08)
        tweenProperty(btn, { Size = UDim2.new(1, 0, 0, 40) }, 0.08)
        task.wait(0.05)

        if callback then callback(btn, btnLabel) end
    end)

    return btn, btnLabel
end

-- Check Key / Launch Button
local launchBtn, launchLabel = createButton("🔓  Validate & Launch", ButtonY, true, function(btn, label)
    local key = KeyInput.Text:gsub("^%s+", ""):gsub("%s+$", "")

    if key == "" then
        setStatus("⚠️  Please enter a key!", CONFIG.WarningColor, 3)
        return
    end

    if not validateKey(key) then
        setStatus("❌  Invalid key! Please try again.", CONFIG.ErrorColor, 4)

        -- Shake animation
        local originalPos = InputContainer.Position
        for i = 1, 4 do
            tweenProperty(InputContainer, {
                Position = originalPos + UDim2.new(0, (i % 2 == 0) and 6 or -6, 0, 0)
            }, 0.05)
            task.wait(0.05)
        end
        tweenProperty(InputContainer, { Position = originalPos }, 0.05)
        return
    end

    -- Key is valid!
    saveKey(key)
    setStatus("✅  Key validated! Loading script...", CONFIG.SuccessColor)

    -- Disable inputs
    KeyInput.TextEditable = false
    btn.Active = false

    -- Loading animation
    label.Text = "⏳  Loading..."

    task.wait(0.5)

    -- Progress bar
    local progressBg = create("Frame", {
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0, ButtonY + 52),
        Size = UDim2.new(1, 0, 0, 6),
        BackgroundColor3 = CONFIG.InputBg,
        Parent = ContentFrame,
    })
    addCorner(progressBg, UDim.new(1, 0))

    local progressFill = create("Frame", {
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = CONFIG.AccentColor,
        Parent = progressBg,
    })
    addCorner(progressFill, UDim.new(1, 0))
    addGradient(progressFill, CONFIG.AccentColor, CONFIG.SuccessColor, 0)

    tweenProperty(progressFill, { Size = UDim2.new(1, 0, 1, 0) }, 1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)

    task.wait(1.5)

    label.Text = "✅  Launching!"
    setStatus("🚀  Script loaded successfully!", CONFIG.SuccessColor)

    task.wait(0.8)

    -- Animate out
    tweenProperty(MainCard, {
        Size = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
    }, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In)
    tweenProperty(Overlay, { BackgroundTransparency = 1 }, 0.5)

    task.wait(0.6)

    ScreenGui:Destroy()

    -- Load the actual script
    local placeId = game.PlaceId
    local scriptUrl = CONFIG.GameScripts[placeId]

    if scriptUrl and scriptUrl ~= "" and not scriptUrl:find("_HERE") then
        local ok, err = pcall(function()
            loadstring(game:HttpGet(scriptUrl))()
        end)
        if not ok then
            warn("[IBdihP Hub] Failed to load script: " .. tostring(err))
        end
    else
        -- Fallback: try to load a universal or notify
        warn("[IBdihP Hub] No script configured for PlaceId: " .. tostring(placeId))
    end
end)

-- Get Key Button
local getKeyBtn, getKeyLabel = createButton("🔗  Get Key (Discord)", ButtonY + 50, false, function()
    setStatus("📋  Key link copied to clipboard!", CONFIG.AccentColor, 3)
    if setclipboard then
        setclipboard(CONFIG.KeyLink)
    end
end)

-- ══════════════════════════════════════════
--   BOTTOM INFO
-- ══════════════════════════════════════════
local BottomLabel = create("TextLabel", {
    AnchorPoint = Vector2.new(0.5, 1),
    Position = UDim2.new(0.5, 0, 1, 0),
    Size = UDim2.new(1, 0, 0, 16),
    BackgroundTransparency = 1,
    Text = "Made with ❤️ by Hersheyz  •  discord.gg/DHeCNzTypH",
    TextColor3 = Color3.fromRGB(80, 80, 100),
    TextSize = 10,
    Font = CONFIG.FontLight,
    Parent = ContentFrame,
})

-- ══════════════════════════════════════════
--   AUTO-VALIDATE SAVED KEY ON LOAD
-- ══════════════════════════════════════════
if savedKey and validateKey(savedKey) then
    task.delay(1, function()
        setStatus("🔑  Saved key detected! Click launch to continue.", CONFIG.AccentColor)
    end)
end
