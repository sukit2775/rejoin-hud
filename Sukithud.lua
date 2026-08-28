-- ==========================================
-- BLACK THEME: SUKIT HUB (DELTA OPTIMIZED)
-- ==========================================
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- ใช้ gethui() สำหรับตัวรันอย่าง Delta เพื่อซ่อน UI จากเกม
local CoreGui = (gethui and gethui()) or game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- ลบ UI เก่าถ้ามี
if CoreGui:FindFirstChild("SukitHub") then
    CoreGui.SukitHub:Destroy()
end

-- 1. สร้าง ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SukitHub"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- 2. ปุ่มเปิด/ปิด UI (Toggle Button)
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0, 10, 0, 10)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15) -- สีดำ
ToggleBtn.BorderColor3 = Color3.fromRGB(120, 120, 120) -- กรอบสีเทา
ToggleBtn.BorderSizePixel = 2
ToggleBtn.Text = "UI"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.Code
ToggleBtn.TextScaled = true
ToggleBtn.Parent = ScreenGui
ToggleBtn.Active = true
ToggleBtn.Draggable = true

-- 3. เมนเฟรม (Main Frame)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 450, 0, 350)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10) -- พื้นหลังดำสนิท
MainFrame.BorderColor3 = Color3.fromRGB(120, 120, 120) -- กรอบสีเทา
MainFrame.BorderSizePixel = 2
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

-- ระบบลาก UI (รองรับมือถือ Touch และ เมาส์)
local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)
MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then 
        dragInput = input 
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
        dragging = false 
    end
end)

-- หัวข้อ UI (Title)
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Title.BorderColor3 = Color3.fromRGB(120, 120, 120) -- กรอบสีเทา
Title.Text = " SUKIT HUB"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.Code
Title.TextSize = 18
Title.Parent = MainFrame

-- ปุ่มปิด UI แบบถาวร (Close Button)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -30, 0, 0)
CloseBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
CloseBtn.BorderSizePixel = 0
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.Code
CloseBtn.TextSize = 18
CloseBtn.Parent = Title

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- 4. ระบบหมวดหมู่ (Tab System)
local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(0, 120, 1, -30)
TabContainer.Position = UDim2.new(0, 0, 0, 30)
TabContainer.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
TabContainer.BorderColor3 = Color3.fromRGB(120, 120, 120) -- กรอบสีเทา
TabContainer.Parent = MainFrame

-- ชื่อผู้สร้าง (Creator Text)
local CreatorText = Instance.new("TextLabel")
CreatorText.Size = UDim2.new(1, 0, 0, 20)
CreatorText.Position = UDim2.new(0, 0, 1, -25)
CreatorText.BackgroundTransparency = 1
CreatorText.Text = "By Dr.sukit"
CreatorText.TextColor3 = Color3.fromRGB(180, 180, 180)
CreatorText.Font = Enum.Font.Code
CreatorText.TextSize = 14
CreatorText.Parent = TabContainer

local PageContainer = Instance.new("Frame")
PageContainer.Size = UDim2.new(1, -120, 1, -30)
PageContainer.Position = UDim2.new(0, 120, 0, 30)
PageContainer.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
PageContainer.BorderSizePixel = 0
PageContainer.Parent = MainFrame

-- หน้าต่างของแต่ละหมวดหมู่
local PlayerPage = Instance.new("Frame")
PlayerPage.Size = UDim2.new(1, 0, 1, 0)
PlayerPage.BackgroundTransparency = 1
PlayerPage.Visible = true
PlayerPage.Parent = PageContainer

local TrollPage = Instance.new("Frame")
TrollPage.Size = UDim2.new(1, 0, 1, 0)
TrollPage.BackgroundTransparency = 1
TrollPage.Visible = false
TrollPage.Parent = PageContainer

-- ปุ่มเลือกหมวดหมู่
local TabBtnPlayer = Instance.new("TextButton")
TabBtnPlayer.Size = UDim2.new(1, 0, 0, 40)
TabBtnPlayer.Position = UDim2.new(0, 0, 0, 0)
TabBtnPlayer.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TabBtnPlayer.BorderColor3 = Color3.fromRGB(120, 120, 120) -- กรอบสีเทา
TabBtnPlayer.Text = "Player"
TabBtnPlayer.TextColor3 = Color3.fromRGB(255, 255, 255)
TabBtnPlayer.Font = Enum.Font.Code
TabBtnPlayer.TextSize = 16
TabBtnPlayer.Parent = TabContainer

