extends CharacterBody2D

#has x
var oldx : Vector2
var a #force accumulators

func _physics_process(delta):
	move_and_slide()
	

func hurt(direction : Vector2, amount):
	velocity += direction
