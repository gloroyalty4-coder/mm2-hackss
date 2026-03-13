local Player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local flying = false
local noclip = false
local speed = 50

local bv, bg

-- Function to handle Noclip (flying through walls)
local noclipConnection
local function toggleNoclip(state)
    if state then
        noclipConnection = RunService.Stepped:Connect(function()
            if Player.Character then
                for _, part in pairs(Player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if noclipConnection then noclipConnection:Disconnect() end
    end
end

local function startFlying()
    local char = Player.Character or Player.CharacterAdded:Wait()
    local root = char:WaitForChild("HumanoidRootPart")
    
    bv = Instance.new("BodyVelocity", root)
    bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
    bv.Velocity = Vector3.new(0, 0, 0)

    bg = Instance.new("BodyGyro", root)
    bg.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
    bg.CFrame = root.CFrame

    char.Humanoid.PlatformStand = true
    toggleNoclip(true) -- Turn on noclip when flying starts

    task.spawn(function()
        while flying do
            local camera = workspace.CurrentCamera
            local moveDir = Vector3.new(0,0,0)

            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir += camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir -= camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir -= camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir += camera.CFrame.RightVector end

            bv.Velocity = moveDir * speed
            bg.CFrame = camera.CFrame
            RunService.RenderStepped:Wait()
        end
    end)
end

local function stopFlying()
    flying = false
    toggleNoclip(false)
    if bv then bv:Destroy() end
    if bg then bg:Destroy() end
    if Player.Character and Player.Character:FindFirstChild("Humanoid") then
        Player.Character.Humanoid.PlatformStand = false
    end
end

UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.F then
        flying = not flying
        if flying then startFlying() else stopFlying() end
    end
end)