local TabBtnTroll = Instance.new("TextButton")
TabBtnTroll.Size = UDim2.new(1, 0, 0, 40)
TabBtnTroll.Position = UDim2.new(0, 0, 0, 40)
TabBtnTroll.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TabBtnTroll.BorderColor3 = Color3.fromRGB(120, 120, 120) -- กรอบสีเทา
TabBtnTroll.Text = "การแกล้ง"
TabBtnTroll.TextColor3 = Color3.fromRGB(255, 255, 255)
TabBtnTroll.Font = Enum.Font.Code
TabBtnTroll.TextSize = 16
TabBtnTroll.Parent = TabContainer

-- ระบบสลับหน้าหมวดหมู่
TabBtnPlayer.MouseButton1Click:Connect(function()
    PlayerPage.Visible = true
    TrollPage.Visible = false
    TabBtnPlayer.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    TabBtnTroll.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
end)

TabBtnTroll.MouseButton1Click:Connect(function()
    PlayerPage.Visible = false
    TrollPage.Visible = true
    TabBtnTroll.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    TabBtnPlayer.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
end)

-- ฟังก์ชันสร้างปุ่มพร้อมกรอบสีเทา
local function CreateButton(parent, text, yPos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 260, 0, 32)
    btn.Position = UDim2.new(0.5, -130, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25) -- ตัวปุ่มสีดำ/เทาเข้ม
    btn.BorderColor3 = Color3.fromRGB(120, 120, 120) -- กรอบสีเทา
    btn.BorderSizePixel = 1
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Code
    btn.TextSize = 15
    btn.Parent = parent
    return btn
end

-- ==================== หมวดหมู่ 1: PLAYER ====================
local SpeedBtn = CreateButton(PlayerPage, "Speed (Off)", 20)
local speedToggle = false

SpeedBtn.MouseButton1Click:Connect(function()
    speedToggle = not speedToggle
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        if speedToggle then
            hum.WalkSpeed = 100
            SpeedBtn.Text = "Speed (On)"
            SpeedBtn.TextColor3 = Color3.fromRGB(0, 255, 100)
        else
            hum.WalkSpeed = 16
            SpeedBtn.Text = "Speed (Off)"
            SpeedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
    end
end)

local FlyBtn = CreateButton(PlayerPage, "Fly (Off)", 65)
local flyToggle = false
local flySpeed = 50
local bg, bv

FlyBtn.MouseButton1Click:Connect(function()
    flyToggle = not flyToggle
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    
    if flyToggle and hrp and hum then
        FlyBtn.Text = "Fly (On)"
        FlyBtn.TextColor3 = Color3.fromRGB(0, 255, 100)
        
        bg = Instance.new("BodyGyro", hrp)
        bg.P = 9e4
        bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.cframe = hrp.CFrame
        
        bv = Instance.new("BodyVelocity", hrp)
        bv.velocity = Vector3.new(0, 0, 0)
        bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
        
        hum.PlatformStand = true
        
        _G.FlyLoop = RunService.RenderStepped:Connect(function()
            local cam = workspace.CurrentCamera
            bg.cframe = cam.CFrame
            local moveDir = hum.MoveDirection
            if moveDir.Magnitude > 0 then
                bv.velocity = cam.CFrame.LookVector * flySpeed
            else
                bv.velocity = Vector3.new(0, 0, 0)
            end
        end)
    else
        FlyBtn.Text = "Fly (Off)"
        FlyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        if bg then bg:Destroy() end
        if bv then bv:Destroy() end
        if _G.FlyLoop then _G.FlyLoop:Disconnect() end
        if hum then hum.PlatformStand = false end
    end
end)

-- ==================== หมวดหมู่ 2: การแกล้ง (TROLL) ====================

-- ช่องค้นหาชื่อผู้เล่น (กรอบสีเทา)
local TargetBox = Instance.new("TextBox")
TargetBox.Size = UDim2.new(0, 260, 0, 32)
TargetBox.Position = UDim2.new(0.5, -130, 0, 10)
TargetBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TargetBox.BorderColor3 = Color3.fromRGB(120, 120, 120) -- กรอบสีเทา
TargetBox.BorderSizePixel = 1
TargetBox.PlaceholderText = "พิมพ์ชื่อผู้เล่นตรงนี้..."
TargetBox.Text = ""
TargetBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TargetBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
TargetBox.Font = Enum.Font.Code
TargetBox.TextSize = 14
TargetBox.Parent = TrollPage

-- ฟังก์ชันค้นหาผู้เล่นจากชื่อบางส่วน
local function GetTargetPlayer(name)
    if name == "" then return nil end
    name = string.lower(name)
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer then
            if string.find(string.lower(v.Name), name) or string.find(string.lower(v.DisplayName), name) then
                return v
            end
        end
    end
    return nil
