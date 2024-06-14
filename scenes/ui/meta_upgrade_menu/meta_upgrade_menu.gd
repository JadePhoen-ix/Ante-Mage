extends CanvasLayer


const META_UPGRADE_CARD_SCENE := preload("res://scenes/ui/meta_upgrade_card/meta_upgrade_card.tscn")

@export var upgrades: Array[MetaUpgrade] = []

@onready var grid_container := $%GridContainer as GridContainer
@onready var main_menu_button := $%MainMenuButton as Button


func _ready() -> void:
	for child in grid_container.get_children():
		child.queue_free()
	
	for upgrade in upgrades:
		var upgrade_card_instance := META_UPGRADE_CARD_SCENE.instantiate() as MetaUpgradeCard
		grid_container.add_child(upgrade_card_instance)
		upgrade_card_instance.set_meta_upgrade(upgrade)
	
	main_menu_button.pressed.connect(_on_main_menu_pressed)


func _on_main_menu_pressed() -> void:
	ScreenTransition.transition_to_scene("res://scenes/ui/main_menu/main_menu.tscn")


