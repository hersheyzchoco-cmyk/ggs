-- ══════════════════════════════════════════════════════════════════
--   IBdihP Hub — Minimal Loader with Key System
--   Made by Hersheyz
-- ══════════════════════════════════════════════════════════════════

local CONFIG = {
    ValidKeys = {
        "ilyguys",
    },
    KeyLink = "https://discord.gg/DHeCNzTypH",
    GameScripts = {
        [109715918987082] = "https://raw.githubusercontent.com/hersheyzchoco-cmyk/ggs/refs/heads/main/main.lua",
        [71724366181884] = "https://raw.githubusercontent.com/hersheyzchoco-cmyk/ggs/refs/heads/main/worldcup.lua",
    },
    Title = "IBdihP Hub",
    Subtitle = "PERMANENT FREE KEY IN DISCORD",
    Version = "v6.7",
}

-- Colors
local C = {
    bg       = Color3.fromRGB(10, 10, 14),
    card     = Color3.fromRGB(16, 16, 22),
    surface  = Color3.fromRGB(22, 22, 30),
    input    = Color3.fromRGB(28, 28, 38),
    border   = Color3.fromRGB(40, 40, 55),
    text     = Color3.fromRGB(240, 240, 250),
    sub      = Color3.fromRGB(120, 120, 145),
    muted    = Color3.fromRGB(70, 70, 90),
    accent1  = Color3.fromRGB(120, 80, 255),
    accent2  = Color3.fromRGB(200, 100, 255),
    accent3  = Color3.fromRGB(100, 180, 255),
    success  = Color3.fromRGB(80, 220, 140),
    error    = Color3.fromRGB(255, 70, 80),
    warning  = Color3.fromRGB(255, 190, 50),
}

local Players      = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer  = Players.LocalPlayer
local PlayerGui    = LocalPlayer:WaitForChild("PlayerGui")

local function getExecutorName()
    if identifyexecutor then return identifyexecutor() or "Unknown"
    elseif syn then return "Synapse"
    elseif fluxus then return "Fluxus"
    elseif KRNL_LOADED then return "KRNL"
    else return "Unknown" end
end

-- Key save/load
local KEY_FILE = "IBdihP_Hub_Key.txt"
local function saveKey(k) if writefile then pcall(writefile, KEY_FILE, k) end end
local function loadKey()
    if isfile and readfile then
        local ok, d = pcall(function() return isfile(KEY_FILE) and readfile(KEY_FILE) or nil end)
        if ok and d and d ~= "" then return d end
    end
    return nil
end
local function isValidKey(k)
    if not k or k == "" then return false end
    for _, v in ipairs(CONFIG.ValidKeys) do if k == v then return true end end
    return false
end

-- Launch script
local function launchScript()
    local url = CONFIG.GameScripts[game.PlaceId]
    if url and url ~= "" then
        local ok, err = pcall(function() loadstring(game:HttpGet(url))() end)
        if not ok then warn("[IBdihP Hub] Load failed: " .. tostring(err)) end
    else
        warn("[IBdihP Hub] No script for PlaceId: " .. tostring(game.PlaceId))
    end
end

-- Auto-launch if saved key is valid
local savedKey = loadKey()
if savedKey and isValidKey(savedKey) then
    launchScript()
    return
end

-- Clean up old GUI
for _, g in ipairs(PlayerGui:GetChildren()) do
    if g.Name == "IBdihPLoader" then g:Destroy() end
end

-- Helpers
local function tw(obj, props, dur, style, dir)
    local t = TweenService:Create(obj, TweenInfo.new(dur or 0.35, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out), props)
    t:Play()
    return t
end

local function mk(class, props)
    local i = Instance.new(class)
    for k, v in pairs(props or {}) do i[k] = v end
    return i
end

local function corner(p, r)
    local c = mk("UICorner", { CornerRadius = r or UDim.new(0, 8) })
    c.Parent = p
    return c
end

local function stroke(p, col, th, tr)
    local s = mk("UIStroke", { Color = col or C.border, Thickness = th or 1, Transparency = tr or 0 })
    s.Parent = p
    return s
