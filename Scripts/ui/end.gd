extends Control

func _ready() -> void:
	$Score.text = "Score: %05d" % EndMoney.money



func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file('res://Scenes/ui/main_menu.tscn')

func _on_retry_pressed() -> void:
	get_tree().change_scene_to_file('res://Scenes/level.tscn')
