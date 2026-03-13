-- UNIVERSAL FLY GUI (MOBILE & PC)
local Player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- 1. CREATE THE UI
local ScreenGui = Instance.new("ScreenGui")
local ToggleButton = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")

ScreenGui.Name = "XenoFlyGui"
ScreenGui.Parent = CoreGui -- Puts it over the game UI
ScreenGui.ResetOnSpawn = false

ToggleButton.Name = "FlyButton"
ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ToggleButton.Position = UDim2.new(0.5, -50, 0.1, 0)
ToggleButton.Size = UDim2.new(0, 100, 0, 40)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.Text = "FLY: OFF"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 14.0
ToggleButton.Active = true
ToggleButton.Draggable = true -- Allows you to move the button on mobile

UICorner.Parent = ToggleButton

-- 2. FLY LOGIC
local flying = false
local speed = 60
local bv, bg

local function toggleFly()
    flying = not flying
    local char = Player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    
    if flying and root then
        ToggleButton.Text = "FLY: ON"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        
        bv = Instance.new("BodyVelocity", root)
        bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
        bg = Instance.new("BodyGyro", root)
        bg.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
        char.Humanoid.PlatformStand = true
        
        task.spawn(function()
            while flying and char and char:FindFirstChild("Humanoid") do
                local cam = workspace.CurrentCamera.CFrame
                local dir = Vector3.new(0,0,0)
                
                -- Support for both Virtual Joystick (Mobile) and Keyboard (PC)
                local move = char.Humanoid.MoveDirection
                if move.Magnitude > 0 then
                    dir = move
                end
                
                -- Vertical movement based on camera angle
                bv.Velocity = dir * speed
                bg.CFrame = cam
                
                -- Noclip logic
                for _, v in pairs(char:GetDescendants()) do
                    if v:IsA("BasePart") then v.CanCollide = false end
                end
                RunService.RenderStepped:Wait()
            end
        end)
    else
        ToggleButton.Text = "FLY: OFF"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        if bv then bv:Destroy() end
        if bg then bg:Destroy() end
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.PlatformStand = false
        end
    end
end

-- 3. CONNECT INPUTS
ToggleButton.MouseButton1Click:Connect(toggleFly)

UIS.InputBegan:Connect(function(i, p)
    if not p and i.KeyCode == Enum.KeyCode.F then toggleFly() end
end)

-- Initial Notification
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Xeno Fly Loaded",
    Text = "Use the button or press F",
    Duration = 3
})
