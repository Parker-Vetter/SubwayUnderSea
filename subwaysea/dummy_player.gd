extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var sanity = 0

func _physics_process(delta: float) -> void:
	# slowly decrease sanity
	sanity -= 0.01
	sanity = max(sanity, -50)
	print("Sanity: ", sanity)
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()

func change_sanity(_sanity_value):
	# sanity will change faster/slower depending on how many debuff/buff areas it is in
	sanity += _sanity_value
	sanity = clamp(sanity, -50, 20.01)
