extends RigidBody2D


@onready var upper_body: RigidBody2D = $UpperBody
@onready var bend_up: Marker2D = $BendUp
@onready var bend_over: Marker2D = $BendOver
@onready var target_feet: Marker2D = $TargetFeet
@onready var floor_snap: Marker2D = $TargetFeet/FloorSnap

@onready var r_lerp_position_hand: Marker2D = $UpperBody/Line2D/AnimationLerp/RLerpPositionHand
#@onready var moving_target: Marker2D = $Thigh/MovingTarget
@onready var left_lerp_mover: Marker2D = $Thigh/LeftFeet/LeftLerpMover
@onready var right_lerp_mover: Marker2D = $Thigh/RightFeet/RightLerpMover
@onready var anchor_target: Marker2D = $Thigh/AnchorTarget
@onready var moving_target: Marker2D = $Thigh/MovingTarget
@onready var moving_ray_cast_2d: RayCast2D = $Thigh/MovingTarget/MovingRayCast2D
@onready var anchor_ray_cast_2d: RayCast2D = $Thigh/AnchorTarget/AnchorRayCast2D

@onready var crouch_raycast: RayCast2D = $Thigh/CrouchMoving/CrouchRaycast
@onready var crouch_anchor: RayCast2D = $Thigh/CrouchAnchor/CrouchAnchor

@onready var spine_offset: Sprite2D = $SpineOffset

@onready var stride_circle: CollisionShape2D = $StrideCircle


@export var stride_circle_speed = 2.0

enum STATES {STAND, BEND, LAY, CUTSCENE}
var cur_state = STATES.STAND

var bend_distance = 0
var direction
var speed = 190000
var chest_speed = 2000 #for polish could add movement speed based on if you are laying down or not
var chest_rotation = 0
var walking_backwards = false
@onready var spine = Vector2.ZERO
var holding_c = []


var ik_length = 23.0
var y_offset = 0

func _ready() -> void:
	set_state_stand()
	upper_body.add_collision_exception_with(self)
	upper_body.global_position = global_position
	
	

func _physics_process(delta: float) -> void:
	
	var v = Input.get_axis("left","right")
	direction = sign(get_global_mouse_position().x - global_position.x)
	
	if v:
		if !(v + direction):
			v *= .2
			walking_backwards = true
		apply_torque(v * speed * 1)
	else:
		angular_velocity = 0.0
		walking_backwards = false
	
	match cur_state:
		STATES.STAND:
			stand_process(delta)
			bend_up.global_position = global_position + Vector2(0, -40)
			spine = bend_up.global_position + Vector2(v * 12,0)
		STATES.BEND:
			crouch_process(delta)
			spine = bend_over.global_position
			bend_over.global_position = global_position + Vector2(direction * 25,-25)
		STATES.CUTSCENE:
			bend_up.global_position = global_position + Vector2(0, -30)
			spine = bend_up.global_position
			spine_offset.global_position = global_position
	
	upper_body.rotation = upper_body.global_position.angle_to_point(global_position - Vector2(0,15)) - PI/2
	
	$Thigh.global_position = $UpperBody/Line2D.to_global($UpperBody/Line2D.get_point_position(1))
	
	anchor_ray_cast_2d.global_position = Vector2(anchor_target.global_position.x, global_position.y)
	moving_ray_cast_2d.global_position = Vector2(moving_target.global_position.x, global_position.y)
	manage_spine(delta)
	manage_arm(delta)
	manage_component(delta)
	match_face(delta)

func set_state_stand():
	cur_state = STATES.STAND
	linear_damp = 0
	speed = 350000
func set_state_bend():
	cur_state = STATES.BEND
	speed = 60000
	
	crouch_i_f.clear()
	crouch_i_f += [crouch_raycast.get_collision_point() + Vector2(0,-19)]
	crouch_i_f += [crouch_anchor.get_collision_point() + Vector2(0,-19)]
	
func set_state_cutscene():
	cur_state = STATES.CUTSCENE
	linear_damp = 12

func manage_spine(delta):
	var u = Input.get_axis('down', 'up')
	
	if Input.is_action_just_pressed("down"):
		if cur_state == STATES.STAND: set_state_bend()
		#elif cur_state == STATES.BEND: set_state_lay()
	elif Input.is_action_just_pressed('up'):
		if cur_state == STATES.LAY: set_state_bend()
		elif cur_state == STATES.BEND: set_state_stand()
	
	
	$UpperBody/Line2D.global_position = upper_body.global_position + Vector2(0,12) + (spine_offset.position - global_position)
	# torso tilt while moving, disabled for ladder movement
	if cur_state != STATES.CUTSCENE:
		$UpperBody/Line2D.rotation = upper_body.global_rotation + (linear_velocity.x * .0019)
	
	upper_body.apply_central_force((upper_body.global_position - (spine)) * -80)
	if cur_state == STATES.STAND: 
		upper_body.rotation = 0
	#apply_central_force((spine.x - upper_body.global_position.x) * Vector2(-60, 0.0))
	apply_torque((spine.x - upper_body.global_position.x) * -10000)
	
	#base this upper part right here on how far the square is from the marker instead of the body


@onready var anchor_leg = left_lerp_mover
@onready var moving_leg = right_lerp_mover
#debug
#var current_y = 0.0
#const amplitude = 12
#
#var distance_leg

var pass_f = [Vector2(-36,10), Vector2(0,30)] #third = offset
var run_f = [Vector2(-26,7), Vector2(30,6)]

var pass_w_f = [Vector2(-23,19),Vector2(0,30)]
var walk_f = [Vector2(-18,20),Vector2(20,30)]

var final_p_f = []
var final_m_f = []



var walk_run_ratio = 1

var idle_f = [Vector2(11,36), Vector2(-14,36)]

var last_stride_angle = 0
var rotation_time = 0
var old_rotation_time = .27
@onready var bounce_curve = preload("res://assets/bounce.tres")

func stand_process(delta):
	calculate_speed(delta)
	
	stride_circle.global_rotation += circle_speed * delta * stride_circle_speed
	walk_run_ratio = min(abs(circle_speed)/3, 1)
	
	if walking_backwards: 
		walk_run_ratio = 0
	else:
		walk_run_ratio = 0.5
		
	#print(walk_run_ratio)
	if abs(circle_speed) > 2:
		stride_circle_speed = 1.5
	else:
		stride_circle_speed = 6.0
	
	if bool(direction - 1):
		final_p_f = [lerp(pass_w_f[0], pass_f[0], walk_run_ratio).reflect(Vector2(0,-1)), lerp(pass_w_f[1], pass_f[1], walk_run_ratio).reflect(Vector2(0,-1))]
		final_m_f = [lerp(walk_f[0],run_f[0], walk_run_ratio).reflect(Vector2(0,-1)), lerp(walk_f[1],run_f[1], walk_run_ratio).reflect(Vector2(0,-1))]
	else:
		final_p_f = [lerp(pass_w_f[0], pass_f[0], walk_run_ratio), lerp(pass_w_f[1], pass_f[1], walk_run_ratio)]
		final_m_f = [lerp(walk_f[0],run_f[0], walk_run_ratio), lerp(walk_f[1],run_f[1], walk_run_ratio)]
	
	
	if linear_velocity.abs().length() > 3.0:
		spine_offset.global_position.x = global_position.x
		spine_offset.global_position.y = global_position.y - (5 * bounce_curve.sample(rotation_time/old_rotation_time))
		rotation_time += delta
		
		if abs(stride_circle.global_rotation - last_stride_angle) > PI/2:
			stride_circle.global_rotation = 0
			old_rotation_time = rotation_time
			rotation_time = 0
			
			last_stride_angle = stride_circle.global_rotation
			anchor_leg.position = final_p_f[0]
			moving_leg.position = final_p_f[1]
			
			if anchor_leg == moving_target:
				anchor_leg = anchor_target
				moving_leg = moving_target
			else:
				anchor_leg = moving_target
				moving_leg = anchor_target
		elif abs(stride_circle.global_rotation - last_stride_angle) > PI/5:
			anchor_leg.position = final_m_f[0]
			moving_leg.position = final_m_f[1]
	else:
		anchor_leg.position = idle_f[0]
		moving_leg.position = idle_f[1]
	
	
	left_lerp_mover.position = left_lerp_mover.position.lerp(anchor_target.position, delta * 25)
	right_lerp_mover.position = right_lerp_mover.position.lerp(moving_target.position, delta * 25)
	
	#$Thigh.global_position = $UpperBody/Line2D.to_global($UpperBody/Line2D.get_point_position(1))

var old_pos_circle_x = 0
var circle_speed = 0 

