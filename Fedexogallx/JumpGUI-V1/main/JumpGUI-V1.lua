--------------------------------------------------
-- SERVICES
--------------------------------------------------

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")
local GuiService = game:GetService("GuiService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local camera = workspace.CurrentCamera

--------------------------------------------------
-- WAIT LOAD
--------------------------------------------------

repeat
	task.wait()
until game:IsLoaded()

task.wait(2)

--------------------------------------------------
-- REMOVE OLD GUI
--------------------------------------------------

for _,v in pairs(playerGui:GetChildren()) do
	if v.Name == "JumpGUIV4" then
		v:Destroy()
	end
end

--------------------------------------------------
-- BLUR
--------------------------------------------------

local blur = Instance.new("BlurEffect")
blur.Size = 0
blur.Parent = Lighting

local function enableBlur()

	TweenService:Create(
		blur,
		TweenInfo.new(0.25),
		{
			Size = 16
		}
	):Play()
end

local function disableBlur()

	TweenService:Create(
		blur,
		TweenInfo.new(0.25),
		{
			Size = 0
		}
	):Play()
end

--------------------------------------------------
-- SOUND
--------------------------------------------------

local whoosh = Instance.new("Sound")

whoosh.SoundId = "rbxassetid://9118823101"
whoosh.Volume = 0.6
whoosh.Parent = SoundService

local function playWhoosh()

	pcall(function()
		whoosh:Play()
	end)
end

--------------------------------------------------
-- GUI
--------------------------------------------------

local gui = Instance.new("ScreenGui")

gui.Name = "JumpGUIV4"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

gui.Parent = playerGui

--------------------------------------------------
-- FORCE ROUNDED CORNERS
--------------------------------------------------

local function applyCorner(obj, radius)

	local corner = Instance.new("UICorner")

	corner.CornerRadius = UDim.new(0,radius)

	corner.Parent = obj

	obj.ClipsDescendants = true

	return corner
end

--------------------------------------------------
-- FRAME
--------------------------------------------------

local frame = Instance.new("Frame")

frame.Size = UDim2.new(0,320,0,200)
frame.Position = UDim2.new(0,40,0,120)

frame.BackgroundColor3 = Color3.fromRGB(30,30,35)
frame.BackgroundTransparency = 0.45

frame.Active = true
frame.Parent = gui

applyCorner(frame,16)

local savedPosition = frame.Position

--------------------------------------------------
-- RAINBOW BORDER
--------------------------------------------------

local stroke = Instance.new("UIStroke")

stroke.Thickness = 2
stroke.Transparency = 0.1
stroke.Parent = frame

task.spawn(function()

	local h = 0

	while task.wait(0.02) do

		h += 0.003

		if h > 1 then
			h = 0
		end

		stroke.Color = Color3.fromHSV(h,1,1)
	end
end)

--------------------------------------------------
-- TITLE
--------------------------------------------------

local title = Instance.new("TextLabel")

title.Size = UDim2.new(1,0,0,30)

title.BackgroundTransparency = 1
title.Text = "Jump GUI V4"

title.TextColor3 = Color3.fromRGB(255,255,255)

title.Font = Enum.Font.GothamBold
title.TextSize = 16

title.Parent = frame

--------------------------------------------------
-- JUMP SYSTEM
--------------------------------------------------

local jumpEnabled = false
local customJump = nil

local function getHum()

	local char = player.Character

	if not char then
		return
	end

	return char:FindFirstChild("Humanoid")
end

task.spawn(function()

	while task.wait(0.25) do

		local hum = getHum()

		if hum and jumpEnabled then

			hum.UseJumpPower = true

			if customJump then
				hum.JumpPower = customJump
			end
		end
	end
end)

--------------------------------------------------
-- TOGGLE
--------------------------------------------------

local toggle = Instance.new("TextButton")

toggle.Size = UDim2.new(0,150,0,35)
toggle.Position = UDim2.new(0,10,0,60)

toggle.BackgroundTransparency = 0.3
toggle.BackgroundColor3 = Color3.fromRGB(40,40,45)

toggle.Text = "JumpBoost OFF"

toggle.TextColor3 = Color3.fromRGB(255,255,255)

toggle.Font = Enum.Font.GothamBold
toggle.TextSize = 14

toggle.Parent = frame

applyCorner(toggle,999)

toggle.MouseButton1Click:Connect(function()

	jumpEnabled = not jumpEnabled

	toggle.Text = jumpEnabled
		and "JumpBoost ON"
		or "JumpBoost OFF"
end)

--------------------------------------------------
-- JUMP VALUE
--------------------------------------------------

local box = Instance.new("TextBox")

box.Size = UDim2.new(0,150,0,30)
box.Position = UDim2.new(0,10,0,110)

box.BackgroundTransparency = 0.35
box.BackgroundColor3 = Color3.fromRGB(40,40,45)

box.PlaceholderText = "Jump Value"

box.TextColor3 = Color3.fromRGB(255,255,255)

box.Font = Enum.Font.Gotham
box.TextSize = 14

box.Parent = frame

applyCorner(box,999)

box:GetPropertyChangedSignal("Text"):Connect(function()

	customJump = tonumber(box.Text)
end)

--------------------------------------------------
-- BUTTONS
--------------------------------------------------

local miniBtn = Instance.new("TextButton")

miniBtn.Size = UDim2.new(0,30,0,30)
miniBtn.Position = UDim2.new(1,-70,0,5)

miniBtn.BackgroundTransparency = 0.3
miniBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)

