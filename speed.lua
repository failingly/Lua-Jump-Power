-- Configuration
getgenv().speed = {
    enabled = false, -- Enable or disable the speed boost
    speed = 16,    -- Desired walk speed
    control = false, -- Enable enhanced control
    friction = 2.0, -- Custom friction factor for more control
}

-- Function to set the player's walk speed
local function setSpeed(player, speed)
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = speed
    end
end

-- Enhanced control function
local function enhanceControl(player, reset)
    local character = player.Character or player.CharacterAdded:Wait()
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if rootPart then
        if reset then
            -- Reset to default physical properties
            rootPart.CustomPhysicalProperties = PhysicalProperties.new()
        else
            -- Apply custom friction or dampening
            rootPart.CustomPhysicalProperties = PhysicalProperties.new(
                0.7, -- Density
                speed.friction, -- Friction
                0.5, -- Elasticity
                1.0, -- FrictionWeight
                0.5  -- ElasticityWeight
            )
        end
    end
end

-- Apply speed and controls to the player's character
local function applySpeedBoost(player)
    local character = player.Character or player.CharacterAdded:Wait()

    if speed.enabled then
        setSpeed(player, speed.speed)
        if speed.control then
            enhanceControl(player, false) -- Apply enhanced control
        end
    else
        setSpeed(player, 16) -- Default walk speed
        if speed.control then
            enhanceControl(player, true) -- Reset control to default
        end
    end
end

-- Main
local player = game.Players.LocalPlayer

-- Apply speed boost to the current character
if player.Character then
    applySpeedBoost(player)
end

-- React to new characters
player.CharacterAdded:Connect(function()
    applySpeedBoost(player)
end)

-- Allow dynamic updates to speed
game:GetService("RunService").RenderStepped:Connect(function()
    if speed.enabled then
        setSpeed(player, speed.speed)
    else
        applySpeedBoost(player)
    end
end)
