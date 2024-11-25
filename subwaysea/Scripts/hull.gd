extends StaticBody2D

@onready var collision_shape_2d: CollisionPolygon2D = $CollisionShape2D
@onready var light_occluder_2d: LightOccluder2D = $CollisionShape2D/LightOccluder2D
@onready var visual_polygon: Polygon2D = $CollisionShape2D/Polygon2D

@onready var smash_points = get_tree().get_nodes_in_group('smash_point')

func _process(delta: float) -> void:

	visual_polygon.set_deferred('polygon', collision_shape_2d.polygon)
	light_occluder_2d.occluder.set_deferred('polygon', collision_shape_2d.polygon)


func was_attacked(rand_val):
	if smash_points.size() <= 0:
		return
	var new_dent = smash_points.pick_random()
	smash_points[smash_points.find(new_dent)].play()
	var angle_to_center = new_dent.polygon[0].angle_to_point(Vector2(1000,1000))
	Camera.add_trauma(1, Vector2.ONE.rotated(angle_to_center))
	
	smash_points.erase(new_dent)
	
	var new_shape = Geometry2D.merge_polygons(collision_shape_2d.polygon, new_dent.polygon)
	
	collision_shape_2d.set_deferred('polygon', new_shape[0])

#perhchance have an interpolated middle ground half way?, like maybe a shape thats half as smaller for visuals