miniBtn.Text = "-"

miniBtn.TextColor3 = Color3.fromRGB(255,255,255)

miniBtn.Font = Enum.Font.GothamBold
miniBtn.TextSize = 18

miniBtn.Parent = frame

applyCorner(miniBtn,999)

--------------------------------------------------

local closeBtn = Instance.new("TextButton")

closeBtn.Size = UDim2.new(0,30,0,30)
closeBtn.Position = UDim2.new(1,-35,0,5)

closeBtn.BackgroundTransparency = 0.15
closeBtn.BackgroundColor3 = Color3.fromRGB(255,0,0)

closeBtn.Text = "X"

closeBtn.TextColor3 = Color3.fromRGB(255,255,255)

closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14

closeBtn.Parent = frame

applyCorner(closeBtn,999)

--------------------------------------------------
-- MIN BAR
--------------------------------------------------

local bar = Instance.new("Frame")

bar.Size = UDim2.new(0,220,0,40)

bar.BackgroundColor3 = Color3.fromRGB(25,25,25)
bar.BackgroundTransparency = 0.45

bar.Visible = false
bar.Active = true

bar.Parent = gui

applyCorner(bar,999)

--------------------------------------------------
-- BAR BORDER
--------------------------------------------------

local barStroke = Instance.new("UIStroke")

barStroke.Thickness = 2
barStroke.Transparency = 0.2

barStroke.Parent = bar

task.spawn(function()

	local h = 0.5

	while task.wait(0.02) do

		h += 0.003

		if h > 1 then
			h = 0
		end

		barStroke.Color = Color3.fromHSV(h,1,1)
	end
end)

--------------------------------------------------
-- BAR TEXT
--------------------------------------------------

local barText = Instance.new("TextLabel")

barText.Size = UDim2.new(1,0,1,0)

barText.BackgroundTransparency = 1
barText.Text = "Jump GUI V4"

barText.TextColor3 = Color3.fromRGB(255,255,255)

barText.Font = Enum.Font.GothamBold
barText.TextSize = 14

barText.Parent = bar

--------------------------------------------------
-- PLUS BUTTON
--------------------------------------------------

local plus = Instance.new("TextButton")

plus.Size = UDim2.new(0,40,0,40)

plus.BackgroundColor3 = Color3.fromRGB(0,0,0)
plus.BackgroundTransparency = 0.35

plus.Text = "+"

plus.TextColor3 = Color3.fromRGB(255,255,255)

plus.Font = Enum.Font.GothamBold
plus.TextSize = 18

