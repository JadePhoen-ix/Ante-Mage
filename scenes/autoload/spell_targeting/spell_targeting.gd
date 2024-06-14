extends Node


func densest_point(params: PhysicsShapeQueryParameters2D, global: bool = false) -> Vector2:
	var enemies := get_tree().get_nodes_in_group("enemy")
	
	var player := get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return Vector2(0, 0)
	
	var adjusted_enemies := enemies.duplicate()
	var most_hits := 0
	var target_point := player.global_position
	for i in enemies.size():
		var enemy := enemies[i] as Enemy
		
		if not global and player.global_position.distance_to(enemy.global_position) > 360:
			continue
		
		if not adjusted_enemies.has(enemy):
			continue
		
		params.transform.origin = enemy.transform.origin
		var hits := get_tree().root.world_2d.direct_space_state.intersect_shape(params)
		if hits.size() > most_hits:
			most_hits = hits.size()
			target_point = enemy.global_position
	
	return target_point


func random_enemy() -> Enemy:
	var enemies := get_tree().get_nodes_in_group("enemy")
	
	if enemies.size() == 0:
		return null
	
	return enemies[randi_range(0, enemies.size() - 1)] as Enemy
