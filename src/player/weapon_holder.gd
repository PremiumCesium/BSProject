@tool
extends Node3D



@export var current_weapon: Weapon:
	set(value):
		current_weapon = value
		if Engine.is_editor_hint():
			load_weapon(value)

var weapon_damage: int
var weapon_range: int
var weapon_ammo: int
var weapon_fire_rate: float

var current_ammo: int

@onready var weapon_mesh: MeshInstance3D = %weapon_mesh

func _ready():
	load_weapon(current_weapon)
	
func load_weapon(weapon: Weapon) -> void:
	if weapon == null:
		print("No weapon loaded")
		return
	
	print("Loading weapon: ", weapon.weapon_name)
	
	# Load the weapon model and set it as a child of this node
	self.weapon_mesh_holder.mesh = weapon.mesh
	
	# Set the weapon properties
	self.weapon_damage = weapon.weapon_damage
	self.weapon_range = weapon.weapon_range
	self.weapon_ammo = weapon.weapon_ammo
	self.weapon_fire_rate = weapon.weapon_fire_rate
