extends Node2D

const PLAYERSPRITE = preload("res://Scenes/MainMenu/player_sprite_body.tscn")
const OXYGENMACHINESPRITE = preload("res://Scenes/MainMenu/oxygen_machine.tscn")
const LIGHTMACHINESPRITE = preload("res://Scenes/MainMenu/light_machine.tscn")
const LIFETIMER = preload("res://Scenes/MainMenu/lifeTimer.tscn")

@onready var line = $Line2D
@onready var spawner = $Spawner
@onready var spriteholder = $SpriteHolder

func _process(delta):
	for child in spriteholder.get_children():  # Iterate over all children of `spriteholder`
			child.rotate(randi_range(2,5) * delta)  # Make it spin (scaled by delta for smooth rotation)
			child.position.y += randi_range(10,20) * delta  # Move down the Y-axis (scaled by delta)

func _on_spawner_timeout() -> void:
	var spawn_x = lerp(line.get_point_position(0).x, line.get_point_position(1).x, randf())
	var spawn_y = line.get_point_position(0).y
	
	# Instantiate and configure the player instance
	var playerinstance = PLAYERSPRITE.instantiate()
	playerinstance.position = Vector2(spawn_x, spawn_y)  # Set position on the line
	spriteholder.add_child(playerinstance)  # Add to spriteholder

		# Instantiate the timer and attach it to the player instance
	var life_timer = LIFETIMER.instantiate()
	life_timer.name = "lifeTimer"
	life_timer.autostart = true
	life_timer.wait_time = 60
	life_timer.connect("timeout", Callable(self, "_on_player_life_timeout"))  # Use a callable for connection
	playerinstance.add_child(life_timer)
	life_timer.start()

func _on_player_life_timeout():
	# Find the timer's parent (player instance) and free it
	var playerinstance = spriteholder.get_child(0)
	if playerinstance:
		playerinstance.queue_free()
