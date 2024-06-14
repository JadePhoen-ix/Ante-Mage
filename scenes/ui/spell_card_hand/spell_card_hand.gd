extends CanvasLayer


const SPELL_CARD_PATH := preload("res://scenes/ui/spell_card/spell_card.tscn")

@export var deck_manager: SpellDeckManager
@export_range(0.0, 10.0, 0.25) var draw_time := 2.0
@export_group("Hand Appearance")
@export var spread_curve: Curve
@export var height_curve: Curve
@export var rotation_curve: Curve
@export var max_width := 180.0
@export_range(0.0, 20.0, 0.01) var draw_interval := 3.0
@export_group("Debug")
@export var update: bool:
	set(value):
		update = false
		update_hand()
@export var add_card: bool:
	set(value):
		add_card = false
		add_card_to_hand(null)

var hand_width := 30.0
var hand_height := 2.0
var hand_rotation := -0.036
var spells_in_hand: Array[Spell] = []

@onready var animation_player := $AnimationPlayer as AnimationPlayer
@onready var card_holder := $%CardHolder as Node2D
@onready var description_label := %DescriptionLabel as Label


func _ready() -> void:
	for child in card_holder.get_children():
		child.free()
	
	await get_tree().physics_frame
	
	for i in 5:
		add_card_to_hand(deck_manager.draw_spell())


func add_card_to_hand(spell: Spell) -> void:
	if spell == null:
		return
	
	var card_instance := SPELL_CARD_PATH.instantiate() as SpellCard
	card_holder.add_child(card_instance)
	
	card_instance.spell_card_selected.connect(_on_spell_card_selected.bind(spell))
	card_instance.visuals_container.mouse_entered.connect(_on_mouse_entered_card.bind(spell))
	card_instance.visuals_container.mouse_exited.connect(_on_mouse_exited_card)
	
	card_instance.set_spell(spell)
	
	spells_in_hand.append(spell)
	deck_manager.spells_in_hand = spells_in_hand
	
	update_hand()


func draw_card() -> void:
	await get_tree().create_timer(draw_time).timeout
	
	add_card_to_hand(deck_manager.draw_spell())
	update_hand()


func update_hand() -> void:
	var cards_in_hand := card_holder.get_child_count()
	if cards_in_hand == 0:
		return
	
	for card in card_holder.get_children():
		var hand_ratio := 0.5
		
		if cards_in_hand > 1:
			var index := card.get_index()
			var count := float(cards_in_hand - 1)
			hand_ratio = index / count
		
		var adjusted_width := minf(hand_width * cards_in_hand, max_width)
		var adjusted_height := hand_height * cards_in_hand
		var global_position := card_holder.global_position
		
		var target_x = global_position.x + spread_curve.sample(hand_ratio) * adjusted_width
		var target_y = global_position.y - height_curve.sample(hand_ratio) * adjusted_height
		
		card.global_position = Vector2(target_x, target_y)
		card.rotation = rotation_curve.sample(hand_ratio) * (hand_rotation * cards_in_hand)


func show_description(spell: Spell) -> void:
	description_label.text = spell.description
	animation_player.stop()
	animation_player.play("description_default")


func hide_description() -> void:
	animation_player.play_backwards("description_default")


func _on_spell_card_selected(spell: Spell) -> void:
	await get_tree().physics_frame
	
	spells_in_hand.erase(spell)
	deck_manager.spells_in_hand = spells_in_hand
	
	GameEvents.emit_spell_cast(spell)
	
	update_hand()
	
	draw_card()


func _on_mouse_entered_card(spell: Spell) -> void:
	show_description(spell)


func _on_mouse_exited_card() -> void:
	hide_description()

