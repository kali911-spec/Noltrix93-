-- Mobile Mod Menu (Fixed & Optimized)
local Players, RS, SG = game:GetService("Players"), game:GetService("RunService"), game:GetService("StarterGui")
local LP, PG = Players.LocalPlayer, Players.LocalPlayer:WaitForChild("PlayerGui")
if PG:FindFirstChild("ModMenu") then PG.ModMenu:Destroy() end

local Gui = Instance.new("ScreenGui", PG) Gui.Name = "ModMenu" Gui.ResetOnSpawn = false

local Toggle = Instance.new("TextButton", Gui)
Toggle.Size = UDim2.new(0, 40, 0, 40) Toggle.Position = UDim2.new(0, 10, 0, 10)
Toggle.Text = "📦" Toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50) Toggle.TextColor3 = Color3.new(1, 1, 1) Toggle.ZIndex = 10

local Frame = Instance.new("ScrollingFrame", Gui)
Frame.Size = UDim2.new(0, 300, 0, 320) Frame.Position = UDim2.new(0.5, -150, 0.5, -160)
Frame.CanvasSize = UDim2.new(0, 0, 0, 1000) Frame.ScrollBarThickness = 8
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30) Frame.BorderSizePixel = 0

Toggle.MouseButton1Click:Connect(function() Frame.Visible = not Frame.Visible end)

local y = 0
local function addBtn(text, color, callback)
    local btn = Instance.new("TextButton", Frame)
    btn.Size = UDim2.new(1, -20, 0, 40) btn.Position = UDim2.new(0, 10, 0, y)
    btn.Text = text btn.BackgroundColor3 = color btn.TextColor3 = Color3.new(1,1,1)
    btn.TextScaled = true btn.Font = Enum.Font.SourceSansBold
    btn.MouseButton1Click:Connect(callback) y += 45 return btn
end

local selected
local btnPlr = addBtn("Select Player", Color3.fromRGB(70,70,70), function()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP then selected = p btnPlr.Text = "To: " .. p.Name break end
    end
end)

addBtn("Teleport to Player", Color3.fromRGB(0,120,255), function()
    if selected and selected.Character and selected.Character:FindFirstChild("HumanoidRootPart") then
        LP.Character:PivotTo(selected.Character.HumanoidRootPart.CFrame + Vector3.new(2,0,0))
    end
end)

local speedBox = Instance.new("TextBox", Frame)
speedBox.Size = UDim2.new(1, -20, 0, 40) speedBox.Position = UDim2.new(0, 10, 0, y)
speedBox.PlaceholderText = "Speed (16-300)" speedBox.Text = ""
speedBox.BackgroundColor3 = Color3.fromRGB(60,60,60) speedBox.TextColor3 = Color3.new(1,1,1)
y += 45

addBtn("Apply Speed", Color3.fromRGB(60,100,60), function()
    local spd = tonumber(speedBox.Text) or 16
    if LP.Character and LP.Character:FindFirstChild("Humanoid") then
        LP.Character.Humanoid.WalkSpeed = math.clamp(spd, 16, 300)
    end
end)

-- Noclip
local noclip = false
addBtn("Toggle Noclip", Color3.fromRGB(100,60,60), function() noclip = not noclip end)
RS.Stepped:Connect(function()
    if noclip and LP.Character then
        for _, p in pairs(LP.Character:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end
end)

-- Fly
local flying, bv = false, nil
addBtn("Toggle Fly", Color3.fromRGB(60,100,120), function()
    flying = not flying
    if flying and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        bv.Velocity = Vector3.zero
        bv.Parent = LP.Character.HumanoidRootPart
    elseif bv then bv:Destroy() bv = nil end
end)

RS.RenderStepped:Connect(function()
    if flying and bv and LP.Character then
        local move = LP:GetAttribute("MoveVector") or Vector3.zero
        bv.Velocity = move * 50
    end
end)

LP:GetPropertyChangedSignal("MoveDirection"):Connect(function()
    LP:SetAttribute("MoveVector", LP.MoveDirection)
end)

-- Prank chat
local chatBox = Instance.new("TextBox", Frame)
chatBox.Size = UDim2.new(1, -20, 0, 40) chatBox.Position = UDim2.new(0, 10, 0, y)
chatBox.PlaceholderText = "Fake system message..." chatBox.Text = ""
chatBox.BackgroundColor3 = Color3.fromRGB(80,80,80) chatBox.TextColor3 = Color3.new(1,1,1)
y += 45

addBtn("Send Fake Chat", Color3.fromRGB(150,100,0), function()
    SG:SetCore("ChatMakeSystemMessage", {
        Text = chatBox.Text,
        Color = Color3.fromRGB(255, 0, 0),
        Font = Enum.Font.SourceSansBold,
        FontSize = Enum.FontSize.Size24
    })
end)
