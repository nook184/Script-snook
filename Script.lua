local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

-- 🖼️ GUI หลัก
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "AutoSystemGUI"
gui.ResetOnSpawn = false

-- 🪟 กรอบ GUI
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 460, 0, 180)
frame.Position = UDim2.new(0.5, -230, 0.5, -90)
frame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
frame.BorderSizePixel = 0
frame.BackgroundTransparency = 1 -- เริ่มโปร่งไว้สำหรับ fade-in
frame.ClipsDescendants = true
frame.ZIndex = 1
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 16)

-- 🌀 พื้นหลัง Gradient
local gradient = Instance.new("UIGradient", frame)
gradient.Color = ColorSequence.new{
ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 100, 150)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 50, 80))
}
gradient.Rotation = 45

-- 🚀 เริ่มทำให้ Gradient หมุนวนอย่างช้าๆ
coroutine.wrap(function()
while true do
TweenService:Create(gradient, TweenInfo.new(10, Enum.EasingStyle.Linear), {Rotation = gradient.Rotation + 360}):Play()
wait(10)
end
end)()

-- ❇️ Outer Glow รอบกรอบ (Glow รอบนอก)
local outerGlow = Instance.new("ImageLabel", gui)
outerGlow.Size = frame.Size + UDim2.new(0, 20, 0, 20)
outerGlow.Position = frame.Position - UDim2.new(0, 10, 0, 10)
outerGlow.BackgroundTransparency = 1
outerGlow.ZIndex = 0
outerGlow.Image = "rbxassetid://7137332345" -- ใช้ glow เดิม หรือเปลี่ยน asset ได้
outerGlow.ImageColor3 = Color3.fromRGB(0, 200, 255)
outerGlow.ImageTransparency = 0.9

-- ✨ เอฟเฟกต์เรืองแสงเบา ๆ
local glow = Instance.new("ImageLabel", frame)
glow.Size = UDim2.new(1.2, 0, 1.2, 0)
glow.Position = UDim2.new(-0.1, 0, -0.1, 0)
glow.BackgroundTransparency = 1
glow.Image = "rbxassetid://7137332345"
glow.ImageColor3 = Color3.fromRGB(0, 200, 255)
glow.ImageTransparency = 0.85
glow.ZIndex = 0

-- 🌟 Title
local title = Instance.new("TextLabel", frame)
title.Text = "🤖 ระบบอัตโนมัติ All Star X"
title.Size = UDim2.new(1, -20, 0, 40)
title.Position = UDim2.new(0, 10, 0, 10)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(0, 255, 255)
title.Font = Enum.Font.FredokaOne
title.TextSize = 28
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 3
title.TextTransparency = 1 -- เริ่มโปร่งสำหรับ fade-in
title.TextStrokeTransparency = 0.7
title.TextStrokeColor3 = Color3.fromRGB(0, 150, 200)

local titleShadow = title:Clone()
titleShadow.Parent = frame
titleShadow.Position = title.Position + UDim2.new(0, 2, 0, 2)
titleShadow.TextColor3 = Color3.fromRGB(0, 100, 120)
titleShadow.ZIndex = 2
titleShadow.TextTransparency = 1

-- ⏳ สถานะ
local statusLabel = Instance.new("TextLabel", frame)
statusLabel.Text = "⏳ กำลังเริ่มต้น..."
statusLabel.Size = UDim2.new(1, -20, 0, 60)
statusLabel.Position = UDim2.new(0, 10, 0, 55)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
statusLabel.Font = Enum.Font.GothamBold
statusLabel.TextSize = 26
statusLabel.TextWrapped = true
statusLabel.TextYAlignment = Enum.TextYAlignment.Top
statusLabel.ZIndex = 3
statusLabel.TextTransparency = 1 -- เริ่มโปร่งสำหรับ fade-in
statusLabel.TextStrokeTransparency = 0.8
statusLabel.TextStrokeColor3 = Color3.fromRGB(0, 100, 150)

local statusShadow = statusLabel:Clone()
statusShadow.Parent = frame
statusShadow.Position = statusLabel.Position + UDim2.new(0, 1, 0, 1)
statusShadow.TextColor3 = Color3.fromRGB(80, 80, 80)
statusShadow.ZIndex = 2
statusShadow.TextTransparency = 1

-- 📊 แถบโหลด
local progressBar = Instance.new("Frame", frame)
progressBar.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
progressBar.Size = UDim2.new(0, 0, 0, 8)
progressBar.Position = UDim2.new(0, 0, 1, -8)
progressBar.ZIndex = 4
Instance.new("UICorner", progressBar).CornerRadius = UDim.new(1, 0)

-- ❄️ เอฟเฟกต์ตกแต่ง (Particle GUI แบบจุดวิบๆ เคลื่อนที่)
local particles = Instance.new("Frame", frame)
particles.BackgroundTransparency = 1
particles.Size = UDim2.new(1, 0, 1, 0)
particles.ZIndex = 5

