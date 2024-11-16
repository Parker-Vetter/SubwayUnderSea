extends RayCast2D

@onready var polarity = 1

func _process(delta: float) -> void: 
	rotateRay(delta)
	
func rotateRay(delta):
	if rotation_degrees >= 42:
		polarity = -1
	elif rotation_degrees <= 0:
		polarity = 1
	set_rotation_degrees(get_rotation_degrees() + (400 * polarity * delta))