plus.Visible = false
plus.Active = true

plus.Parent = gui

applyCorner(plus,999)

--------------------------------------------------
-- SNAP SYSTEM
--------------------------------------------------

local function snapToEdge(guiObject)

	local viewport = camera.ViewportSize

	local posX = guiObject.Position.X.Offset
	local posY = guiObject.Position.Y.Offset

	local sizeX = guiObject.AbsoluteSize.X
	local sizeY = guiObject.AbsoluteSize.Y

	local leftDist = posX
	local rightDist = viewport.X - (posX + sizeX)

	local topDist = posY
	local bottomDist = viewport.Y - (posY + sizeY)

	local minDist = math.min(
		leftDist,
		rightDist,
		topDist,
		bottomDist
	)

	local targetX = posX
	local targetY = posY

	if minDist == leftDist then

		targetX = 8

	elseif minDist == rightDist then

		targetX = viewport.X - sizeX - 8

	elseif minDist == topDist then

		targetY = 8

	elseif minDist == bottomDist then

		targetY = viewport.Y - sizeY - 8
	end

	TweenService:Create(
		guiObject,
		TweenInfo.new(
			0.18,
			Enum.EasingStyle.Quad,
			Enum.EasingDirection.Out
		),
		{
			Position = UDim2.new(
				0,
				targetX,
				0,
				targetY
			)
		}
	):Play()

	savedPosition = UDim2.new(
		0,
		targetX,
		0,
		targetY
	)

	if guiObject == bar then

		plus.Position = UDim2.new(
			0,
			targetX + 225,
			0,
			targetY
		)
	end
end

--------------------------------------------------
-- DRAG SYSTEM
--------------------------------------------------

local function enableDrag(guiObject, callback)

	local dragging = false
	local dragInput
	local dragStart
	local startPos

	guiObject.InputBegan:Connect(function(input)

		if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

			dragging = true

			dragStart = input.Position
			startPos = guiObject.Position

			dragInput = input

			GuiService.MenuIsOpen = true
		end
	end)

	guiObject.InputChanged:Connect(function(input)

		if input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch then

			dragInput = input
		end
	end)

	UIS.InputChanged:Connect(function(input)

		if dragging and input == dragInput then

			local delta = input.Position - dragStart

			local newPos = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)

			guiObject.Position = newPos

			if callback then
				callback(newPos)
			end
		end
	end)

	UIS.InputEnded:Connect(function(input)

		if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

			dragging = false

			snapToEdge(guiObject)

			GuiService.MenuIsOpen = false
		end
	end)
end

--------------------------------------------------
-- APPLY DRAG
--------------------------------------------------

enableDrag(frame,function(newPos)

	savedPosition = newPos
end)

enableDrag(bar,function(newPos)

	savedPosition = newPos

	plus.Position = UDim2.new(
		newPos.X.Scale,
		newPos.X.Offset + 225,
		newPos.Y.Scale,
		newPos.Y.Offset
	)
end)

--------------------------------------------------
-- FUNCTIONS
--------------------------------------------------

local function minimize()

	bar.Position = savedPosition

	plus.Position = UDim2.new(
		bar.Position.X.Scale,
		bar.Position.X.Offset + 225,
		bar.Position.Y.Scale,
		bar.Position.Y.Offset
	)

	bar.Visible = true
	plus.Visible = true

	frame.Visible = false

	disableBlur()
	playWhoosh()
end

local function restore()

	frame.Position = savedPosition

	frame.Visible = true

	bar.Visible = false
	plus.Visible = false

	enableBlur()
	playWhoosh()
end

--------------------------------------------------
-- BUTTON EVENTS
--------------------------------------------------

miniBtn.MouseButton1Click:Connect(minimize)

plus.MouseButton1Click:Connect(restore)

closeBtn.MouseButton1Click:Connect(function()

	gui:Destroy()

	disableBlur()
end)

--------------------------------------------------
-- START
--------------------------------------------------

pcall(function()

	enableBlur()
	playWhoosh()

end)
