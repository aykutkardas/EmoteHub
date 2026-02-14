# EmoteHub - World of Warcraft Addon

A customizable emote action bar addon for World of Warcraft that allows you to quickly access your favorite emotes with custom icons. Features multiple layout options including flexible grid sizes, horizontal linear, and vertical linear arrangements.

## Features

- 16 emote buttons plus integrated toggle button
- Three layout options: flexible grid, horizontal linear (1x17), or vertical linear (17x1)
- Drag and drop to reposition the frame
- Show/hide with slash commands

- Persistent position, visibility, and layout settings
- Always-visible toggle button for easy access
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
- `/emotehub grid` - Switch to grid layout (default 4 columns)
- `/emotehub grid <number>` - Set grid with specific columns (1-17, e.g. `/emotehub grid 5`)
- `/emotehub horizontal` - Switch to horizontal linear layout (1x17)
- `/emotehub vertical` - Switch to vertical linear layout (17x1)
- `/emotehub layout` - Show current layout setting
- `/emotehub small` - Set small button size (32px)
- `/emotehub normal` - Set normal button size (36px, default)
- `/emotehub large` - Set large button size (40px)
- `/emotehub size` - Show current button size
- `/emotehub help` - Show available commands

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


## Layout Options

EmoteHub supports three different layout modes:

### Grid Layout (Default)
- **Flexible grid**: Customize columns from 1-17 (default 4 columns)
- **Toggle integration**: Toggle button appears as the last item in the grid
- **Examples**: 
  - 4x5 grid (4 columns): `/emotehub grid 4`
  - 5x4 grid (5 columns): `/emotehub grid 5` 
  - 3x6 grid (3 columns): `/emotehub grid 3`
- **Best for**: Customizable arrangement to fit your screen and preferences
- **Commands**: `/emotehub grid` or `/emotehub grid <columns>`

### Horizontal Linear Layout
- **1x17 arrangement**: All buttons including toggle in a single horizontal row
- **Toggle position**: Toggle button is the first (leftmost) element
- **Best for**: Placement at top or bottom of screen, horizontal screen edges
- **Command**: `/emotehub horizontal`

### Vertical Linear Layout
- **17x1 arrangement**: All buttons including toggle in a single vertical column
- **Toggle position**: Toggle button is the first (topmost) element  
- **Best for**: Placement at left or right side of screen, vertical screen edges
- **Command**: `/emotehub vertical`

### Switching Layouts
- Use the slash commands above to change layouts instantly
- Layout preference and grid size are automatically saved
- **Toggle Button Integration** (always visible):
  - **Grid Layout**: Toggle button appears as the last item in the grid (stays visible when actions are hidden)
  - **Horizontal Layout**: Toggle button is the first (leftmost) element
  - **Vertical Layout**: Toggle button is the first (topmost) element

## Button Sizing

EmoteHub supports three button size options:

### Size Options
- **Small (32px)**: Compact buttons that save screen space, good for fitting many buttons
- **Normal (36px)**: Default balanced size for good visibility and reasonable space usage
- **Large (40px)**: Larger buttons that are more visible and easier to click

### Size Commands
- `/emotehub small` - Switch to small buttons (32px)
- `/emotehub normal` - Switch to normal buttons (36px, default)
- `/emotehub large` - Switch to large buttons (40px)
- `/emotehub size` - Show current button size

### Size Management
- Button size changes are applied instantly across all layouts
- Size preference is automatically saved
- All layouts (grid, horizontal, vertical) use the same button size
- Toggle button always matches the action button size

## Positioning

**Important**: The toggle button is always visible regardless of whether the action buttons are shown or hidden.

### All Layouts - Universal Dragging
- **Toggle Button Dragging**: Right-click and drag the toggle button to move the entire EmoteHub anywhere on screen
- **Frame Dragging**: Left-click and drag anywhere on the action buttons frame (all layouts)
- **Always Available**: Toggle button remains visible even when action buttons are hidden

### Grid Layout (Flexible)
- **Toggle Integration**: Toggle button is the last item in the grid arrangement
- **Always Visible**: Toggle button remains visible even when action buttons are hidden
- **Flexible Sizing**: Supports 1-17 columns (affects grid shape)
- **Movement**: Right-click drag toggle button or left-click drag frame to move everything
- **Auto-Save**: Frame position is automatically saved when you stop dragging

### Horizontal/Vertical Layouts  
- **Integrated Design**: Toggle button becomes the first element of the action bar
- **Dual Drag Options**: 
  - Right-click drag the toggle button to move the entire bar
  - Left-click drag anywhere on the frame to move the entire bar
- **Unity**: Toggle button and action buttons move together as one unit

### General
- **Auto-Save**: Frame position is automatically saved when you stop dragging
- **Persistent Position**: Position is saved to your character's saved variables and persists across /reload and game restarts
- **Reset Position**: Use `/emotehub reset` to return to center screen

## Troubleshooting


### Layout Issues
1. If layout changes don't apply immediately, try `/reload` to refresh the addon
2. Long horizontal/vertical layouts may extend off-screen on smaller resolutions
3. Use `/emotehub reset` after changing layouts to reposition if needed
4. **Position Reset Issues**: 
   - If position resets on /reload, try moving the frame and it should save properly
   - Position is saved to EmoteHubDB in your WTF folder
   - Use `/emotehub reset` to intentionally reset to center
5. **Dragging Issues**: 
   - All layouts: Right-click drag the toggle button to move EmoteHub
   - Horizontal/Vertical: Also supports left-click drag anywhere on the frame
   - If dragging doesn't work, try clicking directly on the toggle button
6. **Toggle Button Visibility**: 
   - Grid layout: Toggle button stays visible when actions are hidden for easy re-access
   - Linear layouts: Toggle button is part of the visible bar

### Addon Not Loading
1. Check that the folder is named exactly `EmoteHub`
2. Ensure all files are present: `EmoteHub.toc`, `EmoteHub.lua`, `EmoteHubFrame.xml`
3. Verify the addon is enabled in the AddOns menu
4. Check for error messages in the chat window

### Performance Issues
- If experiencing lag, try reducing texture file sizes
- Ensure TGA files are optimized (avoid unnecessarily large files)

## File Structure

EmoteHub/
├── EmoteHub.toc          # Addon metadata
├── EmoteHub.lua          # Main addon logic
├── README.md             # This file
└── Textures/             # Icon folder

## Version History
- **v0.1.2**: Layout Options Update
  - Mist of Pandaria Classic support added

- **v0.1.1**: Layout Options Update
  - Added horizontal linear layout (1x17)
  - Added vertical linear layout (17x1)
  - Layout switching commands
  - Persistent layout settings
  - Toggle button always visible functionality
  - Updated help system
  - Changed default button size to 36px (from 40px)
  - Added button size commands: small (32px), normal (36px), large (40px)
  - Button size changes apply instantly to all layouts
  - Enhanced customization options
  - Improved space efficiency with smaller default size

- **v0.1.0**: Initial release
  - 4x4 emote grid
  - Drag and drop positioning
  - Show/hide commands
  - Saved settings

## Support

For issues or feature requests, please check the addon's page on your preferred addon repository or create an issue in the project repository.

## License

This addon is provided as-is for personal use. Feel free to modify and customize for your own needs.
