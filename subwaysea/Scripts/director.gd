extends Node

var fullscreen := false 

var score = 0 
var done = false

func _process(delta):
	if Input.is_action_just_pressed("exit"):
		get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
		## Attempt to find MainScene dynamically
		#var MainScene = get_tree().root.get_node_or_null("MainScene")
		#if MainScene == null:
			## MainScene is not currently in the scene tree; do nothing
			#return
		#else:
			## Find escMenu as a child of MainScene
			#var escMenu = MainScene.get_node_or_null("escMenu")
			#if escMenu.visible == false:
				#escMenu.visible = true
				#Engine.time_scale = 0  # Pause the game
			#elif escMenu.visible == true:
				#escMenu.visible = false
				#Engine.time_scale = 1  # Resume the game
	
	if Input.is_action_just_pressed("fullscreen"):
		if !fullscreen:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			fullscreen = true
		else:
			fullscreen = false
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	#if Input.is_action_just_pressed('restart'):
		##killing player instead of just reloading the scene for the nice 
		##fade in/fade out that's already implemented
		#get_tree().reload_current_scene()
