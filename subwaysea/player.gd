extends RigidBody2D


@onready var upper_body: RigidBody2D = $UpperBody
@onready var spine = Vector2.ZERO
@onready var bend_up: Marker2D = $BendUp
@onready var bend_over: Marker2D = $BendOver

func _ready() -> void:
	upper_body.add_collision_exception_with(self)
	upper_body.global_position = global_position

func _process(delta: float) -> void:
	var v = Input.get_axis("left","right")
	

	
	if v:
		apply_torque(v * 120000)
	else:
		angular_velocity = 0.0
	
	manage_spine(delta)

func manage_spine(delta):
	
	bend_up.global_position = global_position + Vector2(0, -50)
	bend_over.global_position = global_position + Vector2(0,-10)
	
	var u = Input.get_axis('down', 'up')
	
	if u == -1:
		spine = bend_over.global_position
		upper_body.rotation = lerp(upper_body.rotation, 4.0, delta* 8 )
	else:
		spine = bend_up.global_position
		upper_body.rotation = lerp(upper_body.rotation, 0.0, delta * 2)
		
	upper_body.apply_central_force((upper_body.global_position - spine) * -100)
	apply_central_force((global_position.x - upper_body.global_position.x) * Vector2(-100, 0.0) )
	print(global_position.x - spine.x)
