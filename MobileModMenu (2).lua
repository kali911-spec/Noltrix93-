
-- Mobile Mod Menu (Rebuilt from Scratch)
-- Features: Draggable GUI, Teleport, Speed, Noclip, Fly (joystick-style), Prank Chat, Scrollable

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

-- Clean up old GUI if exists
if PlayerGui:FindFirstChild("ModMenu") then PlayerGui.ModMenu:Destroy() end

-- Main GUI
local gui = Instance.new("ScreenGui", PlayerGui)
gui.Name = "ModMenu"
gui.ResetOnSpawn = false

-- Toggle Button
local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.new(0, 40, 0, 40)
toggleBtn.Position = UDim2.new(0, 10, 0, 10)
toggleBtn.Text = "≡"
toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.TextScaled = true
toggleBtn.ZIndex = 10

-- Main Frame (Draggable)
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 400)
frame.Position = UDim2.new(0.5, -150, 0.5, -200)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Active = true
frame.Draggable = true
frame.Visible = false

-- Title
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "Mobile Mod Menu"
title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18

-- Close Button
local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -30, 0, 0)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.MouseButton1Click:Connect(function() frame.Visible = false end)

toggleBtn.MouseButton1Click:Connect(function() frame.Visible = not frame.Visible end)

-- Scrollable Frame
local scroll = Instance.new("ScrollingFrame", frame)
scroll.Size = UDim2.new(1, 0, 1, -30)
scroll.Position = UDim2.new(0, 0, 0, 30)
scroll.CanvasSize = UDim2.new(0, 0, 0, 600)
scroll.ScrollBarThickness = 6
scroll.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0, 5)

-- Utilities
local function newBtn(text, func)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -10, 0, 40)
    b.Text = text
    b.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.SourceSans
    b.TextSize = 16
    b.Parent = scroll
    b.MouseButton1Click:Connect(func)
end

-- Teleport to Player
local selected = nil
newBtn("Select Player", function()
    local menu = Instance.new("Frame", scroll)
    menu.Size = UDim2.new(1, -10, 0, 120)
    menu.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    menu.ClipsDescendants = true
    menu.Parent = scroll
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local opt = Instance.new("TextButton", menu)
            opt.Size = UDim2.new(1, 0, 0, 20)
            opt.Text = p.Name
            opt.BackgroundColor3 = Color3.fromRGB(65,65,65)
            opt.TextColor3 = Color3.new(1,1,1)
            opt.MouseButton1Click:Connect(function()
                selected = p
                menu:Destroy()
            end)
        end
    end
end)

newBtn("Teleport to Player", function()
    if selected and selected.Character and selected.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character:MoveTo(selected.Character.HumanoidRootPart.Position + Vector3.new(2,0,0))
    end
end)

-- Speed control
local speedInput = Instance.new("TextBox")
speedInput.Size = UDim2.new(1, -10, 0, 40)
speedInput.Text = "Speed (16-300)"
speedInput.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
speedInput.TextColor3 = Color3.new(1,1,1)
speedInput.Parent = scroll

newBtn("Set Speed", function()
    local val = tonumber(speedInput.Text)
    if val and val >= 16 and val <= 300 then
        LocalPlayer.Character.Humanoid.WalkSpeed = val
    end
end)

-- Noclip
local noclip = false
newBtn("Toggle Noclip", function()
    noclip = not noclip
end)

RunService.Stepped:Connect(function()
    if noclip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- Fly
local flying = false
local bv

newBtn("Toggle Fly", function()
    flying = not flying
    if flying then
        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then
            bv = Instance.new("BodyVelocity", root)
            bv.MaxForce = Vector3.new(1e5,1e5,1e5)
            bv.Velocity = Vector3.new()
        end
    elseif bv then
        bv:Destroy()
    end
end)

RunService.RenderStepped:Connect(function()
    if flying and bv then
        local move = Vector3.zero
        if UIS:IsKeyDown(Enum.KeyCode.W) then move += Vector3.new(0, 0, -1) end
        if UIS:IsKeyDown(Enum.KeyCode.S) then move += Vector3.new(0, 0, 1) end
        if UIS:IsKeyDown(Enum.KeyCode.A) then move += Vector3.new(-1, 0, 0) end
        if UIS:IsKeyDown(Enum.KeyCode.D) then move += Vector3.new(1, 0, 0) end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0, 1, 0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then move += Vector3.new(0, -1, 0) end
        if move.Magnitude > 0 then
            bv.Velocity = move.Unit * 50
        else
            bv.Velocity = Vector3.zero
        end
    end
end)

-- Prank Chat
local prankBox = Instance.new("TextBox")
prankBox.Size = UDim2.new(1, -10, 0, 40)
prankBox.Text = "Enter system message..."
prankBox.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
prankBox.TextColor3 = Color3.new(1,1,1)
prankBox.Parent = scroll

newBtn("Send Prank Chat", function()
    local msg = prankBox.Text
    if msg and msg ~= "" then
        game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("[System]: "..msg, "All")
    end
end)
