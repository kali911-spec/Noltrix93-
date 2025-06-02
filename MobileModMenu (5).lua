
-- Mobile Mod Menu (Fixed Version without Chat Prank)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Remove old GUI
if PlayerGui:FindFirstChild("ModMenu") then PlayerGui.ModMenu:Destroy() end

-- Main GUI
local Gui = Instance.new("ScreenGui", PlayerGui)
Gui.Name = "ModMenu"
Gui.ResetOnSpawn = false

-- Toggle Button
local ToggleBtn = Instance.new("TextButton", Gui)
ToggleBtn.Size = UDim2.new(0, 40, 0, 40)
ToggleBtn.Position = UDim2.new(0, 10, 0, 10)
ToggleBtn.Text = "📦"
ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ToggleBtn.TextColor3 = Color3.new(1,1,1)
ToggleBtn.TextScaled = true
ToggleBtn.ZIndex = 10
ToggleBtn.Draggable = true
ToggleBtn.Active = true

-- Scrollable Menu Frame
local Frame = Instance.new("ScrollingFrame", Gui)
Frame.Size = UDim2.new(0, 300, 0, 350)
Frame.Position = UDim2.new(0.5, -150, 0.5, -175)
Frame.CanvasSize = UDim2.new(0, 0, 2, 0)
Frame.ScrollBarThickness = 6
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0
Frame.Visible = false
Frame.Active = true
Frame.Draggable = true

ToggleBtn.MouseButton1Click:Connect(function()
	Frame.Visible = not Frame.Visible
end)

-- Title Bar
local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Title.Text = "Mod Menu"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 20

-- Player Dropdown
local PlayerDropdown = Instance.new("TextButton", Frame)
PlayerDropdown.Size = UDim2.new(1, -20, 0, 30)
PlayerDropdown.Position = UDim2.new(0, 10, 0, 40)
PlayerDropdown.Text = "Select Player"
PlayerDropdown.TextColor3 = Color3.new(1,1,1)
PlayerDropdown.BackgroundColor3 = Color3.fromRGB(60, 60, 60)

local SelectedPlayer = nil
PlayerDropdown.MouseButton1Click:Connect(function()
	if Frame:FindFirstChild("DropdownList") then Frame.DropdownList:Destroy() end
	local menu = Instance.new("Frame", Frame)
	menu.Size = UDim2.new(1, -20, 0, 120)
	menu.Position = UDim2.new(0, 10, 0, 75)
	menu.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	menu.BorderSizePixel = 0
	menu.Name = "DropdownList"
	local y = 0
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer then
			local opt = Instance.new("TextButton", menu)
			opt.Size = UDim2.new(1, 0, 0, 25)
			opt.Position = UDim2.new(0, 0, 0, y)
			opt.Text = plr.Name
			opt.TextColor3 = Color3.new(1,1,1)
			opt.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
			opt.MouseButton1Click:Connect(function()
				SelectedPlayer = plr
				PlayerDropdown.Text = "To: " .. plr.Name
				menu:Destroy()
			end)
			y = y + 25
		end
	end
end)

-- Teleport Button
local TPBtn = Instance.new("TextButton", Frame)
TPBtn.Size = UDim2.new(1, -20, 0, 30)
TPBtn.Position = UDim2.new(0, 10, 0, 200)
TPBtn.Text = "Teleport to Player"
TPBtn.TextColor3 = Color3.new(1,1,1)
TPBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
TPBtn.MouseButton1Click:Connect(function()
	if SelectedPlayer and SelectedPlayer.Character and SelectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
		LocalPlayer.Character.HumanoidRootPart.CFrame = SelectedPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(2,0,0)
	end
end)

-- Speed Settings
local SpeedSlider = Instance.new("TextBox", Frame)
SpeedSlider.Size = UDim2.new(0.5, -15, 0, 30)
SpeedSlider.Position = UDim2.new(0, 10, 0, 240)
SpeedSlider.Text = "Speed (16-300)"
SpeedSlider.TextColor3 = Color3.new(1,1,1)
SpeedSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)

