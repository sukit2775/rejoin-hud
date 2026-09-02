-- ==========================================
-- SUKIT HUB v7.0 DARK EDITION (FULL SYSTEM)
-- ==========================================

local CoreGui = (gethui and gethui()) or game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer

-- ลบ UI เก่าหากรันซ้ำ
if CoreGui:FindFirstChild("SukitHubKaitanFull") then
    CoreGui.SukitHubKaitanFull:Destroy()
end

-- แจ้งเตือนเมื่อเริ่มรัน
StarterGui:SetCore("SendNotification", {
    Title = "SUKIT HUB",
    Text = "SUKIT HUB Dark Edition Loaded!",
    Duration = 5
})

-- ตัวแปรตั้งค่าระบบทั้งหมด
_G.AutoKaitan = false
_G.AutoFarmMob = false
_G.AutoStats = true
_G.StatFocus = "Melee"
_G.Distance = 8.5
_G.AutoRandomFruit = false
_G.AutoStoreFruit = false
_G.AutoGrabFruit = false
_G.PlayerESP = false
_G.FruitESP = false
_G.InfJump = false
_G.FastAttackSpeed = 0.1

-- ตารางเลเวลมอนสเตอร์ (1 - 700+)
local MobLevelTable = {
    {Min = 1, Max = 9, Name = "Bandit", CFrame = CFrame.new(1060, 16, 1548)},
    {Min = 10, Max = 14, Name = "Monkey", CFrame = CFrame.new(-1601, 36, 153)},
    {Min = 15, Max = 29, Name = "Gorilla", CFrame = CFrame.new(-1237, 6, 503)},
    {Min = 30, Max = 39, Name = "Pirate", CFrame = CFrame.new(-1115, 4, 3850)},
    {Min = 40, Max = 59, Name = "Brute", CFrame = CFrame.new(-1145, 14, 4300)},
    {Min = 60, Max = 74, Name = "Desert Bandit", CFrame = CFrame.new(895, 6, 4370)},
    {Min = 75, Max = 89, Name = "Desert Officer", CFrame = CFrame.new(1576, 10, 4374)},
    {Min = 90, Max = 99, Name = "Snow Bandit", CFrame = CFrame.new(1285, 26, -1372)},
    {Min = 100, Max = 119, Name = "Snowman", CFrame = CFrame.new(1285, 26, -1372)},
    {Min = 120, Max = 149, Name = "Chief Petty Officer", CFrame = CFrame.new(-4855, 20, 4300)},
    {Min = 150, Max = 174, Name = "Sky Bandit", CFrame = CFrame.new(-4840, 717, -2620)},
    {Min = 175, Max = 189, Name = "Dark Master", CFrame = CFrame.new(-5250, 388, -2250)},
    {Min = 190, Max = 209, Name = "Prisoner", CFrame = CFrame.new(5300, 1, 470)},
    {Min = 210, Max = 249, Name = "Toga Warrior", CFrame = CFrame.new(5250, 1, 470)},
    {Min = 250, Max = 299, Name = "Military Soldier", CFrame = CFrame.new(-2570, 6, -3000)},
    {Min = 300, Max = 329, Name = "Military Spy", CFrame = CFrame.new(-2570, 6, -3000)},
    {Min = 330, Max = 374, Name = "Magma Ninja", CFrame = CFrame.new(-5400, 8, 8500)},
    {Min = 375, Max = 399, Name = "Fishman Warrior", CFrame = CFrame.new(61100, 18, 1560)},
    {Min = 400, Max = 449, Name = "Fishman Commando", CFrame = CFrame.new(61100, 18, 1560)},
    {Min = 450, Max = 474, Name = "God's Guard", CFrame = CFrame.new(-4700, 845, -1900)},
    {Min = 475, Max = 524, Name = "Shanda", CFrame = CFrame.new(-7900, 5541, -3800)},
    {Min = 525, Max = 549, Name = "Royal Squad", CFrame = CFrame.new(-7900, 5541, -3800)},
    {Min = 550, Max = 624, Name = "Royal Guard", CFrame = CFrame.new(-7900, 5541, -3800)},
    {Min = 625, Max = 649, Name = "Galley Pirate", CFrame = CFrame.new(5600, 2, 4900)},
    {Min = 650, Max = 700, Name = "Galley Captain", CFrame = CFrame.new(5600, 2, 4900)}
}

