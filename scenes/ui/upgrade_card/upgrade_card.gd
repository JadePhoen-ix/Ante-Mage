extends PanelContainer
class_name UpgradeCard


signal upgrade_card_selected

var disabled := false

@onready var animation_player := $AnimationPlayer as AnimationPlayer
@onready var hover_animation_player := $HoverAnimationPlayer as AnimationPlayer 
@onready var name_label := $%NameLabel as Label
@onready var description_label := $%DescriptionLabel as Label


func _ready() -> void:
	gui_input.connect(_on_gui_input)
	mouse_entered.connect(_on_mouse_entered)


func play_in(delay := 0.0) -> void:
	modulate = Color.TRANSPARENT
	await get_tree().create_timer(delay).timeout
	animation_player.play("in")


func play_discard() -> void:
	animation_player.play("discard")


func select_card() -> void:
	disabled = true
	animation_player.play("selected")
	
	var other_cards := get_tree().get_nodes_in_group("upgrade_card")
	for i in other_cards.size():
		var other_card := other_cards[i] as UpgradeCard
		if other_card == self:
			continue
		other_card.play_discard()
	
	await animation_player.animation_finished
	upgrade_card_selected.emit()


func set_upgrade(upgrade: Upgrade) -> void:
	name_label.text = upgrade.name
	description_label.text = upgrade.description


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


