extends Node
signal beat_detected(timestamp)

# === Audio bus & effect configuration ===
const BUS_NAME := "MusicBus"
var BUS_INDEX := AudioServer.get_bus_index(BUS_NAME)
const EFFECT_INDEX := 0  # index of the SpectrumAnalyzer effect on the MusicBus

# === Detection parameters ===
@export_group("Beat Settings")
@export var LOW_FREQ_START := 20   # Hz
@export var LOW_FREQ_END := 200    # Hz
@export var HISTORY_SIZE := 43     # ~0.5s buffer at 60fps with 512-sample FFT
@export var BEAT_THRESHOLD := 1.0  # multiplier above moving average to detect a beat
@export var COOLDOWN := 0.2        # seconds to wait between detected beats

# === Internal state ===
var history: Array = []    
var last_beat: float = -COOLDOWN
var beat_times: Array = []  

# Retrieve the analyzer instance once on ready
@onready var analyzer = _get_analyzer()

func _ready():
	if BUS_INDEX == -1:
		push_error("BeatDetector: Audio bus '%s' not found." % BUS_NAME)
	elif analyzer == null:
		push_error("BeatDetector: SpectrumAnalyzer instance not found on bus '%s' slot %d" % [BUS_NAME, EFFECT_INDEX])

func _process(delta):
	if analyzer == null:
		return
	var now = Time.get_ticks_msec() / 1000.0

	# 1. Sum low-frequency magnitudes (average left/right)
	var vec: Vector2 = analyzer.get_magnitude_for_frequency_range(LOW_FREQ_START, LOW_FREQ_END)
	var energy: float = (vec.x + vec.y) * 0.5

	# 2. Update history
	history.append(energy)
	if history.size() > HISTORY_SIZE:
		history.remove_at(0)

	# 3. Compute moving average
	var avg: float = 0.0
	if history.size() > 0:
		var sum_hist: float = 0.0
		for e in history:
			sum_hist += e
		avg = sum_hist / history.size()

	# 4. Peak detect with cooldown
	if now - last_beat > COOLDOWN and energy > avg * BEAT_THRESHOLD:
		last_beat = now
		beat_times.append(now)
		if beat_times.size() > 16:
			beat_times.remove_at(0)
		emit_signal("beat_detected", now)

# Helper to get the SpectrumAnalyzer instance
func _get_analyzer():
	var inst = AudioServer.get_bus_effect_instance(BUS_INDEX, EFFECT_INDEX)
	if inst is AudioEffectSpectrumAnalyzerInstance:
		return inst
	return null

# Compute current BPM based on recorded beat timestamps
func get_current_bpm() -> float:
	if beat_times.size() < 2:
		return 0.0
	var sum_intervals: float = 0.0
	for i in range(beat_times.size() - 1):
		sum_intervals += beat_times[i+1] - beat_times[i]
	var avg_interval: float = sum_intervals / (beat_times.size() - 1)
	if avg_interval > 0.0:
		return 60 / avg_interval
	return 0.0
