extends Camera2D

@export var camera_move_speed := 400.0
@export var camera_smoothing := 8.0
@export var max_horizontal_offset := 500.0
@export var max_vertical_offset := 300.0
var target_offset := Vector2.ZERO

func _process(delta: float) -> void:
	var direction := Input.get_vector("camera_left", "camera_right", "camera_up", "camera_down")
	target_offset += direction * camera_move_speed * delta
	target_offset.x = clamp(target_offset.x, -max_horizontal_offset, max_horizontal_offset)
	target_offset.y = clamp(target_offset.y, -max_vertical_offset, max_vertical_offset)
	position = position.lerp(target_offset, 1.0 - exp(-camera_smoothing * delta))
