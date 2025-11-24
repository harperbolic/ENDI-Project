extends Enemy

func handler():
	tick_counter += 1
	if tick_counter < bullet_delay:
		return
	attack("diagonal", bullets_direction)
	tick_counter = 0
	await sprite.animation_looped
	sprite.play("default")
