extends Area2D


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	var overlapping_bodies_list = get_overlapping_bodies()
	for body in overlapping_bodies_list:
		if body.has_method("change_sanity"):
			# access function in player code to change sanity value
			body.change_sanity(-0.1)
