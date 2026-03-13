-- XENO COMPATIBLE FLY + NOCLIP
local Player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Notification to confirm the script actually started
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Xeno Loaded",
    Text = "Press F to fly!",
    Duration = 5
})

local flying = false
local speed = 60
local bv, bg

local function toggle()
    flying = not flying
    local char = Player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    
    if flying and root then
        bv = Instance.new("BodyVelocity", root)
        bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
        bg = Instance.new("BodyGyro", root)
        bg.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
        char.Humanoid.PlatformStand = true
        
        -- Flying Loop
        task.spawn(function()
            while flying do
                local cam = workspace.CurrentCamera.CFrame
                local dir = Vector3.new(0,0,0)
                if UIS:IsKeyDown(Enum.KeyCode.W) then dir += cam.LookVector end
                if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= cam.LookVector end
                if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= cam.RightVector end
                if UIS:IsKeyDown(Enum.KeyCode.D) then dir += cam.RightVector end
                
                bv.Velocity = dir * speed
                bg.CFrame = cam
                
                -- Noclip logic (so you don't get stuck in walls)
                for _, v in pairs(char:GetDescendants()) do
                    if v:IsA("BasePart") then v.CanCollide = false end
                end
                RunService.RenderStepped:Wait()
            end
        end)
    else
        if bv then bv:Destroy() end
        if bg then bg:Destroy() end
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.PlatformStand = false
        end
    end
end

UIS.InputBegan:Connect(function(i, p)
    if not p and i.KeyCode == Enum.KeyCode.F then toggle() end
end)
