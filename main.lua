-- XENO GOD-MODE FLY (S-FIXED)
local Player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local pgui = Player:WaitForChild("PlayerGui")

-- 1. CLEANUP & UI
if pgui:FindFirstChild("XenoFinal") then pgui.XenoFinal:Destroy() end

local sg = Instance.new("ScreenGui", pgui)
sg.Name = "XenoFinal"
sg.IgnoreGuiInset = true
sg.ResetOnSpawn = false

local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0.5, -100, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame)

local toggle = Instance.new("TextButton", frame)
toggle.Size = UDim2.new(0.9, 0, 0, 40)
toggle.Position = UDim2.new(0.05, 0, 0.1, 0)
toggle.Text = "FLY: OFF"
toggle.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
toggle.TextColor3 = Color3.new(1,1,1)
toggle.Font = Enum.Font.GothamBold
Instance.new("UICorner", toggle)

local speedLabel = Instance.new("TextLabel", frame)
speedLabel.Size = UDim2.new(1, 0, 0, 30)
speedLabel.Position = UDim2.new(0, 0, 0.6, 0)
speedLabel.Text = "Speed: 100"
speedLabel.TextColor3 = Color3.new(1, 1, 1)
speedLabel.BackgroundTransparency = 1

-- 2. THE MOVEMENT ENGINE
local flying = false
local speed = 100
local bv, bg

toggle.MouseButton1Click:Connect(function()
    flying = not flying
    local char = Player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    
    if flying and root then
        toggle.Text = "FLY: ON"
        toggle.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        
        bv = Instance.new("BodyVelocity", root)
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        
        bg = Instance.new("BodyGyro", root)
        bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        
        char.Humanoid.PlatformStand = true
        
        task.spawn(function()
            while flying and char and char:FindFirstChild("Humanoid") do
                local cam = workspace.CurrentCamera.CFrame
                local moveDir = char.Humanoid.MoveDirection
                
                -- THE TRUE FIX:
                -- Instead of just 'moveDir', we calculate the angle relative to the Camera.
                -- We use the Camera's LookVector for Forward/Back and RightVector for Left/Right.
                
                if moveDir.Magnitude > 0 then
                    -- Convert World MoveDirection into Camera-Relative Velocity
                    -- This ensures S always goes away from your face.
                    local direction = cam:VectorToWorldSpace(cam:VectorToObjectSpace(moveDir))
                    bv.Velocity = direction * speed
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
        toggle.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        if bv then bv:Destroy() end
        if bg then bg:Destroy() end
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.PlatformStand = false
        end
    end
end)

-- Tap speed label to increase
speedLabel.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        speed = (speed >= 500) and 100 or speed + 100
        speedLabel.Text = "Speed: " .. speed
    end
end)
