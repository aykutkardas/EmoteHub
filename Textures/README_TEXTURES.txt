EMOTEBAR TEXTURES - TGA IMAGE GUIDE
===================================

This folder is where you should place your custom TGA texture files for EmoteBar icons.

REQUIRED FILES:
===============
For the addon to display custom icons, place these TGA files in this folder:

- wave.tga      (Wave emote)
- hug.tga       (Hug emote)
- dance.tga     (Dance emote)
- kiss.tga      (Kiss emote)
- flirt.tga     (Flirt emote)
- sit.tga       (Sit emote)
- sleep.tga     (Sleep emote)
- bow.tga       (Bow emote)
- cheer.tga     (Cheer emote)
- cry.tga       (Cry emote)
- laugh.tga     (Laugh emote)
- point.tga     (Point emote)
- salute.tga    (Salute emote)
- shy.tga       (Shy emote)
- thank.tga     (Thank emote)
- yes.tga       (Yes emote)

TGA FORMAT SPECIFICATIONS:
==========================
- Format: TGA (Targa Image Format)
- Recommended Size: 32x32 pixels
- Alternative Sizes: 64x64 or 128x128 pixels also work
- Color Depth: 24-bit (RGB) or 32-bit (RGBA with transparency)
- Compression: Uncompressed or RLE compressed
- File Extension: Must be .tga (lowercase recommended)

CREATING TGA FILES:
===================

Method 1 - GIMP (Free):
1. Open GIMP
2. Create new image (32x32 pixels)
3. Design your icon
4. File → Export As → [filename].tga
5. In export dialog, choose "24 bits" or "32 bits"
6. Click "Export"

Method 2 - Paint.NET (Free):
1. Open Paint.NET
2. Create new image (32x32 pixels)
3. Design your icon
4. File → Save As → Choose TGA format
5. Save with .tga extension

Method 3 - Photoshop:
1. Create new document (32x32 pixels)
2. Design your icon
3. File → Save As → Targa (*.TGA)
4. Choose 24 or 32 bits/pixel

Method 4 - Extract from WoW:
Use tools like:
- WoW Model Viewer
- WoW Export Tools
- MPQ Editors
To extract existing game icons and convert to TGA

DESIGN TIPS:
============
- Keep designs simple and recognizable at small sizes
- Use high contrast colors for visibility
- Consider the dark UI background when choosing colors
- Test transparency with 32-bit TGA if needed
- Make icons square (same width and height)

ICON SOURCES:
=============
You can create icons representing:
- Hand gestures (wave, point, etc.)
- Facial expressions (smile, cry, etc.)
- Body positions (bow, sit, dance)
- Abstract symbols representing emotions
- Simplified character poses
- Custom artistic interpretations

TROUBLESHOOTING:
================

Icons not showing?
- Check file names are exact (case-sensitive)
- Verify files are in this Textures folder
- Ensure TGA format is correct (24/32-bit)
- Restart WoW after adding new files

Icons appear corrupted?
- Re-save as uncompressed TGA
- Try different bit depth (24 vs 32-bit)
- Check image dimensions are correct

File size concerns?
- 32x32 TGA files should be small (~4KB each)
- Larger sizes increase memory usage
- Stick to recommended 32x32 for best performance

FALLBACK BEHAVIOR:
==================
If TGA files are missing, EmoteBar will show:
- Default question mark icons
- Buttons will still function with emote commands
- No visual errors, just generic placeholder icons

ADVANCED CUSTOMIZATION:
=======================
To use different emotes or add more buttons:
1. Edit EmoteBar.lua file
2. Modify the EmoteBar.emotes table
3. Add corresponding TGA files to this folder
4. Update icon paths in the Lua file

Remember: Always backup your files before making changes!

EXAMPLES OF GOOD TGA ICONS:
===========================
- Simple, bold designs
- Clear at 32x32 resolution
- Appropriate color schemes
- Recognizable symbols or gestures
- Consistent style across all icons

Happy customizing!
