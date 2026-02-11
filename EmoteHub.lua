-- EmoteHub.lua
-- Main addon file for EmoteHub
-- An emote action bar for World of Warcraft

-- Addon namespace
EmoteHub = EmoteHub or {}

-- Local variables
local frame = nil
local buttons = {}
local isVisible = true
local toggleButton = nil
local FALLBACK_ICON = "Interface\\Icons\\INV_Misc_QuestionMark"

-- Default emotes list (16 emotes for 4x4 grid) with game icon fallbacks
local defaultEmotes = {
    { name = "Wave",   command = "/wave",   icon = "Interface\\AddOns\\EmoteHub\\Textures\\wave",   fallback = "Interface\\Icons\\Ability_Warrior_RallyingCry" },
    { name = "Yes",    command = "/yes",    icon = "Interface\\AddOns\\EmoteHub\\Textures\\yes",    fallback = "Interface\\Icons\\Ability_Warrior_Revenge" },
    { name = "Thank",  command = "/thank",  icon = "Interface\\AddOns\\EmoteHub\\Textures\\thank",  fallback = "Interface\\Icons\\Spell_Holy_Heal" },
    { name = "Cheer",  command = "/cheer",  icon = "Interface\\AddOns\\EmoteHub\\Textures\\cheer",  fallback = "Interface\\Icons\\Spell_Holy_BlessingOfStamina" },
    { name = "Laugh",  command = "/laugh",  icon = "Interface\\AddOns\\EmoteHub\\Textures\\laugh",  fallback = "Interface\\Icons\\INV_Misc_Food_41" },
    { name = "Cry",    command = "/cry",    icon = "Interface\\AddOns\\EmoteHub\\Textures\\cry",    fallback = "Interface\\Icons\\Spell_Frost_ChillingBlast" },
    { name = "Bow",    command = "/bow",    icon = "Interface\\AddOns\\EmoteHub\\Textures\\bow",    fallback = "Interface\\Icons\\Ability_Warrior_DefensiveStance" },
    { name = "Point",  command = "/point",  icon = "Interface\\AddOns\\EmoteHub\\Textures\\point",  fallback = "Interface\\Icons\\Ability_Hunter_MarkedForDeath" },
    { name = "Salute", command = "/salute", icon = "Interface\\AddOns\\EmoteHub\\Textures\\salute", fallback = "Interface\\Icons\\INV_Banner_03" },
    { name = "Sit",    command = "/sit",    icon = "Interface\\AddOns\\EmoteHub\\Textures\\sit",    fallback = "Interface\\Icons\\Ability_Mount_MountainRam" },
    { name = "Sleep",  command = "/sleep",  icon = "Interface\\AddOns\\EmoteHub\\Textures\\sleep",  fallback = "Interface\\Icons\\Spell_Nature_Sleep" },
    { name = "Shy",    command = "/shy",    icon = "Interface\\AddOns\\EmoteHub\\Textures\\shy",    fallback = "Interface\\Icons\\Ability_Rogue_Vanish" },
    { name = "Kiss",   command = "/kiss",   icon = "Interface\\AddOns\\EmoteHub\\Textures\\kiss",   fallback = "Interface\\Icons\\INV_Misc_Food_24" },
    { name = "Flirt",  command = "/flirt",  icon = "Interface\\AddOns\\EmoteHub\\Textures\\flirt",  fallback = "Interface\\Icons\\INV_Misc_Flower_04" },
    { name = "Hug",    command = "/hug",    icon = "Interface\\AddOns\\EmoteHub\\Textures\\hug",    fallback = "Interface\\Icons\\Spell_Holy_GreaterHeal" },
    { name = "Dance",  command = "/dance",  icon = "Interface\\AddOns\\EmoteHub\\Textures\\dance",  fallback = "Interface\\Icons\\INV_Misc_Drum_05" },
}