-- UI Root
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SukitHubKaitanFull"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local function MakeDraggable(topbarobject, object)
    local dragging, dragInput, dragStart, startPos
    topbarobject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = object.Position
        end
    end)
    topbarobject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            object.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
end

-- ไอคอนปุ่มเปิด/ปิด UI ลอยบนหน้าจอ
local ToggleBtn = Instance.new("ImageButton")
ToggleBtn.Size = UDim2.new(0, 55, 0, 55)
ToggleBtn.Position = UDim2.new(0, 15, 0, 15)
ToggleBtn.BackgroundTransparency = 1
ToggleBtn.Image = "iconSUKITHUB_2.png"
ToggleBtn.Parent = ScreenGui
MakeDraggable(ToggleBtn, ToggleBtn)

-- กรอบหลัก UI (เปลี่ยนเป็นสีดำ + กรอบเทา)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 650, 0, 440)
MainFrame.Position = UDim2.new(0.5, -325, 0.5, -220)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18) -- สีดำ
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Color3.fromRGB(80, 80, 80) -- กรอบสีเทา
MainStroke.Thickness = 2

ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- แถบด้านบน TopBar (สีเทาดำเข้ม)
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 45)
TopBar.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
TopBar.Parent = MainFrame
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 10)
MakeDraggable(TopBar, MainFrame)

local TopStroke = Instance.new("UIStroke", TopBar)
TopStroke.Color = Color3.fromRGB(80, 80, 80)
TopStroke.Thickness = 1

local AppIcon = Instance.new("ImageLabel")
AppIcon.Size = UDim2.new(0, 35, 0, 35)
AppIcon.Position = UDim2.new(0, 8, 0, 5)
AppIcon.BackgroundTransparency = 1
AppIcon.Image = "iconSUKITHUB_2.png"
AppIcon.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 180, 1, 0)
Title.Position = UDim2.new(0, 50, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "SUKIT HUB"
Title.TextColor3 = Color3.fromRGB(255, 255, 255) -- ข้อความสีขาว
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local BountyLabel = Instance.new("TextLabel")
BountyLabel.Size = UDim2.new(0, 200, 1, 0)
BountyLabel.Position = UDim2.new(1, -250, 0, 0)
BountyLabel.BackgroundTransparency = 1
BountyLabel.Text = "Bounty: 0"
BountyLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
BountyLabel.Font = Enum.Font.GothamMedium
BountyLabel.TextSize = 14
BountyLabel.TextXAlignment = Enum.TextXAlignment.Right
BountyLabel.Parent = TopBar

task.spawn(function()
    while task.wait(1) do
        pcall(function()
            local b = LocalPlayer.leaderstats.Bounty.Value
            BountyLabel.Text = "Bounty: " .. string.format("%d", b)
        end)
    end
end)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -40, 0, 5)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "❌"
CloseBtn.TextColor3 = Color3.fromRGB(255, 70, 70)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
CloseBtn.Parent = TopBar
CloseBtn.MouseButton1Click:Connect(function()
    _G.AutoKaitan = false
    _G.AutoFarmMob = false
    ScreenGui:Destroy()
end)

-- Sidebar & Content
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 160, 1, -45)
Sidebar.Position = UDim2.new(0, 0, 0, 45)
Sidebar.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -160, 1, -45)
ContentArea.Position = UDim2.new(0, 160, 0, 45)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = MainFrame

local TabsList = Instance.new("UIListLayout", Sidebar)
TabsList.Padding = UDim.new(0, 4)

local Pages = {}
local TabButtons = {}

