local vim = game:GetService("VirtualInputManager")
local players = game:GetService("Players")
local lp = players.LocalPlayer

-- Create UI
local screenGui = Instance.new("ScreenGui")
local toggleBtn = Instance.new("TextButton")

screenGui.Name = "AutoClickerUI"
screenGui.Parent = lp:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

toggleBtn.Size = UDim2.new(0, 150, 0, 50)
toggleBtn.Position = UDim2.new(0.5, -75, 0.1, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
toggleBtn.Text = "Auto Click: OFF"
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.TextSize = 20
toggleBtn.Parent = screenGui
toggleBtn.Draggable = true -- Allows you to move it around

local active = false

-- Function to handle the clicking logic
local function click(x, y)
    vim:SendMouseButtonEvent(x, y, 0, true, game, 0)
    task.wait(0.01)
    vim:SendMouseButtonEvent(x, y, 0, false, game, 0)
end

-- Toggle logic
toggleBtn.MouseButton1Click:Connect(function()
    active = not active
    toggleBtn.Text = "Auto Click: " .. (active and "ON" or "OFF")
    toggleBtn.BackgroundColor3 = active and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
end)

-- Main Loop
task.spawn(function()
    while true do
        if active then
            local mainGui = lp.PlayerGui:FindFirstChild("ScreenGui")
            if mainGui then
                for _, v in pairs(mainGui:GetChildren()) do
                    if v:IsA("ScrollingFrame") and v.Visible then
                        for _, b in pairs(v:GetDescendants()) do
                            if not active then break end -- Stop immediately if toggled off
                            
                            if b:IsA("GuiButton") and b.Visible and b.AbsoluteSize.X > 0 then
                                -- Check if button is actually on screen (not scrolled away)
                                local p = b.AbsolutePosition
                                local s = b.AbsoluteSize
                                local x, y = p.X + s.X/2, p.Y + s.Y/2 + 36
                                
                                click(x, y)
                                task.wait(0.02) -- Small delay to prevent crashing
                            end
                        end
                    end
                end
            end
        end
        task.wait(0.1)
    end
end)
