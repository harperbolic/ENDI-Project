extends Node

var SM : String = "Scene Manager: "

var scenes = {
	"main_menu" : "res://scenes/main_menu.tscn",
	"testing" : "res://scenes/game_rooms/ROOM_TEMPLATE.tscn",
}

var rooms = {}

var level = ["testing", "testing", "testing"]

@onready var scene = load(scenes["testing"]).instantiate()
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
	pass
