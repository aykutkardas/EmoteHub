-- EmoteHub.lua
-- Main addon file for EmoteHub
-- A customizable 4x4 emote action bar for World of Warcraft

-- Addon namespace
EmoteHub = EmoteHub or {}

-- Local variables
local frame = nil
local buttons = {}
local isVisible = true
local toggleButton = nil

-- Default emotes list (16 emotes for 4x4 grid) with game icon fallbacks
local defaultEmotes = {
    { name = "Wave",   command = "/wave",   icon = "Interface\\AddOns\\EmoteHub\\Textures\\wave",   fallback = "Interface\\Icons\\Ability_Warrior_RallyingCry" },
    { name = "Hug",    command = "/hug",    icon = "Interface\\AddOns\\EmoteHub\\Textures\\hug",    fallback = "Interface\\Icons\\Spell_Holy_GreaterHeal" },
    { name = "Dance",  command = "/dance",  icon = "Interface\\AddOns\\EmoteHub\\Textures\\dance",  fallback = "Interface\\Icons\\INV_Misc_Drum_05" },
    { name = "Kiss",   command = "/kiss",   icon = "Interface\\AddOns\\EmoteHub\\Textures\\kiss",   fallback = "Interface\\Icons\\INV_Misc_Food_24" },
    { name = "Flirt",  command = "/flirt",  icon = "Interface\\AddOns\\EmoteHub\\Textures\\flirt",  fallback = "Interface\\Icons\\INV_Misc_Flower_04" },
    { name = "Sit",    command = "/sit",    icon = "Interface\\AddOns\\EmoteHub\\Textures\\sit",    fallback = "Interface\\Icons\\Ability_Mount_MountainRam" },
    { name = "Sleep",  command = "/sleep",  icon = "Interface\\AddOns\\EmoteHub\\Textures\\sleep",  fallback = "Interface\\Icons\\Spell_Nature_Sleep" },
    { name = "Bow",    command = "/bow",    icon = "Interface\\AddOns\\EmoteHub\\Textures\\bow",    fallback = "Interface\\Icons\\Ability_Warrior_DefensiveStance" },
    { name = "Cheer",  command = "/cheer",  icon = "Interface\\AddOns\\EmoteHub\\Textures\\cheer",  fallback = "Interface\\Icons\\Spell_Holy_BlessingOfStamina" },
    { name = "Cry",    command = "/cry",    icon = "Interface\\AddOns\\EmoteHub\\Textures\\cry",    fallback = "Interface\\Icons\\Spell_Frost_ChillingBlast" },
    { name = "Laugh",  command = "/laugh",  icon = "Interface\\AddOns\\EmoteHub\\Textures\\laugh",  fallback = "Interface\\Icons\\INV_Misc_Food_41" },
    { name = "Point",  command = "/point",  icon = "Interface\\AddOns\\EmoteHub\\Textures\\point",  fallback = "Interface\\Icons\\Ability_Hunter_MarkedForDeath" },
    { name = "Salute", command = "/salute", icon = "Interface\\AddOns\\EmoteHub\\Textures\\salute", fallback = "Interface\\Icons\\INV_Banner_03" },
    { name = "Shy",    command = "/shy",    icon = "Interface\\AddOns\\EmoteHub\\Textures\\shy",    fallback = "Interface\\Icons\\Ability_Rogue_Vanish" },
    { name = "Thank",  command = "/thank",  icon = "Interface\\AddOns\\EmoteHub\\Textures\\thank",  fallback = "Interface\\Icons\\Spell_Holy_Heal" },
    { name = "Yes",    command = "/yes",    icon = "Interface\\AddOns\\EmoteHub\\Textures\\yes",    fallback = "Interface\\Icons\\Ability_Warrior_Revenge" }
}

-- Default saved variables
local defaultSettings = {
    position = {
        point = "CENTER",
        relativeTo = "UIParent",
        relativePoint = "CENTER",
        xOfs = 0,
        yOfs = 0
    },
    isVisible = true,
    buttonSize = 40,
    spacing = 2,
    scale = 1.0,
    alpha = 1.0,
    toggleButtonPosition = {
        point = "CENTER",
        relativePoint = "CENTER",
        xOfs = -200,
        yOfs = 0
    }
}

