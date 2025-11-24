extends Bullet

func set_sprite_rotation():
	match direction:
		Vector2(0, -1):
			$Sprite2D.rotation = deg_to_rad(90)
		Vector2(0, 1):
			$Sprite2D.rotation = deg_to_rad(-90)
		Vector2(-1, 0):
			$Sprite2D.rotation = deg_to_rad(0)
		Vector2(1, 0):
			$Sprite2D.rotation = deg_to_rad(180)
