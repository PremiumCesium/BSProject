extends AudioStreamPlayer3D

@onready var beat_detector = $"../beat_detector"

func _ready() -> void:
	self.bus = "MusicBus"
	var song := load("res://src/music_system/ricflair.tres")
	play_song(song)
	
func play_song(song: Song):
	beat_detector.LOW_FREQ_START = song.low_start
	beat_detector.LOW_FREQ_END = song.low_end
	beat_detector.COOLDOWN = song.cooldown
	beat_detector.BEAT_THRESHOLD = song.threshold
	self.stream = song.track
	self.play()
	
