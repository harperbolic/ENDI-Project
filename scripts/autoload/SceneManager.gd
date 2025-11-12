extends Node

var SM : String = "Scene Manager: "

var scenes = {
	"main_menu" : "res://scenes/main_menu.tscn",
	"testing" : "res://scenes/testing_main.tscn",
}

var rooms = {}

@onready var scene = load(scenes["testing"]).instantiate()
@onready var old_scene = scene
@onready var current_room

func _ready() -> void:
	print(SM, "Scene 'main_menu' loaded")
	add_child(scene)

func load_scene(scene_str : String) -> void:
	old_scene.queue_free()
	scene = load(scenes[scene_str]).instantiate()
	print(SM, "Scene '", scene_str, "' loaded.")
	add_child(scene)
	old_scene = scene

func load_room(scene_str : String) -> void:
	current_room.free()
