extends Control


func _on_start_pressed() -> void:
	#Scene.gen_level()
	#Scene.load_next_room()
	Scene.current_room = 0
	Scene.load_next_room()
	Audio.stop_all_music()
	Audio.play_music("level_theme", 150)


func _ready() -> void:
	Def.lifes = 5

func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_credits_pressed() -> void:
	Scene.load_scene("credits")


func _on_options_pressed() -> void:
	pass # Replace with function body.
