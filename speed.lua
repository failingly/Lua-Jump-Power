-- Configuration
local speedConfig = {
    enabled = false, -- Enable or disable the speed boost
    speed = 16,    -- Desired walk speed
    controlEnhancement = false, -- Enable enhanced control
    friction = 2.0,  -- Custom friction factor for more control
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
local function enhanceControl(player)
    local character = player.Character or player.CharacterAdded:Wait()
    local rootPart = character:WaitForChild("HumanoidRootPart")
    
    -- Apply custom friction or dampening
    rootPart.CustomPhysicalProperties = PhysicalProperties.new(
        0.7, -- Density
        speedConfig.friction, -- Friction
        0.5, -- Elasticity
        1.0, -- FrictionWeight
        0.5  -- ElasticityWeight
    )
end

-- Apply speed and controls to the player's character
local function applySpeedBoost(player)
    local character = player.Character or player.CharacterAdded:Wait()

    if speedConfig.enabled then
        setSpeed(player, speedConfig.speed)
        if speedConfig.controlEnhancement then
            enhanceControl(player)
        end
    else
        setSpeed(player, 16) -- Default walk speed
        if speedConfig.controlEnhancement then
            enhanceControl(player) -- Reset to default physics
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

-- Allow dynamic updates to speedConfig
game:GetService("RunService").RenderStepped:Connect(function()
    if speedConfig.enabled then
        setSpeed(player, speedConfig.speed)
    end
end)
