extends Area2D

enum TreasureType {
	Diamond,
	Coin,
	LargeGem,
	Star,
	Gem,
}

var type : TreasureType

var value = 1000 - (200 * type)

var sprite_pos = {
	0: Vector2i(0,0),
	1: Vector2i(16,0),
	2: Vector2i(0,64),
	3: Vector2i(0,96),
	4: Vector2i(0,32)
}

func set_value() -> void:
	$Sprite.region_rect = Rect2(sprite_pos[type],Vector2(16,16))
	value = 1000 - (200 * type)
	$Label.text = "+" + str(value)
	if type == 1:
		$AnimationPlayer.play('spin')

func collect() -> void:
	if type != 1:
		$Sprite.region_rect = Rect2(sprite_pos[type].x,sprite_pos[type].y+16,16,16)
	else:
		$Sprite.region_rect = Rect2(16,64,16,16)
	$AnimationPlayer.play('Collect')
	await  $AnimationPlayer.animation_finished
	queue_free()
