extends Node

signal fade_finished

func fade_in():
	
	$AnimationPlayer.play("fade_in")
	await $AnimationPlayer.animation_finished
	fade_finished.emit()

func fade_out():
	Audio.play_sfx("transition_in")
	$AnimationPlayer.play("fade_out")
	await $AnimationPlayer.animation_finished
	queue_free()