-- Default saved variables
local defaultSettings = {
    framePosition = {
        point = "CENTER",
        relativeTo = "UIParent",
        relativePoint = "CENTER",
        xOfs = 0,
        yOfs = 0
    },
    isVisible = true,
    buttonSize = 36,
    spacing = 2,
    scale = 1.0,
    alpha = 1.0,
    layout = "grid", -- "grid", "horizontal", "vertical"
    gridColumns = 4
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
                button.icon:SetTexture(FALLBACK_ICON)
            end
        else
            button.icon:SetTexture(FALLBACK_ICON)
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
    if type(EmoteHubDB.framePosition) ~= "table" then
        EmoteHubDB.framePosition = defaultSettings.framePosition
    else
        for key, value in pairs(defaultSettings.framePosition) do
            if EmoteHubDB.framePosition[key] == nil then
                EmoteHubDB.framePosition[key] = value
            end
        end
    end
end

-- Calculate frame dimensions based on layout (includes toggle button)
local function GetFrameDimensions()
    local buttonSize = EmoteHubDB.buttonSize or 36
    local spacing = EmoteHubDB.spacing or 2
    local layout = EmoteHubDB.layout or "grid"
    local frameWidth, frameHeight

    if layout == "horizontal" then
        frameWidth = (17 * buttonSize) + (16 * spacing) -- 17 buttons (16 + toggle) + 16 spaces between
        frameHeight = buttonSize
    elseif layout == "vertical" then
        frameWidth = buttonSize
        frameHeight = (17 * buttonSize) + (16 * spacing) -- 17 buttons (16 + toggle) + 16 spaces between
    else                                                 -- grid (default)
        local gridColumns = EmoteHubDB.gridColumns or 4
        local totalButtons = 17                          -- 16 emote buttons + 1 toggle button
        local gridRows = math.ceil(totalButtons / gridColumns)
        frameWidth = (gridColumns * buttonSize) + ((gridColumns - 1) * spacing)
        frameHeight = (gridRows * buttonSize) + ((gridRows - 1) * spacing)
    end

    return frameWidth, frameHeight
end

-- Create invisible anchor frame (no background, just positioning)
local function CreateMainFrame()
    if frame then
        return frame
    end

    frame = CreateFrame("Frame", nil, UIParent)
    local frameWidth, frameHeight = GetFrameDimensions()
    frame:SetSize(frameWidth, frameHeight)
    -- Set initial position - will be overridden by saved position if available
    frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    frame:SetFrameStrata("MEDIUM")
    frame:SetFrameLevel(10)

    -- Enable dragging for all layouts
    frame:SetMovable(true)
    frame:SetClampedToScreen(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", function(self)
        self:StartMoving()
    end)
    frame:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        -- Save frame position
        SaveFramePosition()
        -- Update toggle button position to stay connected
        PositionToggleButtonInFrame()
    end)

    -- No background - just invisible positioning frame

    return frame
end

-- Create persistent toggle button
local function CreateToggleButton()
    if toggleButton then return toggleButton end

    local buttonSize = EmoteHubDB.buttonSize or 36
    toggleButton = CreateFrame("Button", nil, UIParent)
    toggleButton:SetSize(buttonSize, buttonSize)
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

    -- Drag handler (right-click to move entire action bar)
    toggleButton:SetScript("OnDragStart", function(self)
        -- Always move the frame, toggle button is part of it
        if frame then
            frame:StartMoving()
        end
    end)
    toggleButton:SetScript("OnDragStop", function(self)
        -- Stop moving the frame
        if frame then
            frame:StopMovingOrSizing()
        end
        -- Always save frame position after drag
        SaveFramePosition()
        -- Update toggle button position to stay connected
        PositionToggleButtonInFrame()
    end)

    -- Tooltip (dynamic based on layout)
    toggleButton:SetScript("OnEnter", function(self)
        local layout = EmoteHubDB.layout or "grid"
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText("EmoteHub Toggle", 1, 1, 1)
        GameTooltip:AddLine("Left-click: Show/Hide EmoteHub", 0.8, 0.8, 0.8)
        GameTooltip:AddLine("Right-click drag: Move EmoteHub", 0.8, 0.8, 0.8)
        if layout == "grid" then
            local gridColumns = EmoteHubDB.gridColumns or 4
            GameTooltip:AddLine("Grid: " .. gridColumns .. " columns", 0.7, 0.7, 0.7)
        end
    end)

    toggleButton:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)

    return toggleButton
end

-- Position toggle button within frame based on layout
local function PositionToggleButtonInFrame()
    if not toggleButton or not frame then return end

    local buttonSize = EmoteHubDB.buttonSize or 36
    local spacing = EmoteHubDB.spacing or 2
    local layout = EmoteHubDB.layout or "grid"

    -- Update toggle button size to match action buttons
    toggleButton:SetSize(buttonSize, buttonSize)

    -- Always parent to UIParent so toggle button stays visible when frame is hidden
    toggleButton:SetParent(UIParent)
    toggleButton:ClearAllPoints()

    if layout == "horizontal" then
        -- Toggle button is first element (leftmost) - anchor to frame's left
        toggleButton:SetPoint("LEFT", frame, "LEFT", 0, 0)
    elseif layout == "vertical" then
        -- Toggle button is first element (topmost) - anchor to frame's top
        toggleButton:SetPoint("TOP", frame, "TOP", 0, 0)
    else -- grid (default)
        -- Toggle button is last item in grid (position 17) - anchor to frame with offset
        local gridColumns = EmoteHubDB.gridColumns or 4
        local buttonPosition = 17 -- Last position after 16 emote buttons
        local row = math.floor((buttonPosition - 1) / gridColumns)
        local col = (buttonPosition - 1) % gridColumns
        local x = col * (buttonSize + spacing)
        local y = -(row * (buttonSize + spacing))
        toggleButton:SetPoint("TOPLEFT", frame, "TOPLEFT", x, y)
    end

    -- Always ensure toggle button is visible and at proper level
    EnsureToggleButtonVisible()
