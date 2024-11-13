extends Node2D

@onready var background_shape: Polygon2D = $CanvasLayer/BackgroundShape
@onready var clip_shape: Polygon2D = $Polygon2D

var cat_has_mouse = false
var dragging = false
var intersect_array = []
var intersect_area = 0
var total_area = 49152
var sanity = 0

signal sanity_changed(new_sanity)

func _process(delta: float) -> void:
	
	if Input.is_action_pressed("left_mouse") and (cat_has_mouse == true or dragging):
		global_position = lerp(global_position, get_global_mouse_position(), 12 * delta)
	if Input.is_action_just_released("left_mouse"):
		dragging = false
	
	find_intersect()
	sanity = clamp(intersect_area / total_area, 0, 1)
	sanity_changed.emit(sanity)


func find_intersect():
	var new_background_shape = []
	var new_clip_shape = []
	
	for i in background_shape.polygon:
		new_background_shape += [to_local(i)]
	for i in clip_shape.polygon:
		i += clip_shape.global_position
		new_clip_shape += [to_local(i)]
		
	intersect_array = Geometry2D.intersect_polygons(new_background_shape, new_clip_shape)
	#return intersect_array
	for vector in intersect_array:
		calculate_area(vector)


# DO NOT ASK ME HOW THIS WORKS
func calculate_area(mesh_vertices: PackedVector2Array):
	var result := 0.0
	var num_vertices := mesh_vertices.size()
	
	for q in range(num_vertices):
		var p = (q - 1 + num_vertices) % num_vertices
		result += mesh_vertices[q].cross(mesh_vertices[p])
		
	intersect_area = abs(result) * 0.5


func move_cat_photo(delta):
	if Input.is_action_pressed("left_mouse") and (cat_has_mouse == true or dragging):
		global_position = lerp(global_position, get_global_mouse_position(), 12 * delta)
		find_intersect()
	if Input.is_action_just_released("left_mouse"):
		dragging = false


func _on_area_2d_mouse_entered() -> void:
	cat_has_mouse = true


func _on_area_2d_mouse_exited() -> void:
	cat_has_mouse = false
	if Input.is_action_pressed("left_mouse"):
		dragging = true
