extends Node


@export var end_screen_scene: PackedScene

@onready var player := $%Player as Player


func _ready() -> void:
	player.health_component.died.connect(_on_player_died)


func _on_player_died() -> void:
	var end_screen_instance := end_screen_scene.instantiate() as EndScreen
	add_child(end_screen_instance)
	end_screen_instance.set_defeat()
	MetaProgression.save_game()


