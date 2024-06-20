local addonName, nameSpace = ...

local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_LOGIN")

frame:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == "WowheadQuickLink" then
        if WowheadQuickLinkCfg == nil then
            WowheadQuickLinkCfg = {
                prefix = "",
                suffix = "",
                default_bindings_set = false
            }
        end
    elseif event == "PLAYER_LOGIN" then
        -- Check if bindings have been set before
        if not WowheadQuickLinkCfg.default_bindings_set then
            -- Set default bindings
            HandleDefaultBindings("WOWHEAD_QUICK_LINK_NAME", "CTRL-C")
            HandleDefaultBindings("WOWHEAD_QUICK_LINK_RAIDERIO_NAME", "CTRL-SHIFT-C")

            SaveBindings(GetCurrentBindingSet())

            -- Mark default bindings as set
            WowheadQuickLinkCfg.default_bindings_set = true
        end

        self:UnregisterEvent("PLAYER_LOGIN")
    end
end)

function HandleDefaultBindings(binding_name, default_key)
    -- Get existing binding info
    local bind1 = GetBindingKey(binding_name)

    -- Check if the bind has been set by the user
    if not bind1 then
        -- Set the default key binding
        SetBinding(default_key, binding_name)
    end
end

function IsRetail()
    return false  -- Adjust based on your specific version check needs
end

function IsClassic()
    return false  -- Adjust based on your specific version check needs
end

function IsWrath()
    return true  -- Adjust based on your specific version check needs
end

local function Hide()
    WowheadQuickLinkConfig_Frame:Hide()
end

local function SetUrl()
    WowheadQuickLinkConfig_FinalUrlText:SetText(string.format(nameSpace.baseWowheadUrl, WowheadQuickLinkCfg.prefix, "<type>", "<id>", WowheadQuickLinkCfg.suffix))
end

SlashCmdList["WOWHEAD_QUICK_LINK"] = function(message, editBox)
    WowheadQuickLinkConfig_EditBoxPrefix:SetText(WowheadQuickLinkCfg.prefix)
    WowheadQuickLinkConfig_EditBoxSuffix:SetText(WowheadQuickLinkCfg.suffix)
    SetUrl()
    WowheadQuickLinkConfig_Frame:Show()
end

WowheadQuickLinkConfig_EditBoxPrefix:SetScript("OnEscapePressed", Hide)
WowheadQuickLinkConfig_EditBoxPrefix:SetScript("OnEnterPressed", Hide)

WowheadQuickLinkConfig_EditBoxSuffix:SetScript("OnEscapePressed", Hide)
WowheadQuickLinkConfig_EditBoxSuffix:SetScript("OnEnterPressed", Hide)

WowheadQuickLinkConfig_EditBoxPrefix:SetScript("OnTextChanged", function(self)
    WowheadQuickLinkCfg.prefix = self:GetText()
    SetUrl()
end)

WowheadQuickLinkConfig_EditBoxSuffix:SetScript("OnTextChanged", function(self)
    WowheadQuickLinkCfg.suffix = self:GetText()
    SetUrl()
end)

WowheadQuickLinkConfig_EditBoxPrefix:SetScript("OnTabPressed", function(self)
    WowheadQuickLinkConfig_EditBoxSuffix:SetFocus()
end)

WowheadQuickLinkConfig_EditBoxSuffix:SetScript("OnTabPressed", function(self)
    WowheadQuickLinkConfig_EditBoxPrefix:SetFocus()
end)

_G["BINDING_HEADER_WOWHEAD_QUICK_LINK_HEADER"] = "Wowhead Quick Link"
_G["BINDING_NAME_WOWHEAD_QUICK_LINK_NAME"] = "Generate Wowhead link"
_G["BINDING_NAME_WOWHEAD_QUICK_LINK_RAIDERIO_NAME"] = "Generate Raider.IO link"
