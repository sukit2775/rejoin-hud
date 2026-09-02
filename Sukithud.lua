-- =================================================================
-- SUKIT HUB : FULL SYSTEM + MOB DETECTOR + BRING MOB + AUTO FARM
-- =================================================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- Global Toggles & Configs
_G.AutoFarm = false
_G.BringMob = false
_G.FastAttack = false
_G.MobESP = true -- แสดงตำแหน่งมอนสเตอร์บนหน้าจอ
_G.TargetMobName = "Bandit" -- เปลี่ยนเป็นชื่อมอนสเตอร์ในแมพที่เล่น

local MobFolder = Workspace:FindFirstChild("Enemies") or Workspace:FindFirstChild("Mobs") or Workspace

--------------------------------------------------------------------
-- 1. สร้าง ScreenGui
--------------------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SukitHubGui"
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

--------------------------------------------------------------------
-- 2. ปุ่มไอคอนวงกลม (Toggle Icon + ImgBB Auto Loader)
--------------------------------------------------------------------
local ToggleIcon = Instance.new("ImageButton")
local IconCorner = Instance.new("UICorner")
local IconStroke = Instance.new("UIStroke")

ToggleIcon.Name = "ToggleIcon"
ToggleIcon.Parent = ScreenGui
ToggleIcon.Size = UDim2.new(0, 60, 0, 60)
ToggleIcon.Position = UDim2.new(0.04, 0, 0.2, 0)
ToggleIcon.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
ToggleIcon.BackgroundTransparency = 0.1
ToggleIcon.Active = true
ToggleIcon.Draggable = true
ToggleIcon.Visible = true
ToggleIcon.ZIndex = 100

IconCorner.CornerRadius = UDim.new(1, 0)
IconCorner.Parent = ToggleIcon

IconStroke.Thickness = 2.5
IconStroke.Color = Color3.fromRGB(0, 255, 150)
IconStroke.Parent = ToggleIcon

-- ระบบแปลงลิงก์ ImgBB (https://ibb.co/5WGHJWRj) เป็น Direct Link อัตโนมัติ
local imgbbUrl = "https://ibb.co/5WGHJWRj"
local fileName = "SUKIT_HUB_Icon.png"

task.spawn(function()
    pcall(function()
        local directUrl = imgbbUrl
        if not directUrl:find("i.ibb.co") and directUrl:find("ibb.co") then
            local html = game:HttpGet(directUrl)
            local extractedUrl = html:match('https://i%.ibb%.co/[^"\'%s]+')
            if extractedUrl then
                directUrl = extractedUrl
            end
        end

        if writefile and getcustomasset then
            if not isfile(fileName) then
                writefile(fileName, game:HttpGet(directUrl))
            end
            ToggleIcon.Image = getcustomasset(fileName)
        else
            ToggleIcon.Image = directUrl
        end
    end)
end)

--------------------------------------------------------------------
-- 3. หน้าต่างหลัก (Main Hub Window)
--------------------------------------------------------------------
local MainFrame = Instance.new("Frame")
local MainCorner = Instance.new("UICorner")
local MainStroke = Instance.new("UIStroke")
local MainTitle = Instance.new("TextLabel")
local StatusFrame = Instance.new("Frame")
local StatusLabel = Instance.new("TextLabel")
local Container = Instance.new("Frame")
local UIListLayout = Instance.new("UIListLayout")

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 270, 0, 320)
MainFrame.Position = UDim2.new(0.5, -135, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = true
MainFrame.ZIndex = 10

MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

MainStroke.Thickness = 2
MainStroke.Color = Color3.fromRGB(0, 255, 150)
MainStroke.Parent = MainFrame

-- หัวข้อ UI
MainTitle.Name = "Title"
MainTitle.Parent = MainFrame
MainTitle.Size = UDim2.new(1, 0, 0, 42)
MainTitle.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
MainTitle.Text = "SUKIT HUB"
MainTitle.TextColor3 = Color3.fromRGB(0, 255, 150)
MainTitle.TextSize = 18
MainTitle.Font = Enum.Font.SourceSansBold
MainTitle.ZIndex = 11

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = MainTitle

-- 📢 กล่องแสดงสถานะมอนสเตอร์ (Mob Status Indicator)
StatusFrame.Name = "StatusFrame"
StatusFrame.Parent = MainFrame
StatusFrame.Size = UDim2.new(1, -20, 0, 35)
StatusFrame.Position = UDim2.new(0, 10, 0, 48)
StatusFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
StatusFrame.ZIndex = 11

local StatusCorner = Instance.new("UICorner")
StatusCorner.CornerRadius = UDim.new(0, 8)
StatusCorner.Parent = StatusFrame

StatusLabel.Name = "StatusLabel"
StatusLabel.Parent = StatusFrame
StatusLabel.Size = UDim2.new(1, 0, 1, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "🔍 Checking Mobs..."
StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
StatusLabel.TextSize = 13
StatusLabel.Font = Enum.Font.SourceSansSemibold
StatusLabel.ZIndex = 12

-- Container สำหรับปุ่มกด
Container.Name = "Container"
Container.Parent = MainFrame
Container.Size = UDim2.new(1, -20, 1, -95)
Container.Position = UDim2.new(0, 10, 0, 90)
Container.BackgroundTransparency = 1
Container.ZIndex = 11

UIListLayout.Parent = Container
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)

-- ฟังก์ชันสร้างปุ่มเมนู
local function CreateToggleBtn(text, globalFlag)
    local Button = Instance.new("TextButton")
    local Corner = Instance.new("UICorner")
    
    Button.Parent = Container
    Button.Size = UDim2.new(1, 0, 0, 40)
    Button.BackgroundColor3 = _G[globalFlag] and Color3.fromRGB(0, 180, 100) or Color3.fromRGB(40, 40, 40)
    Button.Text = text .. ": " .. (_G[globalFlag] and "ON" or "OFF")
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 14
    Button.Font = Enum.Font.SourceSansSemibold
    Button.ZIndex = 12

    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Button

    Button.MouseButton1Click:Connect(function()
        _G[globalFlag] = not _G[globalFlag]
        Button.BackgroundColor3 = _G[globalFlag] and Color3.fromRGB(0, 180, 100) or Color3.fromRGB(40, 40, 40)
        Button.Text = text .. ": " .. (_G[globalFlag] and "ON" or "OFF")
    end)
    return Button
end

CreateToggleBtn("Auto Farm Level", "AutoFarm")
CreateToggleBtn("Bring Mob (รวมมอน)", "BringMob")
CreateToggleBtn("Fast Attack (ตีเร็ว)", "FastAttack")
CreateToggleBtn("Mob Tracker (แสดงจุดเกิด)", "MobESP")

--------------------------------------------------------------------
-- 4. ระบบเปิด/ปิด UI เมื่อกดปุ่มวงกลม
--------------------------------------------------------------------
ToggleIcon.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

--------------------------------------------------------------------
-- 5. ระบบตรวจจับมอนสเตอร์บนแมพ (Mob Spawn Detector & ESP)
--------------------------------------------------------------------
local function GetActiveMobs()
    local mobList = {}
    for _, mob in pairs(MobFolder:GetChildren()) do
        if mob:IsA("Model") and mob.Name == _G.TargetMobName and mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") then
            if mob.Humanoid.Health > 0 then
                table.insert(mobList, mob)
            end
        end
    end
    return mobList
end

-- ลูปอัปเดตสถานะมอนสเตอร์บน UI เรียลไทม์
task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            local activeMobs = GetActiveMobs()
            local count = #activeMobs
            if count > 0 then
                StatusLabel.Text = "🟢 มอนสเตอร์เกิดแล้ว: " .. tostring(count) .. " ตัว"
                StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
            else
                StatusLabel.Text = "🔴 ยังไม่มีมอนเกิด (กำลังรอ...)"
                StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
            end
        end)
    end
