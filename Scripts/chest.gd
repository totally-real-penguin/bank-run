extends Area2D

func collect():
	$AnimationPlayer.play('Open')
	await $AnimationPlayer.animation_finished
	queue_free()
