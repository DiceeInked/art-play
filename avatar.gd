extends Node2D

func _draw() -> void:
	draw_circle(Vector2.ZERO, 22.0, Color("10182d"))
	draw_circle(Vector2.ZERO, 18.0, Color("65f4d0"))
	draw_circle(Vector2.ZERO, 13.0, Color("17223b"))
	draw_circle(Vector2(5, -3), 5.0, Color("f5fffd"))
	draw_circle(Vector2(5, -3), 2.5, Color("0b1020"))
	draw_arc(Vector2.ZERO, 25.0, 0.0, TAU, 32, Color("65f4d0", 0.25), 2.0)
