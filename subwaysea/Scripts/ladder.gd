extends Node2D

@onready var path_2d: Path2D = $Path2D
@onready var path_follow_2d: PathFollow2D = $Path2D/PathFollow2D

@onready var top_of_ladder: Area2D = $TopOfLadder
@onready var bottom_of_ladder: Area2D = $BottomOfLadder

@onready var player : RigidBody2D = get_tree().get_first_node_in_group('player')

var enabled = false
#go based on progress

func _physics_process(delta: float) -> void:
	if enabled:
		$Floor/CollisionShape2D.disabled = true
		var v = Input.get_axis("down", 'up')
		path_follow_2d.progress_ratio += -v * delta * .5
		player.apply_central_force((path_follow_2d.global_position - player.global_position) * 100)
		
		
		
		if path_follow_2d.progress_ratio <= .1 or path_follow_2d.progress_ratio >= .9:
			enabled = false
			player.set_state_stand()
	else:
		$Floor/CollisionShape2D.disabled = false
		
		if Input.is_action_just_pressed('up') and bottom_of_ladder.has_overlapping_bodies():
			enabled = true
			player.set_state_cutscene()
			path_follow_2d.progress_ratio = .8
		
		if Input.is_action_just_pressed('down') and top_of_ladder.has_overlapping_bodies():
			enabled = true
			player.set_state_cutscene()
			path_follow_2d.progress_ratio = .2
		
