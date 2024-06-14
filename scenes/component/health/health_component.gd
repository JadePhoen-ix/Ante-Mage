extends Node
class_name HealthComponent


signal died()
signal health_changed()

@export var max_health := 10.0

var current_health: float


func _ready() -> void:
	current_health = max_health


func damage(value: float) -> void:
	current_health = maxf(current_health - value, 0.0)
	health_changed.emit()
	if current_health == 0:
		check_death.call_deferred()


func get_health_percent() -> float:
	if current_health <= 0.0:
		return 0.0
	return minf(current_health / max_health, 1.0)


func check_death() -> void:
	died.emit()
	owner.queue_free()
