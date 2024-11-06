extends Node2D
@onready var background_shape: Polygon2D = $BackgroundShape
@onready var clip_shape: Polygon2D = $ClipShape/Polygon2D
@onready var intersection_polygon: Polygon2D

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	find_intersect()
	


func find_intersect():
	var new_background_shape = []
	var new_clip_shape = []
	
	
	for i in background_shape.polygon:
		new_background_shape += [to_local(i)]
	for i in clip_shape.polygon:
		i += clip_shape.global_position
		new_clip_shape += [to_local(i)]
		
	print(new_background_shape, "NEW CLIP SHAPE HERE --->", new_clip_shape)
	var intersect_array = Geometry2D.intersect_polygons(new_background_shape, new_clip_shape)
	
	print(intersect_array)
	#for overlapping_polygon in intersect_array:
		#var intersection_polyogn = Polygon2D.new()
		#self.add_child(intersection_polygon)
		#intersection_polygon.set_polygon(overlapping_polygon)
		#intersection_polygon.set_color("green")
		#print("Overlap area: ", intersection_polygon.polygon)
	#self.remove_child(intersection_polygon)
	
