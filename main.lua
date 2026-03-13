-- XENO ULTIMATE FLY (S-KEY / JOYSTICK BACK FIX)
local Player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local pgui = Player:WaitForChild("PlayerGui")

-- Cleanup
if pgui:FindFirstChild("XenoFinalFix") then pgui.XenoFinalFix:Destroy() end

local sg = Instance.new("ScreenGui", pgui)
sg.Name = "XenoFinalFix"
sg.IgnoreGuiInset = true
sg.ResetOnSpawn = false

local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0, 220, 0, 110)
frame.Position = UDim2.new(0.5, -110, 0.05, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame)

local toggle = Instance.new("TextButton", frame)
toggle.Size = UDim2.new(0.9, 0, 0, 45)
toggle.Position = UDim2.new(0.05, 0, 0.1, 0)
toggle.Text = "FLY: OFF"
toggle.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
toggle.TextColor3 = Color3.new(1,1,1)
toggle.Font = Enum.Font.GothamBold
Instance.new("UICorner", toggle)

local speedLabel = Instance.new("TextLabel", frame)
speedLabel.Size = UDim2.new(1, 0, 0, 30)
speedLabel.Position = UDim2.new(0, 0, 0.65, 0)
speedLabel.Text = "Speed: 100 (Tap to increase)"
speedLabel.TextColor3 = Color3.new(1, 1, 1)
speedLabel.BackgroundTransparency = 1

-- 2. THE DIRECTION ENGINE
local flying = false
local speed = 100
local bv, bg

toggle.MouseButton1Click:Connect(function()
    flying = not flying
    local char = Player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    
    if flying and root then
        toggle.Text = "FLY: ON"
        toggle.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
        
        bv = Instance.new("BodyVelocity", root)
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        
        bg = Instance.new("BodyGyro", root)
        bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        
        char.Humanoid.PlatformStand = true
        
        task.spawn(function()
            while flying and char and char:FindFirstChild("Humanoid") do
                local cam = workspace.CurrentCamera.CFrame
                local moveDir = char.Humanoid.MoveDirection -- World-space direction
                
                if moveDir.Magnitude > 0 then
                    -- THE CRITICAL FIX:
                    -- We project the MoveDirection onto the Camera's LookVector.
                    -- If moveDir is pointing 'Away' from where the camera looks, 
                    -- this dot product will be negative, making you go backwards.
                    
                    -- Get the direction relative to the camera's face
                    local look = cam.LookVector
                    local right = cam.RightVector
                    
                    -- Calculate how much you are pushing forward/backward and left/right
                    local forwardValue = moveDir:Dot(look)
                    local rightValue = moveDir:Dot(right)
                    
                    -- Reconstruct the velocity using the Camera's actual axis
                    bv.Velocity = (look * forwardValue + right * rightValue).Unit * speed
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
        toggle.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
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
