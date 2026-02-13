local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

local systemEnabled = false
local highlights = {}
local targetPlayer = nil

-- GUI OLUŞTURMA
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TargetUI"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 150, 0, 50)
ToggleButton.Position = UDim2.new(0, 20, 0, 20)
ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ToggleButton.TextColor3 = Color3.new(1,1,1)
ToggleButton.TextScaled = true
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.Text = "SYSTEM: OFF"
ToggleButton.Parent = ScreenGui

local InfoLabel = Instance.new("TextLabel")
InfoLabel.Size = UDim2.new(0, 300, 0, 90)
InfoLabel.Position = UDim2.new(0.5, -150, 0.85, 0)
InfoLabel.BackgroundColor3 = Color3.fromRGB(0,0,0)
InfoLabel.BackgroundTransparency = 0.3
InfoLabel.TextColor3 = Color3.new(1,1,1)
InfoLabel.TextScaled = true
InfoLabel.Font = Enum.Font.SourceSansBold
InfoLabel.Text = ""
InfoLabel.Visible = false
InfoLabel.Parent = ScreenGui

-- Highlight oluştur
local function addHighlight(character)
	if highlights[character] then return end
	
	local hl = Instance.new("Highlight")
	hl.FillColor = Color3.fromRGB(255, 0, 0)
	hl.OutlineColor = Color3.fromRGB(255, 255, 255)
	hl.Parent = character
	
	highlights[character] = hl
end

-- Highlight temizle
local function clearHighlights()
	for char, hl in pairs(highlights) do
		if hl then
			hl:Destroy()
		end
	end
	highlights = {}
end

-- En yakın player
local function getClosestPlayer()
	local closest = nil
	local shortestDistance = math.huge
	
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			local distance = (player.Character.HumanoidRootPart.Position - Camera.CFrame.Position).Magnitude
			
			if distance < shortestDistance then
				shortestDistance = distance
				closest = player
			end
		end
	end
	
	return closest
end

-- Toggle buton
ToggleButton.MouseButton1Click:Connect(function()
	systemEnabled = not systemEnabled
	
	if systemEnabled then
		ToggleButton.Text = "SYSTEM: ON"
		ToggleButton.BackgroundColor3 = Color3.fromRGB(0,120,0)
		InfoLabel.Visible = true
	else
		ToggleButton.Text = "SYSTEM: OFF"
		ToggleButton.BackgroundColor3 = Color3.fromRGB(40,40,40)
		InfoLabel.Visible = false
		clearHighlights()
	end
end)

-- Güncelleme loop
RunService.RenderStepped:Connect(function()
	if not systemEnabled then return end
	
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character then
			addHighlight(player.Character)
		end
	end
	
	targetPlayer = getClosestPlayer()
	
	if targetPlayer and targetPlayer.Character then
		local humanoid = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
		
		if humanoid then
			InfoLabel.Text = "Target: "..targetPlayer.Name..
				"\nHealth: "..math.floor(humanoid.Health)
		end
	else
		InfoLabel.Text = "Target bulunamadi"
	end
end)
