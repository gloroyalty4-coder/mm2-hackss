-- ULTIMATE CINEMATIC FLY (XENO EDITION)
local Player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local pgui = Player:WaitForChild("PlayerGui")

-- 1. CLEANUP & UI SETUP
if pgui:FindFirstChild("XenoUltimate") then pgui.XenoUltimate:Destroy() end

local sg = Instance.new("ScreenGui", pgui)
sg.Name = "XenoUltimate"
sg.IgnoreGuiInset = true
sg.ResetOnSpawn = false

local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0.5, -100, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "ULTIMATE FLY"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold

local toggle = Instance.new("TextButton", frame)
toggle.Size = UDim2.new(0.9, 0, 0, 30)
toggle.Position = UDim2.new(0.05, 0, 0.35, 0)
toggle.Text = "STATUS: OFF"
toggle.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
toggle.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", toggle)

local speedLabel = Instance.new("TextLabel", frame)
speedLabel.Size = UDim2.new(1, 0, 0, 20)
speedLabel.Position = UDim2.new(0, 0, 0.7, 0)
speedLabel.Text = "Speed: 100"
speedLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
speedLabel.BackgroundTransparency = 1

-- 2. FLIGHT ENGINE
local flying = false
local speed = 100
local bv, bg

local function toggleFlight()
    flying = not flying
    local char = Player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    
    if flying and root then
        toggle.Text = "STATUS: ACTIVE"
        toggle.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        
        bv = Instance.new("BodyVelocity", root)
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        
        bg = Instance.new("BodyGyro", root)
        bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        
        char.Humanoid.PlatformStand = true
        
        task.spawn(function()
            while flying and char and char:FindFirstChild("Humanoid") do
                local cam = workspace.CurrentCamera.CFrame
                local moveDir = char.Humanoid.MoveDirection
                
                -- The "10,000x Better" Logic:
                -- If pushing the joystick, move in the EXACT direction the camera looks.
                if moveDir.Magnitude > 0 then
                    bv.Velocity = cam.LookVector * speed
                else
                    bv.Velocity = Vector3.new(0, 0.1, 0) -- Perfect hover
                end
                
                bg.CFrame = cam
                
                -- Seamless Noclip
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
                RunService.RenderStepped:Wait()
            end
        end)
    else
        toggle.Text = "STATUS: OFF"
        toggle.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        if bv then bv:Destroy() end
        if bg then bg:Destroy() end
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.PlatformStand = false
        end
    end
end

toggle.MouseButton1Click:Connect(toggleFlight)

-- Speed Multiplier (Tap title to increase speed)
title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        speed = (speed >= 500) and 50 or speed + 50
        speedLabel.Text = "Speed: " .. speed
    end
end)
