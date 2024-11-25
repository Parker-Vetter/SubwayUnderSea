extends RigidBody2D

@onready var detect_player: Area2D = $DetectPlayer
@onready var detect_machine: Area2D = $DetectMachine

@onready var player = get_tree().get_first_node_in_group('player')
var hit = false
func _process(delta: float) -> void:
	if Input.is_action_just_pressed('interact') and detect_player.overlaps_body(player) and detect_player.get_overlapping_bodies()[0].holding_c == []:
		detect_player.get_overlapping_bodies()[0].holding_c += [self]
		detect_player.get_overlapping_bodies()[0].bump_hand()
		freeze = true
		$Grab.play()
		$CollisionShape2D.disabled = true


	if detect_machine.has_overlapping_bodies():
		if detect_machine.get_overlapping_bodies()[0].has_method('repair'):
			# if I forgot to move the Load method to the @onready function please do that becuase we dont want to load it each time we call this
			if detect_machine.get_overlapping_bodies()[0].find_child("Sprite2D").texture == load("res://assets/Light Machine OFF.png") or detect_machine.get_overlapping_bodies()[0].find_child("Sprite2D").texture == load("res://assets/Engine OFF.png") or detect_machine.get_overlapping_bodies()[0].find_child("Sprite2D").texture == load("res://assets/oxy_broken.png"):
				detect_machine.get_overlapping_bodies()[0].repair()
				die()
	
	if !hit and get_contact_count() == 1:
		hit = true
		$AudioStreamPlayer2D.play()
		
func die():
	#play animation
	detect_player.get_overlapping_bodies()[0].holding_c.erase(self)
	freeze = false
	await get_tree().create_timer(0.5).timeout
	queue_free()
	
