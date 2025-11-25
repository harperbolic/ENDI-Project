extends Node

var settings_save : Dictionary = {
	"debug" : false
}

const TILE_SIZE : Vector2 = Vector2(16, 16)

@onready var lifes = 5

#  dialog files
var intro_dialog: Dictionary

func take_damage() -> void:
	print("took damage")
	lifes -= 1
