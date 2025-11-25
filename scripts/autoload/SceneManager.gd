extends Node

var SM : String = "Scene Manager: "

var scenes = {
	"main_menu" : "res://scenes/main_menu.tscn",
	"testing" : "res://scenes/game_rooms/ROOM_TEMPLATE.tscn",
	"game_over" : "res://scenes/game_over.tscn",
	"credits" : "res://scenes/credits.tscn",
	"easy_1" : "res://scenes/game_rooms/floor1/level_1.tscn",
	"easy_2" : "res://scenes/game_rooms/floor1/level_2.tscn",
	"easy_3" : "res://scenes/game_rooms/floor1/level_3.tscn",
	"medium_1" : "res://scenes/game_rooms/floor2/level_1.tscn",
	
}

var transition_scene = preload("res://scenes/game_elements/transition.tscn")

var level = ["easy_1", "easy_2", "easy_3", "medium_1"]

@onready var scene = load(scenes["main_menu"]).instantiate()
@onready var old_scene = scene
@onready var current_room = 0
@onready var max_room = 9

func _ready() -> void:
	print(SM, "Scene 'main_menu' loaded")
	add_child(scene)

func load_scene(scene_str : String) -> void:
	var transition = transition_scene.instantiate()
	add_child(transition)
	transition.fade_in()
	await transition.fade_finished
	old_scene.queue_free()
	scene = load(scenes[scene_str]).instantiate()
	print(SM, "Scene '", scene_str, "' loaded.")
	add_child.call_deferred(scene)
	old_scene = scene
	transition.fade_out()

func load_next_room():
	if current_room > max_room:
		load_scene("main_menu")
		return
	load_scene(level[current_room])
	Scene.current_room += 1

func reload_room():
	load_scene(level[current_room - 1])
