extends Node
class_name ArenaTimeManager


signal arena_difficulty_increased(arena_difficulty: int)

const INTERVAL_SECONDS := 5

@export var end_screen_scene: PackedScene

var arena_difficulty := 0

@onready var timer := $Timer as Timer


func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)


func _process(delta: float) -> void:
	var next_time_target := timer.wait_time - ((arena_difficulty + 1) * INTERVAL_SECONDS)
	if timer.time_left <= next_time_target:
		arena_difficulty += 1
		arena_difficulty_increased.emit(arena_difficulty)


func get_time_elapsed() -> float:
	return timer.wait_time - timer.time_left


func _on_timer_timeout() -> void:
	var end_screen_instance := end_screen_scene.instantiate() as EndScreen
	add_child(end_screen_instance)
	end_screen_instance.play_jingle()
	MetaProgression.save_game()

