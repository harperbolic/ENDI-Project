extends Control

func _ready() -> void:
	Audio.stop_all_music()

func _on_exit_pressed() -> void:
	get_tree().quit()
