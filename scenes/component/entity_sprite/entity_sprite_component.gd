extends Sprite2D
# THIS ENTIRE SCRIPT EXISTS TO OPTIMISE THE HIT FLASH FOR WEB
# ON WINDOWS THIS IS UNNECASSARY BUT MAY STILL BE USEFUL

@export var health_component: HealthComponent

@onready var hit_flash_component := $HitFlashComponent as HitFlashComponent


func _ready() -> void:
	hit_flash_component.health_component = health_component