for i = 1, 15 do
local dot = Instance.new("Frame", particles)
dot.Size = UDim2.new(0, 4, 0, 4)
dot.Position = UDim2.new(math.random(), 0, math.random(), 0)
dot.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
dot.BackgroundTransparency = 0.4
dot.ZIndex = 5
Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

-- กระพริบแบบสุ่ม
local tweenInfo = TweenInfo.new(math.random(1, 2), Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
TweenService:Create(dot, tweenInfo, {BackgroundTransparency = 1}):Play()

-- เคลื่อนที่เล็กน้อย (Loop)
coroutine.wrap(function()
while true do
local newPos = UDim2.new(math.random(), 0, math.random(), 0)
TweenService:Create(dot, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Position = newPos}):Play()
wait(2)
end
end)()

end

-- 🖼️ ตัวละครอนิเมะมุมล่างขวา
local charImg = Instance.new("ImageLabel", frame)
charImg.Size = UDim2.new(0, 80, 0, 80)
charImg.Position = UDim2.new(1, -90, 1, -90)
charImg.BackgroundTransparency = 1
charImg.Image = "rbxassetid://1234567890" -- แทนด้วย asset id ตัวละครจริงที่ต้องการ
charImg.ZIndex = 6

-- 🎬 ฟังก์ชันอัปเดตสถานะ
local function updateStatus(text, step, max)
statusLabel.Text = text
statusShadow.Text = text
TweenService:Create(progressBar, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(step / max, 0, 0, 8)}):Play()
end

-- 🔥 ฟังก์ชัน Fade-in GUI ทั้งหมด
local function fadeInGUI()
local fadeInTweenInfo = TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

TweenService:Create(frame, fadeInTweenInfo, {BackgroundTransparency = 0.2}):Play()
TweenService:Create(title, fadeInTweenInfo, {TextTransparency = 0}):Play()
TweenService:Create(titleShadow, fadeInTweenInfo, {TextTransparency = 0}):Play()
TweenService:Create(statusLabel, fadeInTweenInfo, {TextTransparency = 0}):Play()
TweenService:Create(statusShadow, fadeInTweenInfo, {TextTransparency = 0}):Play()

end

-- 🔚 ฟังก์ชัน Fade-out แล้วลบ GUI
local function fadeOutAndDestroy(guiElement)
local tweenInfo = TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
for _, v in ipairs(guiElement:GetDescendants()) do
if v:IsA("TextLabel") or v:IsA("Frame") or v:IsA("ImageLabel") then
pcall(function()
TweenService:Create(v, tweenInfo, {
BackgroundTransparency = 1,
TextTransparency = 1,
ImageTransparency = 1
}):Play()
end)
end
end
wait(1.5)
guiElement:Destroy()
end

-- 🚀 เริ่มทำงานอัตโนมัติทันที
coroutine.wrap(function()
wait(0.2)
fadeInGUI()

local step = 0
local codes = {
"VERYHIGHLIKEB",
"ONEEIGHTYFIVELIKES",
"FORTYFIVELIKES",
"somanylikes",
"AFIRSTTIME3001",
"FREENIMBUSMOUNT"
}
local totalSteps = 6 + #codes

for _, code in ipairs(codes) do
step += 1
updateStatus("🎟️ ใช้โค้ด: " .. code, step, totalSteps)
local args = {{
Type = "Code",
Mode = "Redeem",
Code = code
}}
pcall(function()
ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("GetFunction"):InvokeServer(unpack(args))
end)
wait(0.4)
end

step += 1
updateStatus("📍 วาร์ปไปจุด Summon...", step, totalSteps)
local pos = Vector3.new(-227.189, 249.454, 382.306)
local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
if hrp then hrp.CFrame = CFrame.new(pos) end
wait(2)

for i = 1, 2 do
step += 1
updateStatus("✨ Summon รอบที่ " .. i, step, totalSteps)
local summonArgs = {{
Type = "Gacha",
Auto = {
T3 = false, S4 = false, T4 = false, S5 = false,
N3 = false, N5 = false, N4 = false, S3 = false, T5 = false
},
Mode = "Purchase",
Bundle = true,
Index = "StandardSummon2"
}}
pcall(function()
ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("GetFunction"):InvokeServer(unpack(summonArgs))
end)
wait(1)
end

step += 1
updateStatus("📜 โหลดเควส...", step, totalSteps)
local questArgs = {{
Type = "Quest",
Mode = "Get"
}}
pcall(function()
ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("GetFunction"):InvokeServer(unpack(questArgs))
end)
wait(1)

step += 1
updateStatus("✅ เสร็จสิ้นระบบอัตโนมัติ!", step, totalSteps)
wait(3)
fadeOutAndDestroy(gui)

end)()
