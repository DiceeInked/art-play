# Art Play

A small Godot playground where you draw terrain, then walk across it.

## Controls

- `A` / `D` — move in Play mode
- `Space` — switch between Play and Edit modes
- Left mouse — draw terrain in Edit mode
- Right mouse — erase terrain in Edit mode
- `R` — reset the drawing to the starter platform
- Arrow keys — pan the camera

## Project structure

The main scene is intentionally kept declarative. Gameplay behavior lives in separate scripts:

- `drawing_canvas.gd` — terrain painting and collision generation
- `player.gd` — movement and edit-mode switching
- `grid.gd`, `avatar.gd`, and `hud.gd` — presentation
- `player_camera.gd` — manual camera panning

Open `project.godot` in Godot 4.7 or later and run the `node_2d.tscn` main scene.
