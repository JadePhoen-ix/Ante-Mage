extends Node2D


func _ready() -> void:
	var hit_box_shape := PhysicsServer2D.capsule_shape_create()
	var data := Vector2(80.0, 280.0)
	PhysicsServer2D.shape_set_data(hit_box_shape, data)
	
	var params = create_params(hit_box_shape)
	
	global_position = SpellTargeting.densest_point(params)
	
	PhysicsServer2D.free_rid(hit_box_shape)


func create_params(shape_rid: RID) -> PhysicsShapeQueryParameters2D:
	var params := PhysicsShapeQueryParameters2D.new()
	
	params.shape_rid = shape_rid
	params.collide_with_bodies = true
	params.collision_mask = 1 << 3
	params.transform = Transform2D(90.0, Vector2.ZERO)
	
	return params


