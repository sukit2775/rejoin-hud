-- =================================================================
-- SUKIT HUB : MASTER ALL-IN-ONE SCRIPT (COMPLETE VERSION)
-- รองรับโหมด: Normal_Script / Kaitun_Script
-- =================================================================

-- 1. ตัวเลือกโหมดสคริปต์ (ตั้งค่าโหมดตรงนี้)
getgenv().Script_Mode = getgenv().Script_Mode or "Normal_Script" -- "Normal_Script" หรือ "Kaitun_Script"

-- 2. SYSTEM CONFIGURATION
_G.Config = {
    ScriptMode = getgenv().Script_Mode,
    MasterFarm = true,             -- เปิด/ปิด ระบบฟาร์มอัตโนมัติ
    FastAttack = true,             -- เปิด/ปิด โจมตีเร็ว
    BringMob = true,               -- เปิด/ปิด รวมมอนสเตอร์
    AutoStats = true,              -- เปิด/ปิด อัปสเตตัส
    TargetStat = "Melee",          -- สายสเตตัสที่จะอัป: Melee, Defense, Sword, DemonFruit
    AutoRollFruit = true,          -- เปิด/ปิด สุ่มผลแมพ
    DistanceAboveMob = 6,          -- ระยะลอยตัวเหนือหัวมอนสเตอร์
    
    -- [การตั้งค่า Discord Webhook & Icon]
    UI = {
        IconURL = "https://i.ibb.co/bgQ9GgKv/icon-SUKITHUB.jpg",
        IconFileName = "SUKIT_HUB_Icon_v2.jpg"
    },
    Discord = {
        EnableWebhook = false,
        WebhookURL = "YOUR_WEBHOOK_URL_HERE",
        NotifyLevelUp = true
    }
}

-- Global Variables & Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer

local CommF = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")
local MobFolder = Workspace:FindFirstChild("Enemies") or Workspace:FindFirstChild("Mobs") or Workspace

-- ตารางบันทึกกิจกรรมเรียลไทม์
local ActionLogs = {}
local function AddLog(msg)
    local timestamp = os.date("%X")
    local formattedMsg = "[" .. timestamp .. "] " .. msg
    table.insert(ActionLogs, 1, formattedMsg)
    if #ActionLogs > 20 then table.remove(ActionLogs) end
end

AddLog("เริ่มต้นระบบ SUKIT HUB : " .. getgenv().Script_Mode)

-- =================================================================
-- 3. GLOBAL FAST ATTACK ENGINE (Blox Fruits CombatFramework)
-- =================================================================
task.spawn(function()
    RunService.RenderStepped:Connect(function()
        pcall(function()
            if _G.Config.FastAttack or _G.FastAttack then
                local playerScripts = LocalPlayer:FindFirstChild("PlayerScripts")
                if playerScripts and playerScripts:FindFirstChild("CombatFramework") then
                    local combatModule = playerScripts.CombatFramework
                    local Combat = require(combatModule)
                    
                    -- ปิดเอฟเฟกต์กล้องสั่น
                    if combatModule:FindFirstChild("CameraShaker") then
                        local CameraShaker = require(combatModule.CameraShaker)
                        if CameraShaker and CameraShaker.CameraShakeInstance then
                            CameraShaker.CameraShakeInstance.CameraShakeState = {
                                FadingIn = 3, FadingOut = 2, Sustained = 0, Inactive = 1
                            }
                        end
                    end

                    -- ขยายวงโจมตีและปรับเวลาการตีให้เป็น 0
                    if Combat and Combat.activeController then
                        Combat.activeController.timeToNextAttack = 0
                        Combat.activeController.hitboxMagnitude = 120
                        Combat.activeController.increment = 3
                    end
                end
            end
        end)
    end)
end)

