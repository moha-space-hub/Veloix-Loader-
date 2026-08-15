local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

if game.CoreGui:FindFirstChild("Library") then
	game.CoreGui:FindFirstChild("Library"):Destroy()
end

local Library = {}
local LibraryElements = {}

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
	ElementTransparency = 0.12
}

function Library:CreateWindow(Game, Version, Theme)
	Theme = Theme or {}
	local T = {}
	for k, v in pairs(DefaultTheme) do
		T[k] = Theme[k] ~= nil and Theme[k] or v
	end

	LibraryElements = {
		Library_1 = Instance.new("ScreenGui"),
		Main_1 = Instance.new("Frame"),
		UICorner_1 = Instance.new("UICorner"),
		UIStroke_1 = Instance.new("UIStroke"),
		TopBar_1 = Instance.new("Frame"),
		Title_1 = Instance.new("TextLabel"),
		UIPadding_1 = Instance.new("UIPadding"),
		Description_1 = Instance.new("TextLabel"),
		UIPadding_2 = Instance.new("UIPadding"),
		NavigationHolder_1 = Instance.new("Frame"),
		UIStroke_2 = Instance.new("UIStroke"),
		UICorner_2 = Instance.new("UICorner"),
		NavLine_1 = Instance.new("Frame"),
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

	local MinSize = Vector2.new(500, 350)
	local MaxSize = Vector2.new(1200, 900)
	local Smoothness = 0.2

	local isResizing = false
	local inputStartPos
	local startSize

	local dragging = false
	local dragStart = nil
	local startPos = nil
	local lastGoalPos = nil
	local DRAG_SPEED = 11

	local Minimized = false
	local OriginalSize = UDim2.new(0, 560, 0, 370)
	local IsAnimating = false

	LibraryElements.Library_1.Name = "Library"
	LibraryElements.Library_1.Parent = game.CoreGui

	LibraryElements.Main_1.BackgroundColor3 = T.Background
	LibraryElements.Main_1.BackgroundTransparency = T.BackgroundTransparency
	LibraryElements.Main_1.Name = "Main"
	LibraryElements.Main_1.Parent = LibraryElements.Library_1
	LibraryElements.Main_1.Position = UDim2.new(0.5, -280, 0.5, -185)
	LibraryElements.Main_1.Size = UDim2.new(0, 560, 0, 370)
	LibraryElements.Main_1.Selectable = false

	LibraryElements.UICorner_1.Parent = LibraryElements.Main_1

	LibraryElements.UIStroke_1.Color = T.Stroke
	LibraryElements.UIStroke_1.Parent = LibraryElements.Main_1

	LibraryElements.TopBar_1.BackgroundTransparency = 1
	LibraryElements.TopBar_1.Name = "TopBar"
	LibraryElements.TopBar_1.Parent = LibraryElements.Main_1
	LibraryElements.TopBar_1.Size = UDim2.new(1, 0, 0, 60)
	LibraryElements.TopBar_1.Selectable = false

	LibraryElements.Title_1.BackgroundTransparency = 1
	LibraryElements.Title_1.Name = "Title"
	LibraryElements.Title_1.Parent = LibraryElements.TopBar_1
	LibraryElements.Title_1.Size = UDim2.new(1, -150, 0, 60)
	LibraryElements.Title_1.Selectable = false
	LibraryElements.Title_1.FontFace = Font.new("rbxassetid://16658221428", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
	LibraryElements.Title_1.RichText = true
	LibraryElements.Title_1.Text = "<b>bPeM</b>"
	LibraryElements.Title_1.TextColor3 = T.Text
	LibraryElements.Title_1.TextSize = 20
	LibraryElements.Title_1.TextTruncate = Enum.TextTruncate.SplitWord
	LibraryElements.Title_1.TextXAlignment = Enum.TextXAlignment.Left

	LibraryElements.UIPadding_1.Parent = LibraryElements.Title_1
	LibraryElements.UIPadding_1.PaddingBottom = UDim.new(0, 10)
	LibraryElements.UIPadding_1.PaddingLeft = UDim.new(0, 16)

	LibraryElements.Description_1.BackgroundTransparency = 1
	LibraryElements.Description_1.Name = "Description"
	LibraryElements.Description_1.Parent = LibraryElements.TopBar_1
	LibraryElements.Description_1.Size = UDim2.new(1, -150, 0, 60)
	LibraryElements.Description_1.Selectable = false
	LibraryElements.Description_1.FontFace = Font.new("rbxassetid://16658221428", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
	LibraryElements.Description_1.RichText = true
	LibraryElements.Description_1.Text = Game .. "<b> | " .. Version .. "</b>"
	LibraryElements.Description_1.TextColor3 = T.MutedText
	LibraryElements.Description_1.TextSize = 16
	LibraryElements.Description_1.TextTruncate = Enum.TextTruncate.SplitWord
	LibraryElements.Description_1.TextXAlignment = Enum.TextXAlignment.Left

	LibraryElements.UIPadding_2.Parent = LibraryElements.Description_1
	LibraryElements.UIPadding_2.PaddingBottom = UDim.new(0, 10)
	LibraryElements.UIPadding_2.PaddingLeft = UDim.new(0, 16)
	LibraryElements.UIPadding_2.PaddingTop = UDim.new(0, 40)

	LibraryElements.NavigationHolder_1.BackgroundColor3 = T.Secondary
	LibraryElements.NavigationHolder_1.BackgroundTransparency = T.SecondaryTransparency
	LibraryElements.NavigationHolder_1.Name = "NavigationHolder"
	LibraryElements.NavigationHolder_1.Parent = LibraryElements.TopBar_1
	LibraryElements.NavigationHolder_1.Position = UDim2.new(1, -76, 0.283, 0)
	LibraryElements.NavigationHolder_1.Size = UDim2.new(0, 60, 0, 25)
	LibraryElements.NavigationHolder_1.Selectable = false

	LibraryElements.UIStroke_2.Color = T.Stroke
	LibraryElements.UIStroke_2.Parent = LibraryElements.NavigationHolder_1

	LibraryElements.UICorner_2.Parent = LibraryElements.NavigationHolder_1

	LibraryElements.NavLine_1.AnchorPoint = Vector2.new(0.5, 0)
	LibraryElements.NavLine_1.BackgroundColor3 = T.Stroke
	LibraryElements.NavLine_1.BorderSizePixel = 0
	LibraryElements.NavLine_1.Name = "NavLine"
	LibraryElements.NavLine_1.Parent = LibraryElements.NavigationHolder_1
	LibraryElements.NavLine_1.Position = UDim2.new(0.5, 0, 0, 0)
	LibraryElements.NavLine_1.Size = UDim2.new(0, 1, 1, 0)
	LibraryElements.NavLine_1.Selectable = false

	LibraryElements.MinimizeButton_1.BackgroundTransparency = 1
	LibraryElements.MinimizeButton_1.Name = "MinimizeButton"
	LibraryElements.MinimizeButton_1.Parent = LibraryElements.NavigationHolder_1
	LibraryElements.MinimizeButton_1.Size = UDim2.new(0, 30, 0, 25)
	LibraryElements.MinimizeButton_1.Text = ""
	LibraryElements.MinimizeButton_1.TextSize = 14

	LibraryElements.MinimizeIcon_1.AnchorPoint = Vector2.new(0.5, 0.5)
	LibraryElements.MinimizeIcon_1.BackgroundTransparency = 1
	LibraryElements.MinimizeIcon_1.Name = "MinimizeIcon"
	LibraryElements.MinimizeIcon_1.Parent = LibraryElements.MinimizeButton_1
	LibraryElements.MinimizeIcon_1.Position = UDim2.new(0.5, 0, 0.5, 0)
	LibraryElements.MinimizeIcon_1.Size = UDim2.new(0, 18, 0, 18)
	LibraryElements.MinimizeIcon_1.Image = "rbxassetid://75550123309801"

	LibraryElements.CloseButton_1.BackgroundTransparency = 1
	LibraryElements.CloseButton_1.Name = "CloseButton"
	LibraryElements.CloseButton_1.Parent = LibraryElements.NavigationHolder_1
	LibraryElements.CloseButton_1.Position = UDim2.new(0, 30, 0, 0)
	LibraryElements.CloseButton_1.Size = UDim2.new(0, 30, 0, 25)
	LibraryElements.CloseButton_1.Text = ""
	LibraryElements.CloseButton_1.TextSize = 14

	LibraryElements.CloseIcon_1.AnchorPoint = Vector2.new(0.5, 0.5)
	LibraryElements.CloseIcon_1.BackgroundTransparency = 1
	LibraryElements.CloseIcon_1.Name = "CloseIcon"
	LibraryElements.CloseIcon_1.Parent = LibraryElements.CloseButton_1
	LibraryElements.CloseIcon_1.Position = UDim2.new(0.5, 0, 0.5, 0)
	LibraryElements.CloseIcon_1.Size = UDim2.new(0, 18, 0, 18)
	LibraryElements.CloseIcon_1.Image = "rbxassetid://101064721108854"

	LibraryElements.TabsHolder_1.BackgroundTransparency = 1
	LibraryElements.TabsHolder_1.Name = "TabsHolder"
	LibraryElements.TabsHolder_1.Parent = LibraryElements.Main_1
	LibraryElements.TabsHolder_1.Position = UDim2.new(0, 0, 0, 60)
	LibraryElements.TabsHolder_1.Size = UDim2.new(0, 210, 1, -60)
	LibraryElements.TabsHolder_1.Selectable = false

	LibraryElements.Tabs_1.BackgroundTransparency = 1
	LibraryElements.Tabs_1.Name = "Tabs"
	LibraryElements.Tabs_1.Parent = LibraryElements.TabsHolder_1
	LibraryElements.Tabs_1.Size = UDim2.new(1, 0, 1, 0)
	LibraryElements.Tabs_1.AutomaticCanvasSize = Enum.AutomaticSize.Y
	LibraryElements.Tabs_1.CanvasSize = UDim2.new(0, 0, 0, 0)
	LibraryElements.Tabs_1.ElasticBehavior = Enum.ElasticBehavior.Never
	LibraryElements.Tabs_1.ScrollBarImageTransparency = 1
	LibraryElements.Tabs_1.ScrollBarThickness = 1
	LibraryElements.Tabs_1.ScrollingDirection = Enum.ScrollingDirection.Y

	LibraryElements.UIListLayout_1.Padding = UDim.new(0, 8)
	LibraryElements.UIListLayout_1.Parent = LibraryElements.Tabs_1
	LibraryElements.UIListLayout_1.SortOrder = Enum.SortOrder.LayoutOrder

	LibraryElements.UIPadding_4.Parent = LibraryElements.Tabs_1
	LibraryElements.UIPadding_4.PaddingBottom = UDim.new(0, 10)
	LibraryElements.UIPadding_4.PaddingLeft = UDim.new(0, 16)
	LibraryElements.UIPadding_4.PaddingTop = UDim.new(0, 12)

	LibraryElements.ElementsHolder_1.BackgroundTransparency = 1
	LibraryElements.ElementsHolder_1.Name = "ElementsHolder"
	LibraryElements.ElementsHolder_1.Parent = LibraryElements.Main_1
	LibraryElements.ElementsHolder_1.Position = UDim2.new(0, 210, 0, 60)
	LibraryElements.ElementsHolder_1.Size = UDim2.new(1, -210, 1, -60)
	LibraryElements.ElementsHolder_1.Selectable = false
	LibraryElements.ElementsHolder_1.ClipsDescendants = true

	LibraryElements.DragUI_1.AnchorPoint = Vector2.new(0.5, 0)
	LibraryElements.DragUI_1.BackgroundTransparency = 1
	LibraryElements.DragUI_1.Name = "DragUI"
	LibraryElements.DragUI_1.Parent = LibraryElements.Main_1
	LibraryElements.DragUI_1.Position = UDim2.new(0.5, 0, 1, -5)
	LibraryElements.DragUI_1.Size = UDim2.new(0, 267, 0, 26)
	LibraryElements.DragUI_1.Image = "rbxassetid://85013248490002"

	LibraryElements.ResizeUI_1.BackgroundTransparency = 1
	LibraryElements.ResizeUI_1.Name = "ResizeUI"
	LibraryElements.ResizeUI_1.Parent = LibraryElements.Main_1
	LibraryElements.ResizeUI_1.Position = UDim2.new(1, -50, 1, -50)
	LibraryElements.ResizeUI_1.Size = UDim2.new(0, 80, 0, 80)
	LibraryElements.ResizeUI_1.Image = "rbxassetid://120997033468887"

	UIElements.OpenUIHolder_1.Active = true
	UIElements.OpenUIHolder_1.AnchorPoint = Vector2.new(0.5, 0.5)
	UIElements.OpenUIHolder_1.BackgroundColor3 = T.Background
	UIElements.OpenUIHolder_1.BackgroundTransparency = T.BackgroundTransparency
	UIElements.OpenUIHolder_1.Name = "OpenUIHolder"
	UIElements.OpenUIHolder_1.Parent = LibraryElements.Library_1
	UIElements.OpenUIHolder_1.Position = UDim2.new(0, -20, 0.5, 0)
	UIElements.OpenUIHolder_1.Size = UDim2.new(0, 25, 0, 25)
	UIElements.OpenUIHolder_1.Selectable = false

	UIElements.UICorner_31.Parent = UIElements.OpenUIHolder_1

	UIElements.UIStroke_24.Color = T.Stroke
	UIElements.UIStroke_24.Parent = UIElements.OpenUIHolder_1

	UIElements.OpenUI_1.BackgroundTransparency = 1
	UIElements.OpenUI_1.Name = "OpenUI"
	UIElements.OpenUI_1.Parent = UIElements.OpenUIHolder_1
	UIElements.OpenUI_1.Size = UDim2.new(0, 25, 0, 25)
	UIElements.OpenUI_1.Visible = true
	UIElements.OpenUI_1.Image = "rbxassetid://76392913095647"

	local function Lerp(a, b, m)
		return a + (b - a) * m
	end

	local function Update(dt)
		if not startPos then return end
		if dragging then
			local mouseLocation = UserInputService:GetMouseLocation()
			local delta = mouseLocation - dragStart
			lastGoalPos = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			)
		end
		if lastGoalPos then
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
			local connection
			connection = UserInputService.InputEnded:Connect(function(endInput)
				if endInput.UserInputType == Enum.UserInputType.MouseButton1 or endInput.UserInputType == Enum.UserInputType.Touch then
					dragging = false
					connection:Disconnect()
				end
			end)
		end
	end

	LibraryElements.Main_1.InputBegan:Connect(InitDrag)
	LibraryElements.DragUI_1.InputBegan:Connect(InitDrag)
	RunService.Heartbeat:Connect(Update)

	local function update(input)
		local delta = input.Position - inputStartPos
		local newWidth = math.clamp(startSize.X + delta.X, MinSize.X, MaxSize.X)
		local newHeight = math.clamp(startSize.Y + delta.Y, MinSize.Y, MaxSize.Y)
		TweenService:Create(LibraryElements.Main_1, TweenInfo.new(Smoothness, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
			Size = UDim2.new(0, newWidth, 0, newHeight)
		}):Play()
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
			update(input)
		end
	end)

	local function ExitSequence(isClosing)
		if IsAnimating then return end
		IsAnimating = true
		OriginalSize = LibraryElements.Main_1.Size
		for _, child in ipairs(LibraryElements.Main_1:GetChildren()) do
			if child:IsA("GuiObject") then
				child.Visible = false
			end
		end
		local ExitTween = TweenService:Create(LibraryElements.Main_1, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
			Size = UDim2.new(0, 5, 0, 0),
			Position = UDim2.new(0.5, 0, 1, 50)
		})
		ExitTween:Play()
		ExitTween.Completed:Wait()
		if isClosing then
			LibraryElements.Library_1:Destroy()
		else
			local OpenUIButton = TweenService:Create(UIElements.OpenUIHolder_1, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
				Position = UDim2.new(0, 30, 0.5, 0)
			})
			OpenUIButton:Play()
			Minimized = true
			LibraryElements.Main_1.Visible = false
		end
		IsAnimating = false
	end

	local function RestoreSequence()
		if not Minimized or IsAnimating then return end
		IsAnimating = true
		local TargetPos = UDim2.new(
			0.5, -OriginalSize.X.Offset / 2,
			0.5, -OriginalSize.Y.Offset / 2
		)
		startPos = TargetPos
		lastGoalPos = TargetPos
		LibraryElements.Main_1.Size = UDim2.new(0, 5, 0, 5)
		LibraryElements.Main_1.Position = UDim2.new(0.5, 0, 1, -10)
		LibraryElements.Main_1.Visible = true
		local CloseUIButton = TweenService:Create(UIElements.OpenUIHolder_1, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
			Position = UDim2.new(0, -20, 0.5, 0)
		})
		CloseUIButton:Play()
		local RestoreTween = TweenService:Create(LibraryElements.Main_1, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
			Size = OriginalSize,
			Position = TargetPos
		})
		RestoreTween:Play()
		RestoreTween.Completed:Wait()
		for _, child in ipairs(LibraryElements.Main_1:GetChildren()) do
			if child:IsA("GuiObject") then
				child.Visible = true
			end
		end
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
		local TabSectionElements = {
			TabsSection_1 = Instance.new("Frame"),
			Title_2 = Instance.new("TextLabel"),
			UIPadding_3 = Instance.new("UIPadding")
		}
		TabSectionElements.TabsSection_1.LayoutOrder = LayoutCounter
		TabSectionElements.TabsSection_1.BackgroundTransparency = 1
		TabSectionElements.TabsSection_1.Name = "TabsSection"
		TabSectionElements.TabsSection_1.Parent = LibraryElements.Tabs_1
		TabSectionElements.TabsSection_1.Size = UDim2.new(1, 0, 0, 20)
		TabSectionElements.TabsSection_1.Selectable = false
		TabSectionElements.Title_2.BackgroundTransparency = 1
		TabSectionElements.Title_2.Name = "Title"
		TabSectionElements.Title_2.Parent = TabSectionElements.TabsSection_1
		TabSectionElements.Title_2.Size = UDim2.new(1, 0, 1, 0)
		TabSectionElements.Title_2.Selectable = false
		TabSectionElements.Title_2.FontFace = Font.new("rbxassetid://16658221428", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
		TabSectionElements.Title_2.RichText = true
		TabSectionElements.Title_2.Text = "<b>" .. Title .. "</b>"
		TabSectionElements.Title_2.TextColor3 = T.Text
		TabSectionElements.Title_2.TextSize = 16
		TabSectionElements.Title_2.TextTruncate = Enum.TextTruncate.SplitWord
		TabSectionElements.Title_2.TextXAlignment = Enum.TextXAlignment.Left
		TabSectionElements.UIPadding_3.Parent = TabSectionElements.Title_2
	end

	function Tabs:CreateTab(Title, Description, IconId)
		LayoutCounter = LayoutCounter + 1
		local TabElements = {
			TabHolder_1 = Instance.new("Frame"),
			TabButton_1 = Instance.new("TextButton"),
			UICorner_3 = Instance.new("UICorner"),
			UIStroke_3 = Instance.new("UIStroke"),
			Icon_1 = Instance.new("ImageLabel"),
			Title_3 = Instance.new("TextLabel"),
			UIPadding_5 = Instance.new("UIPadding"),
			Description_2 = Instance.new("TextLabel"),
			UIPadding_6 = Instance.new("UIPadding"),
			TabIndicator_1 = Instance.new("Frame"),
			UICorner_4 = Instance.new("UICorner"),
			UIStroke_4 = Instance.new("UIStroke"),
			TabIndicatorDot_1 = Instance.new("Frame"),
			UICorner_5 = Instance.new("UICorner"),
			Elements_1 = Instance.new("Frame"),
			Items_1 = Instance.new("ScrollingFrame"),
			UIPadding_12 = Instance.new("UIPadding"),
			UIListLayout_2 = Instance.new("UIListLayout")
		}

		TabElements.TabHolder_1.LayoutOrder = LayoutCounter
		TabElements.TabHolder_1.BackgroundColor3 = T.Secondary
		TabElements.TabHolder_1.BackgroundTransparency = 1
		TabElements.TabHolder_1.Name = "TabHolder"
		TabElements.TabHolder_1.Parent = LibraryElements.Tabs_1
		TabElements.TabHolder_1.Size = UDim2.new(0, 190, 0, 45)
		TabElements.TabHolder_1.Selectable = false

		TabElements.TabButton_1.BackgroundTransparency = 1
		TabElements.TabButton_1.Name = "TabButton"
		TabElements.TabButton_1.Parent = TabElements.TabHolder_1
		TabElements.TabButton_1.Size = UDim2.new(1, 0, 1, 0)
		TabElements.TabButton_1.Text = ""
		TabElements.TabButton_1.TextSize = 14

		TabElements.UICorner_3.CornerRadius = UDim.new(0, 6)
		TabElements.UICorner_3.Parent = TabElements.TabHolder_1

		TabElements.UIStroke_3.Color = T.Stroke
		TabElements.UIStroke_3.Parent = TabElements.TabHolder_1

		if IconId and IconId ~= "" then
			TabElements.Icon_1.BackgroundTransparency = 1
			TabElements.Icon_1.Name = "Icon"
			TabElements.Icon_1.Parent = TabElements.TabHolder_1
			TabElements.Icon_1.Position = UDim2.new(0, 8, 0.5, -10)
			TabElements.Icon_1.Size = UDim2.new(0, 20, 0, 20)
			TabElements.Icon_1.Image = "rbxassetid://" .. tostring(IconId)
			TabElements.Icon_1.ImageColor3 = T.MutedText
		end

		TabElements.Title_3.BackgroundTransparency = 1
		TabElements.Title_3.Name = "Title"
		TabElements.Title_3.Parent = TabElements.TabHolder_1
		TabElements.Title_3.Size = UDim2.new(1, 0, 0, 20)
		TabElements.Title_3.Selectable = false
		TabElements.Title_3.FontFace = Font.new("rbxassetid://16658221428", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
		TabElements.Title_3.RichText = true
		TabElements.Title_3.Text = "<b>" .. Title .. "</b>"
		TabElements.Title_3.TextColor3 = T.MutedText
		TabElements.Title_3.TextSize = 16
		TabElements.Title_3.TextTruncate = Enum.TextTruncate.SplitWord
		TabElements.Title_3.TextXAlignment = Enum.TextXAlignment.Left

		TabElements.UIPadding_5.Parent = TabElements.Title_3
		TabElements.UIPadding_5.PaddingLeft = UDim.new(0, IconId and 34 or 10)
		TabElements.UIPadding_5.PaddingTop = UDim.new(0, 6)

		TabElements.Description_2.BackgroundTransparency = 1
		TabElements.Description_2.Name = "Description"
		TabElements.Description_2.Parent = TabElements.TabHolder_1
		TabElements.Description_2.Size = UDim2.new(1, 0, 0, 20)
		TabElements.Description_2.Selectable = false
		TabElements.Description_2.FontFace = Font.new("rbxassetid://16658221428", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
		TabElements.Description_2.RichText = true
		TabElements.Description_2.Text = Description
		TabElements.Description_2.TextColor3 = T.DimText
		TabElements.Description_2.TextSize = 14
		TabElements.Description_2.TextTruncate = Enum.TextTruncate.SplitWord
		TabElements.Description_2.TextXAlignment = Enum.TextXAlignment.Left

		TabElements.UIPadding_6.Parent = TabElements.Description_2
		TabElements.UIPadding_6.PaddingLeft = UDim.new(0, IconId and 34 or 10)
		TabElements.UIPadding_6.PaddingTop = UDim.new(0, 24)

		TabElements.TabIndicator_1.Name = "TabIndicator"
		TabElements.TabIndicator_1.BackgroundColor3 = T.Secondary
		TabElements.TabIndicator_1.Parent = TabElements.TabHolder_1
		TabElements.TabIndicator_1.Position = UDim2.new(0, 167, 0, 8)
		TabElements.TabIndicator_1.Size = UDim2.new(0, 14, 0, 14)
		TabElements.TabIndicator_1.Selectable = false

		TabElements.UICorner_4.CornerRadius = UDim.new(0, 6)
		TabElements.UICorner_4.Parent = TabElements.TabIndicator_1

		TabElements.UIStroke_4.Color = T.Stroke
		TabElements.UIStroke_4.Parent = TabElements.TabIndicator_1

		TabElements.TabIndicatorDot_1.AnchorPoint = Vector2.new(0.5, 0.5)
		TabElements.TabIndicatorDot_1.BackgroundColor3 = T.Secondary
		TabElements.TabIndicatorDot_1.Name = "TabIndicatorDot"
		TabElements.TabIndicatorDot_1.Parent = TabElements.TabIndicator_1
		TabElements.TabIndicatorDot_1.Position = UDim2.new(0.5, 0, 0.5, 0)
		TabElements.TabIndicatorDot_1.Size = UDim2.new(0, 8, 0, 8)
		TabElements.TabIndicatorDot_1.Selectable = false

		TabElements.UICorner_5.CornerRadius = UDim.new(0, 6)
		TabElements.UICorner_5.Parent = TabElements.TabIndicatorDot_1

		TabElements.Elements_1.BackgroundTransparency = 1
		TabElements.Elements_1.Name = "Elements"
		TabElements.Elements_1.Parent = LibraryElements.ElementsHolder_1
		TabElements.Elements_1.Size = UDim2.new(1, 0, 1, 0)
		TabElements.Elements_1.Selectable = false

		TabElements.Items_1.BackgroundTransparency = 1
		TabElements.Items_1.Name = "Items"
		TabElements.Items_1.Parent = TabElements.Elements_1
		TabElements.Items_1.Size = UDim2.new(1, 0, 1, 0)
		TabElements.Items_1.AutomaticCanvasSize = Enum.AutomaticSize.Y
		TabElements.Items_1.CanvasSize = UDim2.new(0, 0, 0, 0)
		TabElements.Items_1.ElasticBehavior = Enum.ElasticBehavior.Never
		TabElements.Items_1.ScrollBarImageTransparency = 1
		TabElements.Items_1.ScrollBarThickness = 1
		TabElements.Items_1.ScrollingDirection = Enum.ScrollingDirection.Y

		TabElements.UIPadding_12.Parent = TabElements.Items_1
		TabElements.UIPadding_12.PaddingBottom = UDim.new(0, 10)
		TabElements.UIPadding_12.PaddingLeft = UDim.new(0, 10)
		TabElements.UIPadding_12.PaddingTop = UDim.new(0, 10)

		TabElements.UIListLayout_2.Padding = UDim.new(0, 10)
		TabElements.UIListLayout_2.Parent = TabElements.Items_1
		TabElements.UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder

		table.insert(allTitles, TabElements.TabButton_1)
		table.insert(allIcons, TabElements.TabIndicator_1)
		table.insert(allTabs, TabElements.Elements_1)

		if first then
			first = false
			TabElements.Elements_1.Visible = true
			TabElements.Elements_1.Position = UDim2.new(0, 0, 0, 0)
			currentTab = TabElements.TabButton_1
			currentTitle = TabElements.Title_3
			currentDesc = TabElements.Description_2
			currentIcon = TabElements.TabIndicator_1
			currentHolder = TabElements.TabHolder_1
			currentTabIndex = 1
			TabElements.TabHolder_1.BackgroundTransparency = T.SecondaryTransparency
			TabElements.Title_3.TextColor3 = T.Text
			TabElements.Description_2.TextColor3 = T.MutedText
			TabElements.TabIndicator_1.BackgroundColor3 = T.Accent
			if IconId then TabElements.Icon_1.ImageColor3 = T.Text end
		else
			TabElements.Elements_1.Visible = false
			TabElements.TabHolder_1.BackgroundTransparency = 1
			TabElements.Title_3.TextColor3 = T.MutedText
			TabElements.Description_2.TextColor3 = T.DimText
			TabElements.TabIndicator_1.BackgroundColor3 = T.Secondary
		end

		TabElements.TabButton_1.MouseButton1Click:Connect(function()
			if currentTab == TabElements.TabButton_1 then return end
			local newIndex = table.find(allTitles, TabElements.TabButton_1)
			if not newIndex then return end
			local direction = (newIndex > currentTabIndex) and 1 or -1
			local currentFrame = allTabs[currentTabIndex]
			local newFrame = allTabs[newIndex]

			if currentTab and currentTitle and currentDesc and currentHolder and currentIcon then
				TweenService:Create(currentTitle, TweenInfo.new(0.2), {TextColor3 = T.MutedText}):Play()
				TweenService:Create(currentDesc, TweenInfo.new(0.2), {TextColor3 = T.DimText}):Play()
				TweenService:Create(currentIcon, TweenInfo.new(0.2), {BackgroundColor3 = T.Secondary}):Play()
				TweenService:Create(currentHolder, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
			end
			TweenService:Create(TabElements.Title_3, TweenInfo.new(0.2), {TextColor3 = T.Text}):Play()
			TweenService:Create(TabElements.Description_2, TweenInfo.new(0.2), {TextColor3 = T.MutedText}):Play()
			TweenService:Create(TabElements.TabIndicator_1, TweenInfo.new(0.2), {BackgroundColor3 = T.Accent}):Play()
			TweenService:Create(TabElements.TabHolder_1, TweenInfo.new(0.2), {BackgroundTransparency = T.SecondaryTransparency}):Play()
			if IconId then
				TweenService:Create(TabElements.Icon_1, TweenInfo.new(0.2), {ImageColor3 = T.Text}):Play()
			end

			newFrame.Position = UDim2.new(direction, 0, 0, 0)
			newFrame.Visible = true
			local tweenOut = TweenService:Create(currentFrame, TweenInfo.new(0.2), {Position = UDim2.new(-direction, 0, 0, 0)})
			local tweenIn = TweenService:Create(newFrame, TweenInfo.new(0.2), {Position = UDim2.new(0, 0, 0, 0)})
			tweenOut:Play()
			tweenIn:Play()
			tweenOut.Completed:Connect(function()
				currentFrame.Visible = false
			end)

			currentTab = TabElements.TabButton_1
			currentTitle = TabElements.Title_3
			currentDesc = TabElements.Description_2
			currentIcon = TabElements.TabIndicator_1
			currentHolder = TabElements.TabHolder_1
			currentTabIndex = newIndex
		end)

		local Elements = {}

		function Elements:CreateSection(Title)
			LayoutCounter = LayoutCounter + 1
			local SectionElements = {
				Section_1 = Instance.new("Frame"),
				SectionTitle_1 = Instance.new("TextLabel"),
				UIPadding_13 = Instance.new("UIPadding")
			}
			SectionElements.Section_1.BackgroundTransparency = 1
			SectionElements.Section_1.Name = "Section"
			SectionElements.Section_1.Parent = TabElements.Items_1
			SectionElements.Section_1.Size = UDim2.new(1, 0, 0, 20)
			SectionElements.Section_1.ClipsDescendants = true
			SectionElements.Section_1.Selectable = false
			SectionElements.Section_1.LayoutOrder = LayoutCounter
			SectionElements.SectionTitle_1.BackgroundTransparency = 1
			SectionElements.SectionTitle_1.Name = "SectionTitle"
			SectionElements.SectionTitle_1.Parent = SectionElements.Section_1
			SectionElements.SectionTitle_1.Size = UDim2.new(1, -16, 1, 0)
			SectionElements.SectionTitle_1.Selectable = false
			SectionElements.SectionTitle_1.FontFace = Font.new("rbxassetid://16658221428", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
			SectionElements.SectionTitle_1.RichText = true
			SectionElements.SectionTitle_1.Text = "<b>" .. Title .. "</b>"
			SectionElements.SectionTitle_1.TextColor3 = T.Text
			SectionElements.SectionTitle_1.TextSize = 16
			SectionElements.SectionTitle_1.TextTruncate = Enum.TextTruncate.SplitWord
			SectionElements.SectionTitle_1.TextXAlignment = Enum.TextXAlignment.Left
			SectionElements.UIPadding_13.Parent = SectionElements.SectionTitle_1
		end

		function Elements:CreateToggle(Title, Description, Default, Callback)
			LayoutCounter = LayoutCounter + 1
			local toggled = Default or false
			local debounce = false
			Callback = Callback or function() end

			local ToggleElements = {
				Toggle_1 = Instance.new("Frame"),
				UICorner_16 = Instance.new("UICorner"),
				UIStroke_12 = Instance.new("UIStroke"),
				ToggleTitle_1 = Instance.new("TextLabel"),
				UIPadding_23 = Instance.new("UIPadding"),
				ToggleDescription_1 = Instance.new("TextLabel"),
				UIPadding_24 = Instance.new("UIPadding"),
				TogglerHolder_1 = Instance.new("Frame"),
				UIStroke_11 = Instance.new("UIStroke"),
				UICorner_14 = Instance.new("UICorner"),
				TogglerIndicator_1 = Instance.new("Frame"),
				UICorner_15 = Instance.new("UICorner"),
				TogglerButton_1 = Instance.new("TextButton")
			}

			ToggleElements.Toggle_1.BackgroundColor3 = T.Secondary
			ToggleElements.Toggle_1.BackgroundTransparency = T.ElementTransparency
			ToggleElements.Toggle_1.Name = "Toggle"
			ToggleElements.Toggle_1.Parent = TabElements.Items_1
			ToggleElements.Toggle_1.Size = UDim2.new(1, -16, 0, 52)
			ToggleElements.Toggle_1.ClipsDescendants = true
			ToggleElements.Toggle_1.Selectable = false
			ToggleElements.Toggle_1.LayoutOrder = LayoutCounter

			ToggleElements.UICorner_16.CornerRadius = UDim.new(0, 6)
			ToggleElements.UICorner_16.Parent = ToggleElements.Toggle_1

			ToggleElements.UIStroke_12.Color = T.Stroke
			ToggleElements.UIStroke_12.Parent = ToggleElements.Toggle_1

			ToggleElements.ToggleTitle_1.BackgroundTransparency = 1
			ToggleElements.ToggleTitle_1.Name = "ToggleTitle"
			ToggleElements.ToggleTitle_1.Parent = ToggleElements.Toggle_1
			ToggleElements.ToggleTitle_1.Position = UDim2.new(0, 12, 0, 0)
			ToggleElements.ToggleTitle_1.Size = UDim2.new(1, -90, 1, 0)
			ToggleElements.ToggleTitle_1.Selectable = false
			ToggleElements.ToggleTitle_1.FontFace = Font.new("rbxassetid://16658221428", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
			ToggleElements.ToggleTitle_1.RichText = true
			ToggleElements.ToggleTitle_1.Text = "<b>" .. Title .. "</b>"
			ToggleElements.ToggleTitle_1.TextColor3 = T.MutedText
			ToggleElements.ToggleTitle_1.TextSize = 17
			ToggleElements.ToggleTitle_1.TextTruncate = Enum.TextTruncate.SplitWord
			ToggleElements.ToggleTitle_1.TextXAlignment = Enum.TextXAlignment.Left

			ToggleElements.UIPadding_23.Parent = ToggleElements.ToggleTitle_1
			ToggleElements.UIPadding_23.PaddingBottom = UDim.new(0, 18)

			ToggleElements.ToggleDescription_1.BackgroundTransparency = 1
			ToggleElements.ToggleDescription_1.Name = "ToggleDescription"
			ToggleElements.ToggleDescription_1.Parent = ToggleElements.Toggle_1
			ToggleElements.ToggleDescription_1.Position = UDim2.new(0, 12, 0, 0)
			ToggleElements.ToggleDescription_1.Size = UDim2.new(1, -90, 1, 0)
			ToggleElements.ToggleDescription_1.Selectable = false
			ToggleElements.ToggleDescription_1.FontFace = Font.new("rbxassetid://16658221428", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
			ToggleElements.ToggleDescription_1.RichText = true
			ToggleElements.ToggleDescription_1.Text = Description
			ToggleElements.ToggleDescription_1.TextColor3 = T.DimText
			ToggleElements.ToggleDescription_1.TextSize = 14
			ToggleElements.ToggleDescription_1.TextTruncate = Enum.TextTruncate.SplitWord
			ToggleElements.ToggleDescription_1.TextXAlignment = Enum.TextXAlignment.Left

			ToggleElements.UIPadding_24.Parent = ToggleElements.ToggleDescription_1
			ToggleElements.UIPadding_24.PaddingTop = UDim.new(0, 20)

			ToggleElements.TogglerHolder_1.AnchorPoint = Vector2.new(0, 0.5)
			ToggleElements.TogglerHolder_1.BackgroundColor3 = T.Tertiary
			ToggleElements.TogglerHolder_1.Name = "TogglerHolder"
			ToggleElements.TogglerHolder_1.Parent = ToggleElements.Toggle_1
			ToggleElements.TogglerHolder_1.Position = UDim2.new(1, -56, 0.5, 0)
			ToggleElements.TogglerHolder_1.Size = UDim2.new(0, 40, 0, 20)
			ToggleElements.TogglerHolder_1.Selectable = false

			ToggleElements.UIStroke_11.Color = T.Stroke
			ToggleElements.UIStroke_11.Parent = ToggleElements.TogglerHolder_1

			ToggleElements.UICorner_14.CornerRadius = UDim.new(0, 10)
			ToggleElements.UICorner_14.Parent = ToggleElements.TogglerHolder_1

			ToggleElements.TogglerIndicator_1.Name = "TogglerIndicator"
			ToggleElements.TogglerIndicator_1.BackgroundColor3 = T.Accent
			ToggleElements.TogglerIndicator_1.Parent = ToggleElements.TogglerHolder_1
			ToggleElements.TogglerIndicator_1.Position = UDim2.new(0, 2, 0, 1)
			ToggleElements.TogglerIndicator_1.Size = UDim2.new(0, 18, 0, 18)
			ToggleElements.TogglerIndicator_1.Selectable = false

			ToggleElements.UICorner_15.Parent = ToggleElements.TogglerIndicator_1

			ToggleElements.TogglerButton_1.BackgroundTransparency = 1
			ToggleElements.TogglerButton_1.Name = "TogglerButton"
			ToggleElements.TogglerButton_1.Parent = ToggleElements.TogglerHolder_1
			ToggleElements.TogglerButton_1.Size = UDim2.new(1, 0, 1, 0)
			ToggleElements.TogglerButton_1.Text = ""
			ToggleElements.TogglerButton_1.TextSize = 14

			local function setToggleValue(value, fireCallback)
				toggled = value
				if value then
					TweenService:Create(ToggleElements.TogglerIndicator_1, TweenInfo.new(0.2), {Position = UDim2.new(0, 20, 0, 1)}):Play()
					TweenService:Create(ToggleElements.TogglerIndicator_1, TweenInfo.new(0.2), {BackgroundColor3 = T.Background}):Play()
					TweenService:Create(ToggleElements.TogglerHolder_1, TweenInfo.new(0.2), {BackgroundColor3 = T.Accent}):Play()
				else
					TweenService:Create(ToggleElements.TogglerIndicator_1, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0, 1)}):Play()
					TweenService:Create(ToggleElements.TogglerIndicator_1, TweenInfo.new(0.2), {BackgroundColor3 = T.Accent}):Play()
					TweenService:Create(ToggleElements.TogglerHolder_1, TweenInfo.new(0.2), {BackgroundColor3 = T.Tertiary}):Play()
				end
				if fireCallback then pcall(Callback, value) end
			end

			if Default then
				task.defer(function()
					setToggleValue(true, true)
				end)
			end

			table.insert(getgenv().bPeMConfigState.registered, {
				type = "toggle",
				key = Title,
				getter = function() return toggled end,
				setter = function(val) setToggleValue(val, true) end,
				reset = function() setToggleValue(false, true) end,
			})

			ToggleElements.TogglerButton_1.MouseButton1Click:Connect(function()
				if not debounce then
					debounce = true
					setToggleValue(not toggled, true)
					debounce = false
				end
			end)

			local ToggleObject = {}
			function ToggleObject:Set(value)
				setToggleValue(value, true)
			end
			function ToggleObject:Get()
				return toggled
			end
			return ToggleObject
		end

		function Elements:CreateSlider(Title, Description, Min, Max, Default, Callback)
			LayoutCounter = LayoutCounter + 1
			Min = Min or 0
			Max = Max or 100
			Default = Default or Min
			Callback = Callback or function() end
			local value = Default

			local SliderElements = {
				Slider_1 = Instance.new("Frame"),
				UICorner_S = Instance.new("UICorner"),
				UIStroke_S = Instance.new("UIStroke"),
				SliderTitle_1 = Instance.new("TextLabel"),
				UIPadding_ST = Instance.new("UIPadding"),
				SliderDescription_1 = Instance.new("TextLabel"),
				UIPadding_SD = Instance.new("UIPadding"),
				ValueLabel_1 = Instance.new("TextLabel"),
				BarHolder_1 = Instance.new("Frame"),
				UICorner_BH = Instance.new("UICorner"),
				Fill_1 = Instance.new("Frame"),
				UICorner_F = Instance.new("UICorner"),
				Knob_1 = Instance.new("Frame"),
				UICorner_K = Instance.new("UICorner"),
				Hitbox_1 = Instance.new("TextButton")
			}

			SliderElements.Slider_1.BackgroundColor3 = T.Secondary
			SliderElements.Slider_1.BackgroundTransparency = T.ElementTransparency
			SliderElements.Slider_1.Name = "Slider"
			SliderElements.Slider_1.Parent = TabElements.Items_1
			SliderElements.Slider_1.Size = UDim2.new(1, -16, 0, 68)
			SliderElements.Slider_1.ClipsDescendants = true
			SliderElements.Slider_1.LayoutOrder = LayoutCounter

			SliderElements.UICorner_S.CornerRadius = UDim.new(0, 6)
			SliderElements.UICorner_S.Parent = SliderElements.Slider_1

			SliderElements.UIStroke_S.Color = T.Stroke
			SliderElements.UIStroke_S.Parent = SliderElements.Slider_1

			SliderElements.SliderTitle_1.BackgroundTransparency = 1
			SliderElements.SliderTitle_1.Parent = SliderElements.Slider_1
			SliderElements.SliderTitle_1.Position = UDim2.new(0, 12, 0, 4)
			SliderElements.SliderTitle_1.Size = UDim2.new(1, -80, 0, 20)
			SliderElements.SliderTitle_1.FontFace = Font.new("rbxassetid://16658221428")
			SliderElements.SliderTitle_1.RichText = true
			SliderElements.SliderTitle_1.Text = "<b>" .. Title .. "</b>"
			SliderElements.SliderTitle_1.TextColor3 = T.MutedText
			SliderElements.SliderTitle_1.TextSize = 17
			SliderElements.SliderTitle_1.TextXAlignment = Enum.TextXAlignment.Left

			SliderElements.ValueLabel_1.BackgroundTransparency = 1
			SliderElements.ValueLabel_1.Parent = SliderElements.Slider_1
			SliderElements.ValueLabel_1.Position = UDim2.new(1, -70, 0, 4)
			SliderElements.ValueLabel_1.Size = UDim2.new(0, 58, 0, 20)
			SliderElements.ValueLabel_1.FontFace = Font.new("rbxassetid://16658221428")
			SliderElements.ValueLabel_1.Text = tostring(Default)
			SliderElements.ValueLabel_1.TextColor3 = T.Text
			SliderElements.ValueLabel_1.TextSize = 16
			SliderElements.ValueLabel_1.TextXAlignment = Enum.TextXAlignment.Right

			SliderElements.SliderDescription_1.BackgroundTransparency = 1
			SliderElements.SliderDescription_1.Parent = SliderElements.Slider_1
			SliderElements.SliderDescription_1.Position = UDim2.new(0, 12, 0, 22)
			SliderElements.SliderDescription_1.Size = UDim2.new(1, -24, 0, 16)
			SliderElements.SliderDescription_1.FontFace = Font.new("rbxassetid://16658221428")
			SliderElements.SliderDescription_1.Text = Description
			SliderElements.SliderDescription_1.TextColor3 = T.DimText
			SliderElements.SliderDescription_1.TextSize = 13
			SliderElements.SliderDescription_1.TextXAlignment = Enum.TextXAlignment.Left

			SliderElements.BarHolder_1.BackgroundColor3 = T.Tertiary
			SliderElements.BarHolder_1.Parent = SliderElements.Slider_1
			SliderElements.BarHolder_1.Position = UDim2.new(0, 12, 0, 46)
			SliderElements.BarHolder_1.Size = UDim2.new(1, -24, 0, 8)

			SliderElements.UICorner_BH.CornerRadius = UDim.new(0, 4)
			SliderElements.UICorner_BH.Parent = SliderElements.BarHolder_1

			SliderElements.Fill_1.BackgroundColor3 = T.Accent
			SliderElements.Fill_1.Parent = SliderElements.BarHolder_1
			SliderElements.Fill_1.Size = UDim2.new((Default - Min) / (Max - Min), 0, 1, 0)

			SliderElements.UICorner_F.CornerRadius = UDim.new(0, 4)
			SliderElements.UICorner_F.Parent = SliderElements.Fill_1

			SliderElements.Knob_1.AnchorPoint = Vector2.new(0.5, 0.5)
			SliderElements.Knob_1.BackgroundColor3 = T.Accent
			SliderElements.Knob_1.Parent = SliderElements.BarHolder_1
			SliderElements.Knob_1.Position = UDim2.new((Default - Min) / (Max - Min), 0, 0.5, 0)
			SliderElements.Knob_1.Size = UDim2.new(0, 14, 0, 14)

			SliderElements.UICorner_K.CornerRadius = UDim.new(1, 0)
			SliderElements.UICorner_K.Parent = SliderElements.Knob_1

			SliderElements.Hitbox_1.BackgroundTransparency = 1
			SliderElements.Hitbox_1.Parent = SliderElements.BarHolder_1
			SliderElements.Hitbox_1.Size = UDim2.new(1, 0, 1, 0)
			SliderElements.Hitbox_1.Text = ""

			local sliding = false

			local function updateSlider(input)
				local absPos = SliderElements.BarHolder_1.AbsolutePosition.X
				local absSize = SliderElements.BarHolder_1.AbsoluteSize.X
				local relative = math.clamp((input.Position.X - absPos) / absSize, 0, 1)
				value = math.floor(Min + (Max - Min) * relative + 0.5)
				SliderElements.Fill_1.Size = UDim2.new(relative, 0, 1, 0)
				SliderElements.Knob_1.Position = UDim2.new(relative, 0, 0.5, 0)
				SliderElements.ValueLabel_1.Text = tostring(value)
				pcall(Callback, value)
			end

			SliderElements.Hitbox_1.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					sliding = true
					updateSlider(input)
				end
			end)

			UserInputService.InputChanged:Connect(function(input)
				if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
					updateSlider(input)
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
				setter = function(val)
					value = math.clamp(val, Min, Max)
					local relative = (value - Min) / (Max - Min)
					SliderElements.Fill_1.Size = UDim2.new(relative, 0, 1, 0)
					SliderElements.Knob_1.Position = UDim2.new(relative, 0, 0.5, 0)
					SliderElements.ValueLabel_1.Text = tostring(value)
					pcall(Callback, value)
				end,
				reset = function()
					value = Default
					local relative = (Default - Min) / (Max - Min)
					SliderElements.Fill_1.Size = UDim2.new(relative, 0, 1, 0)
					SliderElements.Knob_1.Position = UDim2.new(relative, 0, 0.5, 0)
					SliderElements.ValueLabel_1.Text = tostring(Default)
					pcall(Callback, Default)
				end,
			})

			local SliderObject = {}
			function SliderObject:Set(val)
				value = math.clamp(val, Min, Max)
				local relative = (value - Min) / (Max - Min)
				SliderElements.Fill_1.Size = UDim2.new(relative, 0, 1, 0)
				SliderElements.Knob_1.Position = UDim2.new(relative, 0, 0.5, 0)
				SliderElements.ValueLabel_1.Text = tostring(value)
				pcall(Callback, value)
			end
			function SliderObject:Get()
				return value
			end
			return SliderObject
		end

		function Elements:CreateKeybind(Title, Description, Default, Callback)
			LayoutCounter = LayoutCounter + 1
			local currentKey = Default or Enum.KeyCode.Unknown
			local listening = false
			Callback = Callback or function() end

			local KeybindElements = {
				Keybind_1 = Instance.new("Frame"),
				UICorner_KB = Instance.new("UICorner"),
				UIStroke_KB = Instance.new("UIStroke"),
				KeybindTitle_1 = Instance.new("TextLabel"),
				UIPadding_KT = Instance.new("UIPadding"),
				KeybindDescription_1 = Instance.new("TextLabel"),
				UIPadding_KD = Instance.new("UIPadding"),
				KeyHolder_1 = Instance.new("Frame"),
				UICorner_KH = Instance.new("UICorner"),
				UIStroke_KH = Instance.new("UIStroke"),
				KeyButton_1 = Instance.new("TextButton")
			}

			KeybindElements.Keybind_1.BackgroundColor3 = T.Secondary
			KeybindElements.Keybind_1.BackgroundTransparency = T.ElementTransparency
			KeybindElements.Keybind_1.Name = "Keybind"
			KeybindElements.Keybind_1.Parent = TabElements.Items_1
			KeybindElements.Keybind_1.Size = UDim2.new(1, -16, 0, 52)
			KeybindElements.Keybind_1.ClipsDescendants = true
			KeybindElements.Keybind_1.LayoutOrder = LayoutCounter

			KeybindElements.UICorner_KB.CornerRadius = UDim.new(0, 6)
			KeybindElements.UICorner_KB.Parent = KeybindElements.Keybind_1

			KeybindElements.UIStroke_KB.Color = T.Stroke
			KeybindElements.UIStroke_KB.Parent = KeybindElements.Keybind_1

			KeybindElements.KeybindTitle_1.BackgroundTransparency = 1
			KeybindElements.KeybindTitle_1.Parent = KeybindElements.Keybind_1
			KeybindElements.KeybindTitle_1.Position = UDim2.new(0, 12, 0, 0)
			KeybindElements.KeybindTitle_1.Size = UDim2.new(1, -110, 1, 0)
			KeybindElements.KeybindTitle_1.FontFace = Font.new("rbxassetid://16658221428")
			KeybindElements.KeybindTitle_1.RichText = true
			KeybindElements.KeybindTitle_1.Text = "<b>" .. Title .. "</b>"
			KeybindElements.KeybindTitle_1.TextColor3 = T.MutedText
			KeybindElements.KeybindTitle_1.TextSize = 17
			KeybindElements.KeybindTitle_1.TextXAlignment = Enum.TextXAlignment.Left

			KeybindElements.UIPadding_KT.Parent = KeybindElements.KeybindTitle_1
			KeybindElements.UIPadding_KT.PaddingBottom = UDim.new(0, 18)

			KeybindElements.KeybindDescription_1.BackgroundTransparency = 1
			KeybindElements.KeybindDescription_1.Parent = KeybindElements.Keybind_1
			KeybindElements.KeybindDescription_1.Position = UDim2.new(0, 12, 0, 0)
			KeybindElements.KeybindDescription_1.Size = UDim2.new(1, -110, 1, 0)
			KeybindElements.KeybindDescription_1.FontFace = Font.new("rbxassetid://16658221428")
			KeybindElements.KeybindDescription_1.Text = Description
			KeybindElements.KeybindDescription_1.TextColor3 = T.DimText
			KeybindElements.KeybindDescription_1.TextSize = 14
			KeybindElements.KeybindDescription_1.TextXAlignment = Enum.TextXAlignment.Left

			KeybindElements.UIPadding_KD.Parent = KeybindElements.KeybindDescription_1
			KeybindElements.UIPadding_KD.PaddingTop = UDim.new(0, 20)

			KeybindElements.KeyHolder_1.AnchorPoint = Vector2.new(0, 0.5)
			KeybindElements.KeyHolder_1.BackgroundColor3 = T.Tertiary
			KeybindElements.KeyHolder_1.Parent = KeybindElements.Keybind_1
			KeybindElements.KeyHolder_1.Position = UDim2.new(1, -90, 0.5, 0)
			KeybindElements.KeyHolder_1.Size = UDim2.new(0, 78, 0, 26)

			KeybindElements.UICorner_KH.CornerRadius = UDim.new(0, 6)
			KeybindElements.UICorner_KH.Parent = KeybindElements.KeyHolder_1

			KeybindElements.UIStroke_KH.Color = T.Stroke
			KeybindElements.UIStroke_KH.Parent = KeybindElements.KeyHolder_1

			KeybindElements.KeyButton_1.BackgroundTransparency = 1
			KeybindElements.KeyButton_1.Parent = KeybindElements.KeyHolder_1
			KeybindElements.KeyButton_1.Size = UDim2.new(1, 0, 1, 0)
			KeybindElements.KeyButton_1.FontFace = Font.new("rbxassetid://16658221428")
			KeybindElements.KeyButton_1.Text = currentKey.Name
			KeybindElements.KeyButton_1.TextColor3 = T.Text
			KeybindElements.KeyButton_1.TextSize = 14

			KeybindElements.KeyButton_1.MouseButton1Click:Connect(function()
				if listening then return end
				listening = true
				KeybindElements.KeyButton_1.Text = "..."
				local connection
				connection = UserInputService.InputBegan:Connect(function(input, gp)
					if gp then return end
					if input.UserInputType == Enum.UserInputType.Keyboard then
						currentKey = input.KeyCode
						KeybindElements.KeyButton_1.Text = currentKey.Name
						listening = false
						connection:Disconnect()
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
				setter = function(val)
					currentKey = val
					KeybindElements.KeyButton_1.Text = currentKey.Name
				end,
				reset = function()
					currentKey = Default or Enum.KeyCode.Unknown
					KeybindElements.KeyButton_1.Text = currentKey.Name
				end,
			})

			local KeybindObject = {}
			function KeybindObject:Set(key)
				currentKey = key
				KeybindElements.KeyButton_1.Text = currentKey.Name
			end
			function KeybindObject:Get()
				return currentKey
			end
			return KeybindObject
		end

		return Elements
	end

	return Tabs
end

return Library
