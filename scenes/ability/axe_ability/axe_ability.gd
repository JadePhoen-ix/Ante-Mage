extends Node2D
class_name AxeAbility


const MAX_RADIUS := 100.0

var base_rotation := Vector2.RIGHT

@onready var hitbox_component := $HurtboxComponent as HurtboxComponent


func _ready() -> void:
	base_rotation = Vector2.RIGHT.rotated(randf_range(0.0, TAU))
	
	var player := get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	global_position = player.global_position
	
	var tween := create_tween()
	tween.tween_method(tween_method.bind(player.global_position), 0.0, 2.0, 3.0)
	tween.tween_callback(queue_free)


func tween_method(rotations: float, start_position: Vector2) -> void:
	var percent := rotations / 2.0
	var current_radius := percent * MAX_RADIUS
	var current_direction := base_rotation.rotated(rotations * TAU)
	
	global_position = start_position + (current_direction * current_radius)


