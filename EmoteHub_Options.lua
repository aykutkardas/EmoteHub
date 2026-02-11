-- EmoteHub_Options.lua
-- Configuration panel for EmoteHub

local addonName, addonTable = ...
-- Create the panel frame
local OptionsPanel = CreateFrame("Frame", "EmoteHubOptionsPanel", InterfaceOptionsFramePanelContainer)
OptionsPanel.name = "EmoteHub"

-- Helper to create a title
local function CreateTitle(parent, text)
    local title = parent:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 16, -16)
    title:SetText(text)
    return title
end

-- Helper to create a simple text label
local function CreateLabel(parent, text, relativeTo, x, y)
    local label = parent:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    label:SetPoint("TOPLEFT", relativeTo, "BOTTOMLEFT", x or 0, y or -20)
    label:SetText(text)
    return label
end

-- Function to initialize the options panel
local function InitializeOptions()
    -- Title
    local title = CreateTitle(OptionsPanel, "EmoteHub Options")
    local subTitle = CreateLabel(OptionsPanel, "Configure EmoteHub layout and appearance.", title, 0, -10)

    -- Layout Section
    local layoutLabel = CreateLabel(OptionsPanel, "Layout Style:", subTitle, 0, -20)

    -- Layout Dropdown
    local layoutDropdown = CreateFrame("Frame", "EmoteHubLayoutDropdown", OptionsPanel, "UIDropDownMenuTemplate")
    layoutDropdown:SetPoint("TOPLEFT", layoutLabel, "BOTTOMLEFT", -15, -8)
    
    local gridSlider -- Pre-declare for visibility
    
    -- Dropdown menu items
    local function LayoutDropdown_OnClick(self)
        UIDropDownMenu_SetSelectedValue(layoutDropdown, self.value)
        EmoteHub.SetLayout(self.value)
        
        -- Update slider state
        if gridSlider then
            if self.value == "grid" then
                gridSlider:Enable()
                gridSlider:SetAlpha(1.0)
            else
                gridSlider:Disable()
                gridSlider:SetAlpha(0.5)
            end
        end
    end
    
    local function LayoutDropdown_Initialize(self, level)
        local info = UIDropDownMenu_CreateInfo()
        
        info.text = "Grid (Flexible Columns)"
        info.value = "grid"
        info.func = LayoutDropdown_OnClick
        info.checked = nil  -- Don't show radio button
        UIDropDownMenu_AddButton(info)
        
        info.text = "Horizontal Bar"
        info.value = "horizontal"
        info.func = LayoutDropdown_OnClick
        info.checked = nil  -- Don't show radio button
        UIDropDownMenu_AddButton(info)
        
        info.text = "Vertical Bar"
        info.value = "vertical"
        info.func = LayoutDropdown_OnClick
        info.checked = nil  -- Don't show radio button
        UIDropDownMenu_AddButton(info)
    end
    
    UIDropDownMenu_Initialize(layoutDropdown, LayoutDropdown_Initialize)
    UIDropDownMenu_SetWidth(layoutDropdown, 160)
    UIDropDownMenu_SetButtonWidth(layoutDropdown, 180)

    -- Grid Columns Slider
    gridSlider = CreateFrame("Slider", "EmoteHubGridSlider", OptionsPanel, "OptionsSliderTemplate")
    gridSlider:SetPoint("TOPLEFT", layoutDropdown, "BOTTOMLEFT", 15, -20)
    gridSlider:SetWidth(200)
    gridSlider:SetMinMaxValues(1, 17)
    gridSlider:SetValueStep(1)
    gridSlider:SetObeyStepOnDrag(true)
    _G[gridSlider:GetName() .. 'Low']:SetText('1')
    _G[gridSlider:GetName() .. 'High']:SetText('17')
    _G[gridSlider:GetName() .. 'Text']:SetText('Grid Columns')

    gridSlider:SetScript("OnValueChanged", function(self, value)
        value = math.floor(value)
        if EmoteHub.GetGridColumns and EmoteHub.GetGridColumns() ~= value then
            EmoteHub.SetGridColumns(value)
        end
        _G[self:GetName() .. 'Text']:SetText('Grid Columns: ' .. value)
    end)

    -- Button Size Slider
    local sizeSlider = CreateFrame("Slider", "EmoteHubSizeSlider", OptionsPanel, "OptionsSliderTemplate")
    sizeSlider:SetPoint("TOPLEFT", gridSlider, "BOTTOMLEFT", 0, -40)
    sizeSlider:SetWidth(200)
    sizeSlider:SetMinMaxValues(16, 64)
    sizeSlider:SetValueStep(2)
    sizeSlider:SetObeyStepOnDrag(true)
    _G[sizeSlider:GetName() .. 'Low']:SetText('16')
    _G[sizeSlider:GetName() .. 'High']:SetText('64')
    _G[sizeSlider:GetName() .. 'Text']:SetText('Button Size')

    sizeSlider:SetScript("OnValueChanged", function(self, value)
        value = math.floor(value)
        if EmoteHub.GetButtonSize and EmoteHub.GetButtonSize() ~= value then
            EmoteHub.SetButtonSize(value)
        end
        _G[self:GetName() .. 'Text']:SetText('Button Size: ' .. value)
    end)

    -- Reset Button
    local resetButton = CreateFrame("Button", "EmoteHubResetButton", OptionsPanel, "UIPanelButtonTemplate")
    -- Adjusted anchor since Scale/Alpha are gone
    resetButton:SetPoint("TOPLEFT", sizeSlider, "BOTTOMLEFT", 0, -40)
    resetButton:SetSize(120, 25)
    resetButton:SetText("Reset Position")
    resetButton:SetScript("OnClick", function()
        EmoteHub.Reset()
    end)

    -- Function to update UI from current settings
    local function RefreshUI()
        -- Layout
        local currentLayout = EmoteHub.GetLayout()
        UIDropDownMenu_SetSelectedValue(layoutDropdown, currentLayout)
        
        -- Set dropdown text based on current layout
        local layoutText = "Grid (Flexible Columns)"
        if currentLayout == "horizontal" then
            layoutText = "Horizontal Bar"
        elseif currentLayout == "vertical" then
            layoutText = "Vertical Bar"
        end
        UIDropDownMenu_SetText(layoutDropdown, layoutText)
        
        -- Update slider state
        if gridSlider then
            if currentLayout == "grid" then
                gridSlider:Enable()
                gridSlider:SetAlpha(1.0)
            else
                gridSlider:Disable()
                gridSlider:SetAlpha(0.5)
            end
        end

        -- Grid Columns
        if EmoteHub.GetGridColumns then
            local cols = EmoteHub.GetGridColumns()
            gridSlider:SetValue(cols)
            _G[gridSlider:GetName() .. 'Text']:SetText('Grid Columns: ' .. cols)
        end

        -- Button Size
        if EmoteHub.GetButtonSize then
            local size = EmoteHub.GetButtonSize()
            sizeSlider:SetValue(size)
            _G[sizeSlider:GetName() .. 'Text']:SetText('Button Size: ' .. size)
        end
    end

    -- Set initial values on show
    OptionsPanel:SetScript("OnShow", RefreshUI)
end

-- Initialize the panel
InitializeOptions()

-- Register the panel with WoW Interface Options
    if Settings and Settings.RegisterCanvasLayoutCategory then
        -- Modern Retail (10.0+)
        local category, layout = Settings.RegisterCanvasLayoutCategory(OptionsPanel, "EmoteHub")
        Settings.RegisterAddOnCategory(category)
        -- Also set parent to nil or UIParent for safety in modern UI if previously set to InterfaceOptionsFramePanelContainer
        OptionsPanel:SetParent(UIParent)
    else
        -- Legacy / Classic
        InterfaceOptions_AddCategory(OptionsPanel)
    end
