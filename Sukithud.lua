-- =========================================================
-- SUKIT HUB : AUTO FARM + BRING MOB + FAST ATTACK + ICON UI
-- =========================================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- Global Settings / Toggles
_G.AutoFarm = false
_G.BringMob = false
_G.FastAttack = false

-- Config เป้าหมาย (ปรับชื่อมอนสเตอร์และโฟลเดอร์ตามเกมที่เล่น)
local TargetMobName = "Bandit" 
local MobFolder = Workspace:FindFirstChild("Enemies") or Workspace

---------------------------------------------------------
-- 1. ฟังก์ชันหลัก (Teleport, Bring Mob, Fast Attack)
---------------------------------------------------------

-- ฟังก์ชัน Teleport ย้ายตำแหน่งผู้เล่น
local function Teleport(cframe)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = cframe
    end
end

-- ฟังก์ชัน Fast Attack
local function FastAttack()
    if not _G.FastAttack then return end
    local character = LocalPlayer.Character
    if character then
        local tool = character:FindFirstChildOfClass("Tool")
        if tool then
            tool:Activate() -- สั่งใช้งานอาวุธรัวๆ
        end
    end
    -- หมายเหตุ: หากเกมใช้ RemoteEvent ในการตี สามารถใส่ยิง Remote ตรงนี้ได้
end

-- ฟังก์ชัน Bring Mob (รวมมอนสเตอร์ + ปิด CanCollide ไม่ให้มอนเบียดกันลอย)
local function BringMobs(targetName, position)
    if not _G.BringMob then return end
    for _, mob in pairs(MobFolder:GetChildren()) do
        if mob:IsA("Model") and mob.Name == targetName and mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") then
            if mob.Humanoid.Health > 0 then
                -- ปิด CanCollide ไม่ให้มอนสเตอร์เบียดกันจนลอยขึ้นฟ้า
                mob.HumanoidRootPart.CanCollide = false
                -- ดึงมอนสเตอร์มารวมที่จุดเป้าหมาย
                mob.HumanoidRootPart.CFrame = position
            end
        end
    end
end

---------------------------------------------------------
-- 2. Loop การฟาร์มอัตโนมัติ (Auto Farm Loop)
---------------------------------------------------------

task.spawn(function()
    while task.wait() do
        if _G.AutoFarm then
            pcall(function()
                for _, mob in pairs(MobFolder:GetChildren()) do
                    if mob:IsA("Model") and mob.Name == TargetMobName and mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") then
                        if mob.Humanoid.Health > 0 then
                            -- ล็อคเป้าตีมอนสเตอร์ตัวนี้จนกว่าเลือดจะหมด (Health <= 0)
                            repeat
                                task.wait(0.01)
                                if not _G.AutoFarm then break end
                                
                                -- ลอยอยู่เหนือหัวมอนสเตอร์ 10 Studs
                                local farmPos = mob.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0)
                                Teleport(farmPos)
                                
                                -- รวมมอนสเตอร์ตัวอื่นมาที่ตำแหน่งมอนตัวนี้
                                BringMobs(TargetMobName, mob.HumanoidRootPart.CFrame)
                                
                                -- ตีมอนสเตอร์
                                FastAttack()
                                
                            until not mob:FindFirstChild("Humanoid") or mob.Humanoid.Health <= 0 or not _G.AutoFarm
                        end
                    end
                end
            end)
        end
    end
end)

---------------------------------------------------------
-- 3. ระบบ GUI & ปุ่มไอคอนวงกลมเปิด/ปิด
---------------------------------------------------------

local CoreGui = game:GetService("CoreGui")
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SukitHubGui"
ScreenGui.ResetOnSpawn = false

-- รองรับการรันผ่าน Executor มือถือต่างๆ
if gethui then
    ScreenGui.Parent = gethui()
elseif syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = CoreGui
else
    ScreenGui.Parent = CoreGui
end

-- 🔴 ปุ่มไอคอนวงกลม (Toggle Button)
local ToggleIcon = Instance.new("ImageButton")
local IconCorner = Instance.new("UICorner")
local IconStroke = Instance.new("UIStroke")

