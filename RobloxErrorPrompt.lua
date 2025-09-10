-- Copied from native & Modified
local CreateInstance = function(InstanceType, Properties, Children)
    local Object = Instance.new(InstanceType)

    for Key, Value in next, Properties or {} do
        Object[Key] = Value
    end

    for _, Child in next, Children or {} do
        Child.Parent = Object
    end

    return Object
end

local DisplayPopup = function(Title, Message, ButtonText, CallbackFunction)
    if not getrenv then
        return warn(Message)
    end

    local ErrorModule = getrenv().require(
        game.CoreGui:WaitForChild("RobloxGui")
                    :WaitForChild("Modules")
                    :WaitForChild("ErrorPrompt")
    )

    local Prompt = ErrorModule.new("Default", { HideErrorCode = true })
    local ErrorGui = CreateInstance("ScreenGui", {
        Parent = game.CoreGui,
        ResetOnSpawn = false
    })


    Prompt:setParent(ErrorGui)
    Prompt:setErrorTitle(Title or "Error")
    Prompt:updateButtons({{
        Text = ButtonText or "Leave",
        Callback = CallbackFunction or function()
            Prompt:_close()
            ErrorGui:Destroy()
            game:Shutdown()
        end,
        Primary = true
    }}, "Default")

    Prompt:_open(Message or "An unknown error occurred.")
end

return DisplayPopup
