extends Node

signal tick
var bpm
var time_begin
var time_delay
var is_playing_music = false
var beat_time
var time_since_tick = 0
var past_time = 0

func play_sfx(id : String) -> void:
	var node = get_node("%SFX/" + id)
	node.play()

func play_music(id : String, bpm_f : int) -> void:
	bpm = bpm_f
	var node = get_node("%Music/" + id)
	print(node)
	
	is_playing_music = true
	
	time_begin = Time.get_ticks_usec()
	time_delay = AudioServer.get_time_to_next_mix() + AudioServer.get_output_latency()
	time_since_tick = 0
	
	beat_time = 60.0 / bpm
	
	node.play()

func stop_music(id : String) -> void:
	var node = get_node("%Music/" + id)
	
	is_playing_music = false
	
	node.stop()

func stop_all_music() -> void:
	var root_node = get_node("%Music")
	var audio_node
	for child in root_node.get_children():
		audio_node = child
		audio_node.stop()
	is_playing_music = false

func _process(_delta: float) -> void:
	if is_playing_music:
		# Obtain from ticks.
		var time = (Time.get_ticks_usec() - time_begin) / 1000000.0
		# Compensate for latency.
		time -= time_delay
		# May be below 0 (did not begin yet).
		time = max(0, time)
		time_since_tick += time - past_time
		if time_since_tick > beat_time:
			tick.emit()
			print("Tick emitted")
			time_since_tick = 0
		past_time = time

func _ready() -> void:
	Audio.play_music("main_menu", 128)
