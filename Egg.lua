-- [[ SUKITHUB - Auto Egg & PVP Hub Full UI ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Global Config
local Config = {
    WalkSpeed = 300,
    SpeedEnabled = false,
    AutoSteal = false,
    TargetBigEgg = false,
    KillAllMap = false,
    KillZone = false,
    TargetLock = false,
    SelectedPlayerName = nil
}

-- Safe Parent Target (สำหรับ Mobile Executor)
local parentTarget = LocalPlayer:WaitForChild("PlayerGui")
pcall(function()
    if gethui then
        parentTarget = gethui()
    end
end)

-- Remove Old UI if Exists
if parentTarget:FindFirstChild("SUKITHUB_GUI") then
    parentTarget:FindFirstChild("SUKITHUB_GUI"):Destroy()
end

-- UI Container Creation
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SUKITHUB_GUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = parentTarget

-- Safe Image Loader
local IconAsset = "rbxassetid://10723345518" -- Fallback ID
pcall(function()
    if writefile and getcustomasset and isfile and game.HttpGet then
        if not isfile("sukithub_icon.png") then
            writefile("sukithub_icon.png", game:HttpGet("https://i.ibb.co/bgQ9GgKv/icon-SUKITHUB.jpg"))
        end
        if isfile("sukithub_icon.png") then
            IconAsset = getcustomasset("sukithub_icon.png")
        end
    end
end)

---------------------------------------------------------
-- Floating Open/Close Toggle Icon Button (ปุ่มไอคอนเปิด-ปิด)
---------------------------------------------------------
local ToggleButton = Instance.new("ImageButton")
ToggleButton.Name = "SUKITHUB_Toggle"
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.Position = UDim2.new(0, 15, 0.4, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
ToggleButton.Image = IconAsset
ToggleButton.Active = true
ToggleButton.Draggable = true
ToggleButton.ZIndex = 100
ToggleButton.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner", ToggleButton)
ToggleCorner.CornerRadius = UDim.new(1, 0)

local ToggleStroke = Instance.new("UIStroke", ToggleButton)
ToggleStroke.Color = Color3.fromRGB(0, 255, 170)
ToggleStroke.Thickness = 2

---------------------------------------------------------
-- Main Window Frame (หน้าต่างหลัก)
---------------------------------------------------------
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 480, 0, 300)
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ZIndex = 10
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner", MainFrame)
MainCorner.CornerRadius = UDim.new(0, 8)

-- Header Title
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -20, 0, 35)
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.Text = "SUKITHUB - EGG & PVP HUB"
TitleLabel.TextColor3 = Color3.fromRGB(0, 255, 170)
TitleLabel.TextSize = 16
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.BackgroundTransparency = 1
TitleLabel.ZIndex = 11
TitleLabel.Parent = MainFrame

-- Sidebar (แถบเมนูซ้าย)
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 120, 1, -45)
Sidebar.Position = UDim2.new(0, 10, 0, 38)
Sidebar.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
Sidebar.BorderSizePixel = 0
Sidebar.ZIndex = 11
Sidebar.Parent = MainFrame

Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 6)

local SidebarList = Instance.new("UIListLayout", Sidebar)
SidebarList.SortOrder = Enum.SortOrder.LayoutOrder
SidebarList.Padding = UDim.new(0, 5)

local SidebarPadding = Instance.new("UIPadding", Sidebar)
SidebarPadding.PaddingTop = UDim.new(0, 5)
SidebarPadding.PaddingLeft = UDim.new(0, 5)
SidebarPadding.PaddingRight = UDim.new(0, 5)

-- Main Display Container (พื้นที่แสดงผลขวา)
local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -145, 1, -45)
Container.Position = UDim2.new(0, 135, 0, 38)
Container.BackgroundTransparency = 1
Container.ZIndex = 11
Container.Parent = MainFrame

-- Open/Close Functionality
ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

