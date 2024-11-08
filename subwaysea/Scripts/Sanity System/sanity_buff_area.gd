extends Area2D
@onready var sanity_buff_area: Area2D = $"."
@onready var sanity_debuff_area: Area2D = $"."
@onready var player: RigidBody2D = $"../Player"

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	var overlapping_bodies_list = get_overlapping_bodies()
	for body in overlapping_bodies_list:
		if body == player:
			pass
