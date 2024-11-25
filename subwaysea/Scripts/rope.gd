extends Node2D

@onready var start = $Tendon
@export var anchor_point : Node2D
var tendons = []
@onready var cord: Line2D = $Cord
@export var rest_length = 10
@export var squeeze_length = 2
@export var tension = 100
const damping = .9

func _ready():
	top_level = true
	
	for i in get_children():
		if i is CharacterBody2D: 
			i.global_position = global_position
			tendons += [i]
	



func _process(delta):
	#anchor_point.global_position = get_global_mouse_position()
	#start.velocity = (anchor_point.global_position -  start.global_position) * 300 * delta
	start.global_position = anchor_point.global_position
	return
	start.velocity = (get_global_mouse_position() -  start.global_position) * 12

func _physics_process(delta):
	tendon_puller(delta)
	tendon_tender(delta)
	#if Input.is_action_just_pressed("actionTwo"):
		#tendons.back().velocity -= (get_global_mouse_position() - tendons.back().global_position).normalized() * 2000
		#rest_length = 50
		#tension = 100
	#if Input.is_action_pressed("actionOne"):
		#rest_length -= delta * 55
		#tension += 5
func tendon_puller(delta):
	for i in tendons:
		if i != tendons[0]:
			var distance = i.global_position - tendons[tendons.find(i) - 1].global_position
			if distance.length() > rest_length or distance.length() < squeeze_length:
				tendons[tendons.find(i) - 1].velocity += distance * delta * tension + Vector2(0,9)
				var dist_mult = (distance - (Vector2(rest_length, rest_length) * distance.normalized())) #somehow gives more weight to the end
				i.velocity -= distance * delta * tension
			#i.velocity += Vector2(0,9.8)
			i.velocity *= damping

func tendon_tender(delta):
	for i in cord.points.size():
		cord.set_point_position(i, tendons[i].position)
		tendons.back().velocity -= tendons.back().global_position - $End.global_position 
	
func tendon_launch(amount):
	tendons.back().velocity -= (get_global_mouse_position() - tendons.back().global_position).normalized()
	
func push(pos : Vector2, direction : Vector2):
	var closest_point = tendons[0]
	for i in tendons:
		if pos.distance_to(i.global_position) < pos.distance_to(closest_point.global_position):
			closest_point = i 
	closest_point.hurt(direction, 1)
	
#get closest point then push off of that
