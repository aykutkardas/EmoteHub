-- EmoteHub_Config_Example.lua
-- Example configuration file for customizing EmoteHub emotes
-- Copy this file and rename it to EmoteHub_Config.lua to use custom settings

--[[
    INSTRUCTIONS:
    1. Copy this file and rename it to "EmoteHub_Config.lua"
    2. Modify the emotes table below with your preferred emotes
    3. Add corresponding TGA files to the Textures folder
    4. Reload the addon or restart WoW

    NOTE: If EmoteHub_Config.lua exists, it will override the default emotes
]]

-- Custom emote configuration
EmoteHub_CustomEmotes = {
    -- Row 1
    { name = "Wave",   command = "/wave",   icon = "Interface\\AddOns\\EmoteHub\\Textures\\wave.tga" },
    { name = "Hug",    command = "/hug",    icon = "Interface\\AddOns\\EmoteHub\\Textures\\hug.tga" },
    { name = "Dance",  command = "/dance",  icon = "Interface\\AddOns\\EmoteHub\\Textures\\dance.tga" },
    { name = "Kiss",   command = "/kiss",   icon = "Interface\\AddOns\\EmoteHub\\Textures\\kiss.tga" },

    -- Row 2
    { name = "Flirt",  command = "/flirt",  icon = "Interface\\AddOns\\EmoteHub\\Textures\\flirt.tga" },
    { name = "Sit",    command = "/sit",    icon = "Interface\\AddOns\\EmoteHub\\Textures\\sit.tga" },
    { name = "Sleep",  command = "/sleep",  icon = "Interface\\AddOns\\EmoteHub\\Textures\\sleep.tga" },
    { name = "Bow",    command = "/bow",    icon = "Interface\\AddOns\\EmoteHub\\Textures\\bow.tga" },

    -- Row 3
    { name = "Cheer",  command = "/cheer",  icon = "Interface\\AddOns\\EmoteHub\\Textures\\cheer.tga" },
    { name = "Cry",    command = "/cry",    icon = "Interface\\AddOns\\EmoteHub\\Textures\\cry.tga" },
    { name = "Laugh",  command = "/laugh",  icon = "Interface\\AddOns\\EmoteHub\\Textures\\laugh.tga" },
    { name = "Point",  command = "/point",  icon = "Interface\\AddOns\\EmoteHub\\Textures\\point.tga" },

    -- Row 4
    { name = "Salute", command = "/salute", icon = "Interface\\AddOns\\EmoteHub\\Textures\\salute.tga" },
    { name = "Shy",    command = "/shy",    icon = "Interface\\AddOns\\EmoteHub\\Textures\\shy.tga" },
    { name = "Thank",  command = "/thank",  icon = "Interface\\AddOns\\EmoteHub\\Textures\\thank.tga" },
    { name = "Yes",    command = "/yes",    icon = "Interface\\AddOns\\EmoteHub\\Textures\\yes.tga" },
}

-- Alternative example with different emotes
--[[
EmoteHub_CustomEmotes = {
    -- Combat/Action Emotes
    { name = "Attack",    command = "/attack",   icon = "Interface\\AddOns\\EmoteHub\\Textures\\attack.tga" },
    { name = "Charge",    command = "/charge",   icon = "Interface\\AddOns\\EmoteHub\\Textures\\charge.tga" },
    { name = "Flee",      command = "/flee",     icon = "Interface\\AddOns\\EmoteHub\\Textures\\flee.tga" },
    { name = "Surrender", command = "/surrender", icon = "Interface\\AddOns\\EmoteHub\\Textures\\surrender.tga" },

    -- Social Emotes
    { name = "Hello",     command = "/hello",    icon = "Interface\\AddOns\\EmoteHub\\Textures\\hello.tga" },
    { name = "Goodbye",   command = "/goodbye",  icon = "Interface\\AddOns\\EmoteHub\\Textures\\goodbye.tga" },
    { name = "Welcome",   command = "/welcome",  icon = "Interface\\AddOns\\EmoteHub\\Textures\\welcome.tga" },
    { name = "Congrats",  command = "/congratulate", icon = "Interface\\AddOns\\EmoteHub\\Textures\\congrats.tga" },

    -- Fun Emotes
    { name = "Chicken",   command = "/chicken",  icon = "Interface\\AddOns\\EmoteHub\\Textures\\chicken.tga" },
    { name = "Silly",     command = "/silly",    icon = "Interface\\AddOns\\EmoteHub\\Textures\\silly.tga" },
    { name = "Train",     command = "/train",    icon = "Interface\\AddOns\\EmoteHub\\Textures\\train.tga" },
    { name = "Violin",    command = "/violin",   icon = "Interface\\AddOns\\EmoteHub\\Textures\\violin.tga" },

    -- Reaction Emotes
    { name = "Clap",      command = "/clap",     icon = "Interface\\AddOns\\EmoteHub\\Textures\\clap.tga" },
    { name = "Bored",     command = "/bored",    icon = "Interface\\AddOns\\EmoteHub\\Textures\\bored.tga" },
    { name = "Confused",  command = "/confused", icon = "Interface\\AddOns\\EmoteHub\\Textures\\confused.tga" },
    { name = "Amazed",    command = "/amaze",    icon = "Interface\\AddOns\\EmoteHub\\Textures\\amazed.tga" },
}
]]

