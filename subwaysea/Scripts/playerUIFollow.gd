extends Control

@onready var playerPosition = get_parent().find_child("Player").find_child("UpperBody").find_child("Line2D").find_child('TextureProgressBar')

var offset = Vector2(0 , 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	playerPosition.value = $TextureProgressBar.value
	
