
-- Mobile Mod Menu Script (Fixed & Scrollable)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

-- Remove existing GUI
if PlayerGui:FindFirstChild("ModMenu") then
    PlayerGui.ModMenu:Destroy()
end

-- GUI Base
local Gui = Instance.new("ScreenGui", PlayerGui)
Gui.Name = "ModMenu"
Gui.ResetOnSpawn = false

-- Toggle Button
local ToggleBtn = Instance.new("TextButton", Gui)
ToggleBtn.Size = UDim2.new(0, 40, 0, 40)
ToggleBtn.Position = UDim2.new(0, 10, 0, 10)
ToggleBtn.Text = "≡"
ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ToggleBtn.TextColor3 = Color3.new(1, 1, 1)
ToggleBtn.TextScaled = true
ToggleBtn.ZIndex = 10

-- Main Frame
local Frame = Instance.new("Frame", Gui)
Frame.Size = UDim2.new(0, 300, 0, 400)
Frame.Position = UDim2.new(0.5, -150, 0.5, -200)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Visible = false

-- Scrollable Area
local Scroller = Instance.new("ScrollingFrame", Frame)
Scroller.Size = UDim2.new(1, 0, 1, -30)
Scroller.Position = UDim2.new(0, 0, 0, 30)
Scroller.CanvasSize = UDim2.new(0, 0, 2, 0)
Scroller.ScrollBarThickness = 6
Scroller.BackgroundTransparency = 1

-- Title Bar
local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Title.Text = "Mobile Mod Menu"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 20

-- Toggle GUI visibility
ToggleBtn.MouseButton1Click:Connect(function()
    Frame.Visible = not Frame.Visible
end)

-- Helper
local function CreateBtn(text, yPos, callback)
    local btn = Instance.new("TextButton", Scroller)
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Text = text
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 18
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- WalkSpeed Box
local SpeedBox = Instance.new("TextBox", Scroller)
SpeedBox.Size = UDim2.new(0.5, -15, 0, 30)
SpeedBox.Position = UDim2.new(0, 10, 0, 10)
SpeedBox.Text = "Speed"
SpeedBox.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
SpeedBox.TextColor3 = Color3.new(1,1,1)

-- Speed Apply
CreateBtn("Set Speed", 50, function()
    local val = tonumber(SpeedBox.Text)
    if val and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = val
    end
end)

-- Speed Reset
CreateBtn("Reset Speed", 90, function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
end)

-- Noclip
local noclip = false
CreateBtn("Toggle Noclip", 130, function()
    noclip = not noclip
end)

RunService.Stepped:Connect(function()
    if noclip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- Fly (Mobile-Friendly)
local flying = false
local bodyGyro, bodyVelocity

CreateBtn("Toggle Fly", 170, function()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart

    flying = not flying

    if flying then
        bodyGyro = Instance.new("BodyGyro", hrp)
        bodyGyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
        bodyGyro.P = 9e4
        bodyGyro.CFrame = hrp.CFrame

        bodyVelocity = Instance.new("BodyVelocity", hrp)
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)
    else
        if bodyGyro then bodyGyro:Destroy() end
        if bodyVelocity then bodyVelocity:Destroy() end
    end
end)

RunService.RenderStepped:Connect(function()
    if flying and bodyVelocity and LocalPlayer.Character then
        local moveVec = Vector3.zero
        if UIS:IsKeyDown(Enum.KeyCode.W) then moveVec += Vector3.new(0,0,-1) end
        if UIS:IsKeyDown(Enum.KeyCode.S) then moveVec += Vector3.new(0,0,1) end
        if UIS:IsKeyDown(Enum.KeyCode.A) then moveVec += Vector3.new(-1,0,0) end
        if UIS:IsKeyDown(Enum.KeyCode.D) then moveVec += Vector3.new(1,0,0) end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then moveVec += Vector3.new(0,1,0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then moveVec += Vector3.new(0,-1,0) end
        if moveVec.Magnitude > 0 then
            moveVec = moveVec.Unit * 50
        end
        bodyVelocity.Velocity = moveVec
        bodyGyro.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
    end
end)

-- Chat Prank
CreateBtn("Prank Chat (Hello!)", 210, function()
    StarterGui:SetCore("ChatMakeSystemMessage", {
        Text = "[System]: Hello from the Mod Menu!";
        Color = Color3.fromRGB(255, 255, 0);
        Font = Enum.Font.SourceSansBold;
        TextSize = 18;
    })
end)
