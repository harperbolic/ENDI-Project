extends Node

var SM : String = "Scene Manager: "

var scenes = {
	"main_menu" : "res://scenes/main_menu.tscn",
	"testing" : "res://scenes/game_rooms/ROOM_TEMPLATE.tscn",
	"game_over" : "res://scenes/game_over.tscn",
	"game_win" : "res://scenes/game_win.tscn",
	"credits" : "res://scenes/credits.tscn",
	"f1l1" : "res://scenes/game_rooms/floor1/level_2.tscn",
	"f1l2" : "res://scenes/game_rooms/floor1/level_1.tscn",
	"f1l3" : "res://scenes/game_rooms/floor1/level_3.tscn",
	"f1l4" : "res://scenes/game_rooms/floor1/level_4.tscn",
	"f1l5" : "res://scenes/game_rooms/floor1/level_5.tscn",
	"f1l6" : "res://scenes/game_rooms/floor1/level_6.tscn",
	"f1l7" : "res://scenes/game_rooms/floor1/level_7.tscn",
	"f2l1" : "res://scenes/game_rooms/floor2/level_3.tscn",
	"f2l2" : "res://scenes/game_rooms/floor2/level_4.tscn",
	"f2l3" : "res://scenes/game_rooms/floor2/level_2.tscn",
}

var transition_scene = preload("res://scenes/game_elements/transition.tscn")

var level = ["f1l1", "f1l2", "f1l3", "f1l4", "f1l5", "f1l6","f1l7", "f2l1", "f2l2", "f2l3", "game_win"]

@onready var scene = load(scenes["main_menu"]).instantiate()
@onready var old_scene = scene
@onready var current_room = 0

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
	load_scene(level[current_room])
	Scene.current_room += 1

func reload_room():
	load_scene(level[current_room - 1])
