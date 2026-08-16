local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

if game.CoreGui:FindFirstChild("Library") then
	game.CoreGui:FindFirstChild("Library"):Destroy()
end

local Library = {}
local LibraryElements = {}

local Lucide = {
	["home"] = "rbxassetid://10709810976",
	["settings"] = "rbxassetid://10734950309",
	["user"] = "rbxassetid://10734950309",
	["sword"] = "rbxassetid://10734952140",
	["shield"] = "rbxassetid://10734886276",
	["eye"] = "rbxassetid://10734887654",
	["zap"] = "rbxassetid://10734951027",
	["box"] = "rbxassetid://10734883381",
	["code"] = "rbxassetid://10734884598",
	["terminal"] = "rbxassetid://10734951027",
	["gamepad"] = "rbxassetid://10734886276",
	["crosshair"] = "rbxassetid://10734884598",
	["target"] = "rbxassetid://10734952140",
	["move"] = "rbxassetid://10734950309",
	["minimize"] = "rbxassetid://75550123309801",
	["x"] = "rbxassetid://101064721108854",
	["chevrons-up-down"] = "rbxassetid://10734884598"
}

local function ResolveIcon(icon)
	if not icon then return nil end
	if type(icon) == "number" then
		return "rbxassetid://" .. tostring(icon)
	end
	if type(icon) == "string" then
		if icon:find("rbxassetid://") then
			return icon
		end
		if Lucide[icon:lower()] then
			return Lucide[icon:lower()]
		end
		return "rbxassetid://" .. icon
	end
	return nil
end

local DefaultTheme = {
	Background = Color3.fromRGB(15, 15, 15),
	Secondary = Color3.fromRGB(25, 25, 25),
	Tertiary = Color3.fromRGB(30, 30, 30),
	Accent = Color3.fromRGB(255, 255, 255),
	Text = Color3.fromRGB(255, 255, 255),
	MutedText = Color3.fromRGB(170, 170, 170),
	DimText = Color3.fromRGB(120, 120, 120),
	Stroke = Color3.fromRGB(40, 40, 40),
	Success = Color3.fromRGB(80, 200, 120),
	Danger = Color3.fromRGB(255, 80, 80),
	BackgroundTransparency = 0,
	SecondaryTransparency = 0,
	ElementTransparency = 0.12,
	Size = UDim2.new(0, 560, 0, 370)
}