-- Simple texture loading with immediate fallback support
local function LoadTexture(button, customPath, fallbackPath)
    local textureLoaded = false

    -- Try custom texture first
    if customPath then
        button.icon:SetTexture(customPath)
        local texturePath = button.icon:GetTexture()
        if texturePath and texturePath ~= "" then
            textureLoaded = true
        end
    end

    -- If custom texture didn't load, use fallback
    if not textureLoaded then
        if fallbackPath then
            button.icon:SetTexture(fallbackPath)
            local fallbackTexture = button.icon:GetTexture()
            if not fallbackTexture or fallbackTexture == "" then
                button.icon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
            end
        else
            button.icon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
        end
    end
end

-- Initialize saved variables
local function InitializeSavedVars()
    EmoteHubDB = EmoteHubDB or {}

    -- Merge defaults with saved data
    for key, value in pairs(defaultSettings) do
        if EmoteHubDB[key] == nil then
            EmoteHubDB[key] = value
        end
    end

    -- Handle nested tables
    if type(EmoteHubDB.position) ~= "table" then
        EmoteHubDB.position = defaultSettings.position
    else
        for key, value in pairs(defaultSettings.position) do
            if EmoteHubDB.position[key] == nil then
                EmoteHubDB.position[key] = value
            end
        end
    end

    -- Handle toggle button position
    if type(EmoteHubDB.toggleButtonPosition) ~= "table" then
        EmoteHubDB.toggleButtonPosition = defaultSettings.toggleButtonPosition
    else
        for key, value in pairs(defaultSettings.toggleButtonPosition) do
            if EmoteHubDB.toggleButtonPosition[key] == nil then
                EmoteHubDB.toggleButtonPosition[key] = value
            end
        end
    end
end

-- Create invisible anchor frame (no background, just positioning)
local function CreateMainFrame()
    if frame then
        return frame
    end

    frame = CreateFrame("Frame", "EmoteHubMainFrame", UIParent)
    local buttonSize = EmoteHubDB.buttonSize or 40
    local spacing = EmoteHubDB.spacing or 2
    local frameWidth = (4 * buttonSize) + (3 * spacing)  -- 4 buttons + 3 spaces between
    local frameHeight = (4 * buttonSize) + (3 * spacing) -- 4 buttons + 3 spaces between
    frame:SetSize(frameWidth, frameHeight)
    frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    frame:SetFrameStrata("MEDIUM")
    frame:SetFrameLevel(10)

    -- No background, no drag handlers - just invisible positioning frame

    return frame
end

-- Create persistent toggle button
local function CreateToggleButton()
    if toggleButton then return toggleButton end

    toggleButton = CreateFrame("Button", "EmoteHubToggleButton", UIParent)
    toggleButton:SetSize(40, 40)
    toggleButton:SetPoint("CENTER", UIParent, "CENTER", -200, 0) -- Position it left of center
    toggleButton:EnableMouse(true)
    toggleButton:SetMovable(true)
    toggleButton:RegisterForDrag("RightButton")
    toggleButton:SetClampedToScreen(true)
    toggleButton:SetFrameStrata("HIGH")
    toggleButton:SetFrameLevel(100)

    -- Button icon (custom icon.tga) - no background
    toggleButton.icon = toggleButton:CreateTexture(nil, "ARTWORK")
    toggleButton.icon:SetAllPoints(true)
    toggleButton.icon:SetTexture("Interface\\AddOns\\EmoteHub\\Textures\\icon") -- Use custom icon.tga

    -- Hover highlight
    toggleButton.highlight = toggleButton:CreateTexture(nil, "HIGHLIGHT")
    toggleButton.highlight:SetAllPoints(true)
    toggleButton.highlight:SetColorTexture(0.3, 0.3, 0.3, 0.5)

    -- Enable left-click
    toggleButton:RegisterForClicks("LeftButtonUp")

    -- Click handler - execute /eh command directly
    toggleButton:SetScript("OnClick", function(self, mouseButton)
        -- Execute the slash command directly like typing /eh in chat
        SlashCmdList["EMOTEHUB"]("")
    end)

    -- Drag handler (right-click to move)
    toggleButton:SetScript("OnDragStart", function(self)
        self:StartMoving()
    end)
    toggleButton:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        -- Save position
        local point, _, relativePoint, xOfs, yOfs = self:GetPoint()
        EmoteHubDB.toggleButtonPosition = {
            point = point or "CENTER",
            relativePoint = relativePoint or "CENTER",
            xOfs = xOfs or -200,
            yOfs = yOfs or 0
        }
        -- Reposition frame above toggle button
        PositionFrameAboveToggle()
    end)

    -- Tooltip
    toggleButton:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText("EmoteHub Toggle", 1, 1, 1)
        GameTooltip:AddLine("Left-click: Show/Hide EmoteHub", 0.8, 0.8, 0.8)
        GameTooltip:AddLine("Right-click drag: Move button", 0.8, 0.8, 0.8)
        GameTooltip:Show()
    end)

    toggleButton:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)

    return toggleButton
