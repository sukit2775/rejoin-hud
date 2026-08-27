repeat task.wait() until game:IsLoaded()

local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local GuiService = game:GetService("GuiService")
local StarterGui = game:GetService("StarterGui")

-- =======================================================
-- 1. ระบบแจ้งเตือนมุมขวาล่าง (Notification)
-- =======================================================
StarterGui:SetCore("SendNotification", {
    Title = "REJOIN HUD",                 
    Text = "สคริปต์เริ่มทำงานแล้ว! กำลังเฝ้าหน้าจอ...", 
    Icon = "rbxassetid://6034287515",     
    Duration = 5                          
})

-- =======================================================
-- 2. ระบบเช็คสถานะสคริปต์ (HUD / Watermark แสดงบนจอ)
-- =======================================================
local ScreenGui = Instance.new("ScreenGui")
local HudFrame = Instance.new("Frame")
local HudText = Instance.new("TextLabel")
local UICorner = Instance.new("UICorner")

ScreenGui.Name = "RejoinHudContainer"
ScreenGui.Parent = game:GetService("CoreGui") 
ScreenGui.ResetOnSpawn = false

HudFrame.Name = "HudFrame"
HudFrame.Parent = ScreenGui
HudFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20) 
HudFrame.BackgroundTransparency = 0.3 
HudFrame.Position = UDim2.new(1, -210, 1, -70) 
HudFrame.Size = UDim2.new(0, 200, 0, 40) 

UICorner.Parent = HudFrame
UICorner.CornerRadius = UDim.new(0, 8)

HudText.Name = "HudText"
HudText.Parent = HudFrame
HudText.BackgroundTransparency = 1
HudText.Size = UDim2.new(1, 0, 1, 0)
HudText.Font = Enum.Font.SourceSansBold
HudText.Text = "🟢 REJOIN HUD : ACTIVE" 
HudText.TextColor3 = Color3.fromRGB(0, 255, 100) 
HudText.TextSize = 16

-- =======================================================
-- 3. ระบบ Auto Rejoin ทำงานเบื้องหลัง
-- =======================================================
local function reconnect()
    HudText.Text = "🔴 DISCONNECTED : REJOINING..."
    HudText.TextColor3 = Color3.fromRGB(255, 50, 50)
    task.wait(3)
    TeleportService:Teleport(game.PlaceId, LocalPlayer)
end

GuiService.ErrorMessageChanged:Connect(reconnect)

local CoreGui = game:GetService("CoreGui")
if CoreGui:FindFirstChild("RobloxPromptGui") then
    local Prompt = CoreGui.RobloxPromptGui:FindFirstChild("promptOverlay")
    if Prompt then
        Prompt.ChildAdded:Connect(function(Child)
            if Child.Name == "ErrorPrompt" then
                reconnect()
            end
        end)
    end
end