-- Advanced customization options
EmoteHub_CustomSettings = {
    -- Button appearance
    buttonSize = 32, -- Size of each button in pixels
    spacing = 2,     -- Spacing between buttons

    -- Frame appearance
    showBackground = true, -- Show frame background
    showBorder = true,     -- Show frame border
    showTitle = true,      -- Show frame title

    -- Colors (RGBA values from 0 to 1)
    backgroundColor = { r = 0, g = 0, b = 0, a = 0.5 },
    borderColor = { r = 0.8, g = 0.8, b = 0.8, a = 1 },
    buttonColor = { r = 0.2, g = 0.2, b = 0.2, a = 0.8 },
    hoverColor = { r = 0.4, g = 0.4, b = 0.4, a = 0.8 },
}

-- Macro examples for complex emote sequences
EmoteHub_MacroExamples = {
    -- Multi-emote sequence
    {
        name = "Greeting",
        command = "/wave\n/say Hello there!\n/bow",
        icon = "Interface\\AddOns\\EmoteHub\\Textures\\greeting.tga"
    },

    -- Conditional emote based on target
    {
        name = "Smart Kiss",
        command = "/kiss [target=mouseover,exists][target=target,exists]; /kiss",
        icon = "Interface\\AddOns\\EmoteHub\\Textures\\smart_kiss.tga"
    },

    -- Emote with chat message
    {
        name = "Roleplay Sleep",
        command = "/me yawns and lies down for a nap\n/sleep",
        icon = "Interface\\AddOns\\EmoteHub\\Textures\\rp_sleep.tga"
    },

    -- Random emote selection
    {
        name = "Random Fun",
        command =
        "/random 4\n/run if GetRandomNumber(1,4)==1 then DoEmote('DANCE') elseif GetRandomNumber(1,4)==2 then DoEmote('SILLY') elseif GetRandomNumber(1,4)==3 then DoEmote('CHICKEN') else DoEmote('TRAIN') end",
        icon = "Interface\\AddOns\\EmoteHub\\Textures\\random.tga"
    },
}

--[[
TEXTURE CREATION TIPS:

1. Size: 32x32, 64x64, or 128x128 pixels work best
2. Format: Save as 24-bit or 32-bit TGA
3. Transparency: Use 32-bit TGA with alpha channel for transparent backgrounds
4. Tools: GIMP, Photoshop, Paint.NET can all save TGA files
5. Sources:
   - Extract from WoW game files using tools like WoW Model Viewer
   - Create custom artwork
   - Use existing game icons as reference

NAMING CONVENTION:
- Use lowercase letters and underscores
- Match the filename exactly in the icon path
- Example: "wave.tga", "custom_dance.tga"

INSTALLATION:
1. Save TGA files in: EmoteHub\Textures\
2. Update the icon path in your emotes table
3. Reload addon with: /reload

TROUBLESHOOTING:
- If icons don't show: Check file paths and names are exact
- If buttons are empty: Verify TGA format is correct
- If addon errors: Check syntax in Lua configuration
]]
