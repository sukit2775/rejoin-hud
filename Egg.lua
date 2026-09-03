-- [[ Auto Egg & PVP Hub UI with SUKITHUB Toggle Icon ]] --
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
    SelectedRarity = "Rare",
    SelectedZone = "Zone 1",
    TargetBigEgg = false,
    KillAllMap = false,
    KillZone = false,
    TargetLock = false,
    SelectedPlayerName = nil
}

-- Custom Asset Loader for Image URL
local function GetAsset(url, fileName)
    if writefile and getcustomasset and isfile and game.HttpGet then
        pcall(function()
            if not isfile(fileName) then
                writefile(fileName, game:HttpGet(url))
            end
        end)
        if isfile(fileName) then
            return getcustomasset(fileName)
        end
    end
    return url
end

local IconAsset = GetAsset("https://i.ibb.co/bgQ9GgKv/icon-SUKITHUB.jpg", "sukithub_icon.png")

-- UI Container Creation
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoEggHubUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

---------------------------------------------------------
-- Floating Open/Close Toggle Button (ไอคอนเปิด-ปิด)
---------------------------------------------------------
local ToggleButton = Instance.new("ImageButton")
ToggleButton.Name = "SUKITHUB_Toggle"
ToggleButton.Size = UDim2.new(0, 55, 0, 55)
ToggleButton.Position = UDim2.new(0, 20, 0.5, -27)
ToggleButton.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
ToggleButton.Image = IconAsset
ToggleButton.Active = true
ToggleButton.Draggable = true
ToggleButton.Parent = ScreenGui

-- ทำให้ปุ่มไอคอนเป็นทรงกลมพร้อมเส้นขอบ
local ToggleCorner = Instance.new("UICorner", ToggleButton)
ToggleCorner.CornerRadius = UDim.new(1, 0)

local ToggleStroke = Instance.new("UIStroke", ToggleButton)
ToggleStroke.Color = Color3.fromRGB(0, 255, 170)
ToggleStroke.Thickness = 2.5

---------------------------------------------------------
-- Main Frame (หน้าต่างหลัก)
---------------------------------------------------------
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 520, 0, 360)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -180)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 10)

-- Toggle GUI Visibility Event
ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Header Bar
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -20, 0, 40)
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.Text = "SUKITHUB - EGG & PVP HUB"
TitleLabel.TextColor3 = Color3.fromRGB(0, 255, 170)
TitleLabel.TextSize = 18
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.BackgroundTransparency = 1
TitleLabel.Parent = MainFrame

-- Sidebar Navigation
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 130, 1, -50)
Sidebar.Position = UDim2.new(0, 10, 0, 45)
Sidebar.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local SidebarCorner = Instance.new("UICorner", Sidebar)
SidebarCorner.CornerRadius = UDim.new(0, 8)

-- Tab Content Area
local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -160, 1, -50)
Container.Position = UDim2.new(0, 150, 0, 45)
Container.BackgroundTransparency = 1
Container.Parent = MainFrame

local Pages = {}

local function CreateTab(name, posIndex)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(1, -10, 0, 35)
    TabBtn.Position = UDim2.new(0, 5, 0, 5 + (posIndex - 1) * 40)
    TabBtn.Text = name
    TabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    TabBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    TabBtn.Font = Enum.Font.SourceSansSemiBold
    TabBtn.TextSize = 14
    TabBtn.Parent = Sidebar
    
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)
    
    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.ScrollBarThickness = 4
    Page.Visible = (posIndex == 1)
    Page.Parent = Container
    
    local UIList = Instance.new("UIListLayout", Page)
    UIList.SortOrder = Enum.SortOrder.LayoutOrder
    UIList.Padding = UDim.new(0, 8)
    
    Pages[name] = {Button = TabBtn, Page = Page}
    
    TabBtn.MouseButton1Click:Connect(function()
        for _, tab in pairs(Pages) do
            tab.Page.Visible = false
            tab.Button.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
            tab.Button.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
        Page.Visible = true
        TabBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 140)
        TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
    
    if posIndex == 1 then
        TabBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 140)
        TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
    
    return Page
end

-- Create Pages
local AutoEggPage = CreateTab("ระบบขโมยไข่", 1)
local PVPPage = CreateTab("ระบบ PVP", 2)
local PlayerPage = CreateTab("ตั้งค่าตัวละคร", 3)

