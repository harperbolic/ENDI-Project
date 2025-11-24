extends Bullet

var is_flipped = false

func _ready() -> void:
	Audio.tick.connect(handler)
	direction = Vector2(-1, 0)
	$AnimationPlayer.play("default")

func handler():
	if !is_flipped:
		direction.x = -1
		if !$front.is_colliding():
			move_anim()
		else:
			$Sprite2D.flip_h = true
			is_flipped = true
	else:
		direction.x = 1
		if !$rear.is_colliding():
			move_anim()
		else:
			$Sprite2D.flip_h = false
			is_flipped = false

func move_anim():
	$CollisionShape2D.disabled = true
	global_position += direction * tile_size
	$Sprite2D.global_position -= direction * tile_size
	
	if sprite_node_pos_tween:
		sprite_node_pos_tween.kill()
		
	sprite_node_pos_tween = create_tween()
	sprite_node_pos_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	sprite_node_pos_tween.tween_property($Sprite2D, "global_position", global_position, 0.1).set_trans(Tween.TRANS_SINE)
	await sprite_node_pos_tween.finished
	$CollisionShape2D.disabled = false