local function CreateTab(name, order)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(1, 0, 0, 38)
    TabBtn.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
    TabBtn.Text = name
    TabBtn.TextColor3 = Color3.fromRGB(230, 230, 230)
    TabBtn.Font = Enum.Font.GothamBold
    TabBtn.TextSize = 13
    TabBtn.LayoutOrder = order
    TabBtn.Parent = Sidebar
    
    local TabStroke = Instance.new("UIStroke", TabBtn)
    TabStroke.Color = Color3.fromRGB(80, 80, 80) -- กรอบเทา
    TabStroke.Thickness = 1
    
    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, -20, 1, -20)
    Page.Position = UDim2.new(0, 10, 0, 10)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = 5
    Page.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
    Page.Parent = ContentArea
    
    local PageLayout = Instance.new("UIListLayout", Page)
    PageLayout.Padding = UDim.new(0, 8)
    
    table.insert(TabButtons, TabBtn)
    table.insert(Pages, Page)
    
    TabBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        for _, b in pairs(TabButtons) do 
            b.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
            b.TextColor3 = Color3.fromRGB(230, 230, 230)
        end
        Page.Visible = true
        TabBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
    return Page
end

-- สร้าง 6 หมวดหมู่หลัก
local PageMain = CreateTab("Main (ไก่ตัน)", 1)
local PageFarm = CreateTab("ระบบฟาร์ม/หาของ", 2)
local PageShop = CreateTab("Shop (ร้านค้า/สุ่ม)", 3)
local PageTP = CreateTab("Teleport (วาร์ป)", 4)
local PagePVP = CreateTab("PVP / Visuals", 5)
local PageSettings = CreateTab("Settings (ตั้งค่า)", 6)

Pages[1].Visible = true
TabButtons[1].BackgroundColor3 = Color3.fromRGB(60, 60, 80)

local function AddButton(page, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -5, 0, 38)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35) -- พื้นปุ่มดำเทา
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(240, 240, 240) -- ตัวหนังสือสว่าง
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.Parent = page
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    local BtnStroke = Instance.new("UIStroke", btn)
    BtnStroke.Color = Color3.fromRGB(90, 90, 90) -- กรอบปุ่มสีเทา
    BtnStroke.Thickness = 1
    
    btn.MouseButton1Click:Connect(function() callback(btn) end)
    return btn
end

-- ระบบต่อสู้ การลอยตัว และการจับผล
local function EquipWeapon()
    local char = LocalPlayer.Character
    if char then
        for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
            if tool:IsA("Tool") and (tool.ToolTip == "Melee" or tool.ToolTip == "Sword" or tool.ToolTip == "Blox Fruit") then
                char.Humanoid:EquipTool(tool)
                break
            end
        end
    end
end

local function FastAttack()
    VirtualUser:CaptureController()
    VirtualUser:Button1Down(Vector2.new(500, 500))
    VirtualUser:Button1Up(Vector2.new(500, 500))
    pcall(function()
        ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RE/RegisterAttack"):FireServer(_G.FastAttackSpeed, 3)
    end)
end

local function HoverAbove(targetHRP)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local hrp = char.HumanoidRootPart
        if not hrp:FindFirstChild("SukitFly") then
            local bv = Instance.new("BodyVelocity")
            bv.Name = "SukitFly"
            bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
            bv.Velocity = Vector3.zero
            bv.Parent = hrp
        end
        hrp.CFrame = targetHRP.CFrame * CFrame.new(0, _G.Distance, 0) * CFrame.Angles(math.rad(-90), 0, 0)
    end
end

local function ClearHover()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") and char.HumanoidRootPart:FindFirstChild("SukitFly") then
        char.HumanoidRootPart.SukitFly:Destroy()
    end
end

local function StoreAllFruits()
    for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
        if string.find(tool.Name, "Fruit") then
            pcall(function()
                ReplicatedStorage.Remotes.CommF_:InvokeServer("StoreFruit", tool.Name, tool)
            end)
        end
    end
end

local function GrabFruits()
    for _, obj in pairs(workspace:GetChildren()) do
        if string.find(obj.Name, "Fruit") or (obj:IsA("Tool") and string.find(obj.Name, "Fruit")) then
            local handle = obj:FindFirstChild("Handle") or obj:FindFirstChildOfClass("Part")
            if handle and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = handle.CFrame
                task.wait(0.5)
            end
        end
    end
end

-- ==========================================
-- 1. หมวดหมู่ MAIN (ไก่ตัน 1-700+)
-- ==========================================
AddButton(PageMain, "เริ่มทำไก่ตัน (Auto All 1-700+)", function(btn)
    _G.AutoKaitan = not _G.AutoKaitan
    btn.Text = _G.AutoKaitan and "หยุดทำไก่ตัน [กำลังทำงาน...]" or "เริ่มทำไก่ตัน (Auto All 1-700+)"
    btn.BackgroundColor3 = _G.AutoKaitan and Color3.fromRGB(40, 100, 40) or Color3.fromRGB(35, 35, 35)
    if not _G.AutoKaitan then ClearHover() end
end)

