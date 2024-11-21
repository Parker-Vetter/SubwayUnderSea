extends Control

@onready var playerPosition = get_parent().find_child("Player").find_child("UpperBody").find_child("Line2D").find_child("RShoulder")

var offset = Vector2(-30 , 10)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = playerPosition.position + offset
