extends AnimatedSprite2D
# THIS ENTIRE SCRIPT EXISTS TO OPTIMISE THE HIT FLASH FOR WEB
# ON WINDOWS THIS IS UNNECASSARY BUT MAY STILL BE USEFUL


@export var health_component: HealthComponent
@export_range(-1.0, 100.0) var shadow_size := -1

@onready var hit_flash_component := $HitFlashComponent as HitFlashComponent
@onready var shadow_sprite := $ShadowSprite as Sprite2D 


func _ready() -> void:
	hit_flash_component.health_component = health_component
	
	if shadow_size != -1:
		shadow_sprite.texture.set("width", shadow_size)

