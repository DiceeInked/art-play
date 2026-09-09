extends CharacterBody2D

@export var move_speed := 260.0
@export var acceleration := 1800.0
@export var friction := 2200.0
@export var gravity := 1200.0
@export var fly_speed := 520.0
var edit_mode := false
var spawn_position := Vector2.ZERO
@onready var drawing = $"../Drawing"

func _ready() -> void:
	spawn_position = global_position

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("toggle_flight"):
		toggle_edit_mode()
	if edit_mode:
		edit_movement(delta)
	else:
		play_movement(delta)
	if global_position.y > drawing.canvas_size:
		global_position = spawn_position
		velocity = Vector2.ZERO

func play_movement(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0.0
	var direction := Input.get_axis("move_left", "move_right")
	var rate := acceleration if direction != 0.0 else friction
	velocity.x = move_toward(velocity.x, direction * move_speed, rate * delta)
	move_and_slide()

func edit_movement(delta: float) -> void:
	velocity = Input.get_vector("move_left", "move_right", "move_up", "move_down") * fly_speed
	global_position += velocity * delta

func toggle_edit_mode() -> void:
	edit_mode = not edit_mode
	velocity = Vector2.ZERO
	$CollisionShape2D.set_deferred("disabled", edit_mode)
	drawing.set_edit_mode(edit_mode)
