# EmoteHub - World of Warcraft Addon

A customizable 4x4 emote action bar addon for World of Warcraft that allows you to quickly access your favorite emotes with custom icons.

## Features

- 4x4 grid of emote buttons (16 total)
- Drag and drop to reposition the frame
- Show/hide with slash commands
- Custom TGA texture support for emote icons
- Persistent position and visibility settings
- Hover tooltips showing emote names and commands

## Installation

1. Extract the EmoteHub folder to your World of Warcraft addons directory:
   `World of Warcraft\_retail_\Interface\AddOns\EmoteHub`

2. Launch World of Warcraft and enable the addon in the AddOns menu

3. The EmoteHub will appear in the center of your screen when you log in

## Commands

- `/emotehub` or `/eh` - Toggle EmoteHub visibility
- `/emotehub show` - Show the EmoteHub
- `/emotehub hide` - Hide the EmoteHub
- `/emotehub reset` - Reset EmoteHub position to center
- `/emotehub` (without arguments) - Show available commands

## Default Emotes

The addon comes with 16 pre-configured emotes:

1. Wave (`/wave`)
2. Hug (`/hug`) 
3. Dance (`/dance`)
4. Kiss (`/kiss`)
5. Flirt (`/flirt`)
6. Sit (`/sit`)
7. Sleep (`/sleep`)
8. Bow (`/bow`)
9. Cheer (`/cheer`)
10. Cry (`/cry`)
11. Laugh (`/laugh`)
12. Point (`/point`)
13. Salute (`/salute`)
14. Shy (`/shy`)
15. Thank (`/thank`)
16. Yes (`/yes`)

## Adding Custom TGA Icons

To use your own custom emote icons:

1. Create your TGA image files (32x32 pixels recommended for best quality)
2. Save them in the `EmoteHub\Textures\` folder
3. Name your files to match the emotes (e.g., `wave.tga`, `hug.tga`, etc.)

### Required TGA Files:

Place these TGA files in the `EmoteHub\Textures\` folder:

- `wave.tga`
- `hug.tga`
- `dance.tga`
- `kiss.tga`
- `flirt.tga`
- `sit.tga`
- `sleep.tga`
- `bow.tga`
- `cheer.tga`
- `cry.tga`
- `laugh.tga`
- `point.tga`
- `salute.tga`
- `shy.tga`
- `thank.tga`
- `yes.tga`

### TGA Format Requirements:

- Format: TGA (Targa)
- Recommended size: 32x32 pixels
- Color depth: 24-bit or 32-bit (with alpha channel for transparency)
- Compression: Uncompressed or RLE compressed

## Customizing Emotes

To customize which emotes appear on the buttons:

1. Open `EmoteHub.lua` in a text editor
2. Find the `EmoteHub.emotes` table (around line 10)
3. Modify the emote entries:
   - `name`: Display name for tooltip
   - `command`: The slash command to execute
   - `icon`: Path to the TGA texture file

Example:
```lua
{ name = "Custom", command = "/custom", icon = "Interface\\AddOns\\EmoteHub\\Textures\\custom.tga" }
```

## Positioning

- **Drag to Move**: Left-click and drag the EmoteHub to reposition it
- **Auto-Save**: Position is automatically saved when you stop dragging
- **Reset Position**: Use `/emotehub reset` to return to center screen

## Troubleshooting

### Icons Not Showing
1. Ensure TGA files are in the correct folder: `EmoteHub\Textures\`
2. Check file names match exactly (case-sensitive)
3. Verify TGA format is correct (uncompressed 24/32-bit)
4. Restart WoW after adding new texture files

### Addon Not Loading
1. Check that the folder is named exactly `EmoteHub`
2. Ensure all files are present: `EmoteHub.toc`, `EmoteHub.lua`, `EmoteHubFrame.xml`
3. Verify the addon is enabled in the AddOns menu
4. Check for error messages in the chat window

### Performance Issues
- If experiencing lag, try reducing texture file sizes
- Ensure TGA files are optimized (avoid unnecessarily large files)

## File Structure

```
EmoteHub/
├── EmoteHub.toc          # Addon metadata
├── EmoteHub.lua          # Main addon logic
├── EmoteHubFrame.xml     # UI frame definitions
├── README.md             # This file
└── Textures/             # Custom TGA icon folder
    ├── wave.tga
    ├── hug.tga
    ├── dance.tga
    └── ... (other emote icons)
```

## Version History

- **v1.0.0**: Initial release
  - 4x4 emote grid
  - Drag and drop positioning
  - Show/hide commands
  - Custom TGA texture support
  - Saved settings

## Support

For issues or feature requests, please check the addon's page on your preferred addon repository or create an issue in the project repository.

## License

This addon is provided as-is for personal use. Feel free to modify and customize for your own needs.