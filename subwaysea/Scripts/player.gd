extends RigidBody2D


@onready var upper_body: RigidBody2D = $UpperBody
@onready var bend_up: Marker2D = $BendUp
@onready var bend_over: Marker2D = $BendOver
@onready var bend_down: Marker2D = $BendDown
@onready var target_feet: Marker2D = $TargetFeet
@onready var floor_snap: Marker2D = $TargetFeet/FloorSnap
@onready var lerp_position: Marker2D = $LerpPosition
@onready var feet_ray_cast: RayCast2D = $TargetFeet/FeetRayCast
@onready var left_lerp_mover: Marker2D = $LeftLerpMover



enum STATES {STAND, BEND, LAY, CUTSCENE}
var cur_state = STATES.STAND

var bend_distance = 0
var speed = 190000
var chest_speed = 2000 #for polish could add movement speed based on if you are laying down or not
var chest_rotation = 0
@onready var spine = Vector2.ZERO

var ik_length = 35.0

func _ready() -> void:
	upper_body.add_collision_exception_with(self)
	upper_body.global_position = global_position

func _physics_process(delta: float) -> void:
	manage_feet(delta)
	var v = Input.get_axis("left","right")
	
	bend_up.global_position = global_position + Vector2(0, -50)
	if v:
		apply_torque(v * speed)
		upper_body.apply_central_force(v * chest_speed * Vector2(1,0))
		upper_body.rotation = chest_rotation * v
		
		bend_over.global_position = global_position + Vector2(v * 12,-30)
		bend_down.global_position = global_position + Vector2(v * 20, 0)
	else:
		angular_velocity = 0.0
	
	match cur_state:
		STATES.STAND:
			spine = bend_up.global_position
			chest_rotation = 0
		STATES.BEND:
			spine = bend_over.global_position
			chest_rotation = 1
		STATES.LAY:
			spine = bend_down.global_position
			chest_rotation = linear_velocity.angle() + PI/2
		STATES.CUTSCENE:
			spine = bend_up.global_position
	
	manage_spine(delta)

func set_state_stand():
	cur_state = STATES.STAND
	linear_damp = 0
	speed = 190000
func set_state_bend():
	cur_state = STATES.BEND
	speed = 150000
func set_state_lay():
	cur_state = STATES.LAY
	speed = 50000
func set_state_cutscene():
	cur_state = STATES.CUTSCENE
	linear_damp = 12

func manage_spine(delta):
	
	var u = Input.get_axis('down', 'up')
	
	if Input.is_action_just_pressed("down"):
		if cur_state == STATES.STAND: set_state_bend()
		elif cur_state == STATES.BEND: set_state_lay()
	elif Input.is_action_just_pressed('up'):
		if cur_state == STATES.LAY: set_state_bend()
		elif cur_state == STATES.BEND: set_state_stand()
		
	upper_body.apply_central_force((upper_body.global_position - spine) * -60)
	#apply_central_force((global_position.x - upper_body.global_position.x) * Vector2(-100, 0.0) ) 
	#base this upper part right here on how far the square is from the marker instead of the body

func manage_feet(delta):
	
	
	#moving code
	if linear_velocity.abs().length() > 20.0:
		target_feet.global_position = global_position + Vector2(Input.get_axis('left','right') * ik_length,0)
		
		if floor_snap.global_position.distance_to(lerp_position.global_position) > ik_length * 1.3:
			lerp_position.global_position = floor_snap.global_position
			#print('thedistance, hes going for speed, shes all alone, all alone, in her time of need')
	else:
		target_feet.global_position = global_position + Vector2(Input.get_axis('left','right') * .1,0)
		lerp_position.global_position = floor_snap.global_position
		
	if feet_ray_cast.is_colliding():
		floor_snap.global_position = feet_ray_cast.get_collision_point()
	
	manage_visual_feet(delta)

func manage_visual_feet(delta):
	left_lerp_mover.global_position = left_lerp_mover.global_position.lerp(lerp_position.global_position, 16 * delta)
	if left_lerp_mover.global_position.distance_to(lerp_position.global_position) > 10.0:
		left_lerp_mover.global_position.y -= delta * 5
	$LeftThigh.global_position = global_position + Vector2(0,-10)
	
	
	
