-- BRUTE FORCE FLY (XENO MOBILE/PC)
local Player = game.Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

-- 1. CLEAN UP (Deletes old versions so they don't stack)
if CoreGui:FindFirstChild("XenoFly") then CoreGui.XenoFly:Destroy() end

-- 2. CREATE THE INTERFACE
local sg = Instance.new("ScreenGui")
sg.Name = "XenoFly"
sg.Parent = CoreGui
sg.IgnoreGuiInset = true -- Makes it show over everything

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0, 120, 0, 45)
btn.Position = UDim2.new(0.5, -60, 0.05, 0) -- Top of screen
btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
btn.BorderSizePixel = 2
btn.BorderColor3 = Color3.fromRGB(255, 255, 255)
btn.Text = "FLY: OFF"
btn.TextColor3 = Color3.new(1, 1, 1)
btn.Font = Enum.Font.RobotoMono
btn.TextSize = 18
btn.Active = true
btn.Draggable = true -- Hold and drag on mobile
btn.Parent = sg

local corner = Instance.new("UICorner", btn)

-- 3. THE LOGIC
local flying = false
local speed = 50
local bv, bg

btn.MouseButton1Click:Connect(function()
    flying = not flying
    local char = Player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    
    if flying and root then
        btn.Text = "FLY: ON"
        btn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        
        bv = Instance.new("BodyVelocity", root)
        bv.MaxForce = Vector3.new(1e7, 1e7, 1e7)
        bg = Instance.new("BodyGyro", root)
        bg.MaxTorque = Vector3.new(1e7, 1e7, 1e7)
        char.Humanoid.PlatformStand = true
        
        task.spawn(function()
            while flying do
                local cam = workspace.CurrentCamera.CFrame
                -- Use MoveDirection for Mobile Joystick support
                bv.Velocity = char.Humanoid.MoveDirection * speed
                bg.CFrame = cam
                
                -- Noclip (Bypass walls)
                for _, v in pairs(char:GetDescendants()) do
                    if v:IsA("BasePart") then v.CanCollide = false end
                end
                task.wait()
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

print("Xeno Fly GUI Forced Successfully")
