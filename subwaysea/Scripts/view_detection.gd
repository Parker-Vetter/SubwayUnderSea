extends RayCast2D

@onready var polarity = 1


func _process(delta: float) -> void: 
	#if Input.is_action_just_pressed("left_mouse"):
		#rotateRay(delta)
	rotateRay(delta)
	
func rotateRay(delta):
	#set_rotation_degrees(get_rotation_degrees() + 10)
	print(rotation_degrees)
	if rotation_degrees >= 42:
		polarity = -1
	elif rotation_degrees <= 0:
		polarity = 1
	print(polarity)
	set_rotation_degrees(get_rotation_degrees() + (3 * polarity))
