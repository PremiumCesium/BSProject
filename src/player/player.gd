extends CharacterBody3D

@export var player_speed: float = 5.0
@export var jump_force: float = 3.0
@export var gravity: float = 8.0
@export var mouse_sensitivity: float = 0.5

@onready var player = $"."
@onready var head = $head

var direction: Vector3 = Vector3.ZERO
var cam_x_deg: float   = 0.0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		player.rotate_y(-deg_to_rad(event.relative.x * mouse_sensitivity))
		cam_x_deg -= (event.relative.y * mouse_sensitivity)
		cam_x_deg = clamp(cam_x_deg, -90.0, 90.0)
		head.rotation_degrees.x = cam_x_deg

	elif event is InputEventKey:
		if Input.is_key_pressed(KEY_ESCAPE):
			get_tree().quit(0)

func _physics_process(delta: float):
	direction = Input.get_axis("left", "right") * player.basis.x + Input.get_axis( "forward", "backwards") * player.basis.z
	velocity = direction.normalized() * player_speed + velocity.y * Vector3.UP

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y += jump_force
	else:
		velocity.y -= gravity * delta

	move_and_slide()
	
	
	