-- =================================================================
-- 4. TWEEN TELEPORTATION & BRING MOB ENGINE
-- =================================================================
RunService.Stepped:Connect(function()
    if _G.Config.MasterFarm and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

local function SafeTween(targetCFrame, speed)
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = LocalPlayer.Character.HumanoidRootPart
    local distance = (hrp.Position - targetCFrame.Position).Magnitude
    local duration = distance / (speed or 250)
    
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
    
    local bv = Instance.new("BodyVelocity")
    bv.Velocity = Vector3.new(0, 0, 0)
    bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bv.Parent = hrp
    
    tween:Play()
    tween.Completed:Wait()
    bv:Destroy()
end

local function BringMonstersToPoint(mobName, targetCFrame)
    if not _G.Config.BringMob then return end
    for _, mob in pairs(MobFolder:GetChildren()) do
        if mob:IsA("Model") and (mob.Name == mobName or mob.Name:find(mobName)) then
            local hrp = mob:FindFirstChild("HumanoidRootPart")
            local hum = mob:FindFirstChild("Humanoid")
            if hrp and hum and hum.Health > 0 then
                if (hrp.Position - targetCFrame.Position).Magnitude < 200 then
                    hrp.CanCollide = false
                    hrp.CFrame = targetCFrame
                end
            end
        end
    end
end

-- =================================================================
-- 5. FULL MAP SHOP SYSTEM (SEA 1, 2, 3)
-- =================================================================
local Shop = {}

-- ฮาคิ และ อบิลิตี้
function Shop:BuyBusoHaki() return CommF:InvokeServer("BuyHaki", "Buso") end
function Shop:BuyGeppo() return CommF:InvokeServer("BuyHaki", "Geppo") end
function Shop:BuySori() return CommF:InvokeServer("BuyHaki", "Sori") end
function Shop:BuyKenHaki() return CommF:InvokeServer("BuyKenHaki") end

-- หมัด / สไตล์การต่อสู้ (ทุกโลก)
function Shop:BuyBlackLeg() return CommF:InvokeServer("BuyBlackLeg") end
function Shop:BuyElectro() return CommF:InvokeServer("BuyElectro") end
function Shop:BuyFishmanKarate() return CommF:InvokeServer("BuyFishmanKarate") end
function Shop:BuyDragonClaw() return CommF:InvokeServer("BlackbeardReward", "DragonClaw", "1") end
function Shop:BuySuperhuman() return CommF:InvokeServer("BuySuperhuman") end
function Shop:BuyDeathStep() return CommF:InvokeServer("BuyDeathStep") end
function Shop:BuySharkmanKarate() return CommF:InvokeServer("BuySharkmanKarate") end
function Shop:BuyElectricClaw() return CommF:InvokeServer("BuyElectricClaw") end
function Shop:BuyDragonTalon() return CommF:InvokeServer("BuyDragonTalon") end
function Shop:BuyGodhuman() return CommF:InvokeServer("BuyGodhuman") end

-- ดาบ & ปืน
function Shop:BuyKatana() return CommF:InvokeServer("BuyItem", "Katana") end
function Shop:BuyCutlass() return CommF:InvokeServer("BuyItem", "Cutlass") end
function Shop:BuyDualKatana() return CommF:InvokeServer("BuyItem", "Dual Katana") end
function Shop:BuyTripleKatana() return CommF:InvokeServer("BuyItem", "Triple Katana") end
function Shop:BuySoulCane() return CommF:InvokeServer("BuyItem", "Soul Cane") end
function Shop:BuyBisento() return CommF:InvokeServer("BuyItem", "Bisento") end
function Shop:BuyCannon() return CommF:InvokeServer("BuyItem", "Cannon") end
function Shop:BuyKabucha() return CommF:InvokeServer("BlackbeardReward", "Slingshot", "2") end

-- สุ่มผล / รีสเตตัส / รีเผ่า
function Shop:RandomFruit() return CommF:InvokeServer("Cousin", "Buy") end
function Shop:ResetStatsBeli() return CommF:InvokeServer("BlackbeardReward", "Refund", "1") end
function Shop:ResetStatsFragments() return CommF:InvokeServer("BlackbeardReward", "Refund", "2") end
function Shop:RerollRace() return CommF:InvokeServer("BlackbeardReward", "Reroll", "2") end

_G.Shop = Shop

-- =================================================================
-- 6. DYNAMIC LEVEL & QUEST DATA MANAGER (FULL QUEST SYSTEM)
-- =================================================================
local function GetPlayerLevel()
    pcall(function()
        return LocalPlayer.Data.Level.Value
    end)
    return 1
end

local function GetCurrentQuestZone()
    local lvl = GetPlayerLevel()
    
    if lvl >= 1 and lvl < 15 then
        return {Mob = "Bandit", Quest = "BanditQuest1", QuestID = 1, NPC = "Bandit Quest Giver", CFrame = CFrame.new(1050, 15, -1200)}
    elseif lvl >= 15 and lvl < 30 then
        return {Mob = "Monkey", Quest = "JungleQuest", QuestID = 1, NPC = "Jungle Quest Giver", CFrame = CFrame.new(-1500, 20, 300)}
    elseif lvl >= 30 and lvl < 40 then
        return {Mob = "Gorilla", Quest = "JungleQuest", QuestID = 2, NPC = "Jungle Quest Giver", CFrame = CFrame.new(-1240, 15, -500)}
    elseif lvl >= 40 and lvl < 60 then
        return {Mob = "Pirate", Quest = "BuggyQuest1", QuestID = 1, NPC = "Pirate Quest Giver", CFrame = CFrame.new(-1140, 15, 3800)}
    elseif lvl >= 60 and lvl < 90 then
        return {Mob = "Desert Bandit", Quest = "DesertQuest", QuestID = 1, NPC = "Desert Quest Giver", CFrame = CFrame.new(895, 15, 4390)}
    elseif lvl >= 90 and lvl < 120 then
        return {Mob = "Snow Bandit", Quest = "SnowQuest", QuestID = 1, NPC = "Snow Quest Giver", CFrame = CFrame.new(1280, 15, -1300)}
    elseif lvl >= 120 and lvl < 150 then
        return {Mob = "Chief Pirate", Quest = "MarineQuest2", QuestID = 1, NPC = "Marine Quest Giver", CFrame = CFrame.new(-5030, 20, 4320)}
    elseif lvl >= 150 and lvl < 190 then
        return {Mob = "Sky Bandit", Quest = "SkyQuest", QuestID = 1, NPC = "Sky Quest Giver", CFrame = CFrame.new(-4840, 715, -2620)}
    elseif lvl >= 190 and lvl < 250 then
        return {Mob = "Prisoner", Quest = "PrisonerQuest", QuestID = 1, NPC = "Prison Quest Giver", CFrame = CFrame.new(4870, 5, 735)}
    else
        return {Mob = "Toga Warrior", Quest = "ColosseumQuest", QuestID = 1, NPC = "Colosseum Quest Giver", CFrame = CFrame.new(-1430, 8, -2760)}
    end
end

local function CheckAndStartQuest(zone)
    local hasQuest = false
    pcall(function()
        hasQuest = LocalPlayer.PlayerGui.MainQuest.Visible
    end)
    
    if not hasQuest then
        AddLog("กำลังไปรับเควสต์: " .. zone.Quest)
        
        -- ส่ง Remote รับเควสต์โดยตรง
        pcall(function()
            CommF:InvokeServer("StartQuest", zone.Quest, zone.QuestID)
        end)
        task.wait(0.5)
    end
end

-- =================================================================
-- 7. AUTO STATS ALLOCATION
-- =================================================================
task.spawn(function()
    while task.wait(2) do
        if _G.Config.MasterFarm and _G.Config.AutoStats then
            pcall(function()
                local points = LocalPlayer.Data.Points.Value
                if points and points > 0 then
                    CommF:InvokeServer("AddPoint", _G.Config.TargetStat, points)
                end
            end)
        end
    end
end)

-- =================================================================
-- 8. FULL UI SYSTEM (SUKIT HUB THEME)
-- =================================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SukitHubMasterCompleteGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 9999

if gethui then
    ScreenGui.Parent = gethui()
elseif syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = CoreGui
elseif CoreGui:FindFirstChild("RobloxGui") then
    ScreenGui.Parent = CoreGui
else
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- Floating Icon Button
local ToggleIcon = Instance.new("ImageButton")
local IconCorner = Instance.new("UICorner")
local IconStroke = Instance.new("UIStroke")

ToggleIcon.Name = "ToggleIcon"
ToggleIcon.Parent = ScreenGui
ToggleIcon.Size = UDim2.new(0, 60, 0, 60)
ToggleIcon.Position = UDim2.new(0.04, 0, 0.2, 0)
ToggleIcon.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
ToggleIcon.Active = true
ToggleIcon.Draggable = true

IconCorner.CornerRadius = UDim.new(1, 0)
IconCorner.Parent = ToggleIcon

IconStroke.Thickness = 2.5
IconStroke.Color = Color3.fromRGB(0, 255, 150)
IconStroke.Parent = ToggleIcon

task.spawn(function()
    pcall(function()
        local url = _G.Config.UI.IconURL
        local file = _G.Config.UI.IconFileName
        if writefile and getcustomasset then
            if not isfile(file) then writefile(file, game:HttpGet(url)) end
            ToggleIcon.Image = getcustomasset(file)
        else
            ToggleIcon.Image = url
        end
    end)
end)

-- Main UI Frame
local MainFrame = Instance.new("Frame")
local MainCorner = Instance.new("UICorner")
local MainStroke = Instance.new("UIStroke")
local TitleLabel = Instance.new("TextLabel")

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 360, 0, 460)
MainFrame.Position = UDim2.new(0.5, -180, 0.5, -230)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainFrame.Active = true
MainFrame.Draggable = true

MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

MainStroke.Thickness = 2
MainStroke.Color = Color3.fromRGB(0, 255, 150)
MainStroke.Parent = MainFrame

TitleLabel.Parent = MainFrame
TitleLabel.Size = UDim2.new(1, 0, 0, 40)
TitleLabel.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
TitleLabel.Text = "SUKIT HUB : " .. string.upper(_G.Config.ScriptMode)
TitleLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
TitleLabel.TextSize = 15
TitleLabel.Font = Enum.Font.SourceSansBold

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleLabel

-- Tab Buttons Header
local TabContainer = Instance.new("Frame")
TabContainer.Parent = MainFrame
TabContainer.Size = UDim2.new(1, -20, 0, 30)
TabContainer.Position = UDim2.new(0, 10, 0, 45)
TabContainer.BackgroundTransparency = 1

local FarmTabBtn = Instance.new("TextButton")
local ShopTabBtn = Instance.new("TextButton")

FarmTabBtn.Parent = TabContainer
FarmTabBtn.Size = UDim2.new(0.48, 0, 1, 0)
FarmTabBtn.Position = UDim2.new(0, 0, 0, 0)
FarmTabBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 90)
FarmTabBtn.Text = "🌾 Auto Farm"
FarmTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FarmTabBtn.Font = Enum.Font.SourceSansBold

