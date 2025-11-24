extends Node

var settings_save : Dictionary = {
	"debug" : false
}

const TILE_SIZE : Vector2 = Vector2(16, 16)

@onready var lifes = 5

signal HP_update

func take_damage() -> void:
	print("took damage")
	lifes -= 1
	HP_update.emit()
	
	if lifes < 1:
		Audio.stop_all_music()
		Audio.play_sfx("spellcast")
		Scene.load_scene("game_over")
