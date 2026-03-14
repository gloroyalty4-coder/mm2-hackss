-- XENO ULTIMATE FLY (CLIPBOARD FIX)
local Player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local pgui = Player:WaitForChild("PlayerGui")

-- 1. UNIVERSAL CLIPBOARD FUNCTION
local function copyToClipboard(text)
    local func = setclipboard or toclipboard or set_clipboard or (Clipboard and Clipboard.set)
    if func then
        func(text)
        return true
    end
    return false
end

local dcLink = "https://discord.gg/gA4geyTmpm" -- Change this!

-- 2. CLEANUP & UI SETUP
if pgui:FindFirstChild("XenoFinalHub") then pgui.XenoFinalHub:Destroy() end

local sg = Instance.new("ScreenGui", pgui)
sg.Name = "XenoFinalHub"
sg.IgnoreGuiInset = true
sg.ResetOnSpawn = false

local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0, 200, 0, 140) -- Made taller for the DC button
frame.Position = UDim2.new(0.5, -100, 0.05, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame)

-- FLY TOGGLE
local toggle = Instance.new("TextButton", frame)
toggle.Size = UDim2.new(0.9, 0, 0, 35)
toggle.Position = UDim2.new(0.05, 0, 0.1, 0)
toggle.Text = "FLY: OFF"
toggle.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
toggle.TextColor3 = Color3.new(1,1,1)
toggle.Font = Enum.Font.GothamBold
Instance.new("UICorner", toggle)

-- DISCORD BUTTON (Reliable Copy)
local dcBtn = Instance.new("TextButton", frame)
dcBtn.Size = UDim2.new(0.9, 0, 0, 35)
dcBtn.Position = UDim2.new(0.05, 0, 0.4, 0)
dcBtn.Text = "COPY DISCORD"
dcBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242) -- Discord Blue
dcBtn.TextColor3 = Color3.new(1,1,1)
dcBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", dcBtn)

local speedLabel = Instance.new("TextLabel", frame)
speedLabel.Size = UDim2.new(1, 0, 0, 30)
speedLabel.Position = UDim2.new(0, 0, 0.75, 0)
speedLabel.Text = "Speed: 100 (Tap)"
speedLabel.TextColor3 = Color3.new(1, 1, 1)
speedLabel.BackgroundTransparency = 1

-- 3. LOGIC
dcBtn.MouseButton1Click:Connect(function()
    if copyToClipboard(dcLink) then
        dcBtn.Text = "COPIED!"
        task.wait(2)
        dcBtn.Text = "COPY DISCORD"
    else
        dcBtn.Text = "ERROR: NO CLIPBOARD"
    end
end)

-- FLYING ENGINE (S-DIRECTION FIX)
local flying = false
local speed = 100
local bv, bg

toggle.MouseButton1Click:Connect(function()
    flying = not flying
    local char = Player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    
    if flying and root then
        toggle.Text = "FLY: ACTIVE"
        toggle.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
        
        bv = Instance.new("BodyVelocity", root)
        bv.MaxForce = Vector3.new(1e7, 1e7, 1e7)
        bg = Instance.new("BodyGyro", root)
        bg.MaxTorque = Vector3.new(1e7, 1e7, 1e7)
        char.Humanoid.PlatformStand = true
        
        task.spawn(function()
            while flying and char and char:FindFirstChild("Humanoid") do
                local cam = workspace.CurrentCamera.CFrame
                local moveDir = char.Humanoid.MoveDirection
                
                if moveDir.Magnitude > 0 then
                    -- Projecting moveDir onto camera axis for S-Fix
                    local forward = cam.LookVector
                    local right = cam.RightVector
                    local fVal = moveDir:Dot(forward)
                    local rVal = moveDir:Dot(right)
                    bv.Velocity = (forward * fVal + right * rVal).Unit * speed
                else
                    bv.Velocity = Vector3.new(0, 0, 0)
                end
                bg.CFrame = cam
                
                -- Noclip
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
                RunService.RenderStepped:Wait()
            end
        end)
    else
        toggle.Text = "FLY: OFF"
        toggle.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
        if bv then bv:Destroy() end
        if bg then bg:Destroy() end
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.PlatformStand = false
        end
    end
end)

speedLabel.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        speed = (speed >= 1000) and 100 or speed + 100
        speedLabel.Text = "Speed: " .. speed
    end
end)
