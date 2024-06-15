extends HurtboxComponent
class_name TickHurtboxComponent


signal duration_timeout()

@export_range(0.5, 60.0, 0.1) var duration := 5.0
@export_range(0.5, 10.0, 0.1) var damage_interval := 1.0

var enemies_in_hurtbox: Array[HitboxComponent] = []

@onready var interval_timer := $IntervalTimer as Timer


func _ready() -> void:
	interval_timer.wait_time = damage_interval
	var duration_timer := get_tree().create_timer(duration)
	
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	duration_timer.timeout.connect(_on_duration_timeout)
	interval_timer.timeout.connect(_on_interval_timeout)
	
	interval_timer.start()


func _on_area_entered(area: Area2D) -> void:
	if area is HitboxComponent:
		enemies_in_hurtbox.append(area)


func _on_area_exited(area: Area2D) -> void:
	if area is HitboxComponent:
		enemies_in_hurtbox.erase(area)


func _on_duration_timeout() -> void:
	monitoring = false
	duration_timeout.emit()


func _on_interval_timeout() -> void:
	for i in enemies_in_hurtbox.size():
		var enemy_hurtbox := enemies_in_hurtbox[i]
		enemy_hurtbox.trigger_hit(damage)