func calculate_speed(delta):
	stride_circle.global_position = global_position
	var new_speed = stride_circle.global_position.x - old_pos_circle_x #forgot delta LOL
	circle_speed = new_speed
	old_pos_circle_x = stride_circle.global_position.x


var crouch_f = [Vector2(30,-3)]
var crouch_i_f = [Vector2(0,0),Vector2(0,0)]

func crouch_process(delta):
	stride_circle_speed = 2.2
	calculate_speed(delta)
	stride_circle.global_rotation += circle_speed * delta * stride_circle_speed
	
	$Thigh/CrouchMoving.position.x = direction * 30
	$Thigh/CrouchAnchor.position.x = direction * -15
	
	upper_body.apply_central_force(Vector2(0,-200 * abs(stride_circle.global_rotation - last_stride_angle)))
	if linear_velocity.abs().length() > 3.0:
		spine_offset.global_position.x = global_position.x - 12 * direction
		spine_offset.global_position.y = global_position.y 
		rotation_time += delta
		
		if abs(stride_circle.global_rotation - last_stride_angle) > PI/2:
			stride_circle.global_rotation = 0
			old_rotation_time = rotation_time
			rotation_time = 0
			
			last_stride_angle = stride_circle.global_rotation
			
			anchor_leg.position = Vector2.ZERO
			moving_leg.position = Vector2.ZERO
			crouch_i_f.clear()
			crouch_i_f += [crouch_raycast.get_collision_point() + Vector2(0,-19)]
			crouch_i_f += [crouch_anchor.get_collision_point() + Vector2(0,-19)]
			
			if anchor_leg == moving_target:
				anchor_leg = anchor_target
				moving_leg = moving_target
			else:
				anchor_leg = moving_target
				moving_leg = anchor_target
		elif abs(stride_circle.global_rotation - last_stride_angle) > PI/3:
			#anchor_leg.position = anchor_leg.to_local(crouch_i_f[0])
			moving_leg.position = crouch_f[0]
		else:
			anchor_leg.position = Vector2.ZERO
			moving_leg.position = Vector2.ZERO
			anchor_leg.position = anchor_leg.to_local(crouch_i_f[0])
			moving_leg.position = moving_leg.to_local(crouch_i_f[1])
	else:
		anchor_leg.position = Vector2.ZERO
		moving_leg.position = Vector2.ZERO
		anchor_leg.position = anchor_leg.to_local(crouch_i_f[0])
		moving_leg.position = moving_leg.to_local(crouch_i_f[1])
			
			
	left_lerp_mover.position = left_lerp_mover.position.lerp(anchor_target.position, delta * 25)
	right_lerp_mover.position = right_lerp_mover.position.lerp(moving_target.position, delta * 25)

func manage_arm(delta):
	$UpperBody/Line2D/RShoulder.global_position = $UpperBody/Line2D/Shoulder_pos.global_position
	$UpperBody/Line2D/AnimationLerp.global_position = $UpperBody/Line2D/Shoulder_pos.global_position
	
	r_lerp_position_hand.position = r_lerp_position_hand.position.lerp(Vector2(29,20) + (Vector2(0,(spine_offset.position.y - global_position.y) * 2)), delta * 8)
func bump_hand():
	r_lerp_position_hand.position += Vector2.ONE * -8

func manage_component(delta):
	for i in holding_c:
		i.global_position = r_lerp_position_hand.get_child(holding_c.find(i)).global_position

func match_face(delta):
	$UpperBody/Line2D/Head.look_at(get_global_mouse_position())
	#$UpperBody/Head.global_rotation = clamp($UpperBody/Head.global_position.angle_to_point(get_global_mouse_position()), -1.0,1.0)
	direction = sign(get_global_mouse_position().x - global_position.x)
	
	$Thigh/RightFeet/RightThigh.scale.y = direction
	$Thigh/LeftFeet/LeftThigh.scale.y = direction
	$UpperBody/Line2D.scale.x = direction
	
	
#region offsets
	#$UpperBody/Line2D.rotation = 0 + (spine_offset.position - global_position).length() * .01
	#$UpperBody/Line2D/OxyTank.rotation = lerp($UpperBody/Line2D/OxyTank.rotation, (-$UpperBody/Line2D.rotation * direction) + 0 + (spine_offset.position - global_position).length() * .05, delta * 12)
	
#endregion
