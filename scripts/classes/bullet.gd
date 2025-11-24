extends Area2D
class_name Bullet

var direction = Vector2(1, 0)
var sprite_node_pos_tween : Tween

var tile_size = Def.TILE_SIZE
var diagonal_size = sqrt((pow(tile_size.x, 2) + (pow(tile_size.y, 2))))

func _on_hitbox_body_entered(body):
	if body.has_method("damage"):
		body.damage()
	queue_free()

func _ready() -> void:
	move()
	Audio.tick.connect(move)

func handler():
	move()

func move():
	$CollisionShape2D.disabled = true
	move_anim()

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
