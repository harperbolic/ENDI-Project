extends Node

@onready var MC : Control = $MC
@onready var Cli : Control = $Cli
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var texture_rect: TextureRect = $TextureRect

var is_MC_on_screen = false
var is_Cli_on_screen = false
var current_cli = "null"
var type

var character : String

func change_portrait (id : String, emotion : String):
	clear_portraits(id)
	
	if current_cli != id && id != "M":
		is_Cli_on_screen = false
	
	if id == "M":
		type = "MC"
		if !is_MC_on_screen:
			animation_player.play("mc_fade_in")
			is_MC_on_screen = true
		
		if !is_Cli_on_screen:
			if current_cli != "null":
				Dialog.reset_boxes()
			animation_player.play("CW_fade_in")
			is_Cli_on_screen = true
			current_cli = id
	elif id == "L":
		texture_rect.visible = false
		$CW.visible = false
		type = "Cli"
		
		if !is_Cli_on_screen:
			if current_cli != "null":
				Dialog.reset_boxes()
			animation_player.play("cli_fade_in")
			is_Cli_on_screen = true
			current_cli = id
	else:
		texture_rect.visible = true
		$CW.visible = false
		type = "Cli"
		
		if id == "S" and current_cli != "S":
			Audio.play_sfx("stinger")
		
		if !is_Cli_on_screen:
			if current_cli != "null":
				Dialog.reset_boxes()
			animation_player.play("cli_fade_in")
			is_Cli_on_screen = true
			current_cli = id
	
	
	var node = get_node(type + "/" + id + "_" + emotion)
	node.visible = true

func clear_portraits(id : String):
	if id == "P":
		for child in MC.get_children():
			child.visible = false
	else:
		for child in Cli.get_children():
			child.visible = false

func bg_fade_in():
	animation_player.play("bg_fade_in")

func fade_out():
	animation_player.play_backwards("bg_fade_in")
	animation_player.play_backwards("cli_fade_in")
	animation_player.play_backwards("mc_fade_in")
