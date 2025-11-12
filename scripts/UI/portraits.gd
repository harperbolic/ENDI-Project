extends Node

@onready var sprites : Control = $Sprites
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var current_sprite

func change_portrait (id : String, emotion : String):
	clear_portraits()
	
	if current_sprite == null:
		pass
	
	var node = get_node("Sprites/" + id + "_" + emotion)
	node.visible = true

func clear_portraits():
	current_sprite = null
	for child in sprites.get_children():
		child.visible = false
