extends CanvasLayer
class_name EndScreen


@onready var description_label := $%DescriptionLabel as Label
@onready var end_screen_panel_container := $%EndScreenPanelContainer as PanelContainer
@onready var restart_button := $%RestartButton as Button
@onready var main_menu_button := %MainMenuButton as Button
@onready var quit_button := $%QuitButton as Button
@onready var title_label := $%TitleLabel as Label
@onready var victory_stream_player := $VictoryStreamPlayer as AudioStreamPlayer 
@onready var defeat_stream_player := $DefeatStreamPlayer as AudioStreamPlayer 


func _ready() -> void:
	end_screen_panel_container.pivot_offset = end_screen_panel_container.size / 2.0
	
	var tween := create_tween()
	tween.tween_property(end_screen_panel_container, "scale", Vector2.ZERO, 0.0)
	tween.tween_property(end_screen_panel_container, "scale", Vector2.ONE, 0.3)\
			.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	
	get_tree().paused = true
	
	restart_button.pressed.connect(_on_restart_button_pressed)
	main_menu_button.pressed.connect(_on_main_menu_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)


func set_defeat() -> void:
	title_label.text = "Defeat"
	description_label.text = "You are slain."
	play_jingle(true)


func play_jingle(defeat := false) -> void:
	if defeat:
		defeat_stream_player.play()
	else:
		victory_stream_player.play()


func _on_restart_button_pressed() -> void:
	ScreenTransition.transition_to_scene("res://scenes/main/main.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_main_menu_pressed() -> void:
	ScreenTransition.transition_to_scene("res://scenes/ui/main_menu/main_menu.tscn")
