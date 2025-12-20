local espLib = {}

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local Camera = workspace.CurrentCamera

local lplayer = Players.LocalPlayer
local espGui

local Functions = {}

function Functions:Create(class, properties)
    local instance = typeof(class) == 'string' and Instance.new(class) or class
    if properties then
        for prop, value in pairs(properties) do
            instance[prop] = value
        end
    end
    return instance
end

function Functions:FadeElement(element, targetAlpha, elapsed, fadeTime)
    local progress = math.min(elapsed / fadeTime, 1)
    local alpha = targetAlpha * progress
    
    if element:IsA("TextLabel") or element:IsA("TextButton") then
        element.TextTransparency = 1 - alpha
    elseif element:IsA("UIStroke") then
        element.Transparency = 1 - alpha
    elseif element:IsA("UIGradient") then
        element.Transparency = NumberSequence.new(1 - alpha)
    elseif element:IsA("ImageLabel") then
        element.ImageTransparency = 1 - alpha
    elseif element:IsA("Frame") then
        element.BackgroundTransparency = 1 - alpha
    end
end

function Functions:SetElementTransparency(element, alpha)
    if element:IsA("TextLabel") or element:IsA("TextButton") then
        element.TextTransparency = 1 - alpha
    elseif element:IsA("UIStroke") then
        element.Transparency = 1 - alpha
    elseif element:IsA("UIGradient") then
        element.Transparency = NumberSequence.new(1 - alpha)
    elseif element:IsA("ImageLabel") then
        element.ImageTransparency = 1 - alpha
    elseif element:IsA("Frame") then
        element.BackgroundTransparency = 1 - alpha
    end
end

local espObjects = {}

espLib.config = {
    enabled = false,
    global = {
        dontFade = false,
        fadeTime = 0.5,
        useTeamColor = false
    },
    teamESPToggles = {
        Natural = false
    },
    toggles = {
        box = false,
        name = false,
        distance = false,
        healthBar = false,
        healthText = false,
        tool = false,
        outlineBox = false,
        outlineName = false,
        outlineDistance = false,
        outlineHealthBar = false,
        outlineHealthText = false,
        outlineTool = false,
    },
    colors = {
        box = {
            colors = {
                ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
                ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)),
                ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1)),
            },
            transparency = {
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(0.5, 0),
                NumberSequenceKeypoint.new(1, 0),
            },
            rotation = 0,
            filled = false,
            filledcolors = {
                ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
                ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)),
                ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1)),
            },
            filledtransparency = {
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(0.5, 0),
                NumberSequenceKeypoint.new(1, 0),
            },
            filledrotation = 0,
        },
        name = {
            colors = {
                ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
                ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)),
                ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1)),
            },
            transparency = {
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(0.5, 0),
                NumberSequenceKeypoint.new(1, 0),
            },
            rotation = 0,
        },
        distance = {
            colors = {
                ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
                ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)),
                ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1)),
            },
            transparency = {
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(0.5, 0),
                NumberSequenceKeypoint.new(1, 0),
            },
            rotation = 0,
        },
        healthBar = {
            colors = {
                ColorSequenceKeypoint.new(0, Color3.new(0, 1, 0)),
                ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 0)),
                ColorSequenceKeypoint.new(1, Color3.new(1, 0, 0)),
            },
            transparency = {
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(0.5, 0),
                NumberSequenceKeypoint.new(1, 0),
            },
            animated = false,
            animatedSpeed = 0.5,
        },
        healthText = {
            colors = {
                ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
                ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)),
                ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1)),
            },
            transparency = {
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(0.5, 0),
                NumberSequenceKeypoint.new(1, 0),
            },
            rotation = 0,
        },
        tool = {
            colors = {
                ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
                ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)),
                ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1)),
            },
            transparency = {
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(0.5, 0),
                NumberSequenceKeypoint.new(1, 0),
            },
            rotation = 0,
        },
        outlineBox = {
            colors = {
                ColorSequenceKeypoint.new(0, Color3.new(0, 0, 0)),
                ColorSequenceKeypoint.new(0.5, Color3.new(0, 0, 0)),
                ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0)),
            },
            transparency = {
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(0.5, 0),
                NumberSequenceKeypoint.new(1, 0),
            },
            rotation = 0,
        },
        outlineName = {
            colors = {
                ColorSequenceKeypoint.new(0, Color3.new(0, 0, 0)),
                ColorSequenceKeypoint.new(0.5, Color3.new(0, 0, 0)),
                ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0)),
            },
            transparency = {
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(0.5, 0),
                NumberSequenceKeypoint.new(1, 0),
            },
            rotation = 0,
        },
        outlineDistance = {
            colors = {
                ColorSequenceKeypoint.new(0, Color3.new(0, 0, 0)),
                ColorSequenceKeypoint.new(0.5, Color3.new(0, 0, 0)),
                ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0)),
            },
            transparency = {
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(0.5, 0),
                NumberSequenceKeypoint.new(1, 0),
            },
            rotation = 0,
        },
        outlineHealthBar = {
            colors = {
                ColorSequenceKeypoint.new(0, Color3.new(0, 0, 0)),
                ColorSequenceKeypoint.new(0.5, Color3.new(0, 0, 0)),
                ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0)),
            },
            transparency = {
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(0.5, 0),
                NumberSequenceKeypoint.new(1, 0),
            },
            rotation = 0,
        },
        outlineHealthText = {
            colors = {
                ColorSequenceKeypoint.new(0, Color3.new(0, 0, 0)),
                ColorSequenceKeypoint.new(0.5, Color3.new(0, 0, 0)),
                ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0)),
            },
            transparency = {
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(0.5, 0),
                NumberSequenceKeypoint.new(1, 0),
            },
            rotation = 0,
        },
        outlineTool = {
            colors = {
                ColorSequenceKeypoint.new(0, Color3.new(0, 0, 0)),
                ColorSequenceKeypoint.new(0.5, Color3.new(0, 0, 0)),
                ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0)),
            },
            transparency = {
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(0.5, 0),
                NumberSequenceKeypoint.new(1, 0),
            },
            rotation = 0,
        },
    },
}

