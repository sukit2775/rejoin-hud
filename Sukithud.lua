-- =================================================================
-- SUKIT HUB : MAIN LOADER SCRIPT (ตัวเลือกโหมดสคริปต์หลัก)
-- =================================================================

-- ฟังก์ชันสำหรับเรียกโหลดสคริปต์ปลายทาง
local function LoadTargetScript(mode)
    getgenv().Script_Mode = mode
    
    if mode == "Kaitun_Script" then
        print("[SUKIT HUB] กำลังโหลด : Kaitun Script...")
        loadstring(game:HttpGet("https://raw.githubusercontent.com/sukit2775/rejoin-hud/refs/heads/main/Kaitun_Script"))()
    elseif mode == "Normal_Script" then
        print("[SUKIT HUB] กำลังโหลด : Normal Script...")
        loadstring(game:HttpGet("https://raw.githubusercontent.com/sukit2775/rejoin-hud/refs/heads/main/Normal_Script"))()
    end
end

-- -----------------------------------------------------------------
-- 1. เช็กระบบอัตโนมัติ (หากมีการตั้งค่า getgenv().Script_Mode ไว้ก่อนแล้ว)
-- -----------------------------------------------------------------
if getgenv().Script_Mode == "Kaitun_Script" or getgenv().Script_Mode == "Normal_Script" then
    LoadTargetScript(getgenv().Script_Mode)
    return
end

-- -----------------------------------------------------------------
-- 2. สร้าง UI เมนูเลือกโหมด (กรณีที่ยังไม่ได้กำหนด Script_Mode)
-- -----------------------------------------------------------------
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SukitHubLoaderGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 99999

if gethui then ScreenGui.Parent = gethui()
elseif syn and syn.protect_gui then syn.protect_gui(ScreenGui); ScreenGui.Parent = CoreGui
elseif CoreGui:FindFirstChild("RobloxGui") then ScreenGui.Parent = CoreGui
else ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

-- Frame หลัก
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 320, 0, 220)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -110)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

local MainStroke = Instance.new("UIStroke")
MainStroke.Thickness = 2
MainStroke.Color = Color3.fromRGB(0, 255, 150)
MainStroke.Parent = MainFrame

-- หัวข้อ UI
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Parent = MainFrame
TitleLabel.Size = UDim2.new(1, 0, 0, 45)
TitleLabel.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
TitleLabel.Text = "SUKIT HUB : SELECT MODE"
TitleLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
TitleLabel.TextSize = 16
TitleLabel.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", TitleLabel).CornerRadius = UDim.new(0, 12)

-- ปุ่มเลือก Normal Script
local NormalBtn = Instance.new("TextButton")
NormalBtn.Parent = MainFrame
NormalBtn.Size = UDim2.new(0.85, 0, 0, 50)
NormalBtn.Position = UDim2.new(0.075, 0, 0.3, 0)
NormalBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
NormalBtn.Text = "NORMAL SCRIPT (ฟาร์มปกติ)"
NormalBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
NormalBtn.TextSize = 14
NormalBtn.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", NormalBtn).CornerRadius = UDim.new(0, 8)

local NormalStroke = Instance.new("UIStroke")
NormalStroke.Thickness = 1.5
NormalStroke.Color = Color3.fromRGB(0, 200, 255)
NormalStroke.Parent = NormalBtn

-- ปุ่มเลือก Kaitun Script
local KaitunBtn = Instance.new("TextButton")
KaitunBtn.Parent = MainFrame
KaitunBtn.Size = UDim2.new(0.85, 0, 0, 50)
KaitunBtn.Position = UDim2.new(0.075, 0, 0.62, 0)
KaitunBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
KaitunBtn.Text = "KAITUN SCRIPT (ไก่ตัน 1-700)"
KaitunBtn.TextColor3 = Color3.fromRGB(0, 255, 150)
KaitunBtn.TextSize = 14
KaitunBtn.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", KaitunBtn).CornerRadius = UDim.new(0, 8)

local KaitunStroke = Instance.new("UIStroke")
KaitunStroke.Thickness = 1.5
KaitunStroke.Color = Color3.fromRGB(0, 255, 150)
KaitunStroke.Parent = KaitunBtn

-- Event เมื่อกดปุ่ม Normal
NormalBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    LoadTargetScript("Normal_Script")
end)

-- Event เมื่อกดปุ่ม Kaitun
KaitunBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    LoadTargetScript("Kaitun_Script")
end)
