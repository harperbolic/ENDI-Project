extends Node
class_name Enemy

var tick_done = true

const bullet : Dictionary = {
	"normal" : preload("res://Entities/Bullets/NormalBullet.tscn"),
	"diagonal" : "",
	"bounce" : "",
	"zigzag" : "",
	"heavy" : ""
}

@export var HP := 2

func damage(attack_damage : int):
	HP -= attack_damage
	
	if HP == 0:
		queue_free()

func attack(weapon, direction : Vector2):
	tick_done = false
	var node = bullet.get(weapon).instantiate()
#	node.rotation = direction
	add_child(node)
	await Audio.tick
	tick_done = true

func _process(_delta: float) -> void:
	if tick_done:
		attack("normal", Vector2(1, 0))