end

local function grad(p, c1, c2, c3, rot)
    local g = mk("UIGradient", { Rotation = rot or 0 })
    if c3 then
        g.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, c1),
            ColorSequenceKeypoint.new(0.5, c2),
            ColorSequenceKeypoint.new(1, c3),
        })
    else
        g.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, c1), ColorSequenceKeypoint.new(1, c2) })
    end
    g.Parent = p
    return g
end

-- GUI
local gui = mk("ScreenGui", {
    Name = "IBdihPLoader",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    IgnoreGuiInset = true,
    DisplayOrder = 999,
    Parent = PlayerGui,
})

-- Full-screen overlay
local overlay = mk("Frame", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundColor3 = C.bg,
    BackgroundTransparency = 1,
    Parent = gui,
})
tw(overlay, { BackgroundTransparency = 0.3 }, 0.6)

-- Ambient gradient mesh behind card
local ambientGlow = mk("Frame", {
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.new(0.5, 0, 0.5, 0),
    Size = UDim2.new(0, 500, 0, 500),
    BackgroundColor3 = C.accent1,
    BackgroundTransparency = 0.92,
    Parent = gui,
})
corner(ambientGlow, UDim.new(1, 0))
grad(ambientGlow, C.accent1, C.accent2, C.accent3, 135)

-- Slow rotate ambient glow
task.spawn(function()
    local g = ambientGlow:FindFirstChildWhichIsA("UIGradient")
    local rot = 135
    while ambientGlow and ambientGlow.Parent do
        rot = (rot + 0.3) % 360
        g.Rotation = rot
        task.wait(0.03)
    end
end)

-- Main card
local card = mk("Frame", {
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.new(0.5, 0, 0.5, 0),
    Size = UDim2.new(0, 0, 0, 0),
    BackgroundColor3 = C.card,
    Parent = gui,
})
corner(card, UDim.new(0, 16))
stroke(card, C.border, 1, 0.5)

-- Accent line at top of card
local topAccent = mk("Frame", {
    Size = UDim2.new(1, 0, 0, 3),
    Position = UDim2.new(0, 0, 0, 0),
    BackgroundColor3 = C.accent1,
    BackgroundTransparency = 0,
    Parent = card,
})
corner(topAccent, UDim.new(0, 16))
grad(topAccent, C.accent1, C.accent2, C.accent3, 0)

-- Animate card in
tw(card, { Size = UDim2.new(0, 380, 0, 440) }, 0.7, Enum.EasingStyle.Back)
task.wait(0.4)

-- Content
local content = mk("Frame", {
    Size = UDim2.new(1, -48, 1, -48),
    Position = UDim2.new(0, 24, 0, 24),
    BackgroundTransparency = 1,
    Parent = card,
})

-- Icon
local iconBg = mk("Frame", {
    AnchorPoint = Vector2.new(0.5, 0),
    Position = UDim2.new(0.5, 0, 0, 8),
    Size = UDim2.new(0, 52, 0, 52),
    BackgroundColor3 = C.surface,
    Parent = content,
})
corner(iconBg, UDim.new(0, 12))
stroke(iconBg, C.border, 1, 0.4)

local icon = mk("ImageLabel", {
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.new(0.5, 0, 0.5, 0),
    Size = UDim2.new(0, 32, 0, 32),
    BackgroundTransparency = 1,
    Image = "rbxassetid://114748833858413",
    Parent = iconBg,
})

-- Title
local title = mk("TextLabel", {
    Position = UDim2.new(0, 0, 0, 70),
    Size = UDim2.new(1, 0, 0, 26),
    BackgroundTransparency = 1,
    Text = CONFIG.Title,
    TextColor3 = C.text,
    TextSize = 22,
    Font = Enum.Font.GothamBold,
    Parent = content,
})

