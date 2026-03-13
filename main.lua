local Player = game.Players.LocalPlayer
local pgui = Player:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")

-- Cleanup
if pgui:FindFirstChild("XenoFlyV4") then pgui.XenoFlyV4:Destroy() end

local sg = Instance.new("ScreenGui", pgui)
sg.Name = "XenoFlyV4"
sg.ResetOnSpawn = false

-- Button Creator Function
local function createBtn(name, pos, size, text)
    local b = Instance.new("TextButton", sg)
    b.Name = name
    b.Position = pos
    b.Size = size
    b.Text = text
    b.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    b.BackgroundTransparency = 0.5
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.SourceSansBold
    b.TextSize = 25
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
    return b
end

-- UI Layout
local main = createBtn("Toggle", UDim2.new(0.5, -50, 0.05, 0), UDim2.new(0, 100, 0, 40), "FLY: OFF")
local upBtn = createBtn("Up", UDim2.new(0.85, 0, 0.45, 0), UDim2.new(0, 60, 0, 60), "▲")
local downBtn = createBtn("Down", UDim2.new(0.85, 0, 0.55, 0), UDim2.new(0, 60, 0, 60), "▼")

-- Variables
local flying = false
local speed = 70
local vertical = 0
local bv, bg

-- Vertical Logic
upBtn.MouseButton1Down:Connect(function() vertical = speed end)
upBtn.MouseButton1Up:Connect(function() vertical = 0 end)
downBtn.MouseButton1Down:Connect(function() vertical = -speed end)
downBtn.MouseButton1Up:Connect(function() vertical = 0 end)

main.MouseButton1Click:Connect(function()
    flying = not flying
    local char = Player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    
    if flying and root then
        main.Text = "FLY: ON"
        main.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        
        bv = Instance.new("BodyVelocity", root)
        bv.MaxForce = Vector3.new(1e7, 1e7, 1e7)
        bg = Instance.new("BodyGyro", root)
        bg.MaxTorque = Vector3.new(1e7, 1e7, 1e7)
        char.Humanoid.PlatformStand = true
        
        task.spawn(function()
            while flying and char and char:FindFirstChild("Humanoid") do
                local cam = workspace.CurrentCamera.CFrame
                local moveDir = char.Humanoid.MoveDirection * speed
                
                -- Add vertical force to the joystick movement
                bv.Velocity = moveDir + Vector3.new(0, vertical, 0)
                bg.CFrame = cam
                
                -- Noclip
                for _, v in pairs(char:GetDescendants()) do
                    if v:IsA("BasePart") then v.CanCollide = false end
                end
                RunService.RenderStepped:Wait()
            end
        end)
    else
        main.Text = "FLY: OFF"
        main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        if bv then bv:Destroy() end
        if bg then bg:Destroy() end
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.PlatformStand = false
        end
    end
end)
