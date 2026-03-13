local Player = game.Players.LocalPlayer
local pgui = Player:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")

-- Cleanup old versions
if pgui:FindFirstChild("XenoFlyV5") then pgui.XenoFlyV5:Destroy() end

local sg = Instance.new("ScreenGui", pgui)
sg.Name = "XenoFlyV5"
sg.ResetOnSpawn = false

-- UI Setup
local main = Instance.new("TextButton", sg)
main.Size = UDim2.new(0, 100, 0, 45)
main.Position = UDim2.new(0.5, -50, 0.05, 0)
main.Text = "FLY: OFF"
main.BackgroundColor3 = Color3.fromRGB(30,30,30)
main.TextColor3 = Color3.new(1,1,1)
main.Draggable = true
Instance.new("UICorner", main)

-- Variables
local flying = false
local speed = 80
local bv, bg

main.MouseButton1Click:Connect(function()
    flying = not flying
    local char = Player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    
    if flying and root then
        main.Text = "FLY: ON"
        main.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        
        bv = Instance.new("BodyVelocity", root)
        bv.MaxForce = Vector3.new(1e7, 1e7, 1e7)
        
        bg = Instance.new("BodyGyro", root)
        bg.MaxTorque = Vector3.new(1e7, 1e7, 1e7)
        
        char.Humanoid.PlatformStand = true
        
        task.spawn(function()
            while flying and char and char:FindFirstChild("Humanoid") do
                local cam = workspace.CurrentCamera
                local direction = Vector3.new(0,0,0)
                
                -- Check if player is moving the joystick/keys
                local moveDir = char.Humanoid.MoveDirection
                
                if moveDir.Magnitude > 0 then
                    -- This is the magic part: it takes your joystick direction 
                    -- and aligns it with where your CAMERA is looking.
                    bv.Velocity = cam.CFrame.LookVector * speed * (moveDir.Z < 0 and 1 or moveDir.Z > 0 and -1 or 0) + 
                                  cam.CFrame.RightVector * speed * (moveDir.X > 0 and 1 or moveDir.X < 0 and -1 or 0)
                else
                    bv.Velocity = Vector3.new(0,0,0)
                end
                
                bg.CFrame = cam.CFrame
                
                -- Noclip (Walk through everything)
                for _, v in pairs(char:GetDescendants()) do
                    if v:IsA("BasePart") then v.CanCollide = false end
                end
                RunService.RenderStepped:Wait()
            end
        end)
    else
        main.Text = "FLY: OFF"
        main.BackgroundColor3 = Color3.fromRGB(30,30,30)
        if bv then bv:Destroy() end
        if bg then bg:Destroy() end
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.PlatformStand = false
        end
    end
end)
