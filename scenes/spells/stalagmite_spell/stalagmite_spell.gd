extends Node2D


const SPELL_FX_SCENE := preload("res://scenes/spells/stalagmite_spell/stalagmite_spell_fx.tscn")

@export var number_of_targets := 4
@export var spell_damage := 7.0


func _ready() -> void:
	var targets: Array[Enemy] = []
	var active_enemies := get_tree().get_nodes_in_group("enemy")
	
	for i in mini(number_of_targets, active_enemies.size()):
		var new_target := SpellTargeting.random_enemy() as Enemy
		while targets.has(new_target):
			new_target = SpellTargeting.random_enemy()
		
		targets.append(new_target)
	
	var foreground := get_tree().get_first_node_in_group("foreground_layer") as Node2D
	if foreground == null:
		return
	
	for i in targets.size():
		var next_target := targets[i]
		
		var sfx_instance := SPELL_FX_SCENE.instantiate() as StalagmiteSpellFX
		foreground.add_child(sfx_instance)
		
		sfx_instance.global_position = next_target.global_position
		sfx_instance.target = next_target
		sfx_instance.damage = spell_damage
	
	queue_free()