-- Subtitle
local subtitle = mk("TextLabel", {
    Position = UDim2.new(0, 0, 0, 96),
    Size = UDim2.new(1, 0, 0, 16),
    BackgroundTransparency = 1,
    Text = CONFIG.Subtitle .. "  ·  " .. CONFIG.Version,
    TextColor3 = C.sub,
    TextSize = 12,
    Font = Enum.Font.GothamMedium,
    Parent = content,
})

-- Info chips
local chipY = 124

local function makeChip(text, posX, width)
    local chip = mk("Frame", {
        Position = UDim2.new(posX, 0, 0, chipY),
        Size = UDim2.new(width or 0.48, 0, 0, 24),
        BackgroundColor3 = C.surface,
        Parent = content,
    })
    corner(chip, UDim.new(0, 6))
    mk("TextLabel", {
        Size = UDim2.new(1, -12, 1, 0),
        Position = UDim2.new(0, 6, 0, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = C.muted,
        TextSize = 10,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = chip,
    })
    return chip
end

makeChip("👤 " .. LocalPlayer.Name, 0)
makeChip("⚙️ " .. getExecutorName(), 0.52)

-- Divider
local divider = mk("Frame", {
    AnchorPoint = Vector2.new(0.5, 0),
    Position = UDim2.new(0.5, 0, 0, chipY + 36),
    Size = UDim2.new(1, 0, 0, 1),
    BackgroundColor3 = C.border,
    BackgroundTransparency = 0.5,
    Parent = content,
})

-- Key section
local keyY = chipY + 50

local keyLabel = mk("TextLabel", {
    Position = UDim2.new(0, 0, 0, keyY),
    Size = UDim2.new(1, 0, 0, 14),
    BackgroundTransparency = 1,
    Text = "ENTER KEY",
    TextColor3 = C.muted,
    TextSize = 10,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = content,
})

local inputBox = mk("Frame", {
    Position = UDim2.new(0, 0, 0, keyY + 20),
    Size = UDim2.new(1, 0, 0, 38),
    BackgroundColor3 = C.input,
    Parent = content,
})
corner(inputBox, UDim.new(0, 8))
local inputStroke = stroke(inputBox, C.border, 1, 0.3)

local keyInput = mk("TextBox", {
    Size = UDim2.new(1, -16, 1, 0),
    Position = UDim2.new(0, 8, 0, 0),
    BackgroundTransparency = 1,
    Text = savedKey or "",
    PlaceholderText = "Paste key here...",
    PlaceholderColor3 = C.muted,
    TextColor3 = C.text,
    TextSize = 13,
    Font = Enum.Font.GothamMedium,
    TextXAlignment = Enum.TextXAlignment.Left,
    ClearTextOnFocus = false,
    Parent = inputBox,
})

keyInput.Focused:Connect(function()
    tw(inputStroke, { Color = C.accent1, Transparency = 0 }, 0.2)
end)
keyInput.FocusLost:Connect(function()
    tw(inputStroke, { Color = C.border, Transparency = 0.3 }, 0.2)
end)

-- Status
local status = mk("TextLabel", {
    Position = UDim2.new(0, 0, 0, keyY + 64),
    Size = UDim2.new(1, 0, 0, 14),
    BackgroundTransparency = 1,
    Text = "",
    TextColor3 = C.sub,
    TextSize = 11,
    Font = Enum.Font.GothamMedium,
    Parent = content,
})

local function setStatus(txt, col, dur)
    status.Text = txt
    status.TextColor3 = col or C.sub
    status.TextTransparency = 0
    if dur then task.delay(dur, function()
        if status.Parent then tw(status, { TextTransparency = 1 }, 0.4) end
    end) end
end

-- Buttons
local btnY = keyY + 86

local function makeBtn(text, y, isPrimary, cb)
    local btn = mk("TextButton", {
        Position = UDim2.new(0, 0, 0, y),
        Size = UDim2.new(1, 0, 0, 36),
        BackgroundColor3 = isPrimary and C.accent1 or C.surface,
        Text = "",
        AutoButtonColor = false,
        Parent = content,
    })
    corner(btn, UDim.new(0, 8))

    if isPrimary then
        grad(btn, C.accent1, C.accent2, C.accent3, 135)

        -- Slow gradient rotation
        task.spawn(function()
            local g = btn:FindFirstChildWhichIsA("UIGradient")
            local r = 135
            while btn and btn.Parent do
                r = (r + 0.2) % 360
                g.Rotation = r
                task.wait(0.03)
            end
        end)
    else
        stroke(btn, C.border, 1, 0.4)
    end

    local label = mk("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = isPrimary and Color3.fromRGB(255, 255, 255) or C.sub,
        TextSize = 13,
        Font = Enum.Font.GothamBold,
        Parent = btn,
    })

    btn.MouseEnter:Connect(function()
        tw(btn, { BackgroundTransparency = isPrimary and 0.08 or 0 }, 0.15)
        if not isPrimary then tw(btn, { BackgroundColor3 = C.input }, 0.15) end
    end)
    btn.MouseLeave:Connect(function()
        tw(btn, { BackgroundTransparency = 0 }, 0.15)
        if not isPrimary then tw(btn, { BackgroundColor3 = C.surface }, 0.15) end
    end)

    btn.MouseButton1Click:Connect(function()
        tw(btn, { Size = UDim2.new(0.97, 0, 0, 34) }, 0.06)
        task.wait(0.06)
        tw(btn, { Size = UDim2.new(1, 0, 0, 36) }, 0.06)
        task.wait(0.04)
        if cb then cb(btn, label) end
    end)

    return btn, label