---------------------------------------------------------
-- Tab Navigation Creator
---------------------------------------------------------
local Pages = {}

local function CreateTab(name, posIndex)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(1, 0, 0, 32)
    TabBtn.Text = name
    TabBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
    TabBtn.BackgroundColor3 = Color3.fromRGB(38, 38, 48)
    TabBtn.Font = Enum.Font.SourceSansBold
    TabBtn.TextSize = 13
    TabBtn.ZIndex = 12
    TabBtn.Parent = Sidebar
    
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 5)
    
    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.ScrollBarThickness = 3
    Page.Visible = (posIndex == 1)
    Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Page.CanvasSize = UDim2.new(0, 0, 0, 0)
    Page.ZIndex = 12
    Page.Parent = Container
    
    local UIList = Instance.new("UIListLayout", Page)
    UIList.SortOrder = Enum.SortOrder.LayoutOrder
    UIList.Padding = UDim.new(0, 6)
    
    Pages[name] = {Button = TabBtn, Page = Page}
    
    TabBtn.MouseButton1Click:Connect(function()
        for _, tab in pairs(Pages) do
            tab.Page.Visible = false
            tab.Button.BackgroundColor3 = Color3.fromRGB(38, 38, 48)
            tab.Button.TextColor3 = Color3.fromRGB(180, 180, 180)
        end
        Page.Visible = true
        TabBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 130)
        TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
    
    if posIndex == 1 then
        TabBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 130)
        TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
    
    return Page
end

-- Create Menu Pages
local AutoEggPage = CreateTab("ขโมยไข่", 1)
local PVPPage = CreateTab("ระบบ PVP", 2)
local PlayerPage = CreateTab("ตัวละคร", 3)

---------------------------------------------------------
-- UI Control Helpers (Toggles & Sliders)
---------------------------------------------------------
local function CreateToggle(parent, text, defaultState, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -5, 0, 36)
    Frame.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
    Frame.ZIndex = 13
    Frame.Parent = parent
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 5)
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(240, 240, 240)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Font = Enum.Font.SourceSans
    Label.TextSize = 13
    Label.BackgroundTransparency = 1
    Label.ZIndex = 14
    Label.Parent = Frame
    
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0, 45, 0, 22)
    Button.Position = UDim2.new(1, -50, 0.5, -11)
    Button.Text = defaultState and "ON" or "OFF"
    Button.BackgroundColor3 = defaultState and Color3.fromRGB(0, 200, 120) or Color3.fromRGB(70, 70, 80)
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Font = Enum.Font.SourceSansBold
    Button.TextSize = 11
    Button.ZIndex = 14
    Button.Parent = Frame
    Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 4)
    
    local state = defaultState
    Button.MouseButton1Click:Connect(function()
        state = not state
        Button.Text = state and "ON" or "OFF"
        Button.BackgroundColor3 = state and Color3.fromRGB(0, 200, 120) or Color3.fromRGB(70, 70, 80)
        callback(state)
    end)
end

local function CreateSlider(parent, text, min, max, default, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -5, 0, 48)
    Frame.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
    Frame.ZIndex = 13
    Frame.Parent = parent
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 5)
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -15, 0, 18)
    Label.Position = UDim2.new(0, 10, 0, 4)
    Label.Text = text .. ": " .. tostring(default)
    Label.TextColor3 = Color3.fromRGB(240, 240, 240)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Font = Enum.Font.SourceSans
    Label.TextSize = 13
    Label.BackgroundTransparency = 1
    Label.ZIndex = 14
    Label.Parent = Frame
    
    local SliderBar = Instance.new("Frame")
    SliderBar.Size = UDim2.new(1, -20, 0, 6)
    SliderBar.Position = UDim2.new(0, 10, 0, 30)
    SliderBar.BackgroundColor3 = Color3.fromRGB(55, 55, 65)
    SliderBar.ZIndex = 14
    SliderBar.Parent = Frame
    Instance.new("UICorner", SliderBar).CornerRadius = UDim.new(0, 3)
    
    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(0, 200, 130)
    Fill.ZIndex = 15
    Fill.Parent = SliderBar
    Instance.new("UICorner", Fill).CornerRadius = UDim.new(0, 3)
    
    local isDragging = false
    local function Update(input)
        local pos = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (max - min) * pos)
        Fill.Size = UDim2.new(pos, 0, 1, 0)
        Label.Text = text .. ": " .. tostring(val)
        callback(val)
    end
    
    SliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            Update(input)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            Update(input)
        end
    end)
