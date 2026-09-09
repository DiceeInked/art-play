extends Node2D

@export var grid_size := 50.0
@export var extent := 60

func _draw() -> void:
	var size := grid_size * extent
	draw_rect(Rect2(-size, -size, size * 2.0, size * 2.0), Color("0b1020"))
	for index in range(-extent, extent + 1):
		var position := index * grid_size
		var color := Color("23304c") if index % 5 == 0 else Color("151f35")
		var width := 1.5 if index % 5 == 0 else 1.0
		draw_line(Vector2(position, -size), Vector2(position, size), color, width)
		draw_line(Vector2(-size, position), Vector2(size, position), color, width)
	draw_line(Vector2(-size, 0), Vector2(size, 0), Color("40567e"), 2.0)
	draw_line(Vector2(0, -size), Vector2(0, size), Color("40567e"), 2.0)
