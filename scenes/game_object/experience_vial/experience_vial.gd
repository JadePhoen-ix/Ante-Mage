extends Node2D


@onready var collision_shape := $Area2D/CollisionShape2D as CollisionShape2D 
@onready var random_audio_component := $RandomAudioComponent2D as RandomAudioComponent2D
@onready var sprite := $Sprite2D as Sprite2D



func _ready() -> void:
	($Area2D as Area2D).area_entered.connect(_on_area_entered)


func tween_collect(percent: float, start_position: Vector2) -> void:
	var player := get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	global_position = start_position.lerp(player.global_position, percent)
	var direction_from_start := player.global_position - start_position
	
	var target_rotation := direction_from_start.angle() + deg_to_rad(90.0)
	var weight := 1 - exp(-2 * get_process_delta_time())
	rotation = lerp_angle(rotation, target_rotation, weight)


func collect():
	GameEvents.emit_experience_vial_collected(1)
	
	random_audio_component.play_random()
	await random_audio_component.finished
	
	queue_free()


func disable_collision() -> void:
	collision_shape.disabled = true


func _on_area_entered(other_area: Area2D) -> void:
	disable_collision.call_deferred()
	
	var tween := create_tween()
	tween.set_parallel()
	
	tween.tween_method(tween_collect.bind(global_position), 0.0, 1.0, 0.5)\
			.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	
	tween.tween_property(sprite, "scale", Vector2.ZERO, 0.1).set_delay(0.4)
	
	tween.chain()
	tween.tween_callback(collect)



