
-- Mobile Mod Menu for Roblox (Fixed Version)
-- Features: Draggable GUI, Joystick Fly, Prank Chat, Noclip, Speed Toggle & Reset, Teleport, Scrollable Frame

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Clear old GUI
if PlayerGui:FindFirstChild("ModMenu") then
    PlayerGui.ModMenu:Destroy()
end

-- GUI
local ModMenu = Instance.new("ScreenGui", PlayerGui)
ModMenu.Name = "ModMenu"
ModMenu.ResetOnSpawn = false

-- Toggle Button
local ToggleBtn = Instance.new("TextButton", ModMenu)
ToggleBtn.Size = UDim2.new(0, 40, 0, 40)
ToggleBtn.Position = UDim2.new(0, 10, 0, 10)
ToggleBtn.Text = "≡"
ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ToggleBtn.TextColor3 = Color3.new(1, 1, 1)
ToggleBtn.TextScaled = true
ToggleBtn.ZIndex = 10
ToggleBtn.Active = true
ToggleBtn.Draggable = true

-- Main Frame
local Frame = Instance.new("ScrollingFrame", ModMenu)
Frame.Size = UDim2.new(0, 300, 0, 350)
Frame.Position = UDim2.new(0.5, -150, 0.5, -175)
Frame.CanvasSize = UDim2.new(0, 0, 1.5, 0)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Visible = false
Frame.ScrollBarThickness = 8

-- Toggle GUI visibility
ToggleBtn.MouseButton1Click:Connect(function()
    Frame.Visible = not Frame.Visible
end)

local function CreateButton(text, order, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, 10 + ((order - 1) * 35))
    btn.Text = text
    btn.BackgroundColor3 = color or Color3.fromRGB(70, 70, 70)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 18
    btn.Parent = Frame
    return btn
end

-- Speed Section
local speedBox = Instance.new("TextBox", Frame)
speedBox.Size = UDim2.new(0.5, -15, 0, 30)
speedBox.Position = UDim2.new(0, 10, 0, 10)
speedBox.Text = "Speed (16-300)"
speedBox.TextColor3 = Color3.new(1,1,1)
speedBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)

local applySpeed = CreateButton("Apply Speed", 1, Color3.fromRGB(60, 100, 60))
applySpeed.Position = UDim2.new(0.5, 5, 0, 10)
applySpeed.MouseButton1Click:Connect(function()
    local val = tonumber(speedBox.Text)
    if val and val >= 16 and val <= 300 then
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
        if hum then hum.WalkSpeed = val end
    end
end)

local resetSpeed = CreateButton("Reset Speed", 2, Color3.fromRGB(120, 80, 60))
resetSpeed.MouseButton1Click:Connect(function()
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    if hum then hum.WalkSpeed = 16 end
end)

-- Noclip
local noclipEnabled = false
local noclipBtn = CreateButton("Toggle Noclip", 3, Color3.fromRGB(80, 50, 100))
noclipBtn.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
end)

RunService.Stepped:Connect(function()
    if noclipEnabled and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- Fly
local flying = false
local flyVel
local flyBtn = CreateButton("Toggle Fly", 4, Color3.fromRGB(60, 120, 150))
flyBtn.MouseButton1Click:Connect(function()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    flying = not flying
    if flying then
        flyVel = Instance.new("BodyVelocity")
        flyVel.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        flyVel.Velocity = Vector3.zero
        flyVel.Parent = root
    else
        if flyVel then flyVel:Destroy() end
    end
end)

RunService.RenderStepped:Connect(function()
    if flying and flyVel then
        local cam = workspace.CurrentCamera
        local dir = Vector3.zero
        if UIS:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0,1,0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.new(0,1,0) end
        flyVel.Velocity = dir.Unit * 70
    end
end)

-- Prank Chat
local chatBox = Instance.new("TextBox", Frame)
chatBox.Size = UDim2.new(1, -20, 0, 30)
chatBox.Position = UDim2.new(0, 10, 0, 155)
chatBox.PlaceholderText = "System Message"

local chatBtn = CreateButton("Send Prank Chat", 6, Color3.fromRGB(100, 120, 50))
chatBtn.MouseButton1Click:Connect(function()
    local msg = chatBox.Text
    if msg and #msg > 0 then
        StarterGui:SetCore("ChatMakeSystemMessage", {
            Text = "[System]: "..msg,
            Color = Color3.fromRGB(255, 255, 0),
            Font = Enum.Font.SourceSansBold,
            FontSize = Enum.FontSize.Size24
        })
    end
end)
