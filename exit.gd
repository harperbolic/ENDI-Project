extends Node2D

func _on_exit_body_entered(body: Node2D) -> void:
	if body:
		Audio.play_sfx("leave")
		Scene.load_next_room()