end

-- Create emote buttons
local function CreateButtons()
    if not frame then return end

    local buttonSize = EmoteHubDB.buttonSize or 36
    local spacing = EmoteHubDB.spacing or 2
    local layout = EmoteHubDB.layout or "grid"

    for i = 1, 16 do
        -- Create simple button
        local button = CreateFrame("Button", nil, frame)
        button:SetSize(buttonSize, buttonSize)

        -- Calculate position based on layout
        local x, y
        if layout == "horizontal" then
            -- Single row, 16 columns (offset by 1 to account for toggle button)
            x = i * (buttonSize + spacing) -- i instead of (i-1) to leave space for toggle
            y = 0
        elseif layout == "vertical" then
            -- Single column, 16 rows (offset by 1 to account for toggle button)
            x = 0
            y = -(i * (buttonSize + spacing)) -- -i instead of -(i-1) to leave space for toggle
        else                                  -- grid (default)
            -- Flexible grid (toggle button will be at position 17)
            local gridColumns = EmoteHubDB.gridColumns or 4
            local row = math.floor((i - 1) / gridColumns)
            local col = (i - 1) % gridColumns
            x = col * (buttonSize + spacing)
            y = -(row * (buttonSize + spacing))
        end

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
            button.icon:SetTexture(FALLBACK_ICON)
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

    -- Position toggle button within frame for horizontal/vertical layouts
    PositionToggleButtonInFrame()

    -- Ensure toggle button is always visible after layout change
    EnsureToggleButtonVisible()
end

-- Update layout and recreate UI
local function UpdateLayout(newLayout)
    if not newLayout or (newLayout ~= "grid" and newLayout ~= "horizontal" and newLayout ~= "vertical") then
        print("|cFF00FF00EmoteHub|r: Invalid layout. Use 'grid', 'horizontal', or 'vertical'.")
        return
    end

    EmoteHubDB.layout = newLayout

    -- Destroy existing buttons
    if buttons then
        for i = 1, 16 do
            if buttons[i] then
                buttons[i]:Hide()
                buttons[i]:SetParent(nil)
                buttons[i] = nil
            end
        end
        buttons = {}
    end

    -- Destroy existing frame
    if frame then
        frame:Hide()
        frame:SetParent(nil)
        frame = nil
    end

    -- Recreate everything with new layout
    CreateMainFrame()
    CreateButtons()

    -- Handle positioning based on layout
    PositionFrameRelativeToToggle()
    PositionToggleButtonInFrame()

    SetVisibility(isVisible)

    -- Ensure toggle button is always visible
    EnsureToggleButtonVisible()

    -- Set scale and alpha
    if frame then
        frame:SetScale(EmoteHubDB.scale or 1.0)
        frame:SetAlpha(EmoteHubDB.alpha or 1.0)
    end

    print("|cFF00FF00EmoteHub|r: Layout changed to " .. newLayout)
end

-- Ensure toggle button is always visible regardless of frame state
local function EnsureToggleButtonVisible()
    if toggleButton then
        -- Update toggle button size to match current button size
        local buttonSize = EmoteHubDB.buttonSize or 36
        toggleButton:SetSize(buttonSize, buttonSize)
        toggleButton:Show()
        toggleButton:SetFrameStrata("HIGH")
        toggleButton:SetFrameLevel(100)
        -- Ensure parent is UIParent so it doesn't get hidden with frame
        toggleButton:SetParent(UIParent)
    end
end

-- Save frame position
function SaveFramePosition()
    if not frame then return end

    local point, relativeTo, relativePoint, xOfs, yOfs = frame:GetPoint()
    if point then
        EmoteHubDB.framePosition = {
            point = point,
            relativeTo = "UIParent",
            relativePoint = relativePoint or "CENTER",
            xOfs = xOfs or 0,
            yOfs = yOfs or 0
        }
    end
end

-- Legacy function for compatibility
function SavePosition()
    SaveFramePosition()
