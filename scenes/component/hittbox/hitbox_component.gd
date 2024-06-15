extends Area2D
class_name HitboxComponent


signal hit()

const FLOATING_TEXT_SCENE := preload("res://scenes/ui/floating_text/floating_text.tscn")

@export var health_component: HealthComponent


func _ready() -> void:
	area_entered.connect(_on_area_entered)


func trigger_hit(damage: float):
	if health_component == null:
		return
	
	if damage <= 0.0:
		return
	
	health_component.damage(damage)
	
	var floating_text := FLOATING_TEXT_SCENE.instantiate() as Node2D
	get_tree().get_first_node_in_group("foreground_layer").add_child(floating_text)
	
	floating_text.global_position = global_position + (Vector2.UP * 16.0)
	
	var format_string := "%0.0f"
	floating_text.start(format_string % damage)
	
	hit.emit()


func _on_area_entered(other_area: Area2D) -> void:
	if not other_area is HurtboxComponent:
		return
	
	trigger_hit(other_area.damage)
