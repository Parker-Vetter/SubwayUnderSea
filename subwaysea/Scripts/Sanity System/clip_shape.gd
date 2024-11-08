extends Node2D



var cat_has_mouse = false
var dragging = false


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	if Input.is_action_pressed("left_mouse") and (cat_has_mouse == true or dragging):
		global_position = lerp(global_position, get_global_mouse_position(), 12 * delta)
	if Input.is_action_just_released("left_mouse"):
		dragging = false


func _on_area_2d_mouse_entered() -> void:
	cat_has_mouse = true


func _on_area_2d_mouse_exited() -> void:
	cat_has_mouse = false
	if Input.is_action_pressed("left_mouse"):
		dragging = true
		
