extends Node


func _ready() -> void:
	GameEvents.spell_cast.connect(_on_spell_cast)


func _on_spell_cast(spell: Spell):
	var foreground := get_tree().get_first_node_in_group("foreground_layer") as Node2D
	if foreground == null:
		return
	
	var spell_instance := spell.spell_scene.instantiate() as Node2D
	foreground.add_child(spell_instance)