ToggleIcon.Name = "ToggleIcon"
ToggleIcon.Parent = ScreenGui
ToggleIcon.Size = UDim2.new(0, 50, 0, 50)
ToggleIcon.Position = UDim2.new(0.03, 0, 0.25, 0)
ToggleIcon.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ToggleIcon.BackgroundTransparency = 0.1
ToggleIcon.Active = true
ToggleIcon.Draggable = true -- สามารถลากขยับปุ่มวงกลมไปวางตรงไหนของหน้าจอก็ได้

-- -------------------------------------------------------------
-- 🖼️ จุดใส่ลิงก์รูปภาพ / GIF Icon (นำลิงก์รูปภาพมาใส่ตรงนี้ได้เลย)
-- -------------------------------------------------------------
ToggleIcon.Image = "loadstring(game:HttpGet("https://raw.githubusercontent.com/sukit2775/rejoin-hud/refs/heads/main/SUKI" -- <--- เอาลิงก์หรือ Asset ID มาวางทับในเครื่องหมายคำพูดนี้

-- ปรับแต่งรูปทรงวงกลม
IconCorner.CornerRadius = UDim.new(1, 0) -- บังคับทรงกลม 100%
IconCorner.Parent = ToggleIcon

IconStroke.Thickness = 2
IconStroke.Color = Color3.fromRGB(0, 255, 150)
IconStroke.Parent = ToggleIcon

-- 📦 หน้าต่างหลัก (Main Hub Window)
local MainFrame = Instance.new("Frame")
local MainCorner = Instance.new("UICorner")
local MainTitle = Instance.new("TextLabel")
local UIListLayout = Instance.new("UIListLayout")
local Container = Instance.new("Frame")

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 240, 0, 260)
MainFrame.Position = UDim2.new(0.5, -120, 0.5, -130)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = true

MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

MainTitle.Name = "Title"
MainTitle.Parent = MainFrame
MainTitle.Size = UDim2.new(1, 0, 0, 40)
MainTitle.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainTitle.Text = "SUKIT HUB"
MainTitle.TextColor3 = Color3.fromRGB(0, 255, 150)
MainTitle.TextSize = 16
MainTitle.Font = Enum.Font.SourceSansBold

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = MainTitle

Container.Parent = MainFrame
Container.Size = UDim2.new(1, -20, 1, -50)
Container.Position = UDim2.new(0, 10, 0, 45)
Container.BackgroundTransparency = 1

UIListLayout.Parent = Container
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)

-- ฟังก์ชันสร้างปุ่ม Toggle เปิด-ปิดระบบ
local function CreateToggleBtn(text, globalFlag)
    local Button = Instance.new("TextButton")
    local Corner = Instance.new("UICorner")
    
    Button.Parent = Container
    Button.Size = UDim2.new(1, 0, 0, 38)
    Button.BackgroundColor3 = _G[globalFlag] and Color3.fromRGB(0, 180, 100) or Color3.fromRGB(45, 45, 45)
    Button.Text = text .. ": " .. (_G[globalFlag] and "ON" or "OFF")
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 14
    Button.Font = Enum.Font.SourceSansSemibold

    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Button

    Button.MouseButton1Click:Connect(function()
        _G[globalFlag] = not _G[globalFlag]
        Button.BackgroundColor3 = _G[globalFlag] and Color3.fromRGB(0, 180, 100) or Color3.fromRGB(45, 45, 45)
        Button.Text = text .. ": " .. (_G[globalFlag] and "ON" or "OFF")
    end)
end

-- สรรค์สร้างเมนูปุ่มกด
CreateToggleBtn("Auto Farm Level", "AutoFarm")
CreateToggleBtn("Bring Mob (รวมมอน)", "BringMob")
CreateToggleBtn("Fast Attack (ตีเร็ว)", "FastAttack")

---------------------------------------------------------
-- 4. อีเวนต์คลิกปุ่มไอคอนเพื่อซ่อน/แสดง UI
---------------------------------------------------------
ToggleIcon.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)
