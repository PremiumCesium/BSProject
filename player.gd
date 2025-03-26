extends CharacterBody3D

@export var player_speed = 5.0
var jump_force = 10.0
var gravity = 8.0
var mouseSens = 0.5
var cam_x_ang = 0.0

print(OS.get_data_dir())

@onready var _head = $head
@onready var cam = $head/Camera3D

var direction = Vector3.ZERO

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		_head.rotate_y(-deg_to_rad(event.relative.x * mouseSens))
		cam_x_ang = -deg_to_rad(event.relative.y * mouseSens) 
		cam_x_ang = clamp(cam_x_ang, -90.0, 90.0)
		cam.rotate_x(cam_x_ang)
		
	elif event is InputEventKey:
		if Input.is_key_pressed(KEY_ESCAPE):
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
		
		

func _process(delta):
	direction = Input.get_axis("left", "right") * _head.basis.x + Input.get_axis( "forward", "backwards") * _head.basis.z
	velocity = direction.normalized() * player_speed + velocity.y * Vector3.UP
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y += jump_force
	else:
		velocity.y -= gravity * delta
	move_and_slide()
	
	
	