AddButton(PageMain, "อัพสเตตัสอัตโนมัติ: ON/OFF", function(btn)
    _G.AutoStats = not _G.AutoStats
    btn.Text = "อัพสเตตัสอัตโนมัติ: " .. (_G.AutoStats and "ON" or "OFF")
end)

AddButton(PageMain, "เน้นอัพ: Melee (สายหมัด)", function() _G.StatFocus = "Melee" end)
AddButton(PageMain, "เน้นอัพ: Defense (สายเลือด)", function() _G.StatFocus = "Defense" end)
AddButton(PageMain, "เน้นอัพ: Sword (สายดาบ)", function() _G.StatFocus = "Sword" end)
AddButton(PageMain, "เน้นอัพ: Demon Fruit (สายผล)", function() _G.StatFocus = "Demon Fruit" end)

AddButton(PageMain, "กดรับโค้ดทั้งหมด (Auto Redeem Codes)", function()
    local codes = {"SUB2GAMERROBOT_RESET1", "KITTGAMING", "Sub2Fer999", "Enyu_is_Pro", "Magicbus", "JCWK", "Starcodeheo", "Bluxxy"}
    for _, code in ipairs(codes) do
        ReplicatedStorage.Remotes.CommF_:InvokeServer("RedeemCode", code)
        task.wait(0.2)
    end
end)

-- ==========================================
-- 2. หมวดหมู่ ระบบฟาร์ม / หาของ
-- ==========================================
AddButton(PageFarm, "Auto Farm มอนสเตอร์ตามเวลปัจจุบัน", function(btn)
    _G.AutoFarmMob = not _G.AutoFarmMob
    btn.Text = _G.AutoFarmMob and "หยุด Auto Farm" or "Auto Farm มอนสเตอร์ตามเวลปัจจุบัน"
    btn.BackgroundColor3 = _G.AutoFarmMob and Color3.fromRGB(40, 100, 40) or Color3.fromRGB(35, 35, 35)
    if not _G.AutoFarmMob then ClearHover() end
end)

AddButton(PageFarm, "วาร์ปไปเก็บผลตกพื้นทันที (Grab Fruits)", function()
    GrabFruits()
end)

AddButton(PageFarm, "เก็บผลเข้าคลังอัตโนมัติ (Store Fruits)", function()
    StoreAllFruits()
end)

AddButton(PageFarm, "Auto Quest Saber (ดาบแชงคูส)", function()
    local saber = workspace.Enemies:FindFirstChild("Saber Expert")
    if saber and saber:FindFirstChild("HumanoidRootPart") then
        EquipWeapon()
        HoverAbove(saber.HumanoidRootPart)
        FastAttack()
    end
end)

AddButton(PageFarm, "ล่าบอส Gorilla King (Lv. 25)", function()
    local boss = workspace.Enemies:FindFirstChild("Gorilla King")
    if boss and boss:FindFirstChild("HumanoidRootPart") then
        EquipWeapon(); HoverAbove(boss.HumanoidRootPart); FastAttack()
    end
end)

AddButton(PageFarm, "ล่าบอส Bobby (Lv. 55)", function()
    local boss = workspace.Enemies:FindFirstChild("Bobby")
    if boss and boss:FindFirstChild("HumanoidRootPart") then
        EquipWeapon(); HoverAbove(boss.HumanoidRootPart); FastAttack()
    end
end)

AddButton(PageFarm, "ล่าบอส Yeti (Lv. 110)", function()
    local boss = workspace.Enemies:FindFirstChild("Yeti")
    if boss and boss:FindFirstChild("HumanoidRootPart") then
        EquipWeapon(); HoverAbove(boss.HumanoidRootPart); FastAttack()
    end
end)

AddButton(PageFarm, "ล่าบอส Vice Admiral (Lv. 130)", function()
    local boss = workspace.Enemies:FindFirstChild("Vice Admiral")
    if boss and boss:FindFirstChild("HumanoidRootPart") then
        EquipWeapon(); HoverAbove(boss.HumanoidRootPart); FastAttack()
    end
end)

