extends Node2D
class_name SpellCard


signal spell_card_selected()

var disabled := false

@onready var animation_player := $AnimationPlayer as AnimationPlayer
@onready var hover_animation_player := $HoverAnimationPlayer as AnimationPlayer 
@onready var name_label := $%NameLabel as Label
@onready var visuals_container := $VisualsContainer as PanelContainer 
@onready var spell_texture_rect := %SpellTextureRect as TextureRect 


func _ready() -> void:
	visuals_container.gui_input.connect(_on_gui_input)
	visuals_container.mouse_entered.connect(_on_mouse_entered)
	visuals_container.mouse_exited.connect(_on_mouse_exited)


func play_in(delay := 0.0) -> void:
	modulate = Color.TRANSPARENT
	await get_tree().create_timer(delay).timeout
	animation_player.play("in")


func select_card() -> void:
	disabled = true
	animation_player.play("selected")
	
	await animation_player.animation_finished
	spell_card_selected.emit()
	queue_free()


func set_spell(spell: Spell) -> void:
	name_label.text = spell.name
	spell_texture_rect.texture = spell.spell_image


func _on_gui_input(event: InputEvent) -> void:
	if disabled:
		return
	
	if event.is_action_pressed("left_click"):
		select_card()


func _on_mouse_entered() -> void:
	if disabled:
		return
	
	hover_animation_player.stop()
	hover_animation_player.play("hover")


func _on_mouse_exited() -> void:
	visuals_container.z_index = 0
	hover_animation_player.stop()
	hover_animation_player.play("return")

