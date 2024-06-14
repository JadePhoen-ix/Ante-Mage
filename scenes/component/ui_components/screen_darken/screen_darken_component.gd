extends ColorRect
class_name ScreenDarkenComponent


@onready var animation_player := $AnimationPlayer as AnimationPlayer


func play_out() -> void:
	animation_player.play_backwards("default")


