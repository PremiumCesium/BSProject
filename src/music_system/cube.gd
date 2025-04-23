extends MeshInstance3D

const FADE_SPEED := 1000.0

@onready var mat: StandardMaterial3D
@onready var beat_detector = get_node("../beat_detector")

func _ready():
	mat = StandardMaterial3D.new()
	set_surface_override_material(0, mat)
	beat_detector.connect("beat_detected", _on_beat)
	mat.albedo_color = Color(1, 0, 0)

func _on_beat(timestamp):
	if mat.albedo_color == Color(1, 0, 0):
		mat.albedo_color = Color(0, 1, 0)
	else:
		mat.albedo_color = Color(1, 0, 0)

func _process(delta):
	pass