-- ==========================================
-- 3. หมวดหมู่ SHOP (ซื้อของ / สุ่มผล)
-- ==========================================
AddButton(PageShop, "🎲 สุ่มผลปีศาจ (Random Fruit)", function()
    ReplicatedStorage.Remotes.CommF_:InvokeServer("Cousin", "Buy")
end)

AddButton(PageShop, "เปิดระบบ Auto สุ่มผลปีศาจเมื่อเงินพอ", function(btn)
    _G.AutoRandomFruit = not _G.AutoRandomFruit
    btn.Text = "Auto สุ่มผลปีศาจ: " .. (_G.AutoRandomFruit and "ON" or "OFF")
end)

AddButton(PageShop, "ซื้อหมัด Black Leg (50,000 Beli)", function()
    ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyItem", "Black Leg")
end)
AddButton(PageShop, "ซื้อหมัด Electro (500,000 Beli)", function()
    ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyItem", "Electro")
end)
AddButton(PageShop, "ซื้อหมัด Fishman Karate (750,000 Beli)", function()
    ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyItem", "Fishman Karate")
end)

AddButton(PageShop, "ซื้อฮาคิเกราะ (Buso Haki - 25k)", function() ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyHaki", "Buso") end)
AddButton(PageShop, "ซื้อเดินบนอากาศ (Geppo - 10k)", function() ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyHaki", "Geppo") end)
AddButton(PageShop, "ซื้อวาร์ปประชิด (Soru - 100k)", function() ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyHaki", "Soru") end)
AddButton(PageShop, "ซื้อฮาคิสังเกต (Ken Haki - 750k)", function() ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyHaki", "Ken") end)

AddButton(PageShop, "ซื้อดาบ Dual Katana (12,000 Beli)", function() ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyItem", "Dual Katana") end)
AddButton(PageShop, "ซื้อดาบ Iron Mace (25,000 Beli)", function() ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyItem", "Iron Mace") end)
AddButton(PageShop, "ซื้อดาบ Triple Katana (60,000 Beli)", function() ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyItem", "Triple Katana") end)

-- ==========================================
-- 4. หมวดหมู่ TELEPORT (วาร์ปครบทุกเกาะ)
-- ==========================================
AddButton(PageTP, "🏝️ เกาะเริ่มต้น (Starter Island)", function() LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1060, 16, 1548) end)
AddButton(PageTP, "🐒 เกาะลิง (Jungle)", function() LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1601, 36, 153) end)
AddButton(PageTP, "🏴‍☠️ เกาะบกโจร (Pirate Village)", function() LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1115, 4, 3850) end)
AddButton(PageTP, "🌵 เกาะทะเลทราย (Desert)", function() LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(895, 6, 4370) end)
AddButton(PageTP, "❄️ เกาะหิมะ (Snow Island)", function() LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1285, 26, -1372) end)
AddButton(PageTP, "🛡️ เกาะทหารเรือ (Marineford)", function() LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-4855, 20, 4300) end)
AddButton(PageTP, "☁️ เกาะลอยฟ้า (Skypiea)", function() LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-4840, 717, -2620) end)
AddButton(PageTP, "🔒 คุกเขตเข้มงวด (Prison)", function() LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(5300, 1, 470) end)
AddButton(PageTP, "🌋 เกาะลาวา (Magma Village)", function() LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-5400, 8, 8500) end)
AddButton(PageTP, "🧜‍♂️ เกาะมนุษย์กั้ง (Underwater)", function() LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(61100, 18, 1560) end)
AddButton(PageTP, "⛲ เมืองน้ำพุ (Fountain City)", function() LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(5600, 2, 4900) end)
AddButton(PageTP, "🌊 วาร์ปไป โลก 2 (Second Sea Lv.700+)", function() ReplicatedStorage.Remotes.CommF_:InvokeServer("TravelMain") end)