end

-- Launch button
makeBtn("Launch", btnY, true, function(btn, label)
    local key = keyInput.Text:gsub("^%s+", ""):gsub("%s+$", "")

    if key == "" then
        setStatus("Enter a key first", C.warning, 3)
        return
    end

    if not isValidKey(key) then
        setStatus("Invalid key", C.error, 3)
        local orig = inputBox.Position
        for i = 1, 3 do
            tw(inputBox, { Position = orig + UDim2.new(0, i % 2 == 0 and 5 or -5, 0, 0) }, 0.04)
            task.wait(0.04)
        end
        tw(inputBox, { Position = orig }, 0.04)
        return
    end

    saveKey(key)
    setStatus("Validated", C.success)
    keyInput.TextEditable = false
    btn.Active = false
    label.Text = "Loading..."

    task.wait(0.4)

    -- Progress bar
    local progBg = mk("Frame", {
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0, btnY + 44),
        Size = UDim2.new(1, 0, 0, 4),
        BackgroundColor3 = C.surface,
        Parent = content,
    })
    corner(progBg, UDim.new(1, 0))

    local progFill = mk("Frame", {
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = C.accent1,
        Parent = progBg,
    })
    corner(progFill, UDim.new(1, 0))
    grad(progFill, C.accent1, C.accent2, C.accent3, 0)

    tw(progFill, { Size = UDim2.new(1, 0, 1, 0) }, 1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
    task.wait(1.3)

    label.Text = "✓"
    task.wait(0.5)

    -- Animate out
    tw(card, { Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1 }, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In)
    tw(overlay, { BackgroundTransparency = 1 }, 0.4)
    tw(ambientGlow, { BackgroundTransparency = 1 }, 0.4)
    task.wait(0.5)

    gui:Destroy()
    launchScript()
end)

-- Get key button
makeBtn("Get Key  ·  Discord", btnY + 44, false, function()
    setStatus("Link copied!", C.accent3, 3)
    if setclipboard then setclipboard(CONFIG.KeyLink) end
end)

-- Bottom text
mk("TextLabel", {
    AnchorPoint = Vector2.new(0.5, 1),
    Position = UDim2.new(0.5, 0, 1, -4),
    Size = UDim2.new(1, 0, 0, 12),
    BackgroundTransparency = 1,
    Text = "by hersheyz  ·  discord.gg/DHeCNzTypH",
    TextColor3 = C.muted,
    TextSize = 9,
    Font = Enum.Font.GothamMedium,
    TextTransparency = 0.3,
    Parent = content,
})
