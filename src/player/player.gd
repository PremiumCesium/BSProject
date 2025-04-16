extends CharacterBody3D

@export_group("Movement Settings")
@export var base_speed: float = 2.5
@export var sprint_speed: float = 5.0
@export var acceleration: float = 8.0
@export var jump_velocity: float = 5.0

@export_group("Camera Settings")
@export var mouse_sensitivity: float = 0.005
@export var smooth_camera_accel: float = 40

@export_group("Abilities")
@export var can_jump: bool = true
@export var can_look: bool = true
@export var can_move: bool = true
@export var air_control: bool = false
@export var use_gravity: bool = true
@export var head_bob: bool = true

@export_group("Controls")
@export var controls: Dictionary = {
	LEFT = "left",
	RIGHT = "right",
	FORWARD = "forward",
	BACKWARD = "backwards",
	JUMP = "jump",
	CROUCH = "crouch",
	SPRINT = "sprint",
	PAUSE = "pause"
	}

@export_group("Nodes")
@export var head: Node3D

var speed: float = base_speed
var paused: bool = false
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var mouse_delta: Vector2 = Vector2()


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_delta = event.relative
		handle_look()

	if Input.is_action_just_pressed(controls.PAUSE):
		handle_pause()


func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	handle_movement(delta)


func handle_movement(delta: float) -> void:
	if !can_move: return

	var input_direction = Input.get_vector(controls.LEFT, controls.RIGHT, controls.FORWARD, controls.BACKWARD)
	var movement_dir = self.basis * Vector3(input_direction.x, 0, input_direction.y).normalized()

	if Input.is_action_pressed(controls.SPRINT): speed = sprint_speed
	else: speed = base_speed

	if !air_control:
		if is_on_floor():
			velocity.x = lerp(velocity.x, movement_dir.x * speed, acceleration * delta)
			velocity.z = lerp(velocity.z, movement_dir.z * speed, acceleration * delta)
	else:
		velocity.x = lerp(velocity.x, movement_dir.x * speed, acceleration * delta)
		velocity.z = lerp(velocity.z, movement_dir.z * speed, acceleration * delta)

	if use_gravity:
		velocity.y -= gravity * delta

	if can_jump and is_on_floor() and Input.is_action_pressed(controls.JUMP):
		velocity.y += jump_velocity

	move_and_slide()


func handle_look() -> void:
	if !can_look || Input.mouse_mode == Input.MOUSE_MODE_VISIBLE: return
	head.rotate_x(- mouse_delta.y * mouse_sensitivity)
	self.rotate_y(- mouse_delta.x * mouse_sensitivity)
	head.rotation.x = clampf(head.rotation.x, - deg_to_rad(89), deg_to_rad(89))
	mouse_delta = Vector2()


func handle_pause() -> void:
	paused = !paused
	match paused:
		true:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		false:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