ShopTabBtn.Parent = TabContainer
ShopTabBtn.Size = UDim2.new(0.48, 0, 1, 0)
ShopTabBtn.Position = UDim2.new(0.52, 0, 0, 0)
ShopTabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ShopTabBtn.Text = "🛒 Full Shop"
ShopTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ShopTabBtn.Font = Enum.Font.SourceSansBold

Instance.new("UICorner", FarmTabBtn).CornerRadius = UDim.new(0, 6)
Instance.new("UICorner", ShopTabBtn).CornerRadius = UDim.new(0, 6)

-- Pages
local FarmPage = Instance.new("Frame")
local ShopPage = Instance.new("ScrollingFrame")

FarmPage.Parent = MainFrame
FarmPage.Size = UDim2.new(1, -20, 1, -90)
FarmPage.Position = UDim2.new(0, 10, 0, 80)
FarmPage.BackgroundTransparency = 1
FarmPage.Visible = true

ShopPage.Parent = MainFrame
ShopPage.Size = UDim2.new(1, -20, 1, -90)
ShopPage.Position = UDim2.new(0, 10, 0, 80)
ShopPage.BackgroundTransparency = 1
ShopPage.CanvasSize = UDim2.new(0, 0, 0, 0)
ShopPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
ShopPage.Visible = false

