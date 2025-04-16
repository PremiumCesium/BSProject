extends CharacterBody3D
class_name BasicEnemy

func _physics_process(delta: float) -> void:
	move_and_slide()
	
	#for moving around
	#if velocity.length() > 0: 
		#$animation.play("run")