function espLib.getTool(player)
    return player.Character and player.Character:FindFirstChildWhichIsA("Tool")
end

function espLib.getDistance(player)
    return (player.Character.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
end

local function shouldRenderPlayer(player)
    if player == lplayer then
        return false
    end
    
    local hasTeamsEnabled = false
    for _, enabled in pairs(espLib.config.teamESPToggles) do
        if enabled == true then
            hasTeamsEnabled = true
            break
        end
    end
    
    if not hasTeamsEnabled then
        return true
    end
    
    if not player.Team then
        return false
    end
    
    local teamToggle = espLib.config.teamESPToggles[player.Team.Name]
    return teamToggle == true
end

local function getESPGui()
    if not espGui then
        espGui = Functions:Create("ScreenGui", {
            Parent = CoreGui,
            Name = "ESPLibGui",
            ResetOnSpawn = false,
        })
    end
    return espGui
end

local function createESPElements(player)
    local container = Functions:Create("Frame", {
        Parent = getESPGui(),
        Name = player.Name .. "_ESPContainer",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        LayoutOrder = 0,
    })
    
    local box = Functions:Create("Frame", {
        Parent = container,
        Name = "Box",
        BackgroundColor3 = Color3.new(1, 1, 1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 1,
    })

    local boxFilled = Functions:Create("UIGradient", {
        Parent = box,
    })
    
    local boxStroke = Functions:Create("UIStroke", {
        Parent = box,
        Thickness = 1,
        Color = Color3.new(1, 1, 1),
        LineJoinMode = Enum.LineJoinMode.Miter
    })
    
    local boxGradient = Functions:Create("UIGradient", {
        Parent = boxStroke,
    })

    local boxOutline = Functions:Create("Frame", {
        Parent = container,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 0,
    })

    local boxOutlineStroke = Functions:Create("UIStroke", {
        Parent = boxOutline,
        Thickness = 3,
        LineJoinMode = Enum.LineJoinMode.Miter
    })
    
    local boxOutlineStrokeGradient = Functions:Create("UIGradient", {
        Parent = boxOutlineStroke,
    })
    
    local nameLabel = Functions:Create("TextLabel", {
        Parent = container,
        Name = "Name",
        BackgroundTransparency = 1,
        TextColor3 = Color3.new(1, 1, 1),
        TextSize = 14,
        AutomaticSize = Enum.AutomaticSize.XY,
        Font = Enum.Font.Code,
    })
    local nameStroke = Functions:Create("UIStroke", {
        Parent = nameLabel,
        Thickness = 1,
        LineJoinMode = Enum.LineJoinMode.Miter,
        Enabled = false
    })
    local nameGradient = Functions:Create("UIGradient", {
        Parent = nameLabel,
    })
    local nameStrokeGradient = Functions:Create("UIGradient", {
        Parent = nameStroke,
    })
    
    local healthbar = Functions:Create("Frame", {
        Parent = container,
        Name = "Healthbar",
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderSizePixel = 0,
    })

    local healthbarOutline = Functions:Create("UIStroke", {
        Parent = healthbar,
        Thickness = 1,
        LineJoinMode = Enum.LineJoinMode.Miter,
        Enabled = false
    })

    local healthbarOutlineGradient = Functions:Create("UIGradient", {
        Parent = healthbarOutline,
    })
    
    local healthbarGradient = Functions:Create("UIGradient", {
        Rotation = 90,
        Parent = healthbar,
    })
    
    local healthText = Functions:Create("TextLabel", {
        Parent = container,
        Name = "HealthText",
        BackgroundTransparency = 1,
        TextColor3 = Color3.new(1, 1, 1),
        TextSize = 12,
        AutomaticSize = Enum.AutomaticSize.XY,
        Font = Enum.Font.Code,
    })
    local healthTextStroke = Functions:Create("UIStroke", {
        Parent = healthText,
        Thickness = 1,
        LineJoinMode = Enum.LineJoinMode.Miter,
        Enabled = false
    })
    local healthTextGradient = Functions:Create("UIGradient", {
        Parent = healthText,
    })
    local healthTextStrokeGradient = Functions:Create("UIGradient", {
        Parent = healthTextStroke,
    })
    
    local distanceLabel = Functions:Create("TextLabel", {
        Parent = container,
        Name = "Distance",
        BackgroundTransparency = 1,
        TextColor3 = Color3.new(1, 1, 1),
        TextSize = 12,
        AutomaticSize = Enum.AutomaticSize.XY,
        Font = Enum.Font.Code,
    })
    local distanceStroke = Functions:Create("UIStroke", {
        Parent = distanceLabel,
        Thickness = 1,
        LineJoinMode = Enum.LineJoinMode.Miter,
        Enabled = false
    })
    local distanceGradient = Functions:Create("UIGradient", {
        Parent = distanceLabel,
    })
    local distanceStrokeGradient = Functions:Create("UIGradient", {
        Parent = distanceStroke,
    })
    
    local toolLabel = Functions:Create("TextLabel", {
        Parent = container,
        Name = "Tool",
        BackgroundTransparency = 1,
        TextColor3 = Color3.new(1, 1, 1),
        TextSize = 12,
        AutomaticSize = Enum.AutomaticSize.XY,
        Font = Enum.Font.Code,
    })
    local toolStroke = Functions:Create("UIStroke", {
        Parent = toolLabel,
        Thickness = 1,
        Color = Color3.new(1, 1, 1),
        LineJoinMode = Enum.LineJoinMode.Miter,
        Enabled = false
    })
    local toolGradient = Functions:Create("UIGradient", {
        Parent = toolLabel,
    })
    local toolStrokeGradient = Functions:Create("UIGradient", {
        Parent = toolStroke,
    })
    
    return {
        container = container,
        box = box,
        boxFilled = boxFilled,
        boxStroke = boxStroke,
        boxGradient = boxGradient,
        boxOutline = boxOutline,
        boxOutlineStroke = boxOutlineStroke,
        boxOutlineStrokeGradient = boxOutlineStrokeGradient,
        nameLabel = nameLabel,
        nameStroke = nameStroke,
        nameGradient = nameGradient,
        nameStrokeGradient = nameStrokeGradient,
        healthbarOutline = healthbarOutline,
        healthbarOutlineGradient = healthbarOutlineGradient,
        healthbar = healthbar,
        healthbarGradient = healthbarGradient,
        healthText = healthText,
        healthTextStroke = healthTextStroke,
        healthTextGradient = healthTextGradient,
        healthTextStrokeGradient = healthTextStrokeGradient,
        distanceLabel = distanceLabel,
        distanceStroke = distanceStroke,
        distanceGradient = distanceGradient,
        distanceStrokeGradient = distanceStrokeGradient,
        toolLabel = toolLabel,
        toolStroke = toolStroke,
        toolGradient = toolGradient,
        toolStrokeGradient = toolStrokeGradient,
    }
end

local function destroyESPElements(espData)
    if espData and espData.container then
        espData.container:Destroy()
    end
end

local function hideESP(espData)
    if espData then
        espData.container.Visible = false
    end
end

local function showESP(espData)
    if espData then
        espData.container.Visible = true
    end
end

local function createPlayerESP(player)
    if espObjects[player] then
        destroyESPElements(espObjects[player])
    end
    
    local espData = createESPElements(player)
    local lastFadeStartTime = tick()
    local lastEnabledState = espLib.config.enabled
    
    local connection
    connection = RunService.RenderStepped:Connect(function()
        if not player.Parent or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
            hideESP(espData)
            return
        end
        
        if not shouldRenderPlayer(player) then
            hideESP(espData)
            return
        end
        
        if espLib.config.enabled ~= lastEnabledState then
            lastFadeStartTime = tick()
            lastEnabledState = espLib.config.enabled
        end
        
        local humanoid = player.Character:FindFirstChild("Humanoid")
        if not humanoid then
            hideESP(espData)
            return
        end
        
        local hrp = player.Character.HumanoidRootPart
        local screenPos, onScreen = Camera:WorldToScreenPoint(hrp.Position)
        
        if not onScreen then
            hideESP(espData)
            return
        end
        
        local currentTime = tick()
        local elapsedTime = currentTime - lastFadeStartTime
        local alpha = 1
        
        if espLib.config.global.dontFade then
            alpha = espLib.config.enabled and 1 or 0
            if alpha == 0 then
                hideESP(espData)
                return
            else
                showESP(espData)
            end
        else
            if espLib.config.enabled then
                alpha = math.min(elapsedTime / espLib.config.global.fadeTime, 1)
            else
                alpha = math.max(1 - (elapsedTime / espLib.config.global.fadeTime), 0)
                if alpha == 0 then
                    hideESP(espData)
                    return
                end
            end
            showESP(espData)
        end
        
        local hrpSize = hrp.Size.Y
        local distance = (Camera.CFrame.Position - hrp.Position).Magnitude
        local scaleFactor = (hrpSize * Camera.ViewportSize.Y) / (screenPos.Z * 2)
        local boxWidth = 3 * scaleFactor
        local boxHeight = 4.5 * scaleFactor
        
        if espLib.config.toggles.box then
            espData.box.Visible = true
            espData.box.BackgroundTransparency = espLib.config.colors.box.filled and 0 or 1
            espData.box.Position = UDim2.new(0, screenPos.X - boxWidth / 2, 0, screenPos.Y - boxHeight / 2)
            espData.box.Size = UDim2.new(0, boxWidth, 0, boxHeight)
            espData.boxGradient.Color = ColorSequence.new(espLib.config.colors.box.colors)
            espData.boxGradient.Transparency = NumberSequence.new(espLib.config.colors.box.transparency)
            espData.boxGradient.Rotation = espLib.config.colors.box.rotation

            if espLib.config.colors.box.filled then
                espData.boxFilled.Color = ColorSequence.new(espLib.config.colors.box.filledcolors)
                espData.boxFilled.Transparency = NumberSequence.new(espLib.config.colors.box.filledtransparency)
                espData.boxFilled.Rotation = espLib.config.colors.box.filledrotation
            end

            Functions:SetElementTransparency(espData.boxStroke, alpha)

            if espLib.config.toggles.outlineBox then
                espData.boxOutline.Visible = true
                espData.boxOutline.Position = UDim2.new(0, (screenPos.X - boxWidth / 2) + 1, 0, screenPos.Y - boxHeight / 2 + 1)
                espData.boxOutline.Size = UDim2.new(0, boxWidth - 2, 0, boxHeight - 2)
                espData.boxOutlineStroke.Color = Color3.new(1, 1, 1)
                espData.boxOutlineStrokeGradient.Color = ColorSequence.new(espLib.config.colors.outlineBox.colors)
                espData.boxOutlineStrokeGradient.Transparency = NumberSequence.new(espLib.config.colors.outlineBox.transparency)
                espData.boxOutlineStrokeGradient.Rotation = espLib.config.colors.outlineBox.rotation
                Functions:SetElementTransparency(espData.boxOutlineStroke, alpha)
            else
                espData.boxOutline.Visible = false
            end
        else
            espData.box.Visible = false
        end
        
        if espLib.config.toggles.name then
            espData.nameLabel.Visible = true
            espData.nameLabel.Text = player.Name
            espData.nameLabel.Position = UDim2.new(0, screenPos.X, 0, screenPos.Y - boxHeight / 2 - 13)
            espData.nameLabel.Size = UDim2.new(0, 120, 0, 18)
            espData.nameLabel.AnchorPoint = Vector2.new(0.5, 0.5)
            Functions:SetElementTransparency(espData.nameLabel, alpha)

            if espLib.config.toggles.outlineName then
                espData.nameStroke.Enabled = true
                espData.nameStroke.Color = Color3.new(1, 1, 1)
                espData.nameStrokeGradient.Color = ColorSequence.new(espLib.config.colors.outlineName.colors)
                espData.nameStrokeGradient.Transparency = NumberSequence.new(espLib.config.colors.outlineName.transparency)
                espData.nameStrokeGradient.Rotation = espLib.config.colors.outlineName.rotation
                Functions:SetElementTransparency(espData.nameStroke, alpha)
            else
                espData.nameStroke.Enabled = false
            end
            espData.nameGradient.Color = ColorSequence.new(espLib.config.colors.name.colors)
            espData.nameGradient.Transparency = NumberSequence.new(espLib.config.colors.name.transparency)
            espData.nameGradient.Rotation = espLib.config.colors.name.rotation
            Functions:SetElementTransparency(espData.nameGradient, alpha)
        else
            espData.nameLabel.Visible = false
        end
        
        if espLib.config.toggles.healthBar then
            local healthPercent = humanoid.Health / humanoid.MaxHealth
            local barWidth = espLib.config.colors.healthBar.width or 2.5
            espData.healthbar.Visible = true
            
            espData.healthbar.Position = UDim2.new(0, screenPos.X - boxWidth / 2 - barWidth - 6, 0, screenPos.Y - boxHeight / 2 + boxHeight * (1 - healthPercent))
            espData.healthbar.Size = UDim2.new(0, barWidth, 0, boxHeight * healthPercent)
                if espLib.config.colors.healthBar.animated then
                    local speed = espLib.config.colors.healthBar.animatedSpeed or 1
                    local t = (math.sin(tick() * speed * math.pi * 2) + 1) / 2
                    local orig = espLib.config.colors.healthBar.colors
                    local n = #orig
                    local kp = {}
                    for i = 1, n do
                        local a = orig[i].Value
                        local b = orig[n - i + 1].Value
                        local col = a:Lerp(b, t)
                        table.insert(kp, ColorSequenceKeypoint.new(orig[i].Time, col))
                    end
                    espData.healthbarGradient.Color = ColorSequence.new(kp)
                else
                    espData.healthbarGradient.Color = ColorSequence.new(espLib.config.colors.healthBar.colors)
                end
            espData.healthbarGradient.Transparency = NumberSequence.new(espLib.config.colors.healthBar.transparency)

            if espLib.config.toggles.outlineHealthBar then
                espData.healthbarOutline.Enabled = true
                espData.healthbarOutline.Color = Color3.new(1, 1, 1)
                espData.healthbarOutlineGradient.Color = ColorSequence.new(espLib.config.colors.outlineHealthBar.colors)
                espData.healthbarOutlineGradient.Transparency = NumberSequence.new(espLib.config.colors.outlineHealthBar.transparency)
                espData.healthbarOutlineGradient.Rotation = espLib.config.colors.outlineHealthBar.rotation
                Functions:SetElementTransparency(espData.healthbarOutline, alpha)
            else
                espData.healthbarOutline.Enabled = false
            end
            
            Functions:SetElementTransparency(espData.healthbar, alpha)
        else
            espData.healthbar.Visible = false
        end
        
        if espLib.config.toggles.healthText then
            espData.healthText.Visible = true
            local healthPercent = math.floor(humanoid.Health / humanoid.MaxHealth * 100)
            espData.healthText.Visible = humanoid.Health < humanoid.MaxHealth
            espData.healthText.Text = tostring(healthPercent) .. "%"
            local barWidth = espLib.config.colors.healthBar.width or 2.5
            espData.healthText.Position = UDim2.new(0, screenPos.X - boxWidth / 2 - barWidth - 6, 0, screenPos.Y - boxHeight / 2 + boxHeight * (1 - healthPercent / 100) + 3)
            espData.healthText.Size = UDim2.new(0, 50, 0, 14)
            espData.healthText.AnchorPoint = Vector2.new(0.5, 0.5)
            Functions:SetElementTransparency(espData.healthText, alpha)

            if espLib.config.toggles.outlineHealthText then
                espData.healthTextStroke.Enabled = true
                espData.healthTextStroke.Color = Color3.new(1, 1, 1)
                espData.healthTextStrokeGradient.Color = ColorSequence.new(espLib.config.colors.outlineHealthText.colors)
                espData.healthTextStrokeGradient.Transparency = NumberSequence.new(espLib.config.colors.outlineHealthText.transparency)
                espData.healthTextStrokeGradient.Rotation = espLib.config.colors.outlineHealthText.rotation
                Functions:SetElementTransparency(espData.healthTextStroke, alpha)
            else
                espData.healthTextStroke.Enabled = false
            end
            espData.healthTextGradient.Color = ColorSequence.new(espLib.config.colors.healthText.colors)
            espData.healthTextGradient.Transparency = NumberSequence.new(espLib.config.colors.healthText.transparency)
            espData.healthTextGradient.Rotation = espLib.config.colors.healthText.rotation
            Functions:SetElementTransparency(espData.healthTextGradient, alpha)
        else
            espData.healthText.Visible = false
        end
        
        if espLib.config.toggles.distance then
            espData.distanceLabel.Visible = true
            espData.distanceLabel.Text = string.format("[%d]", math.floor(distance))
            espData.distanceLabel.Position = UDim2.new(0, screenPos.X, 0, screenPos.Y + boxHeight / 2 + 15)
            espData.distanceLabel.Size = UDim2.new(0, 60, 0, 16)
            espData.distanceLabel.AnchorPoint = Vector2.new(0.5, 0)
            Functions:SetElementTransparency(espData.distanceLabel, alpha)

            if espLib.config.toggles.outlineDistance then
                espData.distanceStroke.Enabled = true
                espData.distanceStroke.Color = Color3.new(1, 1, 1)
                espData.distanceStrokeGradient.Color = ColorSequence.new(espLib.config.colors.outlineDistance.colors)
                espData.distanceStrokeGradient.Transparency = NumberSequence.new(espLib.config.colors.outlineDistance.transparency)
                espData.distanceStrokeGradient.Rotation = espLib.config.colors.outlineDistance.rotation
                Functions:SetElementTransparency(espData.distanceStroke, alpha)
            else
                espData.distanceStroke.Enabled = false
            end

            espData.distanceGradient.Color = ColorSequence.new(espLib.config.colors.distance.colors)
            espData.distanceGradient.Transparency = NumberSequence.new(espLib.config.colors.distance.transparency)
            espData.distanceGradient.Rotation = espLib.config.colors.distance.rotation
            Functions:SetElementTransparency(espData.distanceGradient, alpha)
        else
            espData.distanceLabel.Visible = false
        end
        
        if espLib.config.toggles.tool then
            local tool = espLib.getTool(player)
            espData.toolLabel.Visible = true
            espData.toolLabel.Text = tool and tool.Name or "None"
            espData.toolLabel.Position = UDim2.new(0, screenPos.X, 0, screenPos.Y + boxHeight / 2)
            espData.toolLabel.Size = UDim2.new(0, 100, 0, 16)
            espData.toolLabel.AnchorPoint = Vector2.new(0.5, 0)
            Functions:SetElementTransparency(espData.toolLabel, alpha)
            if espLib.config.toggles.outlineTool then
                espData.toolStroke.Enabled = true
                espData.toolStroke.Color = Color3.new(1, 1, 1)
                espData.toolStrokeGradient.Color = ColorSequence.new(espLib.config.colors.outlineTool.colors)
                espData.toolStrokeGradient.Transparency = NumberSequence.new(espLib.config.colors.outlineTool.transparency)
                espData.toolStrokeGradient.Rotation = espLib.config.colors.outlineTool.rotation
                Functions:SetElementTransparency(espData.toolStroke, alpha)
            else
                espData.toolStroke.Enabled = false
            end
            espData.toolGradient.Color = ColorSequence.new(espLib.config.colors.tool.colors)
            espData.toolGradient.Transparency = NumberSequence.new(espLib.config.colors.tool.transparency)
            espData.toolGradient.Rotation = espLib.config.colors.tool.rotation
            Functions:SetElementTransparency(espData.toolGradient, alpha)
        else
            espData.toolLabel.Visible = false
        end
    end)
    
    espData.connection = connection
    espObjects[player] = espData
end

espLib.initializeESP = function()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= lplayer then
            createPlayerESP(player)
        end
    end
end

Players.PlayerAdded:Connect(function(player)
    if player ~= lplayer then
        createPlayerESP(player)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    if espObjects[player] then
        local espData = espObjects[player]
        
        if espLib.config.global.dontFade then
            if espData.connection then
                espData.connection:Disconnect()
            end
            destroyESPElements(espData)
            espObjects[player] = nil
        else
            local startTime = tick()
            local fadeConnection
            fadeConnection = RunService.RenderStepped:Connect(function()
                local elapsed = tick() - startTime
                local progress = math.min(elapsed / espLib.config.global.fadeTime, 1)
                local alpha = 1 - progress
                
                if espData.container then
                    for _, element in pairs(espData) do
                        if typeof(element) == "Instance" and element:IsDescendantOf(espGui) then
                            Functions:SetElementTransparency(element, alpha)
                        end
                    end
                end
                
                if progress >= 1 then
                    fadeConnection:Disconnect()
                    if espData.connection then
                        espData.connection:Disconnect()
                    end
                    destroyESPElements(espData)
                    espObjects[player] = nil
                end
            end)
        end
    end
end)

if espLib.config.enabled then
    espLib.initializeESP()
end

return espLib
