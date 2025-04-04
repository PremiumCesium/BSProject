class_name WeaponClass

@export var weapon_equipped: int
@export var weapon_name: String
@export var magazine_size: int
@export var round_count: int

# @icon("res://class_icon.png")

func _fire():
    if(round_count):
        pass

func _reload():
    # Trigger animation

    #Execute Reload
    round_count = magazine_size

    pass

