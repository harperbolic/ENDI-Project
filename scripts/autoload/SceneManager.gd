extends Node

var SM : String = "Scene Manager: "

var scenes = {
	"main_menu" : "res://scenes/main_menu.tscn",
	"testing" : "res://scenes/game_rooms/ROOM_TEMPLATE.tscn",
}

var room_easy = {
	"room_1" : "res://scenes/game_rooms/level1j.tscn",
	"room_2" :"res://scenes/game_rooms/ROOM_TEMPLATE.tscn"
}

var room_medium = {
	
}

var room_hard = {
	
}

var level = ["testing", "testing", "testing", "testing", "testing"]

@onready var scene = load(scenes["main_menu"]).instantiate()
@onready var old_scene = scene
@onready var current_room = 0
@onready var max_room = 2

func _ready() -> void:
	print(SM, "Scene 'main_menu' loaded")
	add_child(scene)

func load_scene(scene_str : String) -> void:
	old_scene.queue_free()
	scene = load(scenes[scene_str]).instantiate()
	print(SM, "Scene '", scene_str, "' loaded.")
	add_child.call_deferred(scene)
	old_scene = scene

func load_next_room():
	current_room += 1
	if current_room > max_room:
		load_scene("main_menu")
		return
	load_scene(level[current_room])

func reload_room():
	load_scene(level[current_room])

func gen_level():
	for i in level:
		if i < 3:
			level[i] = room_easy.get(room_easy.keys().pick_random())
		if i < 5:
			level[i] = room_medium.get(room_medium.keys().pick_random())
		else:
			level[i] = room_hard.get(room_hard.keys().pick_random())
