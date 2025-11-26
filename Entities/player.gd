extends Node2D
class_name player

const tile_size = Def.TILE_SIZE
var sprite_node_pos_tween : Tween

var next_move = "none"
var tick_ended = true

func _physics_process(_delta: float) -> void:
	if !sprite_node_pos_tween or !sprite_node_pos_tween.is_running():
		if Input.is_action_pressed("Up"):
			next_move = "up"
		elif Input.is_action_pressed("Down"):
			next_move = "down"
		elif Input.is_action_pressed("Left"):
			next_move = "left"
		elif Input.is_action_pressed("Right"):
			next_move = "right"
	
	if tick_ended:
		execute_action()

func execute_action() -> void:
	tick_ended = false
	await Audio.tick
	
	match next_move:
		"up":
			if !$raycast/up.is_colliding():
				_move(Vector2(0, -1))
		"down":
			if !$raycast/down.is_colliding():
				_move(Vector2(0, 1))
		"left":
			if !$raycast/left.is_colliding():
				_move(Vector2(-1, 0))
		"right":
			if !$raycast/right.is_colliding():
				_move(Vector2(1, 0))
	
	next_move = "none"
	tick_ended = true

func _move(dir: Vector2) -> void:
	Audio.play_sfx("walk")
	
	global_position += dir * tile_size
	$Sprite2D.global_position -= dir * tile_size
	
	if sprite_node_pos_tween:
		sprite_node_pos_tween.kill()
		
	sprite_node_pos_tween = create_tween()
	sprite_node_pos_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	sprite_node_pos_tween.tween_property($Sprite2D, "global_position", global_position, 0.1).set_trans(Tween.TRANS_SINE)

func damage() -> void:
	Def.take_damage()
	Audio.play_sfx("fail")
	if Def.lifes > 0:
		Scene.reload_room()
	else:
		Scene.load_scene("game_over")
