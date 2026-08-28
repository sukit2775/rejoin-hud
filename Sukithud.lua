-- ==========================================
-- RED-BLACK THEME: SUKIT HUB (DELTA OPTIMIZED)
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
ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- พื้นหลังแดง
ToggleBtn.BorderColor3 = Color3.fromRGB(15, 15, 15)
ToggleBtn.BorderSizePixel = 2
ToggleBtn.Text = "UI"
ToggleBtn.TextColor3 = Color3.fromRGB(0, 0, 0) -- ตัวหนังสือดำ
ToggleBtn.Font = Enum.Font.Code
ToggleBtn.TextScaled = true
ToggleBtn.Parent = ScreenGui
ToggleBtn.Active = true
ToggleBtn.Draggable = true

-- 3. เมนเฟรม (Main Frame)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 450, 0, 300)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
MainFrame.BorderSizePixel = 3
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
Title.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- พื้นหลังแดงเพื่อให้ตัวหนังสือดำเด่นขึ้น
Title.BorderColor3 = Color3.fromRGB(255, 0, 0)
Title.Text = " SUKIT HUB"
Title.TextColor3 = Color3.fromRGB(0, 0, 0) -- ตัวหนังสือสีดำ
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.Code
Title.TextSize = 20
Title.Parent = MainFrame

-- ปุ่มปิด UI แบบถาวร (Close Button)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -30, 0, 0)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
CloseBtn.BorderSizePixel = 0
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
CloseBtn.Font = Enum.Font.Code
CloseBtn.TextSize = 20
CloseBtn.Parent = Title

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy() -- ลบ UI ออกจากเกมถาวร
end)

-- 4. ระบบหมวดหมู่ (Tab System)
local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(0, 120, 1, -30)
TabContainer.Position = UDim2.new(0, 0, 0, 30)
TabContainer.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
TabContainer.BorderColor3 = Color3.fromRGB(255, 0, 0)
TabContainer.Parent = MainFrame

-- ชื่อผู้สร้าง (Creator Text)
local CreatorText = Instance.new("TextLabel")
CreatorText.Size = UDim2.new(1, 0, 0, 20)
CreatorText.Position = UDim2.new(0, 0, 1, -25)
CreatorText.BackgroundTransparency = 1
CreatorText.Text = "By Dr.sukit"
CreatorText.TextColor3 = Color3.fromRGB(255, 0, 0)
CreatorText.Font = Enum.Font.Code
CreatorText.TextSize = 14
CreatorText.Parent = TabContainer

local PageContainer = Instance.new("Frame")
PageContainer.Size = UDim2.new(1, -120, 1, -30)
PageContainer.Position = UDim2.new(0, 120, 0, 30)
PageContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
PageContainer.BorderSizePixel = 0
PageContainer.Parent = MainFrame

-- ฟังก์ชันสร้างปุ่มเมนู
local function CreateButton(parent, text, yPos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 200, 0, 40)
    btn.Position = UDim2.new(0.5, -100, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.BorderColor3 = Color3.fromRGB(255, 0, 0)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Code
    btn.TextSize = 18
    btn.Parent = parent
    return btn
end

-- หมวดหมู่ Player
local PlayerPage = Instance.new("Frame")
PlayerPage.Size = UDim2.new(1, 0, 1, 0)
PlayerPage.BackgroundTransparency = 1
PlayerPage.Parent = PageContainer

local TabBtnPlayer = Instance.new("TextButton")
TabBtnPlayer.Size = UDim2.new(1, 0, 0, 40)
TabBtnPlayer.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
TabBtnPlayer.BorderColor3 = Color3.fromRGB(255, 0, 0)
TabBtnPlayer.Text = "Player"
TabBtnPlayer.TextColor3 = Color3.fromRGB(255, 255, 255)
TabBtnPlayer.Font = Enum.Font.Code
TabBtnPlayer.TextSize = 18
TabBtnPlayer.Parent = TabContainer

-- 5. ปุ่มวิ่งเร็ว (Speed)
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
            SpeedBtn.TextColor3 = Color3.fromRGB(255, 0, 0)
        else
            hum.WalkSpeed = 16
            SpeedBtn.Text = "Speed (Off)"
            SpeedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
    end
end)

-- 6. ปุ่มบิน (Fly สำหรับมือถือและคอม)
local FlyBtn = CreateButton(PlayerPage, "Fly (Off)", 80)
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
        FlyBtn.TextColor3 = Color3.fromRGB(255, 0, 0)
        
        bg = Instance.new("BodyGyro", hrp)
        bg.P = 9e4
        bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.cframe = hrp.CFrame
        
        bv = Instance.new("BodyVelocity", hrp)
        bv.velocity = Vector3.new(0, 0, 0)
        bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
        
        hum.PlatformStand = true
        
        -- ดึงทิศทางการเดิน
        _G.FlyLoop = RunService.RenderStepped:Connect(function()
            local cam = workspace.CurrentCamera
            bg.cframe = cam.CFrame
            
            local moveDir = hum.MoveDirection
            if moveDir.Magnitude > 0 then
                bv.velocity = cam.CFrame.LookVector * (flySpeed * (UserInputService:IsKeyDown(Enum.KeyCode.S) and -1 or 1)) 
                if UserInputService.TouchEnabled then
                    bv.velocity = (cam.CFrame.LookVector * moveDir.Z * -1 + cam.CFrame.RightVector * moveDir.X) * flySpeed
                    if moveDir.Magnitude > 0 then
                        bv.velocity = cam.CFrame.LookVector * flySpeed
                    end
                end
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
        if hum then
            hum.PlatformStand = false
        end
    end
end)

-- 7. ฟังก์ชันปุ่มเปิด/ปิด UI ย่อ-ขยาย
ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)
