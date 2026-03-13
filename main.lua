-- MOBILE FLY V3 (FULL VERTICAL CONTROL)
local Player = game.Players.LocalPlayer
local pgui = Player:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")

-- Cleanup old GUI
if pgui:FindFirstChild("XenoFlyV3") then pgui.XenoFlyV3:Destroy() end

local sg = Instance.new("ScreenGui", pgui)
sg.Name = "XenoFlyV3"
sg.ResetOnSpawn = false

-- Helper to make buttons quickly
local function createBtn(name, pos, size, text, color)
    local b = Instance.new("TextButton", sg)
    b.Name = name
    b.Position = pos
    b.Size = size
    b.Text = text
    b.BackgroundColor3 = color
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.SourceSansBold
    b.TextSize = 20
    Instance.new("UICorner", b)
    return b
end

-- Main Toggle, Up, and Down Buttons
local main = createBtn("Toggle", UDim2.new(0.5, -50, 0.1, 0), UDim2.new(0, 100, 0, 40), "FLY: OFF", Color3.fromRGB(50,50,50))
local up = createBtn("Up", UDim2.new(0.8, 0, 0.5, -60), UDim2.new(0, 50, 0, 50), "▲", Color3.fromRGB(70,70,70))
local down = createBtn("Down", UDim2.new(0.8, 0, 0.5, 0), UDim2.new(0, 50, 0, 50), "▼", Color3.fromRGB(70,70,70))

-- Dragging for main button
main.Draggable = true

-- Logic Variables
local flying = false
local speed = 60
local verticalForce = 0
local bv, bg

-- Vertical Button Logic
up.MouseButton1Down:Connect(function() verticalForce = speed end)
up.MouseButton1Up:Connect(function() verticalForce = 0 end)
down.MouseButton1Down:Connect(function() verticalForce = -speed end)
down.MouseButton1Up:Connect(function() verticalForce = 0 end)

main.MouseButton1Click:Connect(function()
    flying = not flying
    local char = Player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    
    if flying and root then
        main.Text = "FLY: ON"
        main.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
        
        bv = Instance.new("BodyVelocity", root)
        bv.MaxForce = Vector3.new(1e7, 1e7, 1e7)
        bg = Instance.new("BodyGyro", root)
        bg.MaxTorque = Vector3.new(1e7, 1e7, 1e7)
        char.Humanoid.PlatformStand = true
        
        task.spawn(function()
            while flying do
                local cam = workspace.CurrentCamera.CFrame
                local moveDir = char.Humanoid.MoveDirection * speed
                
                -- Combined Joystick Move + Vertical Buttons
                bv.Velocity = moveDir + Vector3.new(0, verticalForce, 0)
                bg.CFrame = cam
                
                -- Noclip
                for _, v in pairs(char:GetDescendants()) do
                    if v:IsA("BasePart") then v.CanCollide = false end
                end
                task.wait()
            end
        end)
    else
        main.Text = "FLY: OFF"
        main.BackgroundColor3 = Color3.fromRGB(50,50,50)
        if bv then bv:Destroy() end
        if bg then bg:Destroy() end
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.PlatformStand = false
        end
    end
end)