end

-- Restore toggle button position
local function RestoreToggleButtonPosition()
    if not toggleButton or not EmoteHubDB.toggleButtonPosition then return end

    local pos = EmoteHubDB.toggleButtonPosition
    toggleButton:ClearAllPoints()
    toggleButton:SetPoint(pos.point, UIParent, pos.relativePoint, pos.xOfs, pos.yOfs)
end

-- Create emote buttons
local function CreateButtons()
    if not frame then return end

    local buttonSize = EmoteHubDB.buttonSize or 40
    local spacing = EmoteHubDB.spacing or 2

    for i = 1, 16 do
        -- Create simple button
        local button = CreateFrame("Button", "EmoteHubButton" .. i, frame)
        button:SetSize(buttonSize, buttonSize)

        -- Calculate grid position (4x4) - no padding, tight grid
        local row = math.floor((i - 1) / 4)
        local col = (i - 1) % 4
        local x = col * (buttonSize + spacing)
        local y = -(row * (buttonSize + spacing))

        button:SetPoint("TOPLEFT", frame, "TOPLEFT", x, y)

        -- Enable mouse and register for clicks
        button:EnableMouse(true)
        button:RegisterForClicks("LeftButtonUp", "RightButtonUp")

        -- Simple, clean button styling
        button.normalTexture = button:CreateTexture(nil, "BACKGROUND")
        button.normalTexture:SetAllPoints(true)
        button.normalTexture:SetColorTexture(0.2, 0.2, 0.2, 0.8)

        button.highlightTexture = button:CreateTexture(nil, "HIGHLIGHT")
        button.highlightTexture:SetAllPoints(true)
        button.highlightTexture:SetColorTexture(0.4, 0.4, 0.4, 0.5)

        -- Icon texture - fill entire button for perfect fit
        button.icon = button:CreateTexture(nil, "ARTWORK")
        button.icon:SetAllPoints(true)

        -- Set emote data
        local emote = defaultEmotes[i]
        if emote then
            -- Use improved texture loading function
            LoadTexture(button, emote.icon, emote.fallback)

            -- Simple emote execution using slash command
            button:SetScript("OnClick", function(self, mouseButton, down)
                if self.emoteCommand then
                    local editbox = ChatFrame1EditBox
                    editbox:SetText(self.emoteCommand)
                    ChatEdit_SendText(editbox, 0)
                    editbox:SetText("")
                end
            end)

            -- Store emote data
            button.emoteName = emote.name
            button.emoteCommand = emote.command
            button:SetAlpha(1.0)

            -- Make button clickable
            button:Show()
            button:SetFrameLevel(frame:GetFrameLevel() + 1)
        else
            -- Empty slot
            button.icon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
            button:SetAlpha(0.3)
        end

        -- Tooltip handlers
        button:SetScript("OnEnter", function(self)
            if self.emoteName then
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                GameTooltip:SetText(self.emoteName, 1, 1, 1)
                GameTooltip:AddLine(self.emoteCommand, 0.8, 0.8, 0.8)
                GameTooltip:AddLine("Click to use emote", 0, 1, 0)
                GameTooltip:Show()
            end
        end)

        button:SetScript("OnLeave", function(self)
            GameTooltip:Hide()
        end)

        buttons[i] = button
    end
