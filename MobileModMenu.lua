
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
if PlayerGui:FindFirstChild("ModMenu") then PlayerGui.ModMenu:Destroy() end

local Gui = Instance.new("ScreenGui", PlayerGui)
Gui.Name = "ModMenu"; Gui.ResetOnSpawn = false

local Frame = Instance.new("Frame", Gui)
Frame.Size = UDim2.new(0, 280, 0, 330)
Frame.Position = UDim2.new(0.5, -140, 0.5, -165)
Frame.BackgroundColor3 = Color3.fromRGB(25,25,25); Frame.Draggable = true; Frame.Active = true

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 30); Title.Text = "Mod Menu"
Title.TextColor3 = Color3.new(1,1,1); Title.BackgroundColor3 = Color3.fromRGB(50,50,50)

local function CreateBtn(text, posY)
	local btn = Instance.new("TextButton", Frame)
	btn.Size = UDim2.new(1, -20, 0, 30)
	btn.Position = UDim2.new(0, 10, 0, posY)
	btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Text = text
	return btn
end

-- Speed
local speedInput = Instance.new("TextBox", Frame)
speedInput.Size = UDim2.new(0.5, -15, 0, 30)
speedInput.Position = UDim2.new(0, 10, 0, 40)
speedInput.PlaceholderText = "Speed (16-300)"
speedInput.BackgroundColor3 = Color3.fromRGB(60,60,60)
speedInput.TextColor3 = Color3.new(1,1,1)

local applySpeed = CreateBtn("Set Speed", 40)
applySpeed.Position = UDim2.new(0.5, 5, 0, 40)
applySpeed.MouseButton1Click:Connect(function()
	local v = tonumber(speedInput.Text)
	if v and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
		LocalPlayer.Character.Humanoid.WalkSpeed = math.clamp(v,16,300)
	end
end)

-- Noclip
local noclip = false
CreateBtn("Toggle Noclip", 80).MouseButton1Click:Connect(function()
	noclip = not noclip
end)
RunService.Stepped:Connect(function()
	if noclip and LocalPlayer.Character then
		for _, part in pairs(LocalPlayer.Character:GetChildren()) do
			if part:IsA("BasePart") then part.CanCollide = false end
		end
	end
end)

-- Fly (mobile joystick style)
local flying, bv = false, nil
CreateBtn("Toggle Fly", 120).MouseButton1Click:Connect(function()
	flying = not flying
	local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if flying and hrp then
		bv = Instance.new("BodyVelocity", hrp)
		bv.MaxForce = Vector3.new(1e5,1e5,1e5)
		bv.Velocity = Vector3.zero
	else if bv then bv:Destroy() end end
end)

RunService.RenderStepped:Connect(function()
	if flying and bv and LocalPlayer.Character then
		local move = Vector3.zero
		local cam = workspace.CurrentCamera.CFrame
		local function axis(k,dir) if UIS:IsKeyDown(k) then return dir else return Vector3.zero end end
		move += axis(Enum.KeyCode.W, cam.LookVector)
		move += axis(Enum.KeyCode.S, -cam.LookVector)
		move += axis(Enum.KeyCode.A, -cam.RightVector)
		move += axis(Enum.KeyCode.D, cam.RightVector)
		move += axis(Enum.KeyCode.Space, Vector3.yAxis)
		move += axis(Enum.KeyCode.LeftControl, -Vector3.yAxis)
		bv.Velocity = move.Unit * 60
	end
end)

-- Teleport to player
local selected = nil
local dropdown = CreateBtn("Select Player", 160)
dropdown.MouseButton1Click:Connect(function()
	if Frame:FindFirstChild("List") then Frame.List:Destroy() end
	local list = Instance.new("Frame", Frame)
	list.Size = UDim2.new(1, -20, 0, 100)
	list.Position = UDim2.new(0, 10, 0, 195)
	list.BackgroundColor3 = Color3.fromRGB(45,45,45)
	list.Name = "List"
	for i, p in pairs(Players:GetPlayers()) do
		if p ~= LocalPlayer then
			local b = Instance.new("TextButton", list)
			b.Size = UDim2.new(1, 0, 0, 25)
			b.Position = UDim2.new(0,0,0,(i-1)*25)
			b.Text = p.Name
			b.TextColor3 = Color3.new(1,1,1)
			b.BackgroundColor3 = Color3.fromRGB(60,60,60)
			b.MouseButton1Click:Connect(function()
				selected = p; dropdown.Text = "To: "..p.Name; list:Destroy()
			end)
		end
	end
end)

CreateBtn("Teleport to Player", 300).MouseButton1Click:Connect(function()
	if selected and selected.Character and selected.Character:FindFirstChild("HumanoidRootPart") then
		LocalPlayer.Character.HumanoidRootPart.CFrame = selected.Character.HumanoidRootPart.CFrame + Vector3.new(2,0,0)
	end
end)

-- Prank Chat
local prankBtn = CreateBtn("Prank Chat (System)", 260)
prankBtn.MouseButton1Click:Connect(function()
	local msg = "You have been reported to moderation." -- change this if needed
	game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("[SYSTEM]: "..msg, "All")
end)
