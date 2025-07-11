local HttpService = game:GetService("HttpService")

local Analytics = game:GetService("RbxAnalyticsService")

local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

local hwid = Analytics:GetClientId()

local username = LocalPlayer.Name

local apiUrl = "https://delicate-poetry-6e33.nestv3324.workers.dev/"

local savedKeyFile = "key_data.json"

-- ถ้ามีคีย์ที่เคยผ่านอยู่ในไฟล์ → ข้ามไปโหลด script ทันที

if isfile(savedKeyFile) then

local data = HttpService:JSONDecode(readfile(savedKeyFile))

if data.hwid == hwid and data.key and #data.key > 3 then

	-- โหลด Script ทันที

	loadstring(game:HttpGet("https://raw.githubusercontent.com/nook184/Script-snook/refs/heads/main/Script.lua"))()

	return

end

end

-- GUI

local ScreenGui = Instance.new("ScreenGui", game.CoreGui)

ScreenGui.Name = "KeySystem"

local Frame = Instance.new("Frame", ScreenGui)

Frame.Size = UDim2.new(0, 320, 0, 160)

Frame.Position = UDim2.new(0.5, -160, 0.5, -80)

Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)

Frame.BorderSizePixel = 0

Frame.BackgroundTransparency = 0.1

local UICorner = Instance.new("UICorner", Frame)

UICorner.CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", Frame)

Title.Text = "🔐 ระบบตรวจสอบคีย์"

Title.Font = Enum.Font.GothamBold

Title.TextSize = 18

Title.TextColor3 = Color3.fromRGB(255, 255, 255)

Title.Size = UDim2.new(1, 0, 0, 30)

Title.BackgroundTransparency = 1

local Input = Instance.new("TextBox", Frame)

Input.PlaceholderText = "วางคีย์ที่ได้รับ"

Input.Text = ""

Input.Size = UDim2.new(0.9, 0, 0, 30)

Input.Position = UDim2.new(0.05, 0, 0.35, 0)

Input.Font = Enum.Font.Gotham

Input.TextSize = 14

Input.TextColor3 = Color3.new(1, 1, 1)

Input.BackgroundColor3 = Color3.fromRGB(40, 40, 60)

Input.ClearTextOnFocus = false

local UICorner2 = Instance.new("UICorner", Input)

UICorner2.CornerRadius = UDim.new(0, 6)

local Status = Instance.new("TextLabel", Frame)

Status.Text = ""

Status.Size = UDim2.new(1, -20, 0, 30)

Status.Position = UDim2.new(0, 10, 0.6, 0)

Status.BackgroundTransparency = 1

Status.Font = Enum.Font.Gotham

Status.TextSize = 14

Status.TextColor3 = Color3.new(1, 1, 1)

local Button = Instance.new("TextButton", Frame)

Button.Text = "✅ ยืนยันคีย์"

Button.Size = UDim2.new(0.9, 0, 0, 30)

Button.Position = UDim2.new(0.05, 0, 0.8, 0)

Button.Font = Enum.Font.GothamBold

Button.TextSize = 14

Button.TextColor3 = Color3.fromRGB(255, 255, 255)

Button.BackgroundColor3 = Color3.fromRGB(0, 170, 127)

local UICorner3 = Instance.new("UICorner", Button)

UICorner3.CornerRadius = UDim.new(0, 6)

-- ✅ ฟังก์ชันตรวจสอบคีย์

local function CheckKey(key)

Status.Text = "🔄 กำลังตรวจสอบ..."  

local success, response = pcall(function()  

	return game:HttpPost(apiUrl, HttpService:JSONEncode({  

		key = key,  

		hwid = hwid,  

		username = username  

	}), Enum.HttpContentType.ApplicationJson)  

end)  



if not success then  

	Status.Text = "❌ ไม่สามารถเชื่อมต่อเซิร์ฟเวอร์"  

	Status.TextColor3 = Color3.fromRGB(255, 100, 100)  

	return  

end

if response == "valid_first_time" or response == "valid" then

Status.Text = "✅ คีย์ผ่านแล้ว"

Status.TextColor3 = Color3.fromRGB(100, 255, 100)



-- ✅ บันทึกคีย์ลงไฟล์

writefile(savedKeyFile, HttpService:JSONEncode({

	key = key,

	hwid = hwid,

	username = username

}))



wait(1)

ScreenGui:Destroy()

loadstring(game:HttpGet("https://raw.githubusercontent.com/nook184/Script-snook/refs/heads/main/Script.lua"))()

elseif response == "valid" then  

	Status.Text = "✅ คีย์ผ่านแล้ว"  

	Status.TextColor3 = Color3.fromRGB(100, 255, 100)  

	wait(1)  

	ScreenGui:Destroy()  

	loadstring(game:HttpGet("https://raw.githubusercontent.com/nook184/Script-snook/refs/heads/main/Script.lua"))()  

elseif response == "hwid_mismatch" then  

	Status.Text = "🚫 HWID ของคุณไม่ตรงกับที่เคยใช้คีย์นี้"  

	Status.TextColor3 = Color3.fromRGB(255, 80, 80)  

elseif response == "invalid" then  

	Status.Text = "❌ คีย์ไม่ถูกต้อง"  

	Status.TextColor3 = Color3.fromRGB(255, 50, 50)  

else  

	Status.Text = "⚠️ ข้อผิดพลาดไม่ทราบสาเหตุ"  

	Status.TextColor3 = Color3.fromRGB(255, 255, 0)  

end

end

-- กดปุ่ม → ตรวจสอบคีย์

Button.MouseButton1Click:Connect(function()

local key = Input.Text  

if key and #key > 3 then  

	CheckKey(key)  

else  

	Status.Text = "⚠️ กรุณากรอกคีย์ให้ถูกต้อง"  

	Status.TextColor3 = Color3.fromRGB(255, 200, 0)  

end

end)
