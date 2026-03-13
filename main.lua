-- FORCE START
local player = game.Players.LocalPlayer
local pgui = player:WaitForChild("PlayerGui")

-- Remove old GUI if it exists (prevents stacking)
if pgui:FindFirstChild("MobileFly") then
    pgui.MobileFly:Destroy()
end

-- 1. BUILD THE UI
local sg = Instance.new("ScreenGui")
sg.Name = "MobileFly"
sg.Parent = pgui
sg.ResetOnSpawn = false

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0, 100, 0, 50)
btn.Position = UDim2.new(0.5, -50, 0.2, 0) -- Top middle of screen
btn.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Bright Red
btn.Text = "FLY OFF"
btn.TextColor3 = Color3.new(1,1,1)
btn.Draggable = true
btn.Parent = sg

local corner = Instance.new("UICorner", btn)

-- 2. FLY LOGIC
local flying = false
local speed = 50
local bv, bg

btn.MouseButton1Click:Connect(function()
    flying = not flying
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    
    if flying and root then
        btn.Text = "FLY ON"
        btn.BackgroundColor3 = Color3.fromRGB(0, 255, 0) -- Green
        
        bv = Instance.new("BodyVelocity", root)
        bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
        bg = Instance.new("BodyGyro", root)
        bg.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
        char.Humanoid.PlatformStand = true
        
        task.spawn(function()
            while flying do
                local cam = workspace.CurrentCamera.CFrame
                bv.Velocity = char.Humanoid.MoveDirection * speed
                bg.CFrame = cam
                
                -- Noclip (Walk through walls)
                for _, v in pairs(char:GetDescendants()) do
                    if v:IsA("BasePart") then v.CanCollide = false end
                end
                task.wait()
            end
        end)
    else
        btn.Text = "FLY OFF"
        btn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        if bv then bv:Destroy() end
        if bg then bg:Destroy() end
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.PlatformStand = false
        end
    end
end)

print("GUI SCRIPT LOADED SUCCESSFULLY")
