extends Node


const MAX_RANGE := 125

@export var sword_ability: PackedScene
@export var base_damage := 5

var base_wait_time: float
var damage_modifier := 1.0
var player: Node2D

@onready var timer := $Timer as Timer


func _ready() -> void:
	base_wait_time = timer.wait_time
	timer.timeout.connect(_on_timer_timeout)
	timer.timeout.emit()
	GameEvents.upgrade_added.connect(_on_ability_upgrade_added)


func enemy_range_filter(enemy: Node2D) -> bool:
	return enemy.global_position.distance_squared_to(player.global_position) < pow(MAX_RANGE, 2)


func enemy_sort(a: Node2D, b: Node2D) -> bool:
	var a_distance := a.global_position.distance_squared_to(player.global_position)
	var b_distance := b.global_position.distance_squared_to(player.global_position)
	return a_distance < b_distance


func _on_ability_upgrade_added(upgrade: Upgrade, current_upgrades: Dictionary) -> void:
	if upgrade.id == "sword_rate":
		var percent_reduction := (current_upgrades["sword_rate"]["level"] * 0.1) as float
		timer.wait_time = maxf(base_wait_time * (1 - percent_reduction), 0.05)
		timer.start()
	elif upgrade.id == "sword_damage":
		damage_modifier = 1.0 + (current_upgrades["sword_damage"]["level"] * 0.15)


func _on_timer_timeout() -> void:
	player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	var foreground_layer := get_tree().get_first_node_in_group("foreground_layer") as Node2D
	if foreground_layer == null:
		return
	
	var enemies := get_tree().get_nodes_in_group("enemy") as Array[Node]
	enemies = enemies.filter(enemy_range_filter)
	if enemies.size() == 0:
		return
	
	enemies.sort_custom(enemy_sort)
	var enemy := enemies[0] as Node2D
	
	var sword_instance := sword_ability.instantiate() as SwordAbility
	foreground_layer.add_child(sword_instance)
	
	sword_instance.hitbox_component.damage = base_damage * damage_modifier
	
	sword_instance.global_position = enemy.global_position
	sword_instance.global_position += Vector2.RIGHT.rotated(randf_range(0, TAU)) * 4
	
	var enemy_direction := (enemy.global_position - sword_instance.global_position) as Vector2
	sword_instance.rotation = enemy_direction.angle()


