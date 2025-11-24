extends Node
class_name Enemy

var tick_counter = 0
@onready var tick_done = true

@export var bullets_direction: Vector2
@export var bullet_delay = 2

@onready var sprite: AnimatedSprite2D = $Sprite2D

const bullet : Dictionary = {
	"normal" : preload("res://Entities/Bullets/NormalBullet.tscn"),
	"diagonal" : preload("res://Entities/Bullets/DiagonalBullet.tscn"),
	"bounce" : "",
	"zigzag" : "",
	"heavy" : ""
}

func _ready() -> void:
	sprite.play("default")
	Audio.tick.connect(handler)

func attack(weapon, direction : Vector2):
	var node = bullet.get(weapon).instantiate()
	node.direction = direction
	add_child(node)
	
	Audio.play_sfx("spellcast")
	sprite.play("shoot")

func handler():
	tick_counter += 1
	if tick_counter < bullet_delay:
		return
	attack("normal", bullets_direction)
	tick_counter = 0
	await sprite.animation_looped
	sprite.play("default")