---------------------------------------------------------
-- Helper Functions for UI Elements
---------------------------------------------------------
local function CreateToggle(parent, text, defaultState, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -10, 0, 35)
    Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
    Frame.Parent = parent
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(230, 230, 230)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Font = Enum.Font.SourceSans
    Label.TextSize = 14
    Label.BackgroundTransparency = 1
    Label.Parent = Frame
    
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0, 50, 0, 22)
    Button.Position = UDim2.new(1, -60, 0.5, -11)
    Button.Text = defaultState and "ON" or "OFF"
    Button.BackgroundColor3 = defaultState and Color3.fromRGB(0, 200, 120) or Color3.fromRGB(80, 80, 90)
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Font = Enum.Font.SourceSansBold
    Button.TextSize = 12
    Button.Parent = Frame
    Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 4)
    
    local state = defaultState
    Button.MouseButton1Click:Connect(function()
        state = not state
        Button.Text = state and "ON" or "OFF"
        Button.BackgroundColor3 = state and Color3.fromRGB(0, 200, 120) or Color3.fromRGB(80, 80, 90)
        callback(state)
    end)
end

local function CreateSlider(parent, text, min, max, default, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -10, 0, 50)
    Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
    Frame.Parent = parent
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -20, 0, 20)
    Label.Position = UDim2.new(0, 10, 0, 5)
    Label.Text = text .. ": " .. tostring(default)
    Label.TextColor3 = Color3.fromRGB(230, 230, 230)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Font = Enum.Font.SourceSans
    Label.TextSize = 14
    Label.BackgroundTransparency = 1
    Label.Parent = Frame
    
    local SliderBar = Instance.new("Frame")
    SliderBar.Size = UDim2.new(1, -20, 0, 8)
    SliderBar.Position = UDim2.new(0, 10, 0, 32)
    SliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    SliderBar.Parent = Frame
    Instance.new("UICorner", SliderBar).CornerRadius = UDim.new(0, 4)
    
    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(0, 200, 140)
    Fill.Parent = SliderBar
    Instance.new("UICorner", Fill).CornerRadius = UDim.new(0, 4)
    
    local isDragging = false
    local function Update(input)
        local pos = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (max - min) * pos)
        Fill.Size = UDim2.new(pos, 0, 1, 0)
        Label.Text = text .. ": " .. tostring(val)
        callback(val)
    end
    
    SliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = true
            Update(input)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            Update(input)
        end
    end)
end

---------------------------------------------------------
-- UI Elements Binding
---------------------------------------------------------
CreateToggle(AutoEggPage, "เปิดใช้งาน Auto Steal (ขโมยไข่อัตโนมัติ)", Config.AutoSteal, function(v)
    Config.AutoSteal = v
end)

CreateToggle(AutoEggPage, "เน้นขโมยไข่ใหญ่ (Big Egg Only)", Config.TargetBigEgg, function(v)
    Config.TargetBigEgg = v
end)

CreateToggle(PVPPage, "โจมตีทุกคนในแมพ (Kill All Map)", Config.KillAllMap, function(v)
    Config.KillAllMap = v
end)

CreateToggle(PVPPage, "โจมตีทุกคนในโซนไข่ (Kill Zone)", Config.KillZone, function(v)
    Config.KillZone = v
end)

CreateToggle(PVPPage, "เปิดระบบล็อคเป้าผู้เล่น (Lock Target)", Config.TargetLock, function(v)
    Config.TargetLock = v
end)

CreateToggle(PlayerPage, "เปิดใช้งานความเร็วพิเศษ", Config.SpeedEnabled, function(v)
    Config.SpeedEnabled = v
end)

CreateSlider(PlayerPage, "ความเร็วการวิ่ง (Speed)", 16, 1000, 300, function(val)
    Config.WalkSpeed = val
end)

---------------------------------------------------------
-- Core Loop & Game Mechanics
---------------------------------------------------------
RunService.Stepped:Connect(function()
    if Config.SpeedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = Config.WalkSpeed
    end
end)

RunService.RenderStepped:Connect(function()
    if Config.TargetLock and Config.SelectedPlayerName then
        local targetPlayer = Players:FindFirstChild(Config.SelectedPlayerName)
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPlayer.Character.HumanoidRootPart.Position)
        end
    end
end)

task.spawn(function()
    while task.wait(0.1) do
        local character = LocalPlayer.Character
        if not character or not character:FindFirstChild("HumanoidRootPart") then continue end
        
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
