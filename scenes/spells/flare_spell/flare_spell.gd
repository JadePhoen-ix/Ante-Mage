extends Node2D


var flare_count := 0


func _ready() -> void:
	var player := get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		queue_free()
	
	global_position = player.global_position
	
	flare_count = get_child_count()
	for i in flare_count:
		var flare := get_children()[i] as FlareSpellProjectile
		flare.hit_something.connect(_on_flare_hit_something)


func _on_flare_hit_something() -> void:
	flare_count -= 1
	if flare_count == 0:
		queue_free()

