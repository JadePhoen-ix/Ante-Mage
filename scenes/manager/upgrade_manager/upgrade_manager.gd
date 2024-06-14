extends Node


const UPGRADE_MOVE_SPEED := preload("res://resources/upgrades/move_speed.tres")
const UPGRADE_PYRO_CARDS := preload("res://resources/upgrades/pyro_cards.tres")
const UPGRADE_AERO_CARDS := preload("res://resources/upgrades/aero_cards.tres")

@export var experience_manager: ExperienceManager
@export var upgrade_screen_scene: PackedScene

var current_upgrades := {}
var upgrade_pool := WeightedTable.new()


func _ready() -> void:
	upgrade_pool.add_item(UPGRADE_MOVE_SPEED, 10)
	upgrade_pool.add_item(UPGRADE_PYRO_CARDS, 5)
	upgrade_pool.add_item(UPGRADE_AERO_CARDS, 5)
	
	experience_manager.leveled_up.connect(_on_leveled_up)


func apply_upgrade(upgrade: Upgrade) -> void:
	var has_upgrade := current_upgrades.has(upgrade.id)
	if not has_upgrade:
		current_upgrades[upgrade.id] = {
				"resource": upgrade,
				"level": 1
		}
	else:
		current_upgrades[upgrade.id]["level"] += 1
	
	if upgrade.max_level > 0:
		var current_upgrade_level := current_upgrades[upgrade.id]["level"] as int
		if current_upgrade_level == upgrade.max_level:
			upgrade_pool.remove_item(upgrade)
	
	GameEvents.emit_upgrade_added(upgrade, current_upgrades)


func pick_upgrades() -> Array[Upgrade]:
	var chosen_upgrades: Array[Upgrade] = []
	
	for i in mini(3, upgrade_pool.size):
		var chosen_upgrade := upgrade_pool.pick_item(chosen_upgrades) as Upgrade
		chosen_upgrades.append(chosen_upgrade)
	
	return chosen_upgrades


func _on_leveled_up(current_level: int) -> void:
	var chosen_upgrades := pick_upgrades()
	if chosen_upgrades.size() == 0:
		return
	
	var upgrade_screen_instance := upgrade_screen_scene.instantiate() as UpgradeScreen
	add_child(upgrade_screen_instance)
	
	upgrade_screen_instance.set_ability_upgrades(chosen_upgrades)
	upgrade_screen_instance.upgrade_selected.connect(_on_upgrade_selected)


func _on_upgrade_selected(upgrade: Upgrade) -> void:
	apply_upgrade(upgrade)


