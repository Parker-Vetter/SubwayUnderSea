extends Node2D

@onready var oxygen_system: Node2D = $"../OxygenSystem"

signal oxygen_multiplier_changed(new_multiplier)

var in_buff_area
var in_debuff_area
var sanity = 0.0

func _process(delta: float) -> void:
	passive_sanity_loss()
	
	if in_buff_area:
		add_sanity()
	if in_debuff_area:
		remove_sanity()
		
	calculate_multiplier()


func add_sanity():
	sanity += 0.1

func remove_sanity():
	sanity -= 0.1

func passive_sanity_loss():
	sanity -= 0.01
	sanity = clamp(sanity, 0, 70)

func calculate_multiplier():
		var multiplier = 1 - sanity/70
		multiplier = clamp(multiplier, 0.1, 1)
		oxygen_multiplier_changed.emit(multiplier)


func _on_sanity_debuff_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		in_debuff_area = true


func _on_sanity_debuff_area_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		in_debuff_area = false


func _on_sanity_buff_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		in_buff_area = true


func _on_sanity_buff_area_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		in_buff_area = false


func _on_cat_photo_sanity_changed(new_sanity: Variant) -> void:
	sanity += 0.1 * new_sanity
