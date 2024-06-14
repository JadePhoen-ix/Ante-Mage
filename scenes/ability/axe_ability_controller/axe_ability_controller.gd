extends Node


@export var axe_ability_scene: PackedScene
@export var base_damage := 10

var base_wait_time: float
var damage_modifier := 1.0

@onready var timer := $Timer as Timer


func _ready() -> void:
	base_wait_time = timer.wait_time
	timer.timeout.connect(_on_timer_timeout)
	timer.timeout.emit()
	GameEvents.upgrade_added.connect(_on_ability_upgrade_added)


func _on_ability_upgrade_added(upgrade: Upgrade, current_upgrades: Dictionary) -> void:
	if upgrade.id == "axe_rate":
		var percent_reduction := (current_upgrades["axe_rate"]["level"] * 0.1) as float
		timer.wait_time = maxf(base_wait_time * (1 - percent_reduction), 0.05)
		timer.start()
	elif upgrade.id == "axe_damage":
		damage_modifier = 1.0 + (current_upgrades["axe_damage"]["level"] * 0.111)


func _on_timer_timeout() -> void:
	var foreground := get_tree().get_first_node_in_group("foreground_layer") as Node2D
	if foreground == null:
		return
	
	var axe_instance := axe_ability_scene.instantiate() as AxeAbility
	foreground.add_child(axe_instance)
	axe_instance.hitbox_component.damage = base_damage * damage_modifier


