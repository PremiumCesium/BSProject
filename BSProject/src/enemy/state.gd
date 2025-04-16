extends Node
class_name State

signal Transitioned # To instantaoneously exit whenever our child transition is called

func Enter(): #base enter logic
	pass
	
func Execute(): # base execute logic
	pass
	
func Exit(): #base exit logic
	pass
	
func Update(_delta: float): # update logic
	pass
	
func Physics_Update(_delta: float): # physic update logic
	pass
		
	
		
