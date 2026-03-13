local Player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local pgui = Player:WaitForChild("PlayerGui")

-- Clean up
if pgui:FindFirstChild("XenoFlyV6") then pgui.XenoFlyV6:Destroy() end

local sg = Instance.new("ScreenGui", pgui)
sg.Name = "XenoFlyV6"
sg.ResetOnSpawn = false

local btn = Instance.new("TextButton", sg)
btn.Size = UDim2.new(0, 100, 0, 45)
btn.Position = UDim2.new(0.5, -50, 0.1, 0)
btn.Text = "FLY: OFF"
btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
btn.TextColor3 = Color3.new(1, 1, 1)
btn.Draggable = true
Instance.new("UICorner", btn)

local flying = false
local speed = 80
local bv, bg

btn.MouseButton1Click:Connect(function()
    flying = not flying
    local char = Player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    
    if flying and root then
        btn.Text = "FLY: ON"
        btn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        
        bv = Instance.new("BodyVelocity", root)
        bv.MaxForce = Vector3.new(1e7, 1e7, 1e7)
        
        bg = Instance.new("BodyGyro", root)
        bg.MaxTorque = Vector3.new(1e7, 1e7, 1e7)
        
        char.Humanoid.PlatformStand = true
        
        task.spawn(function()
            while flying and char and char:FindFirstChild("Humanoid") do
                local cam = workspace.CurrentCamera.CFrame
                local moveDir = char.Humanoid.MoveDirection
                
                -- THE FIX: If you are moving, use the Camera's angle to decide height
                if moveDir.Magnitude > 0 then
                    -- This calculates 3D movement based on where you look
                    bv.Velocity = cam.LookVector * (moveDir.Z < 0 and speed or moveDir.Z > 0 and -speed or 0) + 
                                  cam.CFrame.RightVector * (moveDir.X > 0 and speed or moveDir.X < 0 and -speed or 0)
                else
                    bv.Velocity = Vector3.new(0, 0, 0)
                end
                
                bg.CFrame = cam
                
                -- Noclip logic
                for _, v in pairs(char:GetDescendants()) do
                    if v:IsA("BasePart") then v.CanCollide = false end
                end
                RunService.RenderStepped:Wait()
            end
        end)
    else
        btn.Text = "FLY: OFF"
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        if bv then bv:Destroy() end
        if bg then bg:Destroy() end
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.PlatformStand = false
        end
    end
end)