end

-- Save frame position (now saves toggle button position instead)
function SavePosition()
    -- Frame position is always relative to toggle button, so we don't save it
    -- Position is maintained through toggle button positioning
end

-- Position frame above toggle button (sticky dropdown style)
local function PositionFrameAboveToggle()
    if not frame or not toggleButton then return end

    frame:ClearAllPoints()
    frame:SetPoint("BOTTOM", toggleButton, "TOP", 0, 2) -- Minimal 2px gap above toggle button
end

-- Restore frame position (legacy - now uses sticky positioning)
local function RestorePosition()
    -- Frame now always positions above toggle button
    PositionFrameAboveToggle()
end

-- Set frame visibility
local function SetVisibility(visible)
    if not frame then return end

    isVisible = visible
    EmoteHubDB.isVisible = visible

    if visible then
        frame:Show()
    else
        frame:Hide()
    end
end

-- Toggle frame visibility
local function ToggleVisibility()
    SetVisibility(not isVisible)
end

-- Initialize addon
local function Initialize()
    InitializeSavedVars()

    -- Create toggle button first
    CreateToggleButton()
    RestoreToggleButtonPosition()

    -- Then create frame and position it above toggle button
    CreateMainFrame()
    CreateButtons()
    PositionFrameAboveToggle()

    -- Set initial visibility
    isVisible = EmoteHubDB.isVisible
    if isVisible == nil then isVisible = true end
    SetVisibility(isVisible)

    -- Set scale and alpha
    if frame then
        frame:SetScale(EmoteHubDB.scale or 1.0)
        frame:SetAlpha(EmoteHubDB.alpha or 1.0)
    end

    -- EmoteHub loaded silently
end

-- Slash command handler
local function HandleSlashCommand(msg)
    local command = string.lower(strtrim(msg or ""))

    if command == "show" then
        SetVisibility(true)
    elseif command == "hide" then
        SetVisibility(false)
    elseif command == "toggle" or command == "" then
        ToggleVisibility()
    elseif command == "reset" then
        if frame then
            frame:ClearAllPoints()
            frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
            SavePosition()
        end
    elseif command == "help" or command == "?" then
        print("|cFF00FF00EmoteHub|r Commands:")
        print("  |cFFFFFF00/emotehub|r or |cFFFFFF00/eh|r - Toggle visibility")
        print("  |cFFFFFF00/emotehub show|r - Show EmoteHub")
        print("  |cFFFFFF00/emotehub hide|r - Hide EmoteHub")
        print("  |cFFFFFF00/emotehub reset|r - Reset position")
        print("  |cFFFFFF00/emotehub help|r - Show this help")
    else
        -- Silent for unknown commands
    end
end

-- Register slash commands
SLASH_EMOTEHUB1 = "/emotehub"
SLASH_EMOTEHUB2 = "/eh"
SlashCmdList["EMOTEHUB"] = HandleSlashCommand

-- Event frame for initialization
local eventFrame = CreateFrame("Frame", "EmoteHubEventFrame")

eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")

eventFrame:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == "EmoteHub" then
        -- Addon loaded, saved variables are available
        InitializeSavedVars()
    elseif event == "PLAYER_LOGIN" then
        -- Player is logging in, UI systems should be available
        if not frame then
            Initialize()
        end
    elseif event == "PLAYER_ENTERING_WORLD" then
        -- Player is fully in the world, safe to create UI
        if not frame then
            Initialize()
        end

        -- Unregister this event after first use
        eventFrame:UnregisterEvent("PLAYER_ENTERING_WORLD")
    end
end)

-- Global functions for external access
EmoteHub.Toggle = ToggleVisibility
EmoteHub.Show = function() SetVisibility(true) end
EmoteHub.Hide = function() SetVisibility(false) end
EmoteHub.Reset = function()
    if frame then
        frame:ClearAllPoints()
        frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
        SavePosition()
    end
end
