# Art Play

A small Godot playground where you draw terrain, then walk across it.

## Controls

- `A` / `D` — move in Play mode
- `Space` — switch between Play and Edit modes
- Left mouse — draw terrain in Edit mode
- Right mouse — erase terrain in Edit mode
- `R` — reset the drawing to the starter platform
- Arrow keys — pan the camera

The grid follows the camera and continues in every direction. Use the Background and Brush color pickers to set the active colors, then use **Save brush swatch** to keep a brush color for later. Click a saved swatch to use it as the brush; right-click it to use it as the background. Palette choices persist locally on the device that runs the game.

## Project structure

The main scene is intentionally kept declarative. Gameplay behavior lives in separate scripts:

- `drawing_canvas.gd` — terrain painting and collision generation
- `player.gd` — movement and edit-mode switching
- `grid.gd`, `avatar.gd`, and `hud.gd` — presentation
- `palette.gd` — persistent brush/background colors and swatches
- `player_camera.gd` — manual camera panning

Open `project.godot` in Godot 4.7 or later and run the `node_2d.tscn` main scene.
