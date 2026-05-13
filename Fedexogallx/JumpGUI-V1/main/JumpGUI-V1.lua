local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--------------------------------------------------
-- REMOVE OLD GUI
--------------------------------------------------

pcall(function()
	local old = playerGui:FindFirstChild("JumpGUIV3")
	if old then
		old:Destroy()
	end
end)

--------------------------------------------------
-- DEVICE CHECK
--------------------------------------------------

local isMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled

--------------------------------------------------
-- SOUND
--------------------------------------------------

local clickSound = Instance.new("Sound")
clickSound.Parent = SoundService
clickSound.SoundId = "rbxassetid://9118823101"
clickSound.Volume = 0.5

--------------------------------------------------
-- GUI
--------------------------------------------------

local gui = Instance.new("ScreenGui")
gui.Name = "JumpGUIV3"
gui.Parent = playerGui
gui.ResetOnSpawn = false

--------------------------------------------------
-- MAIN FRAME
--------------------------------------------------

local frame = Instance.new("Frame")
frame.Parent = gui
frame.Size = UDim2.new(0, 280, 0, 185)
frame.Position = UDim2.new(0.1, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(163,255,137)
frame.BorderColor3 = Color3.fromRGB(103,221,213)
frame.Active = true
frame.Draggable = true

--------------------------------------------------
-- TITLE
--------------------------------------------------

local title = Instance.new("TextLabel")
title.Parent = frame
title.Size = UDim2.new(0, 150, 0, 30)
title.Position = UDim2.new(0, 90, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(242,60,255)
title.Text = "JUMP GUI V3"
title.TextScaled = true
title.Font = Enum.Font.SourceSansBold
title.TextColor3 = Color3.new(0,0,0)

--------------------------------------------------
-- CLOSE BUTTON
--------------------------------------------------

local closeBtn = Instance.new("TextButton")
closeBtn.Parent = frame
closeBtn.Size = UDim2.new(0,45,0,30)
closeBtn.Position = UDim2.new(0,0,0,0)
closeBtn.Text = "X"
closeBtn.TextScaled = true
closeBtn.BackgroundColor3 = Color3.fromRGB(225,25,0)

--------------------------------------------------
-- MINIMIZE BUTTON
--------------------------------------------------

local miniBtn = Instance.new("TextButton")
miniBtn.Parent = frame
miniBtn.Size = UDim2.new(0,45,0,30)
miniBtn.Position = UDim2.new(0,45,0,0)
miniBtn.Text = "-"
miniBtn.TextScaled = true
miniBtn.BackgroundColor3 = Color3.fromRGB(192,150,230)

--------------------------------------------------
-- STATE
--------------------------------------------------

local multiplier = 1
local jumpEnabled = false
local originalJump = nil

--------------------------------------------------
-- PLUS BUTTON
--------------------------------------------------

local plusBtn = Instance.new("TextButton")
plusBtn.Parent = frame
plusBtn.Size = UDim2.new(0,45,0,30)
plusBtn.Position = UDim2.new(0,0,0,45)
plusBtn.Text = "+"
plusBtn.TextScaled = true
plusBtn.BackgroundColor3 = Color3.fromRGB(133,145,255)

--------------------------------------------------
-- MINUS BUTTON
--------------------------------------------------

local minusBtn = Instance.new("TextButton")
minusBtn.Parent = frame
minusBtn.Size = UDim2.new(0,45,0,30)
minusBtn.Position = UDim2.new(0,0,0,82)
minusBtn.Text = "-"
minusBtn.TextScaled = true
minusBtn.BackgroundColor3 = Color3.fromRGB(123,255,247)

--------------------------------------------------
-- MULTIPLIER LABEL
--------------------------------------------------

local multLabel = Instance.new("TextLabel")
multLabel.Parent = frame
multLabel.Size = UDim2.new(0,80,0,30)
multLabel.Position = UDim2.new(0,55,0,45)
multLabel.BackgroundColor3 = Color3.fromRGB(255,85,0)
multLabel.Text = "x1"
multLabel.TextScaled = true

--------------------------------------------------
-- JUMP BOX
--------------------------------------------------

local jumpBox = Instance.new("TextBox")
jumpBox.Parent = frame
jumpBox.Size = UDim2.new(0,140,0,30)
jumpBox.Position = UDim2.new(0,130,0,45)
jumpBox.PlaceholderText = "Example Jump: 350"
jumpBox.Text = ""
jumpBox.TextScaled = true
jumpBox.BackgroundColor3 = Color3.fromRGB(255,255,255)

--------------------------------------------------
-- TOGGLE BUTTON
--------------------------------------------------

local toggleBtn = Instance.new("TextButton")
toggleBtn.Parent = frame
toggleBtn.Size = UDim2.new(0,170,0,40)
toggleBtn.Position = UDim2.new(0,55,0,110)
toggleBtn.Text = "JUMPBOOST OFF"
toggleBtn.TextScaled = true
toggleBtn.BackgroundColor3 = Color3.fromRGB(255,80,80)

--------------------------------------------------
-- KEYBIND (PC ONLY)
--------------------------------------------------

local bindKey = Enum.KeyCode.K
local waitingBind = false
local bindBtn

if not isMobile then

	bindBtn = Instance.new("TextButton")
	bindBtn.Parent = frame
	bindBtn.Size = UDim2.new(0,90,0,25)
	bindBtn.Position = UDim2.new(0,180,0,155)
	bindBtn.Text = "KEY: K"
	bindBtn.TextScaled = true
	bindBtn.BackgroundColor3 = Color3.fromRGB(79,255,152)

end

--------------------------------------------------
-- GET HUMANOID
--------------------------------------------------

local function getHum()

	local char = player.Character
	if not char then return nil end

	return char:FindFirstChild("Humanoid")

end

--------------------------------------------------
-- UPDATE ORIGINAL JUMP
--------------------------------------------------

local function updateOriginalJump()

	local hum = getHum()
	if not hum then return end

	if not jumpEnabled then
		originalJump = hum.JumpPower
	end
end

--------------------------------------------------
-- APPLY JUMP
--------------------------------------------------

local function applyJump()

	local hum = getHum()
	if not hum then return end

	hum.UseJumpPower = true

	if not originalJump then
		originalJump = hum.JumpPower
	end

	local customJump = tonumber(jumpBox.Text)

	if customJump and customJump > 0 then

		hum.JumpPower = customJump
		title.Text = "Jump " .. customJump

	else

		hum.JumpPower = originalJump * multiplier
		title.Text = "Jump x" .. multiplier

	end
end

--------------------------------------------------
-- ENABLE / DISABLE
--------------------------------------------------

local function setJump(state)

	jumpEnabled = state

	local hum = getHum()
	if not hum then return end

	if state then

		applyJump()

		toggleBtn.Text = "JUMPBOOST ON"
		toggleBtn.BackgroundColor3 = Color3.fromRGB(80,255,120)

	else

		if originalJump then
			hum.JumpPower = originalJump
		end

		title.Text = "JUMP GUI V3"

		toggleBtn.Text = "JUMPBOOST OFF"
		toggleBtn.BackgroundColor3 = Color3.fromRGB(255,80,80)

	end
end

--------------------------------------------------
-- BUTTON EVENTS
--------------------------------------------------

plusBtn.MouseButton1Click:Connect(function()

	multiplier += 1
	multLabel.Text = "x" .. multiplier

	clickSound:Play()

	if jumpEnabled then
		applyJump()
	end

end)

minusBtn.MouseButton1Click:Connect(function()

	if multiplier > 1 then
		multiplier -= 1
	end

	multLabel.Text = "x" .. multiplier

	clickSound:Play()

	if jumpEnabled then
		applyJump()
	end

end)

toggleBtn.MouseButton1Click:Connect(function()

	clickSound:Play()

	setJump(not jumpEnabled)

end)

--------------------------------------------------
-- KEYBIND
--------------------------------------------------

if not isMobile then

	bindBtn.MouseButton1Click:Connect(function()

		waitingBind = true
		bindBtn.Text = "PRESS..."

	end)

	UIS.InputBegan:Connect(function(input,gp)

		if gp then return end

		if waitingBind and input.UserInputType == Enum.UserInputType.Keyboard then

			bindKey = input.KeyCode
			bindBtn.Text = "KEY: " .. input.KeyCode.Name

			waitingBind = false

			clickSound:Play()

		end

		if input.UserInputType == Enum.UserInputType.Keyboard then

			if input.KeyCode == bindKey then

				setJump(not jumpEnabled)

			end
		end
	end)
end

--------------------------------------------------
-- SMART MULTIPLIER LOOP
--------------------------------------------------

RunService.RenderStepped:Connect(function()

	if jumpEnabled then

		local hum = getHum()

		if hum then

			local customJump = tonumber(jumpBox.Text)

			if customJump and customJump > 0 then

				if hum.JumpPower ~= customJump then
					hum.JumpPower = customJump
				end

			else

				local expected = originalJump * multiplier

				if hum.JumpPower ~= expected then
					hum.JumpPower = expected
				end
			end
		end
	else

		updateOriginalJump()

	end
end)

--------------------------------------------------
-- RESPAWN SUPPORT
--------------------------------------------------

player.CharacterAdded:Connect(function()

	task.wait(1)

	updateOriginalJump()

	if jumpEnabled then
		applyJump()
	end

end)
