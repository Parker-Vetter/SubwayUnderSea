extends Node2D
@onready var background_shape: Polygon2D = $BackgroundShape
@onready var clip_shape: Polygon2D = $ClipShape/Polygon2D
@onready var overlap_shape: Polygon2D = $Polygon2D


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	var new_background_shape = []
	var new_clip_shape = []
	
	for i in background_shape.polygon:
		new_background_shape += [to_local(i)]
	for i in clip_shape.polygon:
		i += clip_shape.global_position
		new_clip_shape += [to_local(i)]
		
	var intersect_array = Geometry2D.intersect_polygons(new_background_shape, new_clip_shape)
	
	for vector in intersect_array:
		var area = calculate_area(vector)
		print(area)


func calculate_area(mesh_vertices: PackedVector2Array) -> float:
	var result := 0.0
	var num_vertices := mesh_vertices.size()
	
	for q in range(num_vertices):
		var p = (q - 1 + num_vertices) % num_vertices
		result += mesh_vertices[q].cross(mesh_vertices[p])
		
	return abs(result) * 0.5
