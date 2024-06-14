extends Node


var current_deck: Deck

@onready var demo_deck := $DemoDeck as Deck


func _ready() -> void:
	set_current_deck(demo_deck)


func create_weighted_table_from_deck() -> WeightedTable:
	var deck := WeightedTable.new()
	
	deck.items = current_deck.deck_contents.duplicate(true)
	deck.update_weight_sum()
	
	for i in deck.items.size():
		var dictionary := deck.items[i] as Dictionary
		dictionary["id"] = dictionary["item"].id
	
	return deck


func set_current_deck(deck: Deck) -> void:
	current_deck = deck


