-- Xeno Optimized Fly Script
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local flying = false
local speed = 50
local bv = Instance.new("BodyVelocity")
local bg = Instance.new("BodyGyro")

-- Setup forces (initially parented to nil)
bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
bg.MaxTorque = Vector3.new(1e6, 1e6, 1e6)

local function toggleFly()
    flying = not flying
    if flying then
        char.Humanoid.PlatformStand = true
        bv.Parent = root
        bg.Parent = root
        print("Xeno: Flight Enabled")
    else
        char.Humanoid.PlatformStand = false
        bv.Parent = nil
        bg.Parent = nil
        print("Xeno: Flight Disabled")
    end
end

-- Input Loop
RunService.RenderStepped:Connect(function()
    if flying and root then
        local cam = workspace.CurrentCamera
        local moveDir = Vector3.new(0,0,0)
        
        if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir += cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir -= cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir -= cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir += cam.CFrame.RightVector end
        
        bv.Velocity = moveDir * speed
        bg.CFrame = cam.CFrame
    end
end)

UIS.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.F then
        toggleFly()
    end
end)

print("Xeno Script Loaded - Press F to Fly")
