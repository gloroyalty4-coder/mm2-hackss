local Player = game.Players.LocalPlayer
local Mouse = Player:GetMouse()
local RunService = game:GetService("RunService")

local flying = false
local speed = 50 -- Change this to go faster/slower
local bv, bg -- Velocity and Gyro objects

local function startFlying()
    local char = Player.Character or Player.CharacterAdded:Wait()
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    -- Create physical forces to stay in air
    bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
    bv.Velocity = Vector3.new(0, 0, 0)
    bv.Parent = root

    bg = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
    bg.CFrame = root.CFrame
    bg.Parent = root

    char.Humanoid.PlatformStand = true -- Stops the "walking" animation while flying

    -- Movement Loop
    task.spawn(function()
        while flying and root and char.Humanoid do
            local camera = workspace.CurrentCamera
            local moveDir = Vector3.new(0, 0, 0)

            -- Check keys for direction
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then
                moveDir = moveDir + camera.CFrame.LookVector
            end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then
                moveDir = moveDir - camera.CFrame.LookVector
            end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then
                moveDir = moveDir - camera.CFrame.RightVector
            end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then
                moveDir = moveDir + camera.CFrame.RightVector
            end

            bv.Velocity = moveDir * speed
            bg.CFrame = camera.CFrame
            RunService.RenderStepped:Wait()
        end
    end)
end

local function stopFlying()
    flying = false
    if bv then bv:Destroy() end
    if bg then bg:Destroy() end
    if Player.Character and Player.Character:FindFirstChild("Humanoid") then
        Player.Character.Humanoid.PlatformStand = false
    end
end

-- Toggle with F key
game:GetService("UserInputService").InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.F then
        flying = not flying
        if flying then
            startFlying()
            print("Flight: ON")
        else
            stopFlying()
            print("Flight: OFF")
        end
    end
end)
