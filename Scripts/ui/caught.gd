extends Control

func _on_retry_pressed() -> void:
	get_tree().change_scene_to_file('res://Scenes/level.tscn')


func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file('res://Scenes/ui/main_menu.tscn')
