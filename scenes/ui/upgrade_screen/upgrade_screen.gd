extends CanvasLayer
class_name UpgradeScreen


signal upgrade_selected(upgrade: Upgrade)

@export var upgrade_card_scene: PackedScene

@onready var card_container := $%CardContainer as HBoxContainer
@onready var screen_darken_component := $ScreenDarkenComponent as ScreenDarkenComponent


func _ready() -> void:
	get_tree().paused = true


func set_ability_upgrades(upgrades: Array[Upgrade]) -> void:
	var delay := 0.0
	for upgrade in upgrades:
		var card_instance := upgrade_card_scene.instantiate() as UpgradeCard
		
		card_container.add_child(card_instance)
		card_instance.set_upgrade(upgrade)
		card_instance.play_in(delay)
		delay += 0.2
		
		card_instance.upgrade_card_selected.connect(_on_upgrade_card_selected.bind(upgrade))


func _on_upgrade_card_selected(upgrade: Upgrade) -> void:
	upgrade_selected.emit(upgrade)
	screen_darken_component.play_out()
	
	await screen_darken_component.animation_player.animation_finished
	
	get_tree().paused = false
	queue_free()


