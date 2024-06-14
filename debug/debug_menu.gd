extends Node


@export var experience_manager: ExperienceManager
@export var arena_time_manager: ArenaTimeManager

var hidden := true

@onready var add_one_exp_button := $%AddOneExpButton as Button
@onready var add_one_hundred_exp_button := $%Add100ExpButton as Button
@onready var animation_player := $AnimationPlayer as AnimationPlayer
@onready var kill_player_button := $%KillPlayerButton as Button
@onready var kill_enemies_button := $%KillEnemiesButton as Button
@onready var level_up_button := $%LevelUpButton as Button
@onready var toggle_panel_button := $%TogglePanelButton as Button
@onready var win_game_button := $%WinGameButton as Button


func _ready() -> void:
	add_one_exp_button.pressed.connect(_on_add_one_exp_pressed)
	add_one_hundred_exp_button.pressed.connect(_on_add_one_hundred_exp_pressed)
	level_up_button.pressed.connect(_on_level_up_pressed)
	kill_enemies_button.pressed.connect(_on_kill_enemies_pressed)
	kill_player_button.pressed.connect(_on_kill_player_pressed)
	toggle_panel_button.pressed.connect(_on_toggle_panel_pressed)
	win_game_button.pressed.connect(_on_win_game_pressed)


func _on_add_one_exp_pressed() -> void:
	GameEvents.emit_experience_vial_collected(1)


func _on_add_one_hundred_exp_pressed() -> void:
	GameEvents.emit_experience_vial_collected(100)


func _on_level_up_pressed() -> void:
	var value := experience_manager.target_experience - experience_manager.current_experience
	experience_manager.increment_experience(value)


func _on_kill_enemies_pressed() -> void:
	var active_enemies := get_tree().get_nodes_in_group("enemy")
	for i in active_enemies.size():
		var enemy_health_component := active_enemies[i].health_component as HealthComponent
		if enemy_health_component == null:
			continue
		
		enemy_health_component.damage(enemy_health_component.current_health)


func _on_kill_player_pressed() -> void:
	var player := get_tree().get_first_node_in_group("player") as Player
	if player == null:
		return
	player.health_component.damage(player.health_component.current_health)


func _on_toggle_panel_pressed() -> void:
	if hidden:
		animation_player.play("default")
		hidden = false
	else:
		animation_player.play_backwards("default")
		hidden = true


func _on_win_game_pressed() -> void:
	arena_time_manager.timer.timeout.emit()


