extends Area2D
class_name Bullet

@export var attack_damage = 1
@export var direction = Vector2(0, 0)

var sprite_node_pos_tween : Tween

var tile_size = Def.TILE_SIZE
var diagonal_size = sqrt((pow(tile_size.x, 2) + (pow(tile_size.y, 2))))
var tick_ended = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_hitbox_body_entered(body):
	if body.has_method("damage"):
		body.damage(attack_damage)
	queue_free()

func move():
	$CollisionShape2D.disabled = true
	tick_ended = false
	await Audio.tick
	move_anim()
	tick_ended = true

func move_anim():
	global_position += direction * tile_size
	$Sprite2D.global_position -= direction * tile_size
	
	if sprite_node_pos_tween:
		sprite_node_pos_tween.kill()
		
	sprite_node_pos_tween = create_tween()
	sprite_node_pos_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	sprite_node_pos_tween.tween_property($Sprite2D, "global_position", global_position, 0.1).set_trans(Tween.TRANS_SINE)
	await sprite_node_pos_tween.finished
	$CollisionShape2D.disabled = false

func _process(_delta: float) -> void:
	if tick_ended:
		move()
