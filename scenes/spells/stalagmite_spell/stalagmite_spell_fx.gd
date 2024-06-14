extends Node2D
class_name StalagmiteSpellFX


var target: Enemy
var damage: float


func damage_target() -> void:
	if target == null:
		return
	target.hurtbox_component.trigger_hit(damage)
