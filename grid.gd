extends Node2D

@export var grid_size := 50.0
@onready var palette = $"../Palette"

func _process(_delta: float) -> void:
	# Redraw against the camera's current viewport, making the grid effectively infinite.
	queue_redraw()

func _draw() -> void:
	var camera := get_viewport().get_camera_2d()
	var viewport_size := get_viewport_rect().size
	var center := camera.get_screen_center_position() if camera else Vector2.ZERO
	var zoom := camera.zoom if camera else Vector2.ONE
	var half_size := viewport_size / zoom * 0.5 + Vector2(grid_size * 2.0, grid_size * 2.0)
	var bounds := Rect2(center - half_size, half_size * 2.0)
	var minor_color := palette.background_color.lerp(Color.WHITE, 0.08)
	var major_color := palette.background_color.lerp(Color.WHITE, 0.18)

	draw_rect(bounds, palette.background_color)
	var first_x := floor(bounds.position.x / grid_size) * grid_size
	var first_y := floor(bounds.position.y / grid_size) * grid_size
	for x in range(int(first_x), int(bounds.end.x + grid_size), int(grid_size)):
		var major := int(round(x / grid_size)) % 5 == 0
		draw_line(Vector2(x, bounds.position.y), Vector2(x, bounds.end.y), major_color if major else minor_color, 1.5 if major else 1.0)
	for y in range(int(first_y), int(bounds.end.y + grid_size), int(grid_size)):
		var major := int(round(y / grid_size)) % 5 == 0
		draw_line(Vector2(bounds.position.x, y), Vector2(bounds.end.x, y), major_color if major else minor_color, 1.5 if major else 1.0)
