extends Node
class_name ExperienceManager


signal experience_updated(current_experience: int, target_experience: int)
signal leveled_up(new_level: int)

@export var target_experience := 5
@export var target_experience_growth := 5

var current_experience := 0
var current_level := 1


func _ready() -> void:
	GameEvents.experience_vial_collected.connect(_on_experience_vial_collected)
	GameEvents.upgrade_added.connect(_on_upgrade_added)


func check_experience() -> void:
	if current_experience >= target_experience:
		current_level += 1
		current_experience -= target_experience
		target_experience += target_experience_growth
		experience_updated.emit(current_experience, target_experience)
		leveled_up.emit(current_level)


func increment_experience(value: int) -> void:
	current_experience = current_experience + value
	experience_updated.emit(current_experience, target_experience)
	
	check_experience()


func _on_experience_vial_collected(value: int) -> void:
	increment_experience(value)


func _on_upgrade_added(upgrade: Upgrade, current_upgrades: Dictionary) -> void:
	await get_tree().create_timer(0.4).timeout
	check_experience()
