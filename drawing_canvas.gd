extends Sprite2D

@export_range(128, 4096, 1) var canvas_size := 1024
@export_range(1, 100, 1) var pen_size := 18
@export_range(0, 20, 1) var minimum_wall_height := 2

var edit_mode := false
var image: Image
var image_texture: ImageTexture
var previous_mouse_position := Vector2.ZERO
var terrain_dirty := false
var rebuild_pending := false
var current_terrain: StaticBody2D

func _ready() -> void:
	create_canvas()
	request_rebuild()

func create_canvas() -> void:
	image = Image.create_empty(canvas_size, canvas_size, false, Image.FORMAT_RGBA8)
	image.fill(Color.TRANSPARENT)
	image.fill_rect(Rect2i(64, int(canvas_size * 0.70), canvas_size - 128, 20), Color("65f4d0"))
	image_texture = ImageTexture.create_from_image(image)
	texture = image_texture
	terrain_dirty = true

func set_edit_mode(enabled: bool) -> void:
	if edit_mode == enabled:
		return
	edit_mode = enabled
	previous_mouse_position = to_local(get_global_mouse_position())
	if not edit_mode and terrain_dirty:
		request_rebuild()

func clear_canvas() -> void:
	if not edit_mode:
		return
	create_canvas()
	image_texture.update(image)

func _process(_delta: float) -> void:
	var mouse_position := to_local(get_global_mouse_position())
	if not edit_mode:
		previous_mouse_position = mouse_position
		return
	if Input.is_action_just_pressed("clear_canvas"):
		clear_canvas()
		previous_mouse_position = mouse_position
		return
	if Input.is_action_pressed("draw") or Input.is_action_pressed("erase"):
		var color := Color.TRANSPARENT if Input.is_action_pressed("erase") else Color("65f4d0")
		var size := int(pen_size * 1.25) if Input.is_action_pressed("erase") else pen_size
		draw_stroke(previous_mouse_position, mouse_position, color, size)
		image_texture.update(image)
	previous_mouse_position = mouse_position

func draw_stroke(from: Vector2, to: Vector2, color: Color, radius: int) -> void:
	var distance := from.distance_to(to)
	var steps := max(1, int(ceil(distance)))
	var center := Vector2(image.get_width(), image.get_height()) * 0.5
	for step in range(steps + 1):
		var point := from.lerp(to, float(step) / steps) + center
		draw_brush(point, color, radius)
	terrain_dirty = true

func draw_brush(point: Vector2, color: Color, radius: int) -> void:
	for x_offset in range(-radius, radius + 1):
		for y_offset in range(-radius, radius + 1):
			if x_offset * x_offset + y_offset * y_offset > radius * radius:
				continue
			var x := int(point.x) + x_offset
			var y := int(point.y) + y_offset
			if x >= 0 and x < image.get_width() and y >= 0 and y < image.get_height():
				image.set_pixel(x, y, color)

func request_rebuild() -> void:
	if rebuild_pending:
		return
	rebuild_pending = true
	call_deferred("rebuild_terrain")

func rebuild_terrain() -> void:
	rebuild_pending = false
	if image == null:
		return
	var bitmap := BitMap.new()
	bitmap.create_from_image_alpha(image, 0.5)
	var width := image.get_width()
	var height := image.get_height()
	var center := Vector2(width, height) * 0.5
	var segments := PackedVector2Array()
	for y in range(height + 1):
		var start := -1
		for x in range(width + 1):
			var above := x < width and y > 0 and bitmap.get_bit(x, y - 1)
			var below := x < width and y < height and bitmap.get_bit(x, y)
			if above != below and start == -1:
				start = x
			elif above == below and start != -1:
				segments.append(Vector2(start, y) - center)
				segments.append(Vector2(x, y) - center)
				start = -1
	for x in range(width + 1):
		var start := -1
		for y in range(height + 1):
			var left := y < height and x > 0 and bitmap.get_bit(x - 1, y)
			var right := y < height and x < width and bitmap.get_bit(x, y)
			if left != right and start == -1:
				start = y
			elif left == right and start != -1:
				if y - start >= minimum_wall_height:
					segments.append(Vector2(x, start) - center)
					segments.append(Vector2(x, y) - center)
				start = -1
	var terrain := StaticBody2D.new()
	terrain.name = "DrawnTerrain"
	if not segments.is_empty():
		var collision := CollisionShape2D.new()
		var shape := ConcavePolygonShape2D.new()
		shape.segments = segments
		collision.shape = shape
		terrain.add_child(collision)
	get_parent().add_child(terrain)
	terrain.global_transform = global_transform
	if is_instance_valid(current_terrain):
		current_terrain.queue_free()
	current_terrain = terrain
	terrain_dirty = false
