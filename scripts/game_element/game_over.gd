extends Control

func _on_start_pressed() -> void:
	Scene.current_room = 0
	Def.lifes = 5
	Scene.load_next_room()

func _on_exit_pressed() -> void:
	Scene.load_scene("main_menu")
