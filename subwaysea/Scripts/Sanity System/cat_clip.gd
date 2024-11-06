extends Node2D
@onready var dummy_player: CharacterBody2D = $DummyPlayer


var cat_has_mouse = false
var dragging = false


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	if Input.is_action_pressed("left_mouse_button") and (cat_has_mouse or dragging):
		global_position = lerp(global_position, get_global_mouse_position(), 12 * delta)
	if Input.is_action_just_released("left_mouse_button"):
		dragging = false
	
	#if (cat_has_mouse or dragging) and Input.is_action_pressed("left_mouse_button"):
		#dummy_player.change_sanity(0.2)


func _on_area_2d_mouse_entered() -> void:
	cat_has_mouse = true


func _on_area_2d_mouse_exited() -> void:
	cat_has_mouse = false
	if Input.is_action_pressed("left_mouse_button"):
		dragging = true
		
