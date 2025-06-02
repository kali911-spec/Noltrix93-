
-- Roblox Mobile Mod Menu Script (Fixed Version)
-- Features: Teleport, Speed, Noclip, Fly (Joystick), Prank Chat, Scrollable UI

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

if PlayerGui:FindFirstChild("ModMenu") then
	PlayerGui.ModMenu:Destroy()
end

local Gui = Instance.new("ScreenGui", PlayerGui)
Gui.Name = "ModMenu"
Gui.ResetOnSpawn = false

local Frame = Instance.new("ScrollingFrame", Gui)
Frame.Size = UDim2.new(0, 300, 0, 320)
Frame.Position = UDim2.new(0.5, -150, 0.5, -160)
Frame.CanvasSize = UDim2.new(0, 0, 2, 0)
Frame.ScrollBarThickness = 8
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true

local UIListLayout = Instance.new("UIListLayout", Frame)
UIListLayout.Padding = UDim.new(0, 6)

local function addButton(text, color, callback)
	local button = Instance.new("TextButton", Frame)
	button.Size = UDim2.new(1, -20, 0, 30)
	button.BackgroundColor3 = color
	button.TextColor3 = Color3.new(1, 1, 1)
	button.Text = text
	button.Font = Enum.Font.SourceSans
	button.TextSize = 18
	button.MouseButton1Click:Connect(callback)
	return button
end

local function addTextbox(placeholder)
	local box = Instance.new("TextBox", Frame)
	box.Size = UDim2.new(1, -20, 0, 30)
	box.PlaceholderText = placeholder
	box.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	box.TextColor3 = Color3.new(1, 1, 1)
	box.Font = Enum.Font.SourceSans
	box.TextSize = 18
	return box
end

-- Player dropdown
local SelectedPlayer = nil
local PlayerDropdown = addButton("Select Player", Color3.fromRGB(60, 60, 60), function()
	for _, child in pairs(Frame:GetChildren()) do
		if child.Name == "DropdownOption" then child:Destroy() end
	end
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer then
			local opt = addButton(plr.Name, Color3.fromRGB(80, 80, 80), function()
				SelectedPlayer = plr
				PlayerDropdown.Text = "To: " .. plr.Name
			end)
			opt.Name = "DropdownOption"
		end
	end
end)

-- Teleport
addButton("Teleport to Player", Color3.fromRGB(0, 120, 255), function()
	if SelectedPlayer and SelectedPlayer.Character and SelectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
		LocalPlayer.Character.HumanoidRootPart.CFrame = SelectedPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(2, 0, 0)
	end
end)

-- Speed
local SpeedBox = addTextbox("Speed (16-300)")
addButton("Apply Speed", Color3.fromRGB(0, 200, 100), function()
	local speed = tonumber(SpeedBox.Text)
	if speed and speed >= 16 and speed <= 300 and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
		LocalPlayer.Character.Humanoid.WalkSpeed = speed
	end
end)

-- Noclip
local noclip = false
addButton("Toggle Noclip", Color3.fromRGB(100, 60, 60), function()
	noclip = not noclip
end)

RunService.Stepped:Connect(function()
	if noclip and LocalPlayer.Character then
		for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end
end)

-- Fly
local flying = false
local flyBodyVelocity

addButton("Toggle Fly", Color3.fromRGB(60, 100, 120), function()
	flying = not flying
	local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if flying and hrp then
		flyBodyVelocity = Instance.new("BodyVelocity")
		flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
		flyBodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
		flyBodyVelocity.Parent = hrp
	elseif flyBodyVelocity then
		flyBodyVelocity:Destroy()
		flyBodyVelocity = nil
	end
end)

RunService.RenderStepped:Connect(function()
	if flying and flyBodyVelocity then
		local move = Vector3.new()
		if UserInputService:IsKeyDown(Enum.KeyCode.W) then move += Vector3.new(0, 0, -1) end
		if UserInputService:IsKeyDown(Enum.KeyCode.S) then move += Vector3.new(0, 0, 1) end
		if UserInputService:IsKeyDown(Enum.KeyCode.A) then move += Vector3.new(-1, 0, 0) end
		if UserInputService:IsKeyDown(Enum.KeyCode.D) then move += Vector3.new(1, 0, 0) end
		if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0, 1, 0) end
		if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then move += Vector3.new(0, -1, 0) end
		flyBodyVelocity.Velocity = move.Unit * 50
	end
end)

-- Prank Chat
local PrankBox = addTextbox("Fake Chat Message")
addButton("Send Prank Chat", Color3.fromRGB(200, 100, 0), function()
	if PrankBox.Text ~= "" then
		StarterGui:SetCore("ChatMakeSystemMessage", {
			Text = PrankBox.Text,
			Color = Color3.fromRGB(255, 255, 0),
			Font = Enum.Font.SourceSansBold,
			FontSize = Enum.FontSize.Size24
		})
	end
end)
