@tool
extends Node
class_name Deck

@export_group("Deck Builder")
@export var spell: Spell
@export var amount: int
@export var add_spell: bool:
	set(value):
		add_spell = false
		deck_contents.append({ "item": spell, "weight": amount })
@export var deck_contents: Array[Dictionary]