local SpeedBtn = Instance.new("TextButton", Frame)
SpeedBtn.Size = UDim2.new(0.5, -15, 0, 30)
SpeedBtn.Position = UDim2.new(0.5, 5, 0, 240)
SpeedBtn.Text = "Apply Speed"
SpeedBtn.TextColor3 = Color3.new(1,1,1)
SpeedBtn.BackgroundColor3 = Color3.fromRGB(60, 100, 60)
SpeedBtn.MouseButton1Click:Connect(function()
	local value = tonumber(SpeedSlider.Text)
	if value and value >= 16 and value <= 300 then
		if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
			LocalPlayer.Character.Humanoid.WalkSpeed = value
		end
	end
end)

-- Reset Speed
local ResetBtn = Instance.new("TextButton", Frame)
ResetBtn.Size = UDim2.new(1, -20, 0, 30)
ResetBtn.Position = UDim2.new(0, 10, 0, 280)
ResetBtn.Text = "Reset Speed to 16"
ResetBtn.TextColor3 = Color3.new(1,1,1)
ResetBtn.BackgroundColor3 = Color3.fromRGB(120, 60, 60)
ResetBtn.MouseButton1Click:Connect(function()
	if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
		LocalPlayer.Character.Humanoid.WalkSpeed = 16
	end
end)

-- Noclip
local noclip = false
RunService.Stepped:Connect(function()
	if noclip and LocalPlayer.Character then
		for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
			if part:IsA("BasePart") then part.CanCollide = false end
		end
	end
end)

local NoclipBtn = Instance.new("TextButton", Frame)
NoclipBtn.Size = UDim2.new(1, -20, 0, 30)
NoclipBtn.Position = UDim2.new(0, 10, 0, 320)
NoclipBtn.Text = "Toggle Noclip"
NoclipBtn.TextColor3 = Color3.new(1,1,1)
NoclipBtn.BackgroundColor3 = Color3.fromRGB(100, 60, 60)
NoclipBtn.MouseButton1Click:Connect(function()
	noclip = not noclip
	NoclipBtn.Text = noclip and "Noclip: ON" or "Noclip: OFF"
end)

-- Fly (Joystick Compatible)
local flying = false
local BodyGyro, BodyVelocity

local function startFly()
	local char = LocalPlayer.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") then return end

	BodyGyro = Instance.new("BodyGyro", char.HumanoidRootPart)
	BodyGyro.MaxTorque = Vector3.new(400000, 400000, 400000)
	BodyGyro.P = 20000
	BodyGyro.CFrame = char.HumanoidRootPart.CFrame

	BodyVelocity = Instance.new("BodyVelocity", char.HumanoidRootPart)
	BodyVelocity.Velocity = Vector3.new(0, 0, 0)
	BodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
end

local function stopFly()
	if BodyGyro then BodyGyro:Destroy() end
	if BodyVelocity then BodyVelocity:Destroy() end
end

RunService.RenderStepped:Connect(function()
	if flying and BodyVelocity and LocalPlayer.Character then
		local moveDir = Vector3.new()
		if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir += Vector3.new(0,0,-1) end
		if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir += Vector3.new(0,0,1) end
		if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir += Vector3.new(-1,0,0) end
		if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir += Vector3.new(1,0,0) end
		if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir += Vector3.new(0,1,0) end
		if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir += Vector3.new(0,-1,0) end
		local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		if hrp then
			BodyVelocity.Velocity = hrp.CFrame:VectorToWorldSpace(moveDir) * 50
			BodyGyro.CFrame = hrp.CFrame
		end
	end
end)

local FlyBtn = Instance.new("TextButton", Frame)
FlyBtn.Size = UDim2.new(1, -20, 0, 30)
FlyBtn.Position = UDim2.new(0, 10, 0, 360)
FlyBtn.Text = "Toggle Fly"
FlyBtn.TextColor3 = Color3.new(1,1,1)
FlyBtn.BackgroundColor3 = Color3.fromRGB(60, 100, 120)
FlyBtn.MouseButton1Click:Connect(function()
	flying = not flying
	if flying then
		startFly()
	else
		stopFly()
	end
	FlyBtn.Text = flying and "Fly: ON" or "Fly: OFF"
end)