local ShopLayout = Instance.new("UIListLayout")
ShopLayout.Parent = ShopPage
ShopLayout.Padding = UDim.new(0, 5)

FarmTabBtn.MouseButton1Click:Connect(function()
    FarmPage.Visible = true
    ShopPage.Visible = false
    FarmTabBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 90)
    ShopTabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
end)

ShopTabBtn.MouseButton1Click:Connect(function()
    FarmPage.Visible = false
    ShopPage.Visible = true
    ShopTabBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 90)
    FarmTabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
end)

-- Main Master Toggle Button
local MasterBtn = Instance.new("TextButton")
MasterBtn.Parent = FarmPage
MasterBtn.Size = UDim2.new(1, 0, 0, 45)
MasterBtn.BackgroundColor3 = _G.Config.MasterFarm and Color3.fromRGB(0, 180, 90) or Color3.fromRGB(180, 40, 40)
MasterBtn.Text = "🔥 AUTO FARM (ทำงานอัตโนมัติ) : " .. (_G.Config.MasterFarm and "ON" or "OFF")
MasterBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MasterBtn.Font = Enum.Font.SourceSansBold
MasterBtn.TextSize = 14
Instance.new("UICorner", MasterBtn).CornerRadius = UDim.new(0, 8)

MasterBtn.MouseButton1Click:Connect(function()
    _G.Config.MasterFarm = not _G.Config.MasterFarm
    MasterBtn.BackgroundColor3 = _G.Config.MasterFarm and Color3.fromRGB(0, 180, 90) or Color3.fromRGB(180, 40, 40)
    MasterBtn.Text = "🔥 AUTO FARM (ทำงานอัตโนมัติ) : " .. (_G.Config.MasterFarm and "ON" or "OFF")
    AddLog("สลับสถานะ Auto Farm: " .. (_G.Config.MasterFarm and "เปิด" or "ปิด"))
end)

-- Activity Log Box
local LogBox = Instance.new("ScrollingFrame")
LogBox.Parent = FarmPage
LogBox.Size = UDim2.new(1, 0, 0, 220)
LogBox.Position = UDim2.new(0, 0, 0, 55)
LogBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
LogBox.CanvasSize = UDim2.new(0, 0, 0, 0)
LogBox.AutomaticCanvasSize = Enum.AutomaticSize.Y
Instance.new("UICorner", LogBox).CornerRadius = UDim.new(0, 8)

local LogLayout = Instance.new("UIListLayout")
LogLayout.Parent = LogBox
LogLayout.Padding = UDim.new(0, 3)

local function UpdateLogDisplay()
    for _, child in pairs(LogBox:GetChildren()) do
        if child:IsA("TextLabel") then child:Destroy() end
    end
    for _, txt in ipairs(ActionLogs) do
        local lbl = Instance.new("TextLabel")
        lbl.Parent = LogBox
        lbl.Size = UDim2.new(1, -10, 0, 18)
        lbl.BackgroundTransparency = 1
        lbl.Text = txt
        lbl.TextColor3 = Color3.fromRGB(180, 255, 200)
        lbl.TextSize = 11
        lbl.Font = Enum.Font.SourceSans
        lbl.TextXAlignment = Enum.TextXAlignment.Left
    end
end

task.spawn(function()
    while task.wait(0.5) do
        UpdateLogDisplay()
    end
end)

-- ปุ่มสร้างไอเทม Shop ทั้งหมด
local function AddShopButton(name, fn)
    local btn = Instance.new("TextButton")
    btn.Parent = ShopPage
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.Text = "🛒 " .. name
    btn.TextColor3 = Color3.fromRGB(0, 255, 150)
    btn.Font = Enum.Font.SourceSansSemibold
    btn.TextSize = 13
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    btn.MouseButton1Click:Connect(function()
        pcall(function()
            fn()
            AddLog("สั่งซื้อ: " .. name)
        end)
    end)
end

