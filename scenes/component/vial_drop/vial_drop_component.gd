extends Node


@export_range(0.0, 1.0, 0.01) var drop_percent := 0.5
@export var health_component: HealthComponent
@export var vial_scene: PackedScene


func _ready() -> void:
	health_component.died.connect(_on_died)
	

func _on_died() -> void:
	var adjusted_drop_percent := drop_percent
	var upgrade_level := MetaProgression.get_upgrade_level("experience_gain")
	if upgrade_level > 0:
		adjusted_drop_percent += 0.1
	
	if randf() >= adjusted_drop_percent:
		return
	
	if vial_scene == null:
		return
	
	if not owner is Node2D:
		return
	
	var spawn_position := (owner as Node2D).global_position
	var vial_instance := vial_scene.instantiate() as Node2D
	var entities_layer := get_tree().get_first_node_in_group("entities_layer") as Node2D
	entities_layer.add_child(vial_instance)
	vial_instance.global_position = spawn_position