end

-- Position frame based on saved settings
local function PositionFrameRelativeToToggle()
    if not frame then return end

    -- Use saved position or default to center
    local pos = EmoteHubDB.framePosition
    if pos and pos.point then
        frame:ClearAllPoints()
        frame:SetPoint(pos.point, UIParent, pos.relativePoint, pos.xOfs, pos.yOfs)
    else
        frame:ClearAllPoints()
        frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    end
end

-- Restore frame position from saved settings
local function RestorePosition()
    PositionFrameRelativeToToggle()
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

    -- Always keep toggle button visible regardless of frame state
    EnsureToggleButtonVisible()

    -- Update toggle button position to maintain visual connection
    PositionToggleButtonInFrame()
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

    -- Then create frame and position it relative to toggle button
    CreateMainFrame()
    CreateButtons()

    -- Set initial visibility
    isVisible = EmoteHubDB.isVisible
    if isVisible == nil then isVisible = true end
    SetVisibility(isVisible)

    -- Set scale and alpha
    if frame then
        frame:SetScale(EmoteHubDB.scale or 1.0)
        frame:SetAlpha(EmoteHubDB.alpha or 1.0)
    end

    -- Ensure toggle button is always visible after initialization
    EnsureToggleButtonVisible()

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
            SaveFramePosition()
            -- Update toggle button position after reset
            PositionToggleButtonInFrame()
        end
    elseif command == "grid" then
        UpdateLayout("grid")
    elseif command == "horizontal" then
        UpdateLayout("horizontal")
    elseif command == "vertical" then
        UpdateLayout("vertical")
    elseif command == "layout" then
        local currentLayout = EmoteHubDB.layout or "grid"
        print("|cFF00FF00EmoteHub|r: Current layout is '" .. currentLayout .. "'")
        if currentLayout == "grid" then
            local gridColumns = EmoteHubDB.gridColumns or 4
            print("Grid size: " .. gridColumns .. " columns")
        end
        print("Available layouts: grid, horizontal, vertical")
    elseif command == "small" then
        EmoteHubDB.buttonSize = 32
        UpdateLayout(EmoteHubDB.layout or "grid")
        print("|cFF00FF00EmoteHub|r: Button size set to small (32px)")
    elseif command == "large" then
        EmoteHubDB.buttonSize = 40
        UpdateLayout(EmoteHubDB.layout or "grid")
        print("|cFF00FF00EmoteHub|r: Button size set to large (40px)")
    elseif command == "normal" then
        EmoteHubDB.buttonSize = 36
        UpdateLayout(EmoteHubDB.layout or "grid")
        print("|cFF00FF00EmoteHub|r: Button size set to normal (36px)")
    elseif command == "size" then
        local currentSize = EmoteHubDB.buttonSize or 36
        print("|cFF00FF00EmoteHub|r: Current button size is " .. currentSize .. "px")
        print("Available sizes: small (32px), normal (36px), large (40px)")
    elseif string.match(command, "^grid%s+(%d+)$") then
        local columns = tonumber(string.match(command, "^grid%s+(%d+)$"))
        if columns and columns >= 1 and columns <= 17 then
            EmoteHubDB.gridColumns = columns
            UpdateLayout("grid")
        else
            print("|cFF00FF00EmoteHub|r: Invalid grid size. Use 1-17 columns (e.g., /eh grid 4, /eh grid 5)")
        end
    elseif command == "small" then
        EmoteHubDB.buttonSize = 32
        UpdateLayout(EmoteHubDB.layout or "grid")
        print("|cFF00FF00EmoteHub|r: Button size set to small (32px)")
    elseif command == "large" then
        EmoteHubDB.buttonSize = 40
        UpdateLayout(EmoteHubDB.layout or "grid")
        print("|cFF00FF00EmoteHub|r: Button size set to large (40px)")
    elseif command == "normal" then
        EmoteHubDB.buttonSize = 36
        UpdateLayout(EmoteHubDB.layout or "grid")
        print("|cFF00FF00EmoteHub|r: Button size set to normal (36px)")
    elseif command == "size" then
        local currentSize = EmoteHubDB.buttonSize or 36
        print("|cFF00FF00EmoteHub|r: Current button size is " .. currentSize .. "px")
        print("Available sizes: small (32px), normal (36px), large (40px)")
    elseif command == "position" then
        -- Show current frame position
        if frame then
            local point, relativeTo, relativePoint, xOfs, yOfs = frame:GetPoint()
            print("|cFF00FF00EmoteHub|r: Current frame position - " ..
                (point or "CENTER") .. " " .. (xOfs or 0) .. ", " .. (yOfs or 0))
        end
        -- Also show saved position
        local pos = EmoteHubDB.framePosition
        if pos and pos.point then
            print("|cFF00FF00EmoteHub|r: Saved position - " ..
                pos.point .. " " .. (pos.xOfs or 0) .. ", " .. (pos.yOfs or 0))
        else
            print("|cFF00FF00EmoteHub|r: No saved position (using default center)")
        end
    elseif command == "help" or command == "?" then
        print("|cFF00FF00EmoteHub|r Commands:")
        print("  |cFFFFFF00/emotehub|r or |cFFFFFF00/eh|r - Toggle visibility")
        print("  |cFFFFFF00/emotehub show|r - Show EmoteHub")
        print("  |cFFFFFF00/emotehub hide|r - Hide EmoteHub (toggle button stays visible)")
        print("  |cFFFFFF00/emotehub reset|r - Reset position")
        print("  |cFFFFFF00/emotehub grid|r - Set grid layout (default 4 columns)")
        print("  |cFFFFFF00/emotehub grid <number>|r - Set grid with specific columns (1-17)")
        print("  |cFFFFFF00/emotehub horizontal|r - Set horizontal linear layout")
        print("  |cFFFFFF00/emotehub vertical|r - Set vertical linear layout")
        print("  |cFFFFFF00/emotehub layout|r - Show current layout and grid size")
        print("  |cFFFFFF00/emotehub small|r - Set small button size (32px)")
        print("  |cFFFFFF00/emotehub normal|r - Set normal button size (36px)")
        print("  |cFFFFFF00/emotehub large|r - Set large button size (40px)")
        print("  |cFFFFFF00/emotehub size|r - Show current button size")
        print("  |cFFFFFF00/emotehub position|r - Show current saved position")
        print("  |cFFFFFF00/emotehub help|r - Show this help")
        print("  |cFF888888Note: Toggle button is always visible|r")
    else
        -- Silent for unknown commands
    end