function Library:CreateWindow(Game, Version, Theme, LogoId)
	Theme = Theme or {}
	local T = {}
	for k, v in pairs(DefaultTheme) do
		T[k] = Theme[k] ~= nil and Theme[k] or v
	end

	local WindowSize = T.Size

	LibraryElements = {
		Library_1 = Instance.new("ScreenGui"),
		Main_1 = Instance.new("Frame"),
		UICorner_1 = Instance.new("UICorner"),
		UIStroke_1 = Instance.new("UIStroke"),
		TopBar_1 = Instance.new("Frame"),
		Logo_1 = Instance.new("ImageLabel"),
		Title_1 = Instance.new("TextLabel"),
		UIPadding_1 = Instance.new("UIPadding"),
		Description_1 = Instance.new("TextLabel"),
		UIPadding_2 = Instance.new("UIPadding"),
		NavigationHolder_1 = Instance.new("Frame"),
		UIStroke_2 = Instance.new("UIStroke"),
		UICorner_2 = Instance.new("UICorner"),
		NavLine_1 = Instance.new("Frame"),
		NavLine_2 = Instance.new("Frame"),
		DragHandleButton_1 = Instance.new("TextButton"),
		DragHandleIcon_1 = Instance.new("ImageLabel"),
		MinimizeButton_1 = Instance.new("TextButton"),
		MinimizeIcon_1 = Instance.new("ImageLabel"),
		CloseButton_1 = Instance.new("TextButton"),
		CloseIcon_1 = Instance.new("ImageLabel"),
		TabsHolder_1 = Instance.new("Frame"),
		Tabs_1 = Instance.new("ScrollingFrame"),
		UIListLayout_1 = Instance.new("UIListLayout"),
		UIPadding_4 = Instance.new("UIPadding"),
		ElementsHolder_1 = Instance.new("Frame"),
		DragUI_1 = Instance.new("ImageButton"),
		ResizeUI_1 = Instance.new("ImageButton"),
	}

	local UIElements = {
		OpenUIHolder_1 = Instance.new("Frame"),
		UICorner_31 = Instance.new("UICorner"),
		UIStroke_24 = Instance.new("UIStroke"),
		OpenUI_1 = Instance.new("ImageButton")
	}

	local LayoutCounter = 0
	getgenv().bPeMConfigState = {registered = {}}

	local MinSize = Vector2.new(480, 320)
	local MaxSize = Vector2.new(1200, 900)
	local Smoothness = 0.18

	local isResizing = false
	local inputStartPos
	local startSize

	local dragging = false
	local dragStart = nil
	local startPos = nil
	local lastGoalPos = nil
	local DRAG_SPEED = 14

	local Minimized = false
	local OriginalSize = WindowSize
	local IsAnimating = false

	LibraryElements.Library_1.Name = "Library"
	LibraryElements.Library_1.Parent = game.CoreGui
	LibraryElements.Library_1.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	LibraryElements.Library_1.ResetOnSpawn = false

	LibraryElements.Main_1.BackgroundColor3 = T.Background
	LibraryElements.Main_1.BackgroundTransparency = T.BackgroundTransparency
	LibraryElements.Main_1.Name = "Main"
	LibraryElements.Main_1.Parent = LibraryElements.Library_1
	LibraryElements.Main_1.Position = UDim2.new(0.5, -WindowSize.X.Offset/2, 0.5, -WindowSize.Y.Offset/2)
	LibraryElements.Main_1.Size = WindowSize
	LibraryElements.Main_1.Selectable = false
	LibraryElements.Main_1.Active = true

	LibraryElements.UICorner_1.CornerRadius = UDim.new(0, 8)
	LibraryElements.UICorner_1.Parent = LibraryElements.Main_1

	LibraryElements.UIStroke_1.Color = T.Stroke
	LibraryElements.UIStroke_1.Thickness = 1
	LibraryElements.UIStroke_1.Parent = LibraryElements.Main_1

	LibraryElements.TopBar_1.BackgroundTransparency = 1
	LibraryElements.TopBar_1.Name = "TopBar"
	LibraryElements.TopBar_1.Parent = LibraryElements.Main_1
	LibraryElements.TopBar_1.Size = UDim2.new(1, 0, 0, 58)
	LibraryElements.TopBar_1.Selectable = false

	local hasLogo = LogoId ~= nil and LogoId ~= ""
	local logoResolved = ResolveIcon(LogoId)

	if hasLogo and logoResolved then
		LibraryElements.Logo_1.BackgroundTransparency = 1
		LibraryElements.Logo_1.Name = "Logo"
		LibraryElements.Logo_1.Parent = LibraryElements.TopBar_1
		LibraryElements.Logo_1.Position = UDim2.new(0, 14, 0.5, -13)
		LibraryElements.Logo_1.Size = UDim2.new(0, 26, 0, 26)
		LibraryElements.Logo_1.Image = logoResolved
		LibraryElements.Logo_1.ScaleType = Enum.ScaleType.Fit
	end

	LibraryElements.Title_1.BackgroundTransparency = 1
	LibraryElements.Title_1.Name = "Title"
	LibraryElements.Title_1.Parent = LibraryElements.TopBar_1
	LibraryElements.Title_1.Size = UDim2.new(1, -160, 0, 58)
	LibraryElements.Title_1.Selectable = false
	LibraryElements.Title_1.FontFace = Font.new("rbxassetid://16658221428", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
	LibraryElements.Title_1.RichText = true
	LibraryElements.Title_1.Text = "<b>bPeM</b>"
	LibraryElements.Title_1.TextColor3 = T.Text
	LibraryElements.Title_1.TextSize = 20
	LibraryElements.Title_1.TextTruncate = Enum.TextTruncate.SplitWord
	LibraryElements.Title_1.TextXAlignment = Enum.TextXAlignment.Left

	LibraryElements.UIPadding_1.Parent = LibraryElements.Title_1
	LibraryElements.UIPadding_1.PaddingBottom = UDim.new(0, 8)
	LibraryElements.UIPadding_1.PaddingLeft = UDim.new(0, hasLogo and 48 or 16)

	LibraryElements.Description_1.BackgroundTransparency = 1
	LibraryElements.Description_1.Name = "Description"
	LibraryElements.Description_1.Parent = LibraryElements.TopBar_1
	LibraryElements.Description_1.Size = UDim2.new(1, -160, 0, 58)
	LibraryElements.Description_1.Selectable = false
	LibraryElements.Description_1.FontFace = Font.new("rbxassetid://16658221428", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
	LibraryElements.Description_1.RichText = true
	LibraryElements.Description_1.Text = Game .. "<b> | " .. Version .. "</b>"
	LibraryElements.Description_1.TextColor3 = T.MutedText
	LibraryElements.Description_1.TextSize = 15
	LibraryElements.Description_1.TextTruncate = Enum.TextTruncate.SplitWord
	LibraryElements.Description_1.TextXAlignment = Enum.TextXAlignment.Left

	LibraryElements.UIPadding_2.Parent = LibraryElements.Description_1
	LibraryElements.UIPadding_2.PaddingBottom = UDim.new(0, 8)
	LibraryElements.UIPadding_2.PaddingLeft = UDim.new(0, hasLogo and 48 or 16)
	LibraryElements.UIPadding_2.PaddingTop = UDim.new(0, 36)

	LibraryElements.NavigationHolder_1.BackgroundColor3 = T.Secondary
	LibraryElements.NavigationHolder_1.BackgroundTransparency = T.SecondaryTransparency
	LibraryElements.NavigationHolder_1.Name = "NavigationHolder"
	LibraryElements.NavigationHolder_1.Parent = LibraryElements.TopBar_1
	LibraryElements.NavigationHolder_1.Position = UDim2.new(1, -104, 0.5, -12)
	LibraryElements.NavigationHolder_1.Size = UDim2.new(0, 90, 0, 24)
	LibraryElements.NavigationHolder_1.Selectable = false

	LibraryElements.UIStroke_2.Color = T.Stroke
	LibraryElements.UIStroke_2.Parent = LibraryElements.NavigationHolder_1

	LibraryElements.UICorner_2.CornerRadius = UDim.new(0, 6)
	LibraryElements.UICorner_2.Parent = LibraryElements.NavigationHolder_1

	LibraryElements.NavLine_1.AnchorPoint = Vector2.new(0.5, 0)
	LibraryElements.NavLine_1.BackgroundColor3 = T.Stroke
	LibraryElements.NavLine_1.BorderSizePixel = 0
	LibraryElements.NavLine_1.Name = "NavLine"
	LibraryElements.NavLine_1.Parent = LibraryElements.NavigationHolder_1
	LibraryElements.NavLine_1.Position = UDim2.new(0.333, 0, 0, 0)
	LibraryElements.NavLine_1.Size = UDim2.new(0, 1, 1, 0)

	LibraryElements.NavLine_2.AnchorPoint = Vector2.new(0.5, 0)
	LibraryElements.NavLine_2.BackgroundColor3 = T.Stroke
	LibraryElements.NavLine_2.BorderSizePixel = 0
	LibraryElements.NavLine_2.Name = "NavLine2"
	LibraryElements.NavLine_2.Parent = LibraryElements.NavigationHolder_1
	LibraryElements.NavLine_2.Position = UDim2.new(0.666, 0, 0, 0)
	LibraryElements.NavLine_2.Size = UDim2.new(0, 1, 1, 0)

	LibraryElements.DragHandleButton_1.BackgroundTransparency = 1
	LibraryElements.DragHandleButton_1.Name = "DragHandleButton"
	LibraryElements.DragHandleButton_1.Parent = LibraryElements.NavigationHolder_1
	LibraryElements.DragHandleButton_1.Size = UDim2.new(0, 30, 0, 24)
	LibraryElements.DragHandleButton_1.Text = ""

	LibraryElements.DragHandleIcon_1.AnchorPoint = Vector2.new(0.5, 0.5)
	LibraryElements.DragHandleIcon_1.BackgroundTransparency = 1
	LibraryElements.DragHandleIcon_1.Name = "DragHandleIcon"
	LibraryElements.DragHandleIcon_1.Parent = LibraryElements.DragHandleButton_1
	LibraryElements.DragHandleIcon_1.Position = UDim2.new(0.5, 0, 0.5, 0)
	LibraryElements.DragHandleIcon_1.Size = UDim2.new(0, 15, 0, 15)
	LibraryElements.DragHandleIcon_1.Image = "rbxassetid://10734950309"
	LibraryElements.DragHandleIcon_1.ImageColor3 = T.MutedText

	LibraryElements.MinimizeButton_1.BackgroundTransparency = 1
	LibraryElements.MinimizeButton_1.Name = "MinimizeButton"
	LibraryElements.MinimizeButton_1.Parent = LibraryElements.NavigationHolder_1
	LibraryElements.MinimizeButton_1.Position = UDim2.new(0, 30, 0, 0)
	LibraryElements.MinimizeButton_1.Size = UDim2.new(0, 30, 0, 24)
	LibraryElements.MinimizeButton_1.Text = ""

	LibraryElements.MinimizeIcon_1.AnchorPoint = Vector2.new(0.5, 0.5)
	LibraryElements.MinimizeIcon_1.BackgroundTransparency = 1
	LibraryElements.MinimizeIcon_1.Name = "MinimizeIcon"
	LibraryElements.MinimizeIcon_1.Parent = LibraryElements.MinimizeButton_1
	LibraryElements.MinimizeIcon_1.Position = UDim2.new(0.5, 0, 0.5, 0)
	LibraryElements.MinimizeIcon_1.Size = UDim2.new(0, 16, 0, 16)
	LibraryElements.MinimizeIcon_1.Image = "rbxassetid://75550123309801"

	LibraryElements.CloseButton_1.BackgroundTransparency = 1
	LibraryElements.CloseButton_1.Name = "CloseButton"
	LibraryElements.CloseButton_1.Parent = LibraryElements.NavigationHolder_1
	LibraryElements.CloseButton_1.Position = UDim2.new(0, 60, 0, 0)
	LibraryElements.CloseButton_1.Size = UDim2.new(0, 30, 0, 24)
	LibraryElements.CloseButton_1.Text = ""

	LibraryElements.CloseIcon_1.AnchorPoint = Vector2.new(0.5, 0.5)
	LibraryElements.CloseIcon_1.BackgroundTransparency = 1
	LibraryElements.CloseIcon_1.Name = "CloseIcon"
	LibraryElements.CloseIcon_1.Parent = LibraryElements.CloseButton_1
	LibraryElements.CloseIcon_1.Position = UDim2.new(0.5, 0, 0.5, 0)
	LibraryElements.CloseIcon_1.Size = UDim2.new(0, 16, 0, 16)
	LibraryElements.CloseIcon_1.Image = "rbxassetid://101064721108854"

	LibraryElements.TabsHolder_1.BackgroundTransparency = 1
	LibraryElements.TabsHolder_1.Name = "TabsHolder"
	LibraryElements.TabsHolder_1.Parent = LibraryElements.Main_1
	LibraryElements.TabsHolder_1.Position = UDim2.new(0, 0, 0, 58)
	LibraryElements.TabsHolder_1.Size = UDim2.new(0, 200, 1, -58)

	LibraryElements.Tabs_1.BackgroundTransparency = 1
	LibraryElements.Tabs_1.Name = "Tabs"
	LibraryElements.Tabs_1.Parent = LibraryElements.TabsHolder_1
	LibraryElements.Tabs_1.Size = UDim2.new(1, 0, 1, 0)
	LibraryElements.Tabs_1.AutomaticCanvasSize = Enum.AutomaticSize.Y
	LibraryElements.Tabs_1.CanvasSize = UDim2.new(0, 0, 0, 0)
	LibraryElements.Tabs_1.ElasticBehavior = Enum.ElasticBehavior.Never
	LibraryElements.Tabs_1.ScrollBarImageTransparency = 1
	LibraryElements.Tabs_1.ScrollBarThickness = 2
	LibraryElements.Tabs_1.ScrollingDirection = Enum.ScrollingDirection.Y

	LibraryElements.UIListLayout_1.Padding = UDim.new(0, 6)
	LibraryElements.UIListLayout_1.Parent = LibraryElements.Tabs_1
	LibraryElements.UIListLayout_1.SortOrder = Enum.SortOrder.LayoutOrder

	LibraryElements.UIPadding_4.Parent = LibraryElements.Tabs_1
	LibraryElements.UIPadding_4.PaddingBottom = UDim.new(0, 10)
	LibraryElements.UIPadding_4.PaddingLeft = UDim.new(0, 12)
	LibraryElements.UIPadding_4.PaddingTop = UDim.new(0, 10)

	LibraryElements.ElementsHolder_1.BackgroundTransparency = 1
	LibraryElements.ElementsHolder_1.Name = "ElementsHolder"
	LibraryElements.ElementsHolder_1.Parent = LibraryElements.Main_1
	LibraryElements.ElementsHolder_1.Position = UDim2.new(0, 200, 0, 58)
	LibraryElements.ElementsHolder_1.Size = UDim2.new(1, -200, 1, -58)
	LibraryElements.ElementsHolder_1.ClipsDescendants = true

	LibraryElements.DragUI_1.AnchorPoint = Vector2.new(0.5, 0)
	LibraryElements.DragUI_1.BackgroundTransparency = 1
	LibraryElements.DragUI_1.Name = "DragUI"
	LibraryElements.DragUI_1.Parent = LibraryElements.Main_1
	LibraryElements.DragUI_1.Position = UDim2.new(0.5, 0, 1, -4)
	LibraryElements.DragUI_1.Size = UDim2.new(0, 220, 0, 18)
	LibraryElements.DragUI_1.Image = "rbxassetid://85013248490002"
	LibraryElements.DragUI_1.ImageTransparency = 0.3

	LibraryElements.ResizeUI_1.BackgroundTransparency = 1
	LibraryElements.ResizeUI_1.Name = "ResizeUI"
	LibraryElements.ResizeUI_1.Parent = LibraryElements.Main_1
	LibraryElements.ResizeUI_1.Position = UDim2.new(1, -40, 1, -40)
	LibraryElements.ResizeUI_1.Size = UDim2.new(0, 36, 0, 36)
	LibraryElements.ResizeUI_1.Image = "rbxassetid://120997033468887"
	LibraryElements.ResizeUI_1.ImageTransparency = 0.25

	UIElements.OpenUIHolder_1.Active = true
	UIElements.OpenUIHolder_1.AnchorPoint = Vector2.new(0.5, 0.5)
	UIElements.OpenUIHolder_1.BackgroundColor3 = T.Background
	UIElements.OpenUIHolder_1.BackgroundTransparency = T.BackgroundTransparency
	UIElements.OpenUIHolder_1.Name = "OpenUIHolder"
	UIElements.OpenUIHolder_1.Parent = LibraryElements.Library_1
	UIElements.OpenUIHolder_1.Position = UDim2.new(0, 40, 0.5, 0)
	UIElements.OpenUIHolder_1.Size = UDim2.new(0, 32, 0, 32)
	UIElements.OpenUIHolder_1.Visible = false
	UIElements.OpenUIHolder_1.ZIndex = 100

	UIElements.UICorner_31.CornerRadius = UDim.new(0, 8)
	UIElements.UICorner_31.Parent = UIElements.OpenUIHolder_1

	UIElements.UIStroke_24.Color = T.Stroke
	UIElements.UIStroke_24.Parent = UIElements.OpenUIHolder_1

	UIElements.OpenUI_1.BackgroundTransparency = 1
	UIElements.OpenUI_1.Name = "OpenUI"
	UIElements.OpenUI_1.Parent = UIElements.OpenUIHolder_1
	UIElements.OpenUI_1.Size = UDim2.new(1, 0, 1, 0)
	UIElements.OpenUI_1.Image = "rbxassetid://76392913095647"
	UIElements.OpenUI_1.ZIndex = 101

	local function Lerp(a, b, m)
		return a + (b - a) * m
	end

	local function Update(dt)
		if dragging and lastGoalPos then
			LibraryElements.Main_1.Position = UDim2.new(
				lastGoalPos.X.Scale,
				Lerp(LibraryElements.Main_1.Position.X.Offset, lastGoalPos.X.Offset, dt * DRAG_SPEED),
				lastGoalPos.Y.Scale,
				Lerp(LibraryElements.Main_1.Position.Y.Offset, lastGoalPos.Y.Offset, dt * DRAG_SPEED)
			)
		end
	end

	local function InitDrag(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = UserInputService:GetMouseLocation()
			startPos = LibraryElements.Main_1.Position
			lastGoalPos = startPos

			local connection
			connection = UserInputService.InputEnded:Connect(function(endInput)
				if endInput.UserInputType == Enum.UserInputType.MouseButton1 or endInput.UserInputType == Enum.UserInputType.Touch then
					dragging = false
					connection:Disconnect()
				end
			end)
		end
	end

	LibraryElements.DragHandleButton_1.InputBegan:Connect(InitDrag)
	LibraryElements.DragUI_1.InputBegan:Connect(InitDrag)
	LibraryElements.TopBar_1.InputBegan:Connect(InitDrag)

	RunService.Heartbeat:Connect(function(dt)
		if dragging then
			local mouseLocation = UserInputService:GetMouseLocation()
			local delta = mouseLocation - dragStart
			lastGoalPos = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			)
		end
		Update(dt)
	end)

	local function updateResize(input)
		local delta = input.Position - inputStartPos
		local newWidth = math.clamp(startSize.X + delta.X, MinSize.X, MaxSize.X)
		local newHeight = math.clamp(startSize.Y + delta.Y, MinSize.Y, MaxSize.Y)
		LibraryElements.Main_1.Size = UDim2.new(0, newWidth, 0, newHeight)
		OriginalSize = LibraryElements.Main_1.Size
	end

	LibraryElements.ResizeUI_1.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			isResizing = true
			inputStartPos = input.Position
			startSize = LibraryElements.Main_1.AbsoluteSize
			local connection
			connection = UserInputService.InputEnded:Connect(function(inputEnd)
				if inputEnd.UserInputType == Enum.UserInputType.MouseButton1 or inputEnd.UserInputType == Enum.UserInputType.Touch then
					isResizing = false
					connection:Disconnect()
				end
			end)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if isResizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			updateResize(input)
		end
	end)

	local function ExitSequence(isClosing)
		if IsAnimating then return end
		IsAnimating = true
		if isClosing then
			LibraryElements.Library_1:Destroy()
		else
			LibraryElements.Main_1.Visible = false
			UIElements.OpenUIHolder_1.Visible = true
			Minimized = true
		end
		IsAnimating = false
	end

	local function RestoreSequence()
		if not Minimized or IsAnimating then return end
		IsAnimating = true
		LibraryElements.Main_1.Visible = true
		UIElements.OpenUIHolder_1.Visible = false
		Minimized = false
		IsAnimating = false
	end

	LibraryElements.MinimizeButton_1.MouseButton1Click:Connect(function()
		ExitSequence(false)
	end)

	LibraryElements.CloseButton_1.MouseButton1Click:Connect(function()
		ExitSequence(true)
	end)

	UIElements.OpenUI_1.MouseButton1Click:Connect(function()
		if Minimized then
			RestoreSequence()
		end
	end)

	UserInputService.InputBegan:Connect(function(input, gp)
		if not gp and input.KeyCode == Enum.KeyCode.LeftControl then
			if Minimized then
				RestoreSequence()
			else
				ExitSequence(false)
			end
		end
	end)

	local WindowAPI = {}

	function WindowAPI:EditOpenButton(opts)
		opts = opts or {}
		if opts.Icon then
			UIElements.OpenUI_1.Image = ResolveIcon(opts.Icon) or opts.Icon
		end
		if opts.CornerRadius then
			UIElements.UICorner_31.CornerRadius = opts.CornerRadius
		end
		if opts.Position then
			UIElements.OpenUIHolder_1.Position = opts.Position
		end
		if opts.Size then
			UIElements.OpenUIHolder_1.Size = opts.Size
			UIElements.OpenUI_1.Size = UDim2.new(1, 0, 1, 0)
		end
		if opts.Draggable then
			local draggingOpen = false
			local dragStartOpen = nil
			local startPosOpen = nil

			UIElements.OpenUIHolder_1.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					draggingOpen = true
					dragStartOpen = input.Position
					startPosOpen = UIElements.OpenUIHolder_1.Position
					local conn
					conn = input.Changed:Connect(function()
						if input.UserInputState == Enum.UserInputState.End then
							draggingOpen = false
							if conn then conn:Disconnect() end
						end
					end)
				end
			end)

			UserInputService.InputChanged:Connect(function(input)
				if draggingOpen and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
					local delta = input.Position - dragStartOpen
					UIElements.OpenUIHolder_1.Position = UDim2.new(
						startPosOpen.X.Scale,
						startPosOpen.X.Offset + delta.X,
						startPosOpen.Y.Scale,
						startPosOpen.Y.Offset + delta.Y
					)
				end
			end)
		end
	end

	local Tabs = {}
	local allTitles = {}
	local allIcons = {}
	local allTabs = {}
	local currentTab = nil
	local currentIcon = nil
	local currentHolder = nil
	local currentTabIndex = nil
	local currentTitle = nil
	local currentDesc = nil
	local first = true

	function Tabs:CreateTabSection(Title)
		LayoutCounter = LayoutCounter + 1
		local Section = Instance.new("Frame")
		local TitleLabel = Instance.new("TextLabel")
		local Pad = Instance.new("UIPadding")

		Section.LayoutOrder = LayoutCounter
		Section.BackgroundTransparency = 1
		Section.Name = "TabsSection"
		Section.Parent = LibraryElements.Tabs_1
		Section.Size = UDim2.new(1, 0, 0, 22)

		TitleLabel.BackgroundTransparency = 1
		TitleLabel.Name = "Title"
		TitleLabel.Parent = Section
		TitleLabel.Size = UDim2.new(1, 0, 1, 0)
		TitleLabel.FontFace = Font.new("rbxassetid://16658221428", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
		TitleLabel.RichText = true
		TitleLabel.Text = "<b>" .. Title .. "</b>"
		TitleLabel.TextColor3 = T.Text
		TitleLabel.TextSize = 15
		TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

		Pad.Parent = TitleLabel
	end

	function Tabs:CreateTab(Title, Description, IconId)
		LayoutCounter = LayoutCounter + 1
		local resolvedIcon = ResolveIcon(IconId)

		local TabHolder = Instance.new("Frame")
		local TabButton = Instance.new("TextButton")
		local UICorner = Instance.new("UICorner")
		local UIStroke = Instance.new("UIStroke")
		local Icon = Instance.new("ImageLabel")
		local TitleLabel = Instance.new("TextLabel")
		local TitlePad = Instance.new("UIPadding")
		local DescLabel = Instance.new("TextLabel")
		local DescPad = Instance.new("UIPadding")
		local Indicator = Instance.new("Frame")
		local IndicatorCorner = Instance.new("UICorner")
		local IndicatorStroke = Instance.new("UIStroke")
		local Dot = Instance.new("Frame")
		local DotCorner = Instance.new("UICorner")
		local ElementsFrame = Instance.new("Frame")
		local Items = Instance.new("ScrollingFrame")
		local ItemsPad = Instance.new("UIPadding")
		local ItemsLayout = Instance.new("UIListLayout")

		TabHolder.LayoutOrder = LayoutCounter
		TabHolder.BackgroundColor3 = T.Secondary
		TabHolder.BackgroundTransparency = 1
		TabHolder.Name = "TabHolder"
		TabHolder.Parent = LibraryElements.Tabs_1
		TabHolder.Size = UDim2.new(0, 176, 0, 44)

		TabButton.BackgroundTransparency = 1
		TabButton.Name = "TabButton"
		TabButton.Parent = TabHolder
		TabButton.Size = UDim2.new(1, 0, 1, 0)
		TabButton.Text = ""

		UICorner.CornerRadius = UDim.new(0, 6)
		UICorner.Parent = TabHolder

		UIStroke.Color = T.Stroke
		UIStroke.Parent = TabHolder

		if resolvedIcon then
			Icon.BackgroundTransparency = 1
			Icon.Name = "Icon"
			Icon.Parent = TabHolder
			Icon.Position = UDim2.new(0, 8, 0.5, -9)
			Icon.Size = UDim2.new(0, 18, 0, 18)
			Icon.Image = resolvedIcon
			Icon.ImageColor3 = T.MutedText
		end

		TitleLabel.BackgroundTransparency = 1
		TitleLabel.Name = "Title"
		TitleLabel.Parent = TabHolder
		TitleLabel.Size = UDim2.new(1, 0, 0, 20)
		TitleLabel.FontFace = Font.new("rbxassetid://16658221428", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
		TitleLabel.RichText = true
		TitleLabel.Text = "<b>" .. Title .. "</b>"
		TitleLabel.TextColor3 = T.MutedText
		TitleLabel.TextSize = 15
		TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

		TitlePad.Parent = TitleLabel
		TitlePad.PaddingLeft = UDim.new(0, resolvedIcon and 32 or 10)
		TitlePad.PaddingTop = UDim.new(0, 5)

		DescLabel.BackgroundTransparency = 1
		DescLabel.Name = "Description"
		DescLabel.Parent = TabHolder
		DescLabel.Size = UDim2.new(1, 0, 0, 18)
		DescLabel.FontFace = Font.new("rbxassetid://16658221428", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
		DescLabel.Text = Description
		DescLabel.TextColor3 = T.DimText
		DescLabel.TextSize = 13
		DescLabel.TextXAlignment = Enum.TextXAlignment.Left

		DescPad.Parent = DescLabel
		DescPad.PaddingLeft = UDim.new(0, resolvedIcon and 32 or 10)
		DescPad.PaddingTop = UDim.new(0, 22)

		Indicator.Name = "TabIndicator"
		Indicator.BackgroundColor3 = T.Secondary
		Indicator.Parent = TabHolder
		Indicator.Position = UDim2.new(1, -20, 0, 7)
		Indicator.Size = UDim2.new(0, 12, 0, 12)

		IndicatorCorner.CornerRadius = UDim.new(0, 4)
		IndicatorCorner.Parent = Indicator

		IndicatorStroke.Color = T.Stroke
		IndicatorStroke.Parent = Indicator

		Dot.AnchorPoint = Vector2.new(0.5, 0.5)
		Dot.BackgroundColor3 = T.Secondary
		Dot.Name = "Dot"
		Dot.Parent = Indicator
		Dot.Position = UDim2.new(0.5, 0, 0.5, 0)
		Dot.Size = UDim2.new(0, 6, 0, 6)

		DotCorner.CornerRadius = UDim.new(1, 0)
		DotCorner.Parent = Dot

		ElementsFrame.BackgroundTransparency = 1
		ElementsFrame.Name = "Elements"
		ElementsFrame.Parent = LibraryElements.ElementsHolder_1
		ElementsFrame.Size = UDim2.new(1, 0, 1, 0)
		ElementsFrame.Visible = false

		Items.BackgroundTransparency = 1
		Items.Name = "Items"
		Items.Parent = ElementsFrame
		Items.Size = UDim2.new(1, 0, 1, 0)
		Items.AutomaticCanvasSize = Enum.AutomaticSize.Y
		Items.CanvasSize = UDim2.new(0, 0, 0, 0)
		Items.ElasticBehavior = Enum.ElasticBehavior.Never
		Items.ScrollBarImageTransparency = 1
		Items.ScrollBarThickness = 2
		Items.ScrollingDirection = Enum.ScrollingDirection.Y

		ItemsPad.Parent = Items
		ItemsPad.PaddingBottom = UDim.new(0, 12)
		ItemsPad.PaddingLeft = UDim.new(0, 12)
		ItemsPad.PaddingRight = UDim.new(0, 8)
		ItemsPad.PaddingTop = UDim.new(0, 10)

		ItemsLayout.Padding = UDim.new(0, 8)
		ItemsLayout.Parent = Items
		ItemsLayout.SortOrder = Enum.SortOrder.LayoutOrder

		table.insert(allTitles, TabButton)
		table.insert(allIcons, Indicator)
		table.insert(allTabs, ElementsFrame)

		if first then
			first = false
			ElementsFrame.Visible = true
			currentTab = TabButton
			currentTitle = TitleLabel
			currentDesc = DescLabel
			currentIcon = Indicator
			currentHolder = TabHolder
			currentTabIndex = 1
			TabHolder.BackgroundTransparency = T.SecondaryTransparency
			TitleLabel.TextColor3 = T.Text
			DescLabel.TextColor3 = T.MutedText
			Indicator.BackgroundColor3 = T.Accent
			if resolvedIcon then Icon.ImageColor3 = T.Text end
		end

		TabButton.MouseButton1Click:Connect(function()
			if currentTab == TabButton then return end
			local newIndex = table.find(allTitles, TabButton)
			if not newIndex then return end

			local direction = (newIndex > currentTabIndex) and 1 or -1
			local currentFrame = allTabs[currentTabIndex]
			local newFrame = allTabs[newIndex]

			if currentTitle and currentDesc and currentHolder and currentIcon then
				TweenService:Create(currentTitle, TweenInfo.new(0.18), {TextColor3 = T.MutedText}):Play()
				TweenService:Create(currentDesc, TweenInfo.new(0.18), {TextColor3 = T.DimText}):Play()
				TweenService:Create(currentIcon, TweenInfo.new(0.18), {BackgroundColor3 = T.Secondary}):Play()
				TweenService:Create(currentHolder, TweenInfo.new(0.18), {BackgroundTransparency = 1}):Play()
			end

			TweenService:Create(TitleLabel, TweenInfo.new(0.18), {TextColor3 = T.Text}):Play()
			TweenService:Create(DescLabel, TweenInfo.new(0.18), {TextColor3 = T.MutedText}):Play()
			TweenService:Create(Indicator, TweenInfo.new(0.18), {BackgroundColor3 = T.Accent}):Play()
			TweenService:Create(TabHolder, TweenInfo.new(0.18), {BackgroundTransparency = T.SecondaryTransparency}):Play()
			if resolvedIcon then
				TweenService:Create(Icon, TweenInfo.new(0.18), {ImageColor3 = T.Text}):Play()
			end

			newFrame.Position = UDim2.new(direction, 0, 0, 0)
			newFrame.Visible = true

			local outTween = TweenService:Create(currentFrame, TweenInfo.new(0.18), {Position = UDim2.new(-direction, 0, 0, 0)})
			local inTween = TweenService:Create(newFrame, TweenInfo.new(0.18), {Position = UDim2.new(0, 0, 0, 0)})
			outTween:Play()
			inTween:Play()
			outTween.Completed:Connect(function()
				currentFrame.Visible = false
			end)

			currentTab = TabButton
			currentTitle = TitleLabel
			currentDesc = DescLabel
			currentIcon = Indicator
			currentHolder = TabHolder
			currentTabIndex = newIndex
		end)

		local Elements = {}

		function Elements:CreateSection(Title)
			LayoutCounter = LayoutCounter + 1
			local Section = Instance.new("Frame")
			local TitleLabel = Instance.new("TextLabel")
			local Pad = Instance.new("UIPadding")

			Section.BackgroundTransparency = 1
			Section.Name = "Section"
			Section.Parent = Items
			Section.Size = UDim2.new(1, 0, 0, 22)
			Section.LayoutOrder = LayoutCounter

			TitleLabel.BackgroundTransparency = 1
			TitleLabel.Name = "SectionTitle"
			TitleLabel.Parent = Section
			TitleLabel.Size = UDim2.new(1, -10, 1, 0)
			TitleLabel.FontFace = Font.new("rbxassetid://16658221428", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
			TitleLabel.RichText = true
			TitleLabel.Text = "<b>" .. Title .. "</b>"
			TitleLabel.TextColor3 = T.Text
			TitleLabel.TextSize = 15
			TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

			Pad.Parent = TitleLabel
		end

		function Elements:CreateButton(Title, Description, Callback)
			LayoutCounter = LayoutCounter + 1
			Callback = Callback or function() end

			local Button = Instance.new("Frame")
			local Corner = Instance.new("UICorner")
			local Stroke = Instance.new("UIStroke")
			local TitleLabel = Instance.new("TextLabel")
			local TitlePad = Instance.new("UIPadding")
			local DescLabel = Instance.new("TextLabel")
			local DescPad = Instance.new("UIPadding")
			local Holder = Instance.new("Frame")
			local HolderCorner = Instance.new("UICorner")
			local HolderStroke = Instance.new("UIStroke")
			local Btn = Instance.new("TextButton")

			Button.BackgroundColor3 = T.Secondary
			Button.BackgroundTransparency = T.ElementTransparency
			Button.Name = "Button"
			Button.Parent = Items
			Button.Size = UDim2.new(1, -4, 0, 50)
			Button.LayoutOrder = LayoutCounter

			Corner.CornerRadius = UDim.new(0, 6)
			Corner.Parent = Button

			Stroke.Color = T.Stroke
			Stroke.Parent = Button

			TitleLabel.BackgroundTransparency = 1
			TitleLabel.Parent = Button
			TitleLabel.Position = UDim2.new(0, 12, 0, 0)
			TitleLabel.Size = UDim2.new(1, -100, 1, 0)
			TitleLabel.FontFace = Font.new("rbxassetid://16658221428")
			TitleLabel.RichText = true
			TitleLabel.Text = "<b>" .. Title .. "</b>"
			TitleLabel.TextColor3 = T.MutedText
			TitleLabel.TextSize = 16
			TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

			TitlePad.Parent = TitleLabel
			TitlePad.PaddingBottom = UDim.new(0, 16)

			DescLabel.BackgroundTransparency = 1
			DescLabel.Parent = Button
			DescLabel.Position = UDim2.new(0, 12, 0, 0)
			DescLabel.Size = UDim2.new(1, -100, 1, 0)
			DescLabel.FontFace = Font.new("rbxassetid://16658221428")
			DescLabel.Text = Description
			DescLabel.TextColor3 = T.DimText
			DescLabel.TextSize = 13
			DescLabel.TextXAlignment = Enum.TextXAlignment.Left

			DescPad.Parent = DescLabel
			DescPad.PaddingTop = UDim.new(0, 18)

			Holder.AnchorPoint = Vector2.new(0, 0.5)
			Holder.BackgroundColor3 = T.Accent
			Holder.Parent = Button
			Holder.Position = UDim2.new(1, -82, 0.5, 0)
			Holder.Size = UDim2.new(0, 68, 0, 26)

			HolderCorner.CornerRadius = UDim.new(0, 6)
			HolderCorner.Parent = Holder

			HolderStroke.Color = T.Stroke
			HolderStroke.Parent = Holder

			Btn.BackgroundTransparency = 1
			Btn.Parent = Holder
			Btn.Size = UDim2.new(1, 0, 1, 0)
			Btn.FontFace = Font.new("rbxassetid://16658221428")
			Btn.Text = "Click"
			Btn.TextColor3 = T.Background
			Btn.TextSize = 14

			Btn.MouseButton1Click:Connect(function()
				local press = TweenService:Create(Holder, TweenInfo.new(0.07), {Position = UDim2.new(1, -82, 0.5, 2)})
				press:Play()
				press.Completed:Connect(function()
					TweenService:Create(Holder, TweenInfo.new(0.07), {Position = UDim2.new(1, -82, 0.5, 0)}):Play()
				end)
				pcall(Callback)
			end)

			local obj = {}
			function obj:SetText(t, d)
				if t then TitleLabel.Text = "<b>" .. t .. "</b>" end
				if d then DescLabel.Text = d end
			end
			return obj
		end

		function Elements:CreateToggle(Title, Description, Default, Callback)
			LayoutCounter = LayoutCounter + 1
			local toggled = Default or false
			local debounce = false
			Callback = Callback or function() end

			local Toggle = Instance.new("Frame")
			local Corner = Instance.new("UICorner")
			local Stroke = Instance.new("UIStroke")
			local TitleLabel = Instance.new("TextLabel")
			local TitlePad = Instance.new("UIPadding")
			local DescLabel = Instance.new("TextLabel")
			local DescPad = Instance.new("UIPadding")
			local Holder = Instance.new("Frame")
			local HolderStroke = Instance.new("UIStroke")
			local HolderCorner = Instance.new("UICorner")
			local Indicator = Instance.new("Frame")
			local IndicatorCorner = Instance.new("UICorner")
			local Hit = Instance.new("TextButton")

			Toggle.BackgroundColor3 = T.Secondary
			Toggle.BackgroundTransparency = T.ElementTransparency
			Toggle.Name = "Toggle"
			Toggle.Parent = Items
			Toggle.Size = UDim2.new(1, -4, 0, 50)
			Toggle.LayoutOrder = LayoutCounter

			Corner.CornerRadius = UDim.new(0, 6)
			Corner.Parent = Toggle

			Stroke.Color = T.Stroke
			Stroke.Parent = Toggle

			TitleLabel.BackgroundTransparency = 1
			TitleLabel.Parent = Toggle
			TitleLabel.Position = UDim2.new(0, 12, 0, 0)
			TitleLabel.Size = UDim2.new(1, -90, 1, 0)
			TitleLabel.FontFace = Font.new("rbxassetid://16658221428")
			TitleLabel.RichText = true
			TitleLabel.Text = "<b>" .. Title .. "</b>"
			TitleLabel.TextColor3 = T.MutedText
			TitleLabel.TextSize = 16
			TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

			TitlePad.Parent = TitleLabel
			TitlePad.PaddingBottom = UDim.new(0, 16)

			DescLabel.BackgroundTransparency = 1
			DescLabel.Parent = Toggle
			DescLabel.Position = UDim2.new(0, 12, 0, 0)
			DescLabel.Size = UDim2.new(1, -90, 1, 0)
			DescLabel.FontFace = Font.new("rbxassetid://16658221428")
			DescLabel.Text = Description
			DescLabel.TextColor3 = T.DimText
			DescLabel.TextSize = 13
			DescLabel.TextXAlignment = Enum.TextXAlignment.Left

			DescPad.Parent = DescLabel
			DescPad.PaddingTop = UDim.new(0, 18)

			Holder.AnchorPoint = Vector2.new(0, 0.5)
			Holder.BackgroundColor3 = T.Tertiary
			Holder.Parent = Toggle
			Holder.Position = UDim2.new(1, -54, 0.5, 0)
			Holder.Size = UDim2.new(0, 40, 0, 20)

			HolderStroke.Color = T.Stroke
			HolderStroke.Parent = Holder

			HolderCorner.CornerRadius = UDim.new(0, 10)
			HolderCorner.Parent = Holder

			Indicator.BackgroundColor3 = T.Accent
			Indicator.Parent = Holder
			Indicator.Position = UDim2.new(0, 2, 0, 1)
			Indicator.Size = UDim2.new(0, 18, 0, 18)

			IndicatorCorner.CornerRadius = UDim.new(1, 0)
			IndicatorCorner.Parent = Indicator

			Hit.BackgroundTransparency = 1
			Hit.Parent = Holder
			Hit.Size = UDim2.new(1, 0, 1, 0)
			Hit.Text = ""

			local function setValue(val, fire)
				toggled = val
				if val then
					TweenService:Create(Indicator, TweenInfo.new(0.18), {Position = UDim2.new(0, 20, 0, 1)}):Play()
					TweenService:Create(Indicator, TweenInfo.new(0.18), {BackgroundColor3 = T.Background}):Play()
					TweenService:Create(Holder, TweenInfo.new(0.18), {BackgroundColor3 = T.Accent}):Play()
				else
					TweenService:Create(Indicator, TweenInfo.new(0.18), {Position = UDim2.new(0, 2, 0, 1)}):Play()
					TweenService:Create(Indicator, TweenInfo.new(0.18), {BackgroundColor3 = T.Accent}):Play()
					TweenService:Create(Holder, TweenInfo.new(0.18), {BackgroundColor3 = T.Tertiary}):Play()
				end
				if fire then pcall(Callback, val) end
			end

			if Default then
				task.defer(function() setValue(true, true) end)
			end

			table.insert(getgenv().bPeMConfigState.registered, {
				type = "toggle",
				key = Title,
				getter = function() return toggled end,
				setter = function(v) setValue(v, true) end,
				reset = function() setValue(false, true) end
			})

			Hit.MouseButton1Click:Connect(function()
				if not debounce then
					debounce = true
					setValue(not toggled, true)
					debounce = false
				end
			end)

			local obj = {}
			function obj:Set(v) setValue(v, true) end
			function obj:Get() return toggled end
			return obj
		end

		function Elements:CreateSlider(Title, Description, Min, Max, Default, Callback)
			LayoutCounter = LayoutCounter + 1
			Min = Min or 0
			Max = Max or 100
			Default = math.clamp(Default or Min, Min, Max)
			Callback = Callback or function() end
			local value = Default

			local Slider = Instance.new("Frame")
			local Corner = Instance.new("UICorner")
			local Stroke = Instance.new("UIStroke")
			local TitleLabel = Instance.new("TextLabel")
			local ValueLabel = Instance.new("TextLabel")
			local DescLabel = Instance.new("TextLabel")
			local Bar = Instance.new("Frame")
			local BarCorner = Instance.new("UICorner")
			local Fill = Instance.new("Frame")
			local FillCorner = Instance.new("UICorner")
			local Knob = Instance.new("Frame")
			local KnobCorner = Instance.new("UICorner")
			local Hit = Instance.new("TextButton")

			Slider.BackgroundColor3 = T.Secondary
			Slider.BackgroundTransparency = T.ElementTransparency
			Slider.Name = "Slider"
			Slider.Parent = Items
			Slider.Size = UDim2.new(1, -4, 0, 66)
			Slider.LayoutOrder = LayoutCounter

			Corner.CornerRadius = UDim.new(0, 6)
			Corner.Parent = Slider

			Stroke.Color = T.Stroke
			Stroke.Parent = Slider

			TitleLabel.BackgroundTransparency = 1
			TitleLabel.Parent = Slider
			TitleLabel.Position = UDim2.new(0, 12, 0, 4)
			TitleLabel.Size = UDim2.new(1, -80, 0, 18)
			TitleLabel.FontFace = Font.new("rbxassetid://16658221428")
			TitleLabel.RichText = true
			TitleLabel.Text = "<b>" .. Title .. "</b>"
			TitleLabel.TextColor3 = T.MutedText
			TitleLabel.TextSize = 16
			TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

			ValueLabel.BackgroundTransparency = 1
			ValueLabel.Parent = Slider
			ValueLabel.Position = UDim2.new(1, -70, 0, 4)
			ValueLabel.Size = UDim2.new(0, 58, 0, 18)
			ValueLabel.FontFace = Font.new("rbxassetid://16658221428")
			ValueLabel.Text = tostring(Default)
			ValueLabel.TextColor3 = T.Text
			ValueLabel.TextSize = 15
			ValueLabel.TextXAlignment = Enum.TextXAlignment.Right

			DescLabel.BackgroundTransparency = 1
			DescLabel.Parent = Slider
			DescLabel.Position = UDim2.new(0, 12, 0, 22)
			DescLabel.Size = UDim2.new(1, -24, 0, 16)
			DescLabel.FontFace = Font.new("rbxassetid://16658221428")
			DescLabel.Text = Description
			DescLabel.TextColor3 = T.DimText
			DescLabel.TextSize = 13
			DescLabel.TextXAlignment = Enum.TextXAlignment.Left

			Bar.BackgroundColor3 = T.Tertiary
			Bar.Parent = Slider
			Bar.Position = UDim2.new(0, 12, 0, 46)
			Bar.Size = UDim2.new(1, -24, 0, 8)

			BarCorner.CornerRadius = UDim.new(0, 4)
			BarCorner.Parent = Bar

			Fill.BackgroundColor3 = T.Accent
			Fill.Parent = Bar
			Fill.Size = UDim2.new((Default - Min) / (Max - Min), 0, 1, 0)

			FillCorner.CornerRadius = UDim.new(0, 4)
			FillCorner.Parent = Fill

			Knob.AnchorPoint = Vector2.new(0.5, 0.5)
			Knob.BackgroundColor3 = T.Accent
			Knob.Parent = Bar
			Knob.Position = UDim2.new((Default - Min) / (Max - Min), 0, 0.5, 0)
			Knob.Size = UDim2.new(0, 14, 0, 14)

			KnobCorner.CornerRadius = UDim.new(1, 0)
			KnobCorner.Parent = Knob

			Hit.BackgroundTransparency = 1
			Hit.Parent = Bar
			Hit.Size = UDim2.new(1, 0, 1, 0)
			Hit.Text = ""

			local sliding = false

			local function update(input)
				local absPos = Bar.AbsolutePosition.X
				local absSize = Bar.AbsoluteSize.X
				local rel = math.clamp((input.Position.X - absPos) / absSize, 0, 1)
				value = math.floor(Min + (Max - Min) * rel + 0.5)
				Fill.Size = UDim2.new(rel, 0, 1, 0)
				Knob.Position = UDim2.new(rel, 0, 0.5, 0)
				ValueLabel.Text = tostring(value)
				pcall(Callback, value)
			end

			Hit.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					sliding = true
					update(input)
				end
			end)

			UserInputService.InputChanged:Connect(function(input)
				if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
					update(input)
				end
			end)

			UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					sliding = false
				end
			end)

			table.insert(getgenv().bPeMConfigState.registered, {
				type = "slider",
				key = Title,
				getter = function() return value end,
				setter = function(v)
					value = math.clamp(v, Min, Max)
					local rel = (value - Min) / (Max - Min)
					Fill.Size = UDim2.new(rel, 0, 1, 0)
					Knob.Position = UDim2.new(rel, 0, 0.5, 0)
					ValueLabel.Text = tostring(value)
					pcall(Callback, value)
				end,
				reset = function()
					value = Default
					local rel = (Default - Min) / (Max - Min)
					Fill.Size = UDim2.new(rel, 0, 1, 0)
					Knob.Position = UDim2.new(rel, 0, 0.5, 0)
					ValueLabel.Text = tostring(Default)
					pcall(Callback, Default)
				end
			})

			local obj = {}
			function obj:Set(v)
				value = math.clamp(v, Min, Max)
				local rel = (value - Min) / (Max - Min)
				Fill.Size = UDim2.new(rel, 0, 1, 0)
				Knob.Position = UDim2.new(rel, 0, 0.5, 0)
				ValueLabel.Text = tostring(value)
				pcall(Callback, value)
			end
			function obj:Get() return value end
			return obj
		end

		function Elements:CreateKeybind(Title, Description, Default, Callback)
			LayoutCounter = LayoutCounter + 1
			local currentKey = Default or Enum.KeyCode.Unknown
			local listening = false
			Callback = Callback or function() end

			local Keybind = Instance.new("Frame")
			local Corner = Instance.new("UICorner")
			local Stroke = Instance.new("UIStroke")
			local TitleLabel = Instance.new("TextLabel")
			local TitlePad = Instance.new("UIPadding")
			local DescLabel = Instance.new("TextLabel")
			local DescPad = Instance.new("UIPadding")
			local Holder = Instance.new("Frame")
			local HolderCorner = Instance.new("UICorner")
			local HolderStroke = Instance.new("UIStroke")
			local Btn = Instance.new("TextButton")

			Keybind.BackgroundColor3 = T.Secondary
			Keybind.BackgroundTransparency = T.ElementTransparency
			Keybind.Name = "Keybind"
			Keybind.Parent = Items
			Keybind.Size = UDim2.new(1, -4, 0, 50)
			Keybind.LayoutOrder = LayoutCounter

			Corner.CornerRadius = UDim.new(0, 6)
			Corner.Parent = Keybind

			Stroke.Color = T.Stroke
			Stroke.Parent = Keybind

			TitleLabel.BackgroundTransparency = 1
			TitleLabel.Parent = Keybind
			TitleLabel.Position = UDim2.new(0, 12, 0, 0)
			TitleLabel.Size = UDim2.new(1, -110, 1, 0)
			TitleLabel.FontFace = Font.new("rbxassetid://16658221428")
			TitleLabel.RichText = true
			TitleLabel.Text = "<b>" .. Title .. "</b>"
			TitleLabel.TextColor3 = T.MutedText
			TitleLabel.TextSize = 16
			TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

			TitlePad.Parent = TitleLabel
			TitlePad.PaddingBottom = UDim.new(0, 16)

			DescLabel.BackgroundTransparency = 1
			DescLabel.Parent = Keybind
			DescLabel.Position = UDim2.new(0, 12, 0, 0)
			DescLabel.Size = UDim2.new(1, -110, 1, 0)
			DescLabel.FontFace = Font.new("rbxassetid://16658221428")
			DescLabel.Text = Description
			DescLabel.TextColor3 = T.DimText
			DescLabel.TextSize = 13
			DescLabel.TextXAlignment = Enum.TextXAlignment.Left

			DescPad.Parent = DescLabel
			DescPad.PaddingTop = UDim.new(0, 18)

			Holder.AnchorPoint = Vector2.new(0, 0.5)
			Holder.BackgroundColor3 = T.Tertiary
			Holder.Parent = Keybind
			Holder.Position = UDim2.new(1, -88, 0.5, 0)
			Holder.Size = UDim2.new(0, 76, 0, 26)

			HolderCorner.CornerRadius = UDim.new(0, 6)
			HolderCorner.Parent = Holder

			HolderStroke.Color = T.Stroke
			HolderStroke.Parent = Holder

			Btn.BackgroundTransparency = 1
			Btn.Parent = Holder
			Btn.Size = UDim2.new(1, 0, 1, 0)
			Btn.FontFace = Font.new("rbxassetid://16658221428")
			Btn.Text = currentKey.Name
			Btn.TextColor3 = T.Text
			Btn.TextSize = 13

			Btn.MouseButton1Click:Connect(function()
				if listening then return end
				listening = true
				Btn.Text = "..."
				local conn
				conn = UserInputService.InputBegan:Connect(function(input, gp)
					if gp then return end
					if input.UserInputType == Enum.UserInputType.Keyboard then
						currentKey = input.KeyCode
						Btn.Text = currentKey.Name
						listening = false
						conn:Disconnect()
						pcall(Callback, currentKey)
					end
				end)
			end)

			UserInputService.InputBegan:Connect(function(input, gp)
				if not gp and not listening and input.KeyCode == currentKey then
					pcall(Callback, currentKey)
				end
			end)

			table.insert(getgenv().bPeMConfigState.registered, {
				type = "keybind",
				key = Title,
				getter = function() return currentKey end,
				setter = function(v)
					currentKey = v
					Btn.Text = currentKey.Name
				end,
				reset = function()
					currentKey = Default or Enum.KeyCode.Unknown
					Btn.Text = currentKey.Name
				end
			})

			local obj = {}
			function obj:Set(k)
				currentKey = k
				Btn.Text = currentKey.Name
			end
			function obj:Get() return currentKey end
			return obj
		end

		function Elements:CreateDropdown(Title, Description, Options, Callback)
			LayoutCounter = LayoutCounter + 1
			local Toggled = false
			local currentSelection = nil
			Callback = Callback or function() end

			local Dropdown = Instance.new("Frame")
			local Corner = Instance.new("UICorner")
			local Stroke = Instance.new("UIStroke")
			local TitleLabel = Instance.new("TextLabel")
			local DescLabel = Instance.new("TextLabel")
			local Holder = Instance.new("Frame")
			local HolderLayout = Instance.new("UIListLayout")
			local HolderStroke = Instance.new("UIStroke")
			local HolderCorner = Instance.new("UICorner")
			local Selected = Instance.new("Frame")
			local SelectedBtn = Instance.new("TextButton")
			local SelectedPad = Instance.new("UIPadding")
			local Arrow = Instance.new("ImageLabel")
			local ItemsFrame = Instance.new("Frame")
			local ItemsLayout = Instance.new("UIListLayout")
			local ItemsPad = Instance.new("UIPadding")

			Dropdown.AutomaticSize = Enum.AutomaticSize.Y
			Dropdown.BackgroundColor3 = T.Secondary
			Dropdown.BackgroundTransparency = T.ElementTransparency
			Dropdown.Name = "Dropdown"
			Dropdown.Parent = Items
			Dropdown.Size = UDim2.new(1, -4, 0, 50)
			Dropdown.ClipsDescendants = true
			Dropdown.LayoutOrder = LayoutCounter

			Corner.CornerRadius = UDim.new(0, 6)
			Corner.Parent = Dropdown

			Stroke.Color = T.Stroke
			Stroke.Parent = Dropdown

			TitleLabel.BackgroundTransparency = 1
			TitleLabel.Parent = Dropdown
			TitleLabel.Position = UDim2.new(0, 12, 0, 5)
			TitleLabel.Size = UDim2.new(1, -170, 0, 18)
			TitleLabel.FontFace = Font.new("rbxassetid://16658221428")
			TitleLabel.RichText = true
			TitleLabel.Text = "<b>" .. Title .. "</b>"
			TitleLabel.TextColor3 = T.MutedText
			TitleLabel.TextSize = 16
			TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

			DescLabel.BackgroundTransparency = 1
			DescLabel.Parent = Dropdown
			DescLabel.Position = UDim2.new(0, 12, 0, 24)
			DescLabel.Size = UDim2.new(1, -170, 0, 16)
			DescLabel.FontFace = Font.new("rbxassetid://16658221428")
			DescLabel.Text = Description
			DescLabel.TextColor3 = T.DimText
			DescLabel.TextSize = 13
			DescLabel.TextXAlignment = Enum.TextXAlignment.Left

			Holder.AutomaticSize = Enum.AutomaticSize.Y
			Holder.BackgroundColor3 = T.Tertiary
			Holder.Parent = Dropdown
			Holder.Position = UDim2.new(1, -155, 0, 10)
			Holder.Size = UDim2.new(0, 140, 0, 30)
			Holder.ZIndex = 20

			HolderLayout.Parent = Holder
			HolderLayout.SortOrder = Enum.SortOrder.LayoutOrder

			HolderStroke.Color = T.Stroke
			HolderStroke.Parent = Holder

			HolderCorner.CornerRadius = UDim.new(0, 6)
			HolderCorner.Parent = Holder

			Selected.BackgroundTransparency = 1
			Selected.Parent = Holder
			Selected.Size = UDim2.new(1, 0, 0, 30)
			Selected.LayoutOrder = 1
			Selected.ZIndex = 21

			SelectedBtn.BackgroundTransparency = 1
			SelectedBtn.Parent = Selected
			SelectedBtn.Size = UDim2.new(1, 0, 1, 0)
			SelectedBtn.FontFace = Font.new("rbxassetid://16658221428")
			SelectedBtn.Text = "None"
			SelectedBtn.TextColor3 = T.MutedText
			SelectedBtn.TextSize = 13
			SelectedBtn.TextXAlignment = Enum.TextXAlignment.Left
			SelectedBtn.ZIndex = 22

			SelectedPad.Parent = SelectedBtn
			SelectedPad.PaddingLeft = UDim.new(0, 10)
			SelectedPad.PaddingRight = UDim.new(0, 26)

			Arrow.AnchorPoint = Vector2.new(0, 0.5)
			Arrow.BackgroundTransparency = 1
			Arrow.Parent = Selected
			Arrow.Position = UDim2.new(1, -22, 0.5, 0)
			Arrow.Rotation = -90
			Arrow.Size = UDim2.new(0, 16, 0, 16)
			Arrow.Image = "rbxassetid://10734884598"
			Arrow.ImageColor3 = T.MutedText
			Arrow.ZIndex = 22

			ItemsFrame.Name = "DropdownItems"
			ItemsFrame.Parent = Holder
			ItemsFrame.BackgroundTransparency = 1
			ItemsFrame.Size = UDim2.new(1, 0, 0, 0)
			ItemsFrame.AutomaticSize = Enum.AutomaticSize.Y
			ItemsFrame.Visible = false
			ItemsFrame.ClipsDescendants = true
			ItemsFrame.LayoutOrder = 2
			ItemsFrame.ZIndex = 21

			ItemsLayout.Parent = ItemsFrame
			ItemsLayout.Padding = UDim.new(0, 2)

			ItemsPad.Parent = ItemsFrame
			ItemsPad.PaddingBottom = UDim.new(0, 6)
			ItemsPad.PaddingLeft = UDim.new(0, 4)
			ItemsPad.PaddingRight = UDim.new(0, 4)

			local function Close()
				Toggled = false
				ItemsFrame.Visible = false
				TweenService:Create(Arrow, TweenInfo.new(0.15), {Rotation = -90}):Play()
			end

			local function Open()
				Toggled = true
				ItemsFrame.Visible = true
				TweenService:Create(Arrow, TweenInfo.new(0.15), {Rotation = 0}):Play()
			end

			SelectedBtn.MouseButton1Click:Connect(function()
				if Toggled then Close() else Open() end
			end)

			UserInputService.InputBegan:Connect(function(input)
				if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and Toggled then
					local mouse = UserInputService:GetMouseLocation()
					local pos = Holder.AbsolutePosition
					local size = Holder.AbsoluteSize
					local inX = mouse.X >= pos.X and mouse.X <= pos.X + size.X
					local inY = mouse.Y >= pos.Y and mouse.Y <= pos.Y + size.Y + 40
					if not (inX and inY) then
						Close()
					end
				end
			end)

			local function selectOption(name)
				currentSelection = name
				SelectedBtn.Text = name
				SelectedBtn.TextColor3 = T.Text
				pcall(Callback, name)
				Close()
			end

			local function AddOptions(list)
				for _, name in ipairs(list) do
					local opt = Instance.new("Frame")
					local optCorner = Instance.new("UICorner")
					local optBtn = Instance.new("TextButton")
					local optPad = Instance.new("UIPadding")

					opt.Name = "OptionHolder"
					opt.Parent = ItemsFrame
					opt.BackgroundColor3 = T.Secondary
					opt.BackgroundTransparency = 1
					opt.Size = UDim2.new(1, 0, 0, 26)
					opt.ZIndex = 22

					optCorner.CornerRadius = UDim.new(0, 4)
					optCorner.Parent = opt

					optBtn.BackgroundTransparency = 1
					optBtn.Parent = opt
					optBtn.Size = UDim2.new(1, 0, 1, 0)
					optBtn.FontFace = Font.new("rbxassetid://16658221428")
					optBtn.Text = name
					optBtn.TextColor3 = T.Text
					optBtn.TextSize = 13
					optBtn.TextXAlignment = Enum.TextXAlignment.Left
					optBtn.ZIndex = 23

					optPad.Parent = optBtn
					optPad.PaddingLeft = UDim.new(0, 8)

					optBtn.MouseButton1Click:Connect(function()
						selectOption(name)
					end)

					optBtn.MouseEnter:Connect(function()
						opt.BackgroundTransparency = 0.55
					end)
					optBtn.MouseLeave:Connect(function()
						opt.BackgroundTransparency = 1
					end)
				end
			end

			AddOptions(Options)

			table.insert(getgenv().bPeMConfigState.registered, {
				type = "dropdown",
				key = Title,
				getter = function() return currentSelection end,
				setter = function(v) if v then selectOption(v) end end,
				reset = function()
					currentSelection = nil
					SelectedBtn.Text = "None"
					SelectedBtn.TextColor3 = T.MutedText
				end
			})

			local obj = {}
			function obj:Refresh(newList)
				for _, c in ipairs(ItemsFrame:GetChildren()) do
					if c:IsA("Frame") and c.Name == "OptionHolder" then
						c:Destroy()
					end
				end
				currentSelection = nil
				SelectedBtn.Text = "None"
				SelectedBtn.TextColor3 = T.MutedText
				Close()
				AddOptions(newList)
			end
			function obj:SetSelected(v)
				selectOption(v)
			end
			return obj
		end

		return Elements
	end

	return setmetatable(Tabs, {
		__index = function(_, k)
			return WindowAPI[k]
		end
	})
end

return Library
