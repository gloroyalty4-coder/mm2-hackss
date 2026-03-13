-- GOD-TIER FLY (DIRECTION FIXED)
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
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame)

local toggle = Instance.new("TextButton", frame)
toggle.Size = UDim2.new(0.9, 0, 0, 40)
toggle.Position = UDim2.new(0.05, 0, 0.1, 0)
toggle.Text = "FLY: OFF"
toggle.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
toggle.TextColor3 = Color3.new(1,1,1)
toggle.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", toggle)

local speedLabel = Instance.new("TextLabel", frame)
speedLabel.Size = UDim2.new(1, 0, 0, 30)
speedLabel.Position = UDim2.new(0, 0, 0.6, 0)
speedLabel.Text = "Speed: 100 (Tap to change)"
speedLabel.TextColor3 = Color3.new(1, 1, 1)
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
        toggle.Text = "FLY: ACTIVE"
        toggle.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
        
        bv = Instance.new("BodyVelocity", root)
        bv.MaxForce = Vector3.new(1e8, 1e8, 1e8) -- Infinite force
        
        bg = Instance.new("BodyGyro", root)
        bg.MaxTorque = Vector3.new(1e8, 1e8, 1e8)
        
        char.Humanoid.PlatformStand = true
        
        task.spawn(function()
            while flying and char and char:FindFirstChild("Humanoid") do
                local cam = workspace.CurrentCamera.CFrame
                local moveDir = char.Humanoid.MoveDirection -- The direction you are pushing the stick
                
                if moveDir.Magnitude > 0 then
                    -- THE FIX: 
                    -- We take the MoveDirection (world space) and align it with the camera.
                    -- If you press S, MoveDirection is opposite to your look direction.
                    bv.Velocity = moveDir * speed
                else
                    bv.Velocity = Vector3.new(0, 0.1, 0) -- Hover
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
end

toggle.MouseButton1Click:Connect(toggleFlight)

-- Speed Changer
speedLabel.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        speed = (speed >= 1000) and 100 or speed + 100
        speedLabel.Text = "Speed: " .. speed
    end
end)