end

-- Register slash commands
SLASH_EMOTEHUB1 = "/emotehub"
SLASH_EMOTEHUB2 = "/eh"
SlashCmdList["EMOTEHUB"] = HandleSlashCommand

-- Event frame for initialization
local eventFrame = CreateFrame("Frame")

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
        -- Apply position after UI is created - saved vars should be fully loaded
        PositionFrameRelativeToToggle()
        PositionToggleButtonInFrame()
    elseif event == "PLAYER_ENTERING_WORLD" then
        -- Player is fully in the world, safe to create UI
        if not frame then
            Initialize()
        end
        -- Apply position here as well - ensure it's set
        PositionFrameRelativeToToggle()
        PositionToggleButtonInFrame()

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
        SaveFramePosition()
        -- Update toggle button position after reset
        PositionToggleButtonInFrame()
    end
end
EmoteHub.SetLayout = UpdateLayout
EmoteHub.GetLayout = function() return EmoteHubDB.layout or "grid" end
EmoteHub.SetGrid = function() UpdateLayout("grid") end
EmoteHub.SetHorizontal = function() UpdateLayout("horizontal") end
EmoteHub.SetVertical = function() UpdateLayout("vertical") end
EmoteHub.SetGridColumns = function(columns)
    if columns and columns >= 1 and columns <= 17 then
        EmoteHubDB.gridColumns = columns
        UpdateLayout("grid")
        return true
    end
    return false
end
EmoteHub.GetGridColumns = function() return EmoteHubDB.gridColumns or 4 end
EmoteHub.SetButtonSize = function(size)
    if size and size >= 16 and size <= 128 then
        EmoteHubDB.buttonSize = size
        UpdateLayout(EmoteHubDB.layout or "grid")
        return true
    end
    return false
end
EmoteHub.GetButtonSize = function() return EmoteHubDB.buttonSize or 36 end
EmoteHub.SetSmallSize = function() EmoteHub.SetButtonSize(32) end
EmoteHub.SetNormalSize = function() EmoteHub.SetButtonSize(36) end
EmoteHub.SetLargeSize = function() EmoteHub.SetButtonSize(40) end
EmoteHub.GetPosition = function()
    -- Return current frame position if available, otherwise saved position
    if frame then
        local point, relativeTo, relativePoint, xOfs, yOfs = frame:GetPoint()
        if point then
            return point, xOfs or 0, yOfs or 0
        end
    end
    -- Fallback to saved position
    local pos = EmoteHubDB.framePosition
    if pos and pos.point then
        return pos.point, pos.xOfs or 0, pos.yOfs or 0
    end
    return "CENTER", 0, 0
end
