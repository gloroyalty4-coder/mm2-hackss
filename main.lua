local Player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local pgui = Player:WaitForChild("PlayerGui")

-- Cleanup previous versions
if pgui:FindFirstChild("XenoCamFly") then pgui.XenoCamFly:Destroy() end

local sg = Instance.new("ScreenGui", pgui)
sg.Name = "XenoCamFly"
sg.ResetOnSpawn = false

-- Simple Toggle Button
local btn = Instance.new("TextButton", sg)
btn.Size = UDim2.new(0, 120, 0, 45)
btn.Position = UDim2.new(0.5, -60, 0.05, 0)
btn.Text = "CAM FLY: OFF"
btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
btn.TextColor3 = Color3.new(1, 1, 1)
btn.Font = Enum.Font.SourceSansBold
btn.TextSize = 18
Instance.new("UICorner", btn)

local flying = false
local speed = 80
local bv, bg

btn.MouseButton1Click:Connect(function()
    flying = not flying
    local char = Player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    
    if flying and root then
        btn.Text = "CAM FLY: ON"
        btn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        
        -- Physical forces to stay in air
        bv = Instance.new("BodyVelocity", root)
        bv.MaxForce = Vector3.new(1e7, 1e7, 1e7)
        
        bg = Instance.new("BodyGyro", root)
        bg.MaxTorque = Vector3.new(1e7, 1e7, 1e7)
        
        char.Humanoid.PlatformStand = true -- Prevents glitchy walking animations
        
        task.spawn(function()
            while flying and char and char:FindFirstChild("Humanoid") do
                local cam = workspace.CurrentCamera.CFrame
                local moveDirection = char.Humanoid.MoveDirection -- This is your Joystick input
                
                -- THE MATH:
                -- If you move the joystick, we multiply your Camera's "Forward" direction 
                -- by the speed. This includes Up/Down angles!
                if moveDirection.Magnitude > 0 then
                    bv.Velocity = cam.LookVector * speed 
                else
                    bv.Velocity = Vector3.new(0, 0.1, 0) -- Hover in place
                end
                
                bg.CFrame = cam -- Keeps your body facing the way you look
                
                -- Noclip (Bypass walls)
                for _, v in pairs(char:GetDescendants()) do
                    if v:IsA("BasePart") then v.CanCollide = false end
                end
                RunService.RenderStepped:Wait()
            end
        end)
    else
        btn.Text = "CAM FLY: OFF"
        btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        if bv then bv:Destroy() end
        if bg then bg:Destroy() end
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.PlatformStand = false
        end
    end
end)
