-- XENO ULTIMATE FLY + DISCORD NOTI
local Player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local pgui = Player:WaitForChild("PlayerGui")

-- 1. SEND DISCORD NOTIFICATION
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Support & Updates",
    Text = "Join our Discord server for more scripts!",
    Duration = 10, -- Stays on screen for 10 seconds
    Button1 = "Okay"
})

-- 2. CLEANUP & UI SETUP
if pgui:FindFirstChild("XenoDiscordFly") then pgui.XenoDiscordFly:Destroy() end

local sg = Instance.new("ScreenGui", pgui)
sg.Name = "XenoDiscordFly"
sg.IgnoreGuiInset = true
sg.ResetOnSpawn = false

local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0.5, -100, 0.05, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame)

local toggle = Instance.new("TextButton", frame)
toggle.Size = UDim2.new(0.9, 0, 0, 40)
toggle.Position = UDim2.new(0.05, 0, 0.1, 0)
toggle.Text = "FLY: OFF"
toggle.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
toggle.TextColor3 = Color3.new(1,1,1)
toggle.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", toggle)

local speedLabel = Instance.new("TextLabel", frame)
speedLabel.Size = UDim2.new(1, 0, 0, 30)
speedLabel.Position = UDim2.new(0, 0, 0.6, 0)
speedLabel.Text = "Speed: 100 (Tap Me)"
speedLabel.TextColor3 = Color3.new(1, 1, 1)
speedLabel.BackgroundTransparency = 1

-- 3. THE MOVEMENT ENGINE (FIXED FOR S-DIRECTION)
local flying = false
local speed = 100
local bv, bg

toggle.MouseButton1Click:Connect(function()
    flying = not flying
    local char = Player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    
    if flying and root then
        toggle.Text = "FLY: ACTIVE"
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
                
                if moveDir.Magnitude > 0 then
                    -- Projecting moveDir onto camera look/right vectors
                    -- This ensures 'S' moves you AWAY from where you look.
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
        toggle.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
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