AddShopButton("ฮาคิเกราะ (Buso Haki)", function() Shop:BuyBusoHaki() end)
AddShopButton("วิชาตัวเบา (Geppo)", function() Shop:BuyGeppo() end)
AddShopButton("หลบหลีก (Sori)", function() Shop:BuySori() end)
AddShopButton("ฮาคิสังเกต (Ken Haki)", function() Shop:BuyKenHaki() end)
AddShopButton("หมัดซันจิ (Black Leg)", function() Shop:BuyBlackLeg() end)
AddShopButton("หมัดสายฟ้า (Electro)", function() Shop:BuyElectro() end)
AddShopButton("หมัดเงือก (Fishman Karate)", function() Shop:BuyFishmanKarate() end)
AddShopButton("หมัดมังกร (Dragon Claw)", function() Shop:BuyDragonClaw() end)
AddShopButton("ซูเปอร์แมน (Superhuman)", function() Shop:BuySuperhuman() end)
AddShopButton("ก๊อดแมน (Godhuman)", function() Shop:BuyGodhuman() end)
AddShopButton("🎲 สุ่มผลไม้ (Random Fruit)", function() Shop:RandomFruit() end)
AddShopButton("🔄 รีสเตตัส (Reset Stats - Beli)", function() Shop:ResetStatsBeli() end)
AddShopButton("🧬 สุ่มเผ่า (Reroll Race)", function() Shop:RerollRace() end)

ToggleIcon.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- =================================================================
-- 9. MAIN AUTO FARM LOOP (ครบจบทุกระบบ)
-- =================================================================
task.spawn(function()
    local lastLvl = 0

    while task.wait(0.1) do
        if _G.Config.MasterFarm then
            pcall(function()
                local player = LocalPlayer
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.Humanoid.Health > 0 then
                    
                    local currentLvl = GetPlayerLevel()
                    if lastLvl ~= 0 and currentLvl > lastLvl then
                        AddLog("🎉 เลเวลอัปเป็น: " .. currentLvl)
                    end
                    lastLvl = currentLvl

                    -- ดึงข้อมูลเควสต์และมอนสเตอร์ปัจจุบัน
                    local zone = GetCurrentQuestZone()
                    
                    -- Step 1: ตรวจสอบและรับเควสต์อัตโนมัติ
                    CheckAndStartQuest(zone)
                    
                    -- Step 2: ค้นหามอนสเตอร์เป้าหมายในระยะ
                    local targetMob = nil
                    for _, mob in pairs(MobFolder:GetChildren()) do
                        if mob:IsA("Model") and (mob.Name == zone.Mob or mob.Name:find(zone.Mob)) then
                            local hum = mob:FindFirstChild("Humanoid")
                            local hrp = mob:FindFirstChild("HumanoidRootPart")
                            if hum and hrp and hum.Health > 0 then
                                targetMob = mob
                                break
                            end
                        end
                    end
                    
                    -- Step 3: เคลื่อนที่ไปจุดฟาร์ม หรือ ทำการเข้าประชิดแล้วโจมตี
                    if not targetMob then
                        SafeTween(zone.CFrame)
                    else
                        local hum = targetMob:FindFirstChild("Humanoid")
                        local hrp = targetMob:FindFirstChild("HumanoidRootPart")
                        
                        while hum and hum.Health > 0 and _G.Config.MasterFarm and hrp do
                            task.wait(0.01)
                            
                            -- ลอยตัวเหนือหัวมอนสเตอร์
                            local attackCFrame = hrp.CFrame * CFrame.new(0, _G.Config.DistanceAboveMob, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                            player.Character.HumanoidRootPart.CFrame = attackCFrame
                            
                            -- ดึงมอนสเตอร์ตัวอื่นมารวม
                            BringMonstersToPoint(zone.Mob, hrp.CFrame)
                            
                            -- จำลองการคลิกโจมตี
                            VirtualUser:CaptureController()
                            VirtualUser:ClickButton1(Vector2.new(500, 500))
                        end
                    end
                end
            end)
        end
    end
end)

print("[SUKIT HUB] สคริปต์ฉบับสมบูรณ์พร้อมใช้งานแล้ว!")
