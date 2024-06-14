extends Node
class_name SpellDeckManager


signal deck_shuffled()

const FIREBALL_SPELL_RES = preload("res://resources/spells/fireball_spell.tres")
const FLARE_SPELL_RES = preload("res://resources/spells/flare_spell.tres")
const WHIRLWIND_SPELL_RES = preload("res://resources/spells/whirlwind_spell.tres")
const TYPHOON_SPELL_RES = preload("res://resources/spells/typhoon_spell.tres")

var base_deck: WeightedTable
var gameplay_deck: WeightedTable
var spells_in_hand: Array[Spell]


func _ready() -> void:
	base_deck = DeckData.create_weighted_table_from_deck()
	gameplay_deck = DeckData.create_weighted_table_from_deck()
	
	GameEvents.upgrade_added.connect(_on_upgrade_added)


func add_spell_to_deck(spell: Spell, deck: WeightedTable = gameplay_deck) -> void:
	if not deck.has(spell):
		deck.add_item(spell, 1)
	else:
		var index := deck.get_item_index(spell)
		var item := deck.items[index]["item"] as Spell
		var weight := deck.items[index]["weight"] as int
		deck.change_item_weight(item, weight + 1)


func draw_spell() -> Spell:
	if gameplay_deck.weight_sum == 0:
		shuffle_deck()
	
	var drawn_card := gameplay_deck.pick_item() as Spell
	
	remove_card_from_deck(drawn_card)
	
	return drawn_card


func remove_card_from_deck(card: Spell) -> void:
	var index := gameplay_deck.get_item_index(card)
	
	var current_weight := gameplay_deck.items[index]["weight"] as int
	var adjusted_weight := current_weight - 1
	
	if adjusted_weight <= 0:
		gameplay_deck.remove_item(card)
	else:
		gameplay_deck.change_item_weight(card, adjusted_weight)


func shuffle_deck() -> void:
	gameplay_deck.items = base_deck.items.duplicate(true)
	
	for spell in spells_in_hand:
		remove_card_from_deck(spell)
	
	gameplay_deck.update_weight_sum()
	deck_shuffled.emit()


func _on_upgrade_added(upgrade: Upgrade, current_upgrades: Dictionary) -> void:
	if upgrade.id == "pyro_cards":
		for i in 1:
			add_spell_to_deck(FIREBALL_SPELL_RES, base_deck)
			add_spell_to_deck(FIREBALL_SPELL_RES)
		for i in 3:
			add_spell_to_deck(FLARE_SPELL_RES, base_deck)
			add_spell_to_deck(FLARE_SPELL_RES)
	
	if upgrade.id == "aero_cards":
		for i in 1:
			add_spell_to_deck(TYPHOON_SPELL_RES, base_deck)
			add_spell_to_deck(TYPHOON_SPELL_RES)
		for i in 3:
			add_spell_to_deck(WHIRLWIND_SPELL_RES, base_deck)
			add_spell_to_deck(WHIRLWIND_SPELL_RES)


