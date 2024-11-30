extends Control


func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/MainScene.tscn")

func _on_credits_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Credits.tscn")

func _on_button_pressed() -> void:
	get_tree().quit()

func _on_tutorial_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/tutorial_menu.tscn")	

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
