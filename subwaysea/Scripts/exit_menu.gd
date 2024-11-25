extends Control

func _on_credits_button_pressed() -> void:
	Engine.time_scale = 1
	get_tree().change_scene_to_file("res://Scenes/Credits.tscn")

func _on_exit_button_pressed() -> void:
	Engine.time_scale = 1
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func _on_return_button_pressed() -> void:
	get_parent().visible = false
	Engine.time_scale = 1
