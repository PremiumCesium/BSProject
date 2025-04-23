extends State
class_name EnemyFollow

@export var enemy:CharacterBody3D
@export var move_speed:= 40.0
@export var player : CharacterBody3D
var increment = 0.1


func Enter():
	print_debug("Hey")
	
func Exit():
	print_debug("exit")
	
func Physics_Update(delta: float):
	var direction = player.global_position - enemy.global_position
	print_debug(direction)
	print_debug(direction.length())
	if direction.length() >= 2:
		
		enemy.velocity += direction.normalized() * increment+ enemy.velocity * get_process_delta_time()
		if(increment > move_speed):
			increment = move_speed
		else:
			increment = increment + 0.1
		
	else:
		increment =0.1
		enemy.velocity = Vector3()