end)

-- ระบบใส่ข้อความลอยบอกตำแหน่งมอนสเตอร์บนแมพ (Mob Tracker ESP)
task.spawn(function()
    while task.wait(1) do
        if _G.MobESP then
            pcall(function()
                local activeMobs = GetActiveMobs()
                for _, mob in pairs(activeMobs) do
                    if not mob.HumanoidRootPart:FindFirstChild("MobTag") then
                        local bb = Instance.new("BillboardGui")
                        bb.Name = "MobTag"
                        bb.Parent = mob.HumanoidRootPart
                        bb.Size = UDim2.new(0, 100, 0, 30)
                        bb.StudsOffset = Vector3.new(0, 3, 0)
                        bb.AlwaysOnTop = true

                        local txt = Instance.new("TextLabel")
                        txt.Parent = bb
                        txt.Size = UDim2.new(1, 0, 1, 0)
                        txt.BackgroundTransparency = 1
                        txt.Text = mob.Name .. " [HP: " .. math.floor(mob.Humanoid.Health) .. "]"
                        txt.TextColor3 = Color3.fromRGB(0, 255, 150)
                        txt.TextStrokeTransparency = 0
                        txt.TextSize = 12
                        txt.Font = Enum.Font.SourceSansBold
                    else
                        local txt = mob.HumanoidRootPart.MobTag:FindFirstChildOfClass("TextLabel")
                        if txt and mob:FindFirstChild("Humanoid") then
                            txt.Text = mob.Name .. " [HP: " .. math.floor(mob.Humanoid.Health) .. "]"
                        end
                    end
                end
            end)
        end
    end
end)

--------------------------------------------------------------------
-- 6. ระบบฟาร์มหลัก (Auto Farm / Bring Mob / Fast Attack)
--------------------------------------------------------------------
local function Teleport(cframe)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = cframe
    end
end

local function FastAttack()
    if not _G.FastAttack then return end
    local character = LocalPlayer.Character
    if character then
        local tool = character:FindFirstChildOfClass("Tool")
        if tool then
            tool:Activate()
        end
    end
end

local function BringMobs(targetName, position)
    if not _G.BringMob then return end
    for _, mob in pairs(MobFolder:GetChildren()) do
        if mob:IsA("Model") and mob.Name == targetName and mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") then
            if mob.Humanoid.Health > 0 then
                mob.HumanoidRootPart.CanCollide = false
                mob.HumanoidRootPart.CFrame = position
            end
        end
    end
end

task.spawn(function()
    while task.wait() do
        if _G.AutoFarm then
            pcall(function()
                local activeMobs = GetActiveMobs()
                for _, mob in pairs(activeMobs) do
                    if mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                        repeat
                            task.wait(0.01)
                            if not _G.AutoFarm then break end
                            
                            -- วาร์ปลอยอยู่เหนือหัวมอนสเตอร์ 10 Studs
                            local farmPos = mob.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0)
                            Teleport(farmPos)
                            
                            -- ดึงมอนตัวอื่นมารวมที่ตำแหน่งมอนเป้าหมาย
                            BringMobs(_G.TargetMobName, mob.HumanoidRootPart.CFrame)
                            
                            -- ตีมอนสเตอร์
                            FastAttack()
                            
                        until not mob:FindFirstChild("Humanoid") or mob.Humanoid.Health <= 0 or not _G.AutoFarm
                    end
                end
            end)
        end
    end
end)