-- ==========================================
-- 5. หมวดหมู่ PVP / VISUALS
-- ==========================================
AddButton(PagePVP, "เปิด/ปิด ESP ผู้เล่น (Player Highlight)", function(btn)
    _G.PlayerESP = not _G.PlayerESP
    btn.Text = "ESP ผู้เล่น: " .. (_G.PlayerESP and "ON" or "OFF")
    if _G.PlayerESP then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and not p.Character:FindFirstChild("SukitHighlight") then
                local hl = Instance.new("Highlight")
                hl.Name = "SukitHighlight"
                hl.FillColor = Color3.fromRGB(255, 0, 0)
                hl.Parent = p.Character
            end
        end
    else
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("SukitHighlight") then
                p.Character.SukitHighlight:Destroy()
            end
        end
    end
end)

AddButton(PagePVP, "เปิด/ปิด กระโดดไม่จำกัด (Infinite Jump)", function(btn)
    _G.InfJump = not _G.InfJump
    btn.Text = "กระโดดรัวๆ (Inf Jump): " .. (_G.InfJump and "ON" or "OFF")
end)

AddButton(PagePVP, "เพิ่มความเร็วการวิ่ง (Speed Boost)", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 100
    end
end)

AddButton(PagePVP, "วาร์ปไป Safe Zone (เซฟโซนปลอดภัย)", function()
    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1060, 100, 1548)
end)

-- ==========================================
-- 6. หมวดหมู่ SETTINGS (ตั้งค่า)
-- ==========================================
AddButton(PageSettings, "ระยะลอยตัว: 8.5 บล็อก (ปกติ)", function(btn)
    if _G.Distance == 8.5 then
        _G.Distance = 12
        btn.Text = "ระยะลอยตัว: 12 บล็อก (สูงปลอดภัย)"
    else
        _G.Distance = 8.5
        btn.Text = "ระยะลอยตัว: 8.5 บล็อก (ปกติ)"
    end
end)

AddButton(PageSettings, "ย้ายเซิร์ฟเวอร์ใหม่ (Server Hop)", function()
    TeleportService:Teleport(game.PlaceId, LocalPlayer)
end)

AddButton(PageSettings, "รีโหลดเข้าเกมใหม่ (Rejoin Game)", function()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end)

AddButton(PageSettings, "🛑 ปิดใช้งาน UI ถาวร (Destroy UI)", function()
    _G.AutoKaitan = false
    _G.AutoFarmMob = false
    ClearHover()
    ScreenGui:Destroy()
end)

-- ==========================================
-- BACKGROUND LOOPS & EVENTS
-- ==========================================

-- ระบบ Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if _G.InfJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- ระบบ Auto Stat
task.spawn(function()
    while task.wait(0.5) do
        if (_G.AutoKaitan or _G.AutoStats) and LocalPlayer:FindFirstChild("Data") then
            pcall(function()
                ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", _G.StatFocus, 1)
                ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Defense", 1)
            end)
        end
    end
end)

-- ระบบ Auto Random Fruit สุ่มผลอัตโนมัติ
task.spawn(function()
    while task.wait(5) do
        if _G.AutoRandomFruit then
            pcall(function()
                ReplicatedStorage.Remotes.CommF_:InvokeServer("Cousin", "Buy")
                StoreAllFruits()
            end)
        end
    end
end)

-- ลูปการตีมอนสเตอร์หลัก (Auto Kaitan / Auto Farm)
task.spawn(function()
    while task.wait() do
        if _G.AutoKaitan or _G.AutoFarmMob then
            pcall(function()
                local level = LocalPlayer.Data.Level.Value
                
                if level >= 700 and _G.AutoKaitan then
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("TravelMain")
                    return
                end

                local currentMob = "Bandit"
                for _, mobInfo in ipairs(MobLevelTable) do
                    if level >= mobInfo.Min and level <= mobInfo.Max then
                        currentMob = mobInfo.Name
                        break
                    end
                end

                local target = nil
                for _, enemy in pairs(workspace.Enemies:GetChildren()) do
                    if enemy.Name == currentMob and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                        target = enemy
                        break
                    end
                end

                if target and target:FindFirstChild("HumanoidRootPart") then
                    EquipWeapon()
                    HoverAbove(target.HumanoidRootPart)
                    FastAttack()
                else
                    ClearHover()
                end
            end)
        end
    end
end)

-- ปิดการชน (Noclip)
RunService.Stepped:Connect(function()
    if (_G.AutoKaitan or _G.AutoFarmMob) and LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)
