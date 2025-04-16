extends State
class_name EnemyIdle
#https://www.youtube.com/watch?v=ow_Lum-Agbs&t=119s Im tired of writing comments

@export var enemy : CharacterBody3D
@export var move_speed : float = 10.0
@export var ai : Node # state machine
@export var nametoTransition : String # FOR TRANSITIONING POSITION
@export var area_node: Area3D


var move_direction : Vector3
var wander_time : float

func _ready():
	area_node = $idle_area
	if area_node:
		area_node.body_entered.connect(self._on_Area_body_entered)
		area_node.monitoring = true
	else:
		print("Error: Area3D node not found!")
	
	area_node.monitoring = true

func randomize_wander():
	move_direction = Vector3(randf_range(-1,1), 0.0, randf_range(-1,1)).normalized()
	wander_time = randf_range(1,3)
	
func Enter():
	randomize_wander()
	
func Update(delta: float):
	if wander_time > 0:
		wander_time -= delta
	else:
		randomize_wander()
		
func Physics_Update(delta: float):
	if enemy:
		enemy.velocity = move_direction * move_speed
		
		# Called when a body enters the trigger area
		
func Exit():
	print_debug("Exit")
	
func _on_Area_body_entered(body):
	if(body.name == "player"):
		print("Made Contact")
		ai.on_child_transition(ai.current_state, nametoTransition)
		



	
	
	
