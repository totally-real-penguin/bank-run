extends CharacterBody2D

@export var max_speed:int
@export var acceleration:int
@export var gravity: int
@export var max_fall_speed: int
@export var jump_power: int
@export var rebound: int

var score: int = 0
var shown_score: int = 0

var time: int = 150

var on_left_wall: bool = false
var on_right_wall: bool = false

var has_key: bool = false

func _physics_process(delta: float) -> void:
	var input_vector = Input.get_axis('left','right')

	velocity.x = move_toward(velocity.x, max_speed * input_vector,acceleration * delta)
	velocity.y = move_toward(velocity.y, max_fall_speed, gravity * delta)
	velocity.y = clamp(velocity.y,-max_fall_speed*3,max_fall_speed)

	if Input.is_action_just_pressed('jump'):
		if is_on_floor():
			velocity.y = -jump_power
			$Jump.play()
		elif on_left_wall:
			velocity.y = -jump_power
			velocity.x = rebound
			$Jump.play()
		elif on_right_wall:
			velocity.y = -jump_power
			velocity.x = -rebound
			$Jump.play()

	if !is_on_floor() and Input.is_action_just_released('jump'):
		velocity.y /= 1.5

	if time == 0:
		get_tree().change_scene_to_file('res://Scenes/ui/caught.tscn')

	shown_score = int(move_toward(shown_score,score,32))
	%Score.text = "Score: %05d" % shown_score
	move_and_slide()
	if is_on_floor():
		if abs(velocity.x) > 5 and $AnimationPlayer.current_animation != "Run":
			$AnimationPlayer.play("Run")
		elif $AnimationPlayer.current_animation != "Idle" and abs(velocity.x) < 5:
			$AnimationPlayer.play("Idle")
	else:
		$Sprite.scale.y = min(1,(max_fall_speed / abs(velocity.y)))
		$AnimationPlayer.play('RESET')

	if has_key:
		$Key.visible = true
	else:
		$Key.visible = false
	if input_vector < 0:
		$Sprite.flip_h = true
		$Sprite.offset = Vector2i(1,0)
	else:
		$Sprite.flip_h = false
		$Sprite.offset = Vector2i(0,0)

func _on_treasure_detector_area_entered(area: Area2D) -> void:
	if area.name.begins_with("Treasure"):
		score += area.value
		$GemCollect.play()
		area.collect()
	if area.name == "Exit" and time <= 15:
		EndMoney.money = score
		get_tree().change_scene_to_file('res://Scenes/ui/end.tscn')
	if area.name.begins_with("Chest") and has_key:
		area.collect()
		score += 5000
		has_key = false
	if area.name.begins_with("Key") and !has_key:
		has_key = true
		area.queue_free()
	if area.name.begins_with("Locked") and has_key:
		has_key = false
		area.get_parent().queue_free()

func _on_timer_timeout() -> void:
	time -= 1
	var minutes = floor(time/60)
	var seconds = time % 60
	%Time.text = "Time: %02d:%02d" % [minutes,seconds]
	if time <= 15:
		%Exit.visible = !%Exit.visible


func _on_right_wall_dectector_body_entered(body: Node2D) -> void:
	if body.name == "TileMap":
		on_right_wall = true

func _on_left_wall_dectector_body_entered(body: Node2D) -> void:
	if body.name == "TileMap":
		on_left_wall = true

func _on_left_wall_dectector_body_exited(body: Node2D) -> void:
	if body.name == "TileMap":
		on_left_wall = false

func _on_right_wall_dectector_body_exited(body: Node2D) -> void:
	if body.name == "TileMap":
		on_right_wall = false
