extends CharacterBody3D

@onready var player = $"."
@onready var head = $"head"
@onready var weapon_holder = $"head/hand/weapon_holder"

@export var player_speed: float = 5.0
@export var jump_force: float = 8.0
@export var gravity: float = 8.0
@export var mouse_sensitivity: float = 0.5

var direction: Vector3 = Vector3.ZERO
var cam_x_deg: float   = 0.0
var weapons: Array     = [Weapon]

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	look(event)

	if event is InputEventKey:
		if Input.is_key_pressed(KEY_ESCAPE):
			get_tree().quit()

	if event.is_action_pressed("weapon_1"):
		var new_weapon = load("res://src/weapons/rifle.tres")
		weapon_holder.current_weapon = new_weapon
		
	if event.is_action_pressed("weapon_2"):
		var new_weapon = load("res://src/weapons/rifle1.tres")
		weapon_holder.current_weapon = new_weapon

func look(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		player.rotate_y(-deg_to_rad(event.relative.x * mouse_sensitivity))
		cam_x_deg -= event.relative.y * mouse_sensitivity
		cam_x_deg = clamp(cam_x_deg, -90.0, 90.0)
		head.rotation_degrees = Vector3(cam_x_deg, head.rotation_degrees.y, head.rotation_degrees.z)

func _physics_process(delta: float) -> void:
	movement(delta)

func movement(delta: float) -> void:
	direction = Input.get_axis("left", "right") * player.basis.x + Input.get_axis("forward", "backwards") * player.basis.z
	velocity = direction.normalized() * player_speed + velocity.y * Vector3.UP

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity = Vector3(velocity.x, jump_force, velocity.z)
	else:
		velocity = Vector3(velocity.x, velocity.y - gravity * delta, velocity.z)

	move_and_slide()