end

-- 1. ล็อกขาผู้เล่น (Freeze Lock)
local FreezeBtn = CreateButton(TrollPage, "1. ล็อกขาผู้เล่น (Off)", 50)
local freezeToggle = false

FreezeBtn.MouseButton1Click:Connect(function()
    freezeToggle = not freezeToggle
    if freezeToggle then
        FreezeBtn.Text = "1. ล็อกขาผู้เล่น (On)"
        FreezeBtn.TextColor3 = Color3.fromRGB(0, 255, 100)
        
        task.spawn(function()
            while freezeToggle do
                RunService.Heartbeat:Wait()
                local target = GetTargetPlayer(TargetBox.Text)
                local char = LocalPlayer.Character
                if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and char and char:FindFirstChild("HumanoidRootPart") then
                    char.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, -2.5, 0)
                    char.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
                end
            end
        end)
    else
        FreezeBtn.Text = "1. ล็อกขาผู้เล่น (Off)"
        FreezeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end)

-- 2. วาร์ปไปหาผู้เล่น (TP To Player)
local TpBtn = CreateButton(TrollPage, "2. วาร์ปไปหาผู้เล่น", 90)

TpBtn.MouseButton1Click:Connect(function()
    local target = GetTargetPlayer(TargetBox.Text)
    local char = LocalPlayer.Character
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
    end
end)

-- 3. หมุนปลิวออกจากโลก (Spin Fling)
local FlingBtn = CreateButton(TrollPage, "3. หมุนปลิวออกจากโลก (Off)", 130)
local flingToggle = false

FlingBtn.MouseButton1Click:Connect(function()
    flingToggle = not flingToggle
    if flingToggle then
        FlingBtn.Text = "3. หมุนปลิวออกจากโลก (On)"
        FlingBtn.TextColor3 = Color3.fromRGB(0, 255, 100)
        
        task.spawn(function()
            local bav = Instance.new("BodyAngularVelocity")
            bav.Name = "SukitFlingBAV"
            bav.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            bav.AngularVelocity = Vector3.new(0, 99999, 0)
            
            while flingToggle do
                RunService.Heartbeat:Wait()
                local target = GetTargetPlayer(TargetBox.Text)
                local char = LocalPlayer.Character
                if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and char and char:FindFirstChild("HumanoidRootPart") then
                    local hrp = char.HumanoidRootPart
                    local targetHrp = target.Character.HumanoidRootPart
                    
                    if not hrp:FindFirstChild("SukitFlingBAV") then
                        bav.Parent = hrp
                    end
                    
                    hrp.Velocity = Vector3.new(9999, 9999, 9999)
                    hrp.CFrame = targetHrp.CFrame * CFrame.new(math.random(-1,1), 0, math.random(-1,1))
                end
            end
            
            if bav then bav:Destroy() end
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
            end
        end)
    else
        FlingBtn.Text = "3. หมุนปลิวออกจากโลก (Off)"
        FlingBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end)

-- 4. หมุนตัวเองอยู่นิ่งๆ (Self Spin)
local SpinSelfBtn = CreateButton(TrollPage, "4. หมุนตัวเองอยู่นิ่งๆ (Off)", 170)
local spinSelfToggle = false

SpinSelfBtn.MouseButton1Click:Connect(function()
    spinSelfToggle = not spinSelfToggle
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = char:FindFirstChild("HumanoidRootPart")
    
    if spinSelfToggle then
        SpinSelfBtn.Text = "4. หมุนตัวเองอยู่นิ่งๆ (On)"
        SpinSelfBtn.TextColor3 = Color3.fromRGB(0, 255, 100)
        
        if hrp then
            if hrp:FindFirstChild("SukitSelfSpin") then
                hrp.SukitSelfSpin:Destroy()
            end
            local spinBAV = Instance.new("BodyAngularVelocity")
            spinBAV.Name = "SukitSelfSpin"
            spinBAV.MaxTorque = Vector3.new(0, math.huge, 0)
            spinBAV.AngularVelocity = Vector3.new(0, 30, 0) -- ความเร็วในการหมุนตัว
            spinBAV.Parent = hrp
        end
    else
        SpinSelfBtn.Text = "4. หมุนตัวเองอยู่นิ่งๆ (Off)"
        SpinSelfBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        
        if hrp and hrp:FindFirstChild("SukitSelfSpin") then
            hrp.SukitSelfSpin:Destroy()
        end
    end
end)

-- 7. ปุ่มเปิด/ปิด UI ย่อ-ขยาย
ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)