end

---------------------------------------------------------
-- Populate Control Elements into Tabs
---------------------------------------------------------

-- 1. Tab Auto Egg
CreateToggle(AutoEggPage, "เปิดใช้งาน Auto Steal (ขโมยไข่)", Config.AutoSteal, function(v)
    Config.AutoSteal = v
end)

CreateToggle(AutoEggPage, "เน้นขโมยไข่ใหญ่ (Big Egg Only)", Config.TargetBigEgg, function(v)
    Config.TargetBigEgg = v
end)

-- 2. Tab PVP
CreateToggle(PVPPage, "โจมตีทุกคนในแมพ (Kill All Map)", Config.KillAllMap, function(v)
    Config.KillAllMap = v
end)

CreateToggle(PVPPage, "โจมตีทุกคนในโซน (Kill Zone)", Config.KillZone, function(v)
    Config.KillZone = v
end)

CreateToggle(PVPPage, "เปิดระบบล็อคเป้าผู้เล่น (Lock Target)", Config.TargetLock, function(v)
    Config.TargetLock = v
end)

-- 3. Tab Player
CreateToggle(PlayerPage, "เปิดใช้งานความเร็วพิเศษ", Config.SpeedEnabled, function(v)
    Config.SpeedEnabled = v
end)

CreateSlider(PlayerPage, "ความเร็วการวิ่ง (Speed)", 16, 1000, 300, function(val)
    Config.WalkSpeed = val
end)

---------------------------------------------------------
-- Game Loops & Mechanics Executions
---------------------------------------------------------

-- WalkSpeed Loop
RunService.Stepped:Connect(function()
    if Config.SpeedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = Config.WalkSpeed
    end
end)

-- Target Lock Loop
RunService.RenderStepped:Connect(function()
    if Config.TargetLock and Config.SelectedPlayerName then
        local targetPlayer = Players:FindFirstChild(Config.SelectedPlayerName)
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPlayer.Character.HumanoidRootPart.Position)
        end
    end
end)

-- Auto Steal & PVP Main Loop
task.spawn(function()
    while task.wait(0.1) do
        local character = LocalPlayer.Character
        if not character or not character:FindFirstChild("HumanoidRootPart") then continue end
        
        -- Auto Steal Egg Logic
        if Config.AutoSteal then
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("ProximityPrompt") and obj.Parent then
                    local name = obj.Parent.Name:lower()
                    if Config.TargetBigEgg and not name:find("big") then
                        continue
                    end
                    if obj.Parent:FindFirstChild("TouchInterest") or name:find("egg") then
                        fireproximityprompt(obj)
                    end
                end
            end
        end
        
        -- PVP Logic
        if Config.KillAllMap or Config.KillZone then
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local targetRoot = player.Character.HumanoidRootPart
                    local dist = (character.HumanoidRootPart.Position - targetRoot.Position).Magnitude
                    local inZone = dist <= 150
                    
                    if Config.KillAllMap or (Config.KillZone and inZone) then
                        local tool = character:FindFirstChildOfClass("Tool")
                        if tool then
                            tool:Activate()
                            if tool:FindFirstChild("Handle") then
                                firetouchinterest(tool.Handle, targetRoot, 0)
                                firetouchinterest(tool.Handle, targetRoot, 1)
                            end
                        end
                    end
                end
            end
        end
    end
end)
