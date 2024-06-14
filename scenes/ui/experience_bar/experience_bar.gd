extends CanvasLayer


@export var experience_manager: ExperienceManager

@onready var progress_bar := $%ProgressBar as ProgressBar


func _ready() -> void:
	progress_bar.value = 0
	experience_manager.experience_updated.connect(_on_experience_updated)


func _on_experience_updated(current: float, target: float) -> void:
	var percent: float = current / target
	progress_bar.value = percent


