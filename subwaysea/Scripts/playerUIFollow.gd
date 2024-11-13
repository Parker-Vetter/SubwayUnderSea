extends Control

@onready var playerPosition = get_parent().find_child("Player")

var offset = Vector2(20 , -60)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = playerPosition.position + offset
