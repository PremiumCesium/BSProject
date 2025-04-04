@tool

extends Node3D

@export var current_weapon: Weapon:
	set(value):
		current_weapon = value
		load_weapon()

@onready var weapon_mesh: MeshInstance3D = $"weapon_mesh"

var weapon_ammo: int        = 0
var weapon_damage: int      = 0
var weapon_range: int       = 0
var weapon_fire_rate: float = 0.0
var weapon_name: String     = ""
var curent_ammo: int        = 0

func _ready() -> void:
	load_weapon()

func load_weapon() -> void:
	var weapon: Weapon = current_weapon
	weapon_ammo = weapon.weapon_ammo
	weapon_damage = weapon.weapon_damage
	weapon_range = weapon.weapon_range
	weapon_fire_rate = weapon.weapon_fire_rate
	weapon_name = weapon.weapon_name
	curent_ammo = weapon_ammo

	if weapon_mesh != null:
		weapon_mesh.mesh = weapon.mesh