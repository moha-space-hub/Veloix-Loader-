--[[
    WindUI Improved - Single File
    Modern Roblox UI Library
    Features: Better Spacing, Modern Hover, Redesigned Toggle, Discord Live Card, Clean Design
]]

local WindUI = {
    Version = "2.0.0-Improved",
    Window = nil,
    Theme = nil,
    Themes = {},
    UIScale = 1,
    Transparent = false,
    TransparencyValue = 0.15,
}

local cloneref = cloneref or clonereference or function(i) return i end

local HttpService = cloneref(game:GetService("HttpService"))
local Players = cloneref(game:GetService("Players"))
local TweenService = cloneref(game:GetService("TweenService"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local RunService = cloneref(game:GetService("RunService"))
local CoreGui = cloneref(game:GetService("CoreGui"))
local TextService = cloneref(game:GetService("TextService"))

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local Request = http_request or (syn and syn.request) or request or http.request

-- ==================== UTILITIES ====================

local function GenerateGUID()
    return HttpService:GenerateGUID(false)
end

local function SafeCallback(fn, ...)
    if not fn then return end
    local ok, err = pcall(fn, ...)
    if not ok then
        warn("[WindUI] Callback error:", err)
    end
end

local function Tween(obj, time, props, style, direction)
    style = style or Enum.EasingStyle.Quint
    direction = direction or Enum.EasingDirection.Out
    local tw = TweenService:Create(obj, TweenInfo.new(time, style, direction), props)
    tw:Play()
    return tw
end

local function New(class, props, children)
    local obj = Instance.new(class)
    for k, v in pairs(props or {}) do
        if k ~= "Parent" then
            obj[k] = v
        end
    end
    if children then
        for _, child in ipairs(children) do
            if typeof(child) == "Instance" then
                child.Parent = obj
            end
        end
    end
    if props and props.Parent then
        obj.Parent = props.Parent
    end
    return obj
end

local function Corner(radius)
    return New("UICorner", { CornerRadius = UDim.new(0, radius or 8) })
end

local function Padding(t, r, b, l)
    return New("UIPadding", {
        PaddingTop = UDim.new(0, t or 0),
        PaddingRight = UDim.new(0, r or t or 0),
        PaddingBottom = UDim.new(0, b or t or 0),
        PaddingLeft = UDim.new(0, l or r or t or 0),
    })
end

local function ListLayout(dir, pad, hAlign, vAlign)
    return New("UIListLayout", {
        FillDirection = dir or Enum.FillDirection.Vertical,
        Padding = UDim.new(0, pad or 6),
        HorizontalAlignment = hAlign or Enum.HorizontalAlignment.Left,
        VerticalAlignment = vAlign or Enum.VerticalAlignment.Top,
        SortOrder = Enum.SortOrder.LayoutOrder,
    })
end

local function Stroke(color, thickness, transparency)
    return New("UIStroke", {
        Color = color or Color3.fromRGB(255, 255, 255),
        Thickness = thickness or 1,
        Transparency = transparency or 0.9,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    })
end

-- ==================== THEME ====================

local Themes = {
    Dark = {
        Name = "Dark",
        Background = Color3.fromRGB(16, 16, 16),
        Accent = Color3.fromRGB(24, 24, 27),
        Element = Color3.fromRGB(32, 32, 36),
        ElementHover = Color3.fromRGB(42, 42, 48),
        Text = Color3.fromRGB(255, 255, 255),
        TextDim = Color3.fromRGB(160, 160, 170),
        Outline = Color3.fromRGB(255, 255, 255),
        Toggle = Color3.fromRGB(51, 199, 89),
        ToggleOff = Color3.fromRGB(60, 60, 68),
        Button = Color3.fromRGB(0, 145, 255),
        ButtonHover = Color3.fromRGB(30, 160, 255),
        Success = Color3.fromRGB(51, 199, 89),
        Danger = Color3.fromRGB(255, 69, 58),
        Slider = Color3.fromRGB(0, 145, 255),
        Online = Color3.fromRGB(51, 199, 89),
        Discord = Color3.fromRGB(88, 101, 242),
    },
    Light = {
        Name = "Light",
        Background = Color3.fromRGB(245, 245, 247),
        Accent = Color3.fromRGB(255, 255, 255),
        Element = Color3.fromRGB(235, 235, 240),
        ElementHover = Color3.fromRGB(220, 220, 230),
        Text = Color3.fromRGB(20, 20, 25),
        TextDim = Color3.fromRGB(100, 100, 110),
        Outline = Color3.fromRGB(0, 0, 0),
        Toggle = Color3.fromRGB(51, 199, 89),
        ToggleOff = Color3.fromRGB(180, 180, 190),
        Button = Color3.fromRGB(0, 122, 255),
        ButtonHover = Color3.fromRGB(30, 140, 255),
        Success = Color3.fromRGB(52, 199, 89),
        Danger = Color3.fromRGB(255, 59, 48),
        Slider = Color3.fromRGB(0, 122, 255),
        Online = Color3.fromRGB(52, 199, 89),
        Discord = Color3.fromRGB(88, 101, 242),
    },
}

WindUI.Themes = Themes
WindUI.Theme = Themes.Dark

local function GetTheme(key)
    return WindUI.Theme[key] or Themes.Dark[key]
end

-- ==================== ICONS (simple lucide-style text fallback) ====================

local function CreateIcon(name, size, color)
    -- Simple text-based icon placeholder (you can replace with real image icons later)
    local icon = New("TextLabel", {
        Size = UDim2.new(0, size or 18, 0, size or 18),
        BackgroundTransparency = 1,
        Text = "",
        TextColor3 = color or GetTheme("Text"),
        TextSize = size or 18,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Center,
        TextYAlignment = Enum.TextYAlignment.Center,
    })
    return icon
end

-- ==================== CORE CREATOR ====================

local Creator = {}
Creator.Signals = {}

function Creator.AddSignal(signal, fn)
    local conn = signal:Connect(fn)
    table.insert(Creator.Signals, conn)
    return conn
end

function Creator.DisconnectAll()
    for _, conn in ipairs(Creator.Signals) do
        pcall(function() conn:Disconnect() end)
    end
    Creator.Signals = {}
end

-- ==================== HOVER SYSTEM ====================

local function AddHover(frame, onEnter, onLeave)
    local hovering = false
    Creator.AddSignal(frame.MouseEnter, function()
        if hovering then return end
        hovering = true
        if onEnter then onEnter() end
    end)
    Creator.AddSignal(frame.MouseLeave, function()
        if not hovering then return end
        hovering = false
        if onLeave then onLeave() end
    end)
end

local function AddElementHover(mainFrame, bgFrame)
    local originalColor = bgFrame.BackgroundColor3
    local hoverColor = GetTheme("ElementHover")

    AddHover(mainFrame, function()
        Tween(bgFrame, 0.18, { BackgroundColor3 = hoverColor })
        if mainFrame:FindFirstChild("HoverScale") then
            Tween(mainFrame.HoverScale, 0.18, { Scale = 1.01 })
        end
    end, function()
        Tween(bgFrame, 0.18, { BackgroundColor3 = originalColor })
        if mainFrame:FindFirstChild("HoverScale") then
            Tween(mainFrame.HoverScale, 0.18, { Scale = 1 })
        end
    end)
end

-- ==================== ELEMENT BASE ====================

local function CreateElementBase(config)
    local parent = config.Parent
    local title = config.Title or ""
    local desc = config.Desc
    local layoutOrder = config.LayoutOrder or 0

    local container = New("Frame", {
        Name = "Element",
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Parent = parent,
        LayoutOrder = layoutOrder,
    })

    local bg = New("Frame", {
        Name = "Background",
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = GetTheme("Element"),
        Parent = container,
    }, {
        Corner(10),
        Padding(12, 14, 12, 14),
    })

    local scale = New("UIScale", { Name = "HoverScale", Scale = 1, Parent = container })

    local content = New("Frame", {
        Name = "Content",
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Parent = bg,
    }, {
        ListLayout(Enum.FillDirection.Vertical, 4),
    })

    local titleLabel = New("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, 0, 0, 18),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = GetTheme("Text"),
        TextSize = 14,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = content,
    })

    local descLabel
    if desc and desc ~= "" then
        descLabel = New("TextLabel", {
            Name = "Desc",
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            Text = desc,
            TextColor3 = GetTheme("TextDim"),
            TextSize = 12,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            Parent = content,
        })
    end

    -- Right side container for controls (toggle, button etc)
    local right = New("Frame", {
        Name = "Right",
        Size = UDim2.new(0, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.XY,
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, 0, 0.5, 0),
        Parent = bg,
    })

    return {
        Container = container,
        Background = bg,
        Content = content,
        Title = titleLabel,
        Desc = descLabel,
        Right = right,
        Scale = scale,
    }
end

-- ==================== SPACE ====================

local function CreateSpace(config)
    config = config or {}
    local size = config.Size or config or 12
    if typeof(size) == "table" then size = size.Size or 12 end

    local space = New("Frame", {
        Name = "Space",
        Size = UDim2.new(1, 0, 0, size),
        BackgroundTransparency = 1,
        Parent = config.Parent,
        LayoutOrder = config.LayoutOrder or 0,
    })

    return {
        __type = "Space",
        ElementFrame = space,
        SetSize = function(_, newSize)
            space.Size = UDim2.new(1, 0, 0, newSize)
        end,
    }
end

-- ==================== TOGGLE (Improved) ====================

local function CreateToggle(config)
    config = config or {}
    local value = config.Value
    if value == nil then value = false end

    local element = CreateElementBase(config)
    AddElementHover(element.Container, element.Background)

    -- Adjust title width so it doesn't overlap toggle
    element.Title.Size = UDim2.new(1, -60, 0, 18)
    if element.Desc then
        element.Desc.Size = UDim2.new(1, -60, 0, 0)
    end

    local toggleWidth = 46
    local toggleHeight = 26
    local knobSize = 20

    local toggleFrame = New("Frame", {
        Name = "Toggle",
        Size = UDim2.new(0, toggleWidth, 0, toggleHeight),
        BackgroundColor3 = value and GetTheme("Toggle") or GetTheme("ToggleOff"),
        Parent = element.Right,
    }, {
        Corner(999),
    })

    local knob = New("Frame", {
        Name = "Knob",
        Size = UDim2.new(0, knobSize, 0, knobSize),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        Position = value and UDim2.new(1, -knobSize - 3, 0.5, 0) or UDim2.new(0, 3, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        Parent = toggleFrame,
    }, {
        Corner(999),
        New("UIStroke", {
            Color = Color3.fromRGB(0, 0, 0),
            Thickness = 0.5,
            Transparency = 0.85,
        }),
    })

    -- Hitbox
    local hitbox = New("TextButton", {
        Name = "Hitbox",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        Parent = toggleFrame,
        ZIndex = 5,
    })

    local toggled = value
    local canCallback = not config.Locked

    local function Set(v, fireCallback)
        if not canCallback and fireCallback then return end
        toggled = v
        local targetPos = v and UDim2.new(1, -knobSize - 3, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
        local targetColor = v and GetTheme("Toggle") or GetTheme("ToggleOff")

        Tween(knob, 0.25, { Position = targetPos }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        Tween(toggleFrame, 0.25, { BackgroundColor3 = targetColor })

        if fireCallback ~= false then
            SafeCallback(config.Callback, toggled)
        end
    end

    Creator.AddSignal(hitbox.MouseButton1Click, function()
        Set(not toggled, true)
    end)

    -- Hover on toggle itself
    AddHover(toggleFrame, function()
        Tween(toggleFrame, 0.15, { BackgroundColor3 = toggled and GetTheme("Toggle"):Lerp(Color3.new(1,1,1), 0.1) or GetTheme("ToggleOff"):Lerp(Color3.new(1,1,1), 0.08) })
    end, function()
        Tween(toggleFrame, 0.15, { BackgroundColor3 = toggled and GetTheme("Toggle") or GetTheme("ToggleOff") })
    end)

    local api = {
        __type = "Toggle",
        Value = toggled,
        ElementFrame = element.Container,
        Set = function(_, v, fire)
            Set(v, fire ~= false)
            api.Value = toggled
        end,
        Get = function() return toggled end,
        Lock = function()
            canCallback = false
            Tween(toggleFrame, 0.2, { BackgroundTransparency = 0.5 })
        end,
        Unlock = function()
            canCallback = true
            Tween(toggleFrame, 0.2, { BackgroundTransparency = 0 })
        end,
    }

    return api
end

-- ==================== BUTTON ====================

local function CreateButton(config)
    config = config or {}
    local variant = config.Variant or "Primary" -- Primary, Secondary, Success, Danger

    local colors = {
        Primary = GetTheme("Button"),
        Secondary = GetTheme("Element"),
        Success = GetTheme("Success"),
        Danger = GetTheme("Danger"),
    }
    local bgColor = colors[variant] or colors.Primary

    local btn = New("TextButton", {
        Name = "Button",
        Size = UDim2.new(1, 0, 0, 36),
        BackgroundColor3 = bgColor,
        Text = "",
        AutoButtonColor = false,
        Parent = config.Parent,
        LayoutOrder = config.LayoutOrder or 0,
    }, {
        Corner(10),
        Padding(0, 14, 0, 14),
    })

    local label = New("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = config.Title or "Button",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 14,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Center,
        Parent = btn,
    })

    local scale = New("UIScale", { Scale = 1, Parent = btn })

    AddHover(btn, function()
        Tween(btn, 0.15, { BackgroundColor3 = bgColor:Lerp(Color3.new(1,1,1), 0.12) })
        Tween(scale, 0.15, { Scale = 1.02 })
    end, function()
        Tween(btn, 0.15, { BackgroundColor3 = bgColor })
        Tween(scale, 0.15, { Scale = 1 })
    end)

    Creator.AddSignal(btn.MouseButton1Click, function()
        Tween(scale, 0.08, { Scale = 0.97 })
        task.delay(0.08, function()
            Tween(scale, 0.12, { Scale = 1 })
        end)
        SafeCallback(config.Callback)
    end)

    return {
        __type = "Button",
        ElementFrame = btn,
        SetTitle = function(_, text)
            label.Text = text
        end,
    }
end

-- ==================== SECTION ====================

local function CreateSection(config)
    config = config or {}

    local section = New("Frame", {
        Name = "Section",
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Parent = config.Parent,
        LayoutOrder = config.LayoutOrder or 0,
    }, {
        ListLayout(Enum.FillDirection.Vertical, 8),
    })

    local header = New("Frame", {
        Name = "Header",
        Size = UDim2.new(1, 0, 0, 28),
        BackgroundTransparency = 1,
        Parent = section,
    })

    local title = New("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = config.Title or "Section",
        TextColor3 = GetTheme("Text"),
        TextSize = 15,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = header,
    })

    local content = New("Frame", {
        Name = "Content",
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Parent = section,
    }, {
        ListLayout(Enum.FillDirection.Vertical, 6),
    })

    local api = {
        __type = "Section",
        ElementFrame = section,
        Elements = {},
        Container = content,
    }

    -- Attach element creators to section
    function api:Toggle(cfg)
        cfg = cfg or {}
        cfg.Parent = content
        cfg.LayoutOrder = #api.Elements + 1
        local el = CreateToggle(cfg)
        table.insert(api.Elements, el)
        return el
    end

    function api:Button(cfg)
        cfg = cfg or {}
        cfg.Parent = content
        cfg.LayoutOrder = #api.Elements + 1
        local el = CreateButton(cfg)
        table.insert(api.Elements, el)
        return el
    end

    function api:Space(size)
        local el = CreateSpace({ Parent = content, Size = size or 10, LayoutOrder = #api.Elements + 1 })
        table.insert(api.Elements, el)
        return el
    end

    function api:Paragraph(cfg)
        cfg = cfg or {}
        local el = CreateElementBase({
            Parent = content,
            Title = cfg.Title or "",
            Desc = cfg.Desc,
            LayoutOrder = #api.Elements + 1,
        })
        AddElementHover(el.Container, el.Background)
        table.insert(api.Elements, { __type = "Paragraph", ElementFrame = el.Container })
        return el
    end

    function api:Divider()
        local div = New("Frame", {
            Size = UDim2.new(1, 0, 0, 1),
            BackgroundColor3 = GetTheme("Outline"),
            BackgroundTransparency = 0.9,
            Parent = content,
            LayoutOrder = #api.Elements + 1,
        })
        table.insert(api.Elements, { __type = "Divider", ElementFrame = div })
        return div
    end

    return api
end

-- ==================== DISCORD CARD (Live + Fallback) ====================

local function FetchDiscordInvite(inviteCode)
    if not Request then return nil end
    local ok, result = pcall(function()
        local response = Request({
            Url = "https://discord.com/api/v10/invites/" .. inviteCode .. "?with_counts=true&with_expiration=true",
            Method = "GET",
            Headers = {
                ["Content-Type"] = "application/json",
                ["User-Agent"] = "Mozilla/5.0",
            },
        })
        if response and response.Body then
            return HttpService:JSONDecode(response.Body)
        end
        return nil
    end)
    if ok and result and result.guild then
        return {
            Name = result.guild.name,
            Icon = result.guild.icon and ("https://cdn.discordapp.com/icons/" .. result.guild.id .. "/" .. result.guild.icon .. ".png?size=128") or nil,
            Banner = result.guild.banner and ("https://cdn.discordapp.com/banners/" .. result.guild.id .. "/" .. result.guild.banner .. ".png?size=512") or nil,
            Online = result.approximate_presence_count or 0,
            Members = result.approximate_member_count or 0,
            Description = result.guild.description or "",
            Code = inviteCode,
        }
    end
    return nil
end

local function CreateDiscord(config)
    config = config or {}
    local invite = config.Invite

    -- Static fallback
    local data = {
        Name = config.Name or "Discord Server",
        Icon = config.Icon,
        Banner = config.Banner,
        Online = config.Online or 0,
        Members = config.Members or 0,
        Description = config.Description or config.Desc or "",
        Created = config.Created or "",
        ButtonText = config.ButtonText or "Go to Server",
    }

    local card = New("Frame", {
        Name = "DiscordCard",
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = Color3.fromRGB(30, 31, 34),
        Parent = config.Parent,
        LayoutOrder = config.LayoutOrder or 0,
        ClipsDescendants = true,
    }, {
        Corner(12),
        ListLayout(Enum.FillDirection.Vertical, 0),
    })

    -- Banner
    local banner = New("Frame", {
        Name = "Banner",
        Size = UDim2.new(1, 0, 0, 60),
        BackgroundColor3 = Color3.fromRGB(88, 101, 242),
        Parent = card,
    })

    local bannerImage
    if data.Banner then
        bannerImage = New("ImageLabel", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Image = data.Banner,
            ScaleType = Enum.ScaleType.Crop,
            Parent = banner,
        })
    end

    -- Spacer after banner so icon overlaps a bit
    local spacer = New("Frame", {
        Size = UDim2.new(1, 0, 0, 28),
        BackgroundTransparency = 1,
        Parent = card,
    })

    -- Main content
    local body = New("Frame", {
        Name = "Body",
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Parent = card,
    }, {
        Padding(0, 16, 16, 16),
        ListLayout(Enum.FillDirection.Vertical, 10),
    })

    -- Icon + Name row
    local topRow = New("Frame", {
        Size = UDim2.new(1, 0, 0, 56),
        BackgroundTransparency = 1,
        Parent = body,
    })

    local iconFrame = New("Frame", {
        Size = UDim2.new(0, 56, 0, 56),
        BackgroundColor3 = Color3.fromRGB(40, 42, 46),
        Parent = topRow,
    }, {
        Corner(14),
        New("UIStroke", {
            Color = Color3.fromRGB(30, 31, 34),
            Thickness = 4,
        }),
    })

    local iconImage = New("ImageLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Image = data.Icon or "",
        ScaleType = Enum.ScaleType.Crop,
        Parent = iconFrame,
    }, {
        Corner(12),
    })

    local nameLabel = New("TextLabel", {
        Size = UDim2.new(1, -70, 0, 22),
        Position = UDim2.new(0, 68, 0, 8),
        BackgroundTransparency = 1,
        Text = data.Name,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = topRow,
    })

    local statsRow = New("Frame", {
        Size = UDim2.new(1, -70, 0, 18),
        Position = UDim2.new(0, 68, 0, 32),
        BackgroundTransparency = 1,
        Parent = topRow,
    }, {
        ListLayout(Enum.FillDirection.Horizontal, 12),
    })

    local onlineText = New("TextLabel", {
        Size = UDim2.new(0, 0, 0, 18),
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundTransparency = 1,
        Text = "● " .. tostring(data.Online) .. " Online",
        TextColor3 = GetTheme("Online"),
        TextSize = 12,
        Font = Enum.Font.Gotham,
        Parent = statsRow,
    })

    local membersText = New("TextLabel", {
        Size = UDim2.new(0, 0, 0, 18),
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundTransparency = 1,
        Text = "● " .. tostring(data.Members) .. " Members",
        TextColor3 = Color3.fromRGB(160, 160, 170),
        TextSize = 12,
        Font = Enum.Font.Gotham,
        Parent = statsRow,
    })

    -- Description
    local descLabel = New("TextLabel", {
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Text = data.Description,
        TextColor3 = Color3.fromRGB(170, 170, 180),
        TextSize = 13,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        Parent = body,
    })

    -- Button
    local joinBtn = New("TextButton", {
        Name = "JoinButton",
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = Color3.fromRGB(35, 165, 90),
        Text = "",
        AutoButtonColor = false,
        Parent = body,
    }, {
        Corner(8),
    })

    local joinLabel = New("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = data.ButtonText,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        Parent = joinBtn,
    })

    local btnScale = New("UIScale", { Scale = 1, Parent = joinBtn })

    AddHover(joinBtn, function()
        Tween(joinBtn, 0.15, { BackgroundColor3 = Color3.fromRGB(45, 185, 105) })
        Tween(btnScale, 0.15, { Scale = 1.02 })
    end, function()
        Tween(joinBtn, 0.15, { BackgroundColor3 = Color3.fromRGB(35, 165, 90) })
        Tween(btnScale, 0.15, { Scale = 1 })
    end)

    Creator.AddSignal(joinBtn.MouseButton1Click, function()
        local link = "https://discord.gg/" .. (invite or "")
        if setclipboard then
            setclipboard(link)
        end
        if request then
            -- some executors support open
        end
        SafeCallback(config.OnClick, link)
        -- Try to open if possible
        if typeof(open) == "function" then
            open(link)
        end
    end)

    -- Live fetch
    if invite and invite ~= "" then
        task.spawn(function()
            local live = FetchDiscordInvite(invite)
            if live then
                nameLabel.Text = live.Name or data.Name
                onlineText.Text = "● " .. tostring(live.Online or 0) .. " Online"
                membersText.Text = "● " .. tostring(live.Members or 0) .. " Members"
                if live.Description and live.Description ~= "" then
                    descLabel.Text = live.Description
                end
                if live.Icon then
                    iconImage.Image = live.Icon
                end
                if live.Banner and bannerImage then
                    bannerImage.Image = live.Banner
                elseif live.Banner then
                    bannerImage = New("ImageLabel", {
                        Size = UDim2.new(1, 0, 1, 0),
                        BackgroundTransparency = 1,
                        Image = live.Banner,
                        ScaleType = Enum.ScaleType.Crop,
                        Parent = banner,
                    })
                end
            end
        end)
    end

    return {
        __type = "Discord",
        ElementFrame = card,
        Refresh = function()
            if invite then
                task.spawn(function()
                    local live = FetchDiscordInvite(invite)
                    if live then
                        nameLabel.Text = live.Name or nameLabel.Text
                        onlineText.Text = "● " .. tostring(live.Online or 0) .. " Online"
                        membersText.Text = "● " .. tostring(live.Members or 0) .. " Members"
                    end
                end)
            end
        end,
    }
end

-- ==================== SLIDER ====================

local function CreateSlider(config)
    config = config or {}
    local min = config.Min or 0
    local max = config.Max or 100
    local value = config.Value or min
    local step = config.Step or 1

    local element = CreateElementBase(config)
    element.Title.Size = UDim2.new(1, -80, 0, 18)

    local valueLabel = New("TextLabel", {
        Size = UDim2.new(0, 50, 0, 18),
        Position = UDim2.new(1, 0, 0, 0),
        AnchorPoint = Vector2.new(1, 0),
        BackgroundTransparency = 1,
        Text = tostring(value),
        TextColor3 = GetTheme("TextDim"),
        TextSize = 13,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Right,
        Parent = element.Background,
    })

    local sliderBg = New("Frame", {
        Size = UDim2.new(1, 0, 0, 6),
        BackgroundColor3 = GetTheme("ToggleOff"),
        Parent = element.Content,
        LayoutOrder = 10,
    }, {
        Corner(999),
    })

    local fill = New("Frame", {
        Size = UDim2.new((value - min) / (max - min), 0, 1, 0),
        BackgroundColor3 = GetTheme("Slider"),
        Parent = sliderBg,
    }, {
        Corner(999),
    })

    local knob = New("Frame", {
        Size = UDim2.new(0, 14, 0, 14),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        Position = UDim2.new((value - min) / (max - min), 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Parent = sliderBg,
        ZIndex = 3,
    }, {
        Corner(999),
    })

    local dragging = false

    local function SetValue(v, fire)
        v = math.clamp(math.floor(v / step + 0.5) * step, min, max)
        value = v
        local pct = (v - min) / (max - min)
        fill.Size = UDim2.new(pct, 0, 1, 0)
        knob.Position = UDim2.new(pct, 0, 0.5, 0)
        valueLabel.Text = tostring(v)
        if fire ~= false then
            SafeCallback(config.Callback, v)
        end
    end

    Creator.AddSignal(sliderBg.InputBegan, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            local pct = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
            SetValue(min + (max - min) * pct, true)
        end
    end)

    Creator.AddSignal(UserInputService.InputChanged, function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local pct = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
            SetValue(min + (max - min) * pct, true)
        end
    end)

    Creator.AddSignal(UserInputService.InputEnded, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    AddElementHover(element.Container, element.Background)

    return {
        __type = "Slider",
        Value = value,
        ElementFrame = element.Container,
        Set = function(_, v) SetValue(v, true) end,
        Get = function() return value end,
    }
end

-- ==================== INPUT ====================

local function CreateInput(config)
    config = config or {}
    local element = CreateElementBase(config)
    element.Title.Size = UDim2.new(1, 0, 0, 18)

    local box = New("TextBox", {
        Size = UDim2.new(1, 0, 0, 32),
        BackgroundColor3 = GetTheme("Accent"),
        Text = config.Value or config.Placeholder or "",
        PlaceholderText = config.Placeholder or "Type here...",
        PlaceholderColor3 = GetTheme("TextDim"),
        TextColor3 = GetTheme("Text"),
        TextSize = 13,
        Font = Enum.Font.Gotham,
        ClearTextOnFocus = false,
        Parent = element.Content,
        LayoutOrder = 5,
    }, {
        Corner(8),
        Padding(0, 10, 0, 10),
        Stroke(GetTheme("Outline"), 1, 0.92),
    })

    Creator.AddSignal(box.FocusLost, function(enter)
        SafeCallback(config.Callback, box.Text, enter)
    end)

    AddElementHover(element.Container, element.Background)

    return {
        __type = "Input",
        ElementFrame = element.Container,
        Set = function(_, text) box.Text = text end,
        Get = function() return box.Text end,
    }
end

-- ==================== TAB ====================

local function CreateTab(config, window)
    local tab = {
        __type = "Tab",
        Title = config.Title or "Tab",
        Icon = config.Icon,
        Selected = false,
        Elements = {},
        Window = window,
    }

    -- Sidebar button
    local tabBtn = New("TextButton", {
        Name = "TabButton",
        Size = UDim2.new(1, 0, 0, 38),
        BackgroundColor3 = GetTheme("Accent"),
        BackgroundTransparency = 1,
        Text = "",
        AutoButtonColor = false,
        Parent = window.UIElements.TabList,
        LayoutOrder = config.LayoutOrder or 0,
    }, {
        Corner(8),
        Padding(0, 10, 0, 10),
    })

    local tabLabel = New("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = tab.Title,
        TextColor3 = GetTheme("TextDim"),
        TextSize = 13,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = tabBtn,
    })

    -- Content container
    local container = New("ScrollingFrame", {
        Name = "TabContainer",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = GetTheme("TextDim"),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Visible = false,
        Parent = window.UIElements.Content,
    }, {
        Padding(12, 14, 12, 14),
        ListLayout(Enum.FillDirection.Vertical, 8),
    })

    tab.Container = container
    tab.Button = tabBtn
    tab.Label = tabLabel

    function tab:Select()
        for _, t in ipairs(window.Tabs) do
            t.Selected = false
            t.Container.Visible = false
            Tween(t.Button, 0.15, { BackgroundTransparency = 1 })
            t.Label.TextColor3 = GetTheme("TextDim")
        end
        tab.Selected = true
        tab.Container.Visible = true
        Tween(tabBtn, 0.15, { BackgroundTransparency = 0.6 })
        tabLabel.TextColor3 = GetTheme("Text")
        window.CurrentTab = tab
    end

    Creator.AddSignal(tabBtn.MouseButton1Click, function()
        tab:Select()
    end)

    AddHover(tabBtn, function()
        if not tab.Selected then
            Tween(tabBtn, 0.15, { BackgroundTransparency = 0.85 })
        end
    end, function()
        if not tab.Selected then
            Tween(tabBtn, 0.15, { BackgroundTransparency = 1 })
        end
    end)

    -- Element creators
    function tab:Section(cfg)
        cfg = cfg or {}
        cfg.Parent = container
        cfg.LayoutOrder = #tab.Elements + 1
        local el = CreateSection(cfg)
        table.insert(tab.Elements, el)
        return el
    end

    function tab:Toggle(cfg)
        cfg = cfg or {}
        cfg.Parent = container
        cfg.LayoutOrder = #tab.Elements + 1
        local el = CreateToggle(cfg)
        table.insert(tab.Elements, el)
        return el
    end

    function tab:Button(cfg)
        cfg = cfg or {}
        cfg.Parent = container
        cfg.LayoutOrder = #tab.Elements + 1
        local el = CreateButton(cfg)
        table.insert(tab.Elements, el)
        return el
    end

    function tab:Space(size)
        local el = CreateSpace({ Parent = container, Size = size or 12, LayoutOrder = #tab.Elements + 1 })
        table.insert(tab.Elements, el)
        return el
    end

    function tab:Discord(cfg)
        cfg = cfg or {}
        cfg.Parent = container
        cfg.LayoutOrder = #tab.Elements + 1
        local el = CreateDiscord(cfg)
        table.insert(tab.Elements, el)
        return el
    end

    function tab:Slider(cfg)
        cfg = cfg or {}
        cfg.Parent = container
        cfg.LayoutOrder = #tab.Elements + 1
        local el = CreateSlider(cfg)
        table.insert(tab.Elements, el)
        return el
    end

    function tab:Input(cfg)
        cfg = cfg or {}
        cfg.Parent = container
        cfg.LayoutOrder = #tab.Elements + 1
        local el = CreateInput(cfg)
        table.insert(tab.Elements, el)
        return el
    end

    function tab:Paragraph(cfg)
        cfg = cfg or {}
        local el = CreateElementBase({
            Parent = container,
            Title = cfg.Title or "",
            Desc = cfg.Desc,
            LayoutOrder = #tab.Elements + 1,
        })
        AddElementHover(el.Container, el.Background)
        table.insert(tab.Elements, { __type = "Paragraph", ElementFrame = el.Container })
        return el
    end

    function tab:Divider()
        local div = New("Frame", {
            Size = UDim2.new(1, 0, 0, 1),
            BackgroundColor3 = GetTheme("Outline"),
            BackgroundTransparency = 0.9,
            Parent = container,
            LayoutOrder = #tab.Elements + 1,
        })
        table.insert(tab.Elements, { __type = "Divider", ElementFrame = div })
        return div
    end

    return tab
end

-- ==================== WINDOW ====================

function WindUI:CreateWindow(config)
    config = config or {}

    local window = {
        Title = config.Title or "WindUI",
        Author = config.Author or "",
        Size = config.Size or UDim2.new(0, 580, 0, 420),
        MinSize = config.MinSize or Vector2.new(400, 300),
        Theme = config.Theme or "Dark",
        Tabs = {},
        CurrentTab = nil,
        UIElements = {},
        Closed = false,
    }

    if Themes[window.Theme] then
        WindUI.Theme = Themes[window.Theme]
    end

    local guiParent = (gethui and gethui()) or CoreGui
    local protect = protectgui or (syn and syn.protect_gui) or function() end

    local screenGui = New("ScreenGui", {
        Name = "WindUI",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = guiParent,
    })
    protect(screenGui)

    local main = New("Frame", {
        Name = "Main",
        Size = window.Size,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = GetTheme("Background"),
        Parent = screenGui,
        ClipsDescendants = true,
    }, {
        Corner(14),
        New("UIStroke", {
            Color = GetTheme("Outline"),
            Thickness = 1,
            Transparency = 0.92,
        }),
    })

    window.UIElements.Main = main
    window.UIElements.ScreenGui = screenGui

    -- Topbar
    local topbar = New("Frame", {
        Name = "Topbar",
        Size = UDim2.new(1, 0, 0, 48),
        BackgroundColor3 = GetTheme("Accent"),
        Parent = main,
    }, {
        Corner(14),
        -- bottom square to hide bottom corners
        New("Frame", {
            Size = UDim2.new(1, 0, 0, 14),
            Position = UDim2.new(0, 0, 1, -14),
            BackgroundColor3 = GetTheme("Accent"),
            BorderSizePixel = 0,
        }),
    })

    local titleLabel = New("TextLabel", {
        Size = UDim2.new(1, -100, 1, 0),
        Position = UDim2.new(0, 16, 0, 0),
        BackgroundTransparency = 1,
        Text = window.Title,
        TextColor3 = GetTheme("Text"),
        TextSize = 15,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = topbar,
    })

    if window.Author and window.Author ~= "" then
        titleLabel.Text = window.Title .. "  ·  " .. window.Author
        titleLabel.TextSize = 14
    end

    -- Close button
    local closeBtn = New("TextButton", {
        Size = UDim2.new(0, 32, 0, 32),
        Position = UDim2.new(1, -40, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = GetTheme("Danger"),
        BackgroundTransparency = 0.85,
        Text = "✕",
        TextColor3 = GetTheme("Text"),
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        Parent = topbar,
    }, {
        Corner(8),
    })

    Creator.AddSignal(closeBtn.MouseButton1Click, function()
        Tween(main, 0.25, { Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1 })
        task.delay(0.3, function()
            screenGui:Destroy()
            Creator.DisconnectAll()
        end)
    end)

    -- Sidebar
    local sidebar = New("Frame", {
        Name = "Sidebar",
        Size = UDim2.new(0, 160, 1, -48),
        Position = UDim2.new(0, 0, 0, 48),
        BackgroundColor3 = GetTheme("Accent"),
        Parent = main,
    }, {
        Padding(8, 8, 8, 8),
    })

    local tabList = New("ScrollingFrame", {
        Name = "TabList",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = sidebar,
    }, {
        ListLayout(Enum.FillDirection.Vertical, 4),
    })

    window.UIElements.TabList = tabList

    -- Content area
    local content = New("Frame", {
        Name = "Content",
        Size = UDim2.new(1, -160, 1, -48),
        Position = UDim2.new(0, 160, 0, 48),
        BackgroundTransparency = 1,
        Parent = main,
        ClipsDescendants = true,
    })

    window.UIElements.Content = content

    -- Dragging
    local dragging, dragStart, startPos
    Creator.AddSignal(topbar.InputBegan, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
        end
    end)
    Creator.AddSignal(UserInputService.InputChanged, function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    Creator.AddSignal(UserInputService.InputEnded, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    -- API
    function window:Tab(cfg)
        cfg = cfg or {}
        cfg.LayoutOrder = #window.Tabs + 1
        local t = CreateTab(cfg, window)
        table.insert(window.Tabs, t)
        if #window.Tabs == 1 then
            t:Select()
        end
        return t
    end

    function window:SetTheme(name)
        if Themes[name] then
            WindUI.Theme = Themes[name]
            -- Note: full live theme switch would require refreshing all elements
        end
    end

    WindUI.Window = window
    return window
end

-- ==================== NOTIFY (simple) ====================

function WindUI:Notify(config)
    config = config or {}
    -- Simple placeholder - can be expanded
    print("[WindUI Notify]", config.Title or "", config.Content or "")
end

return WindUI
