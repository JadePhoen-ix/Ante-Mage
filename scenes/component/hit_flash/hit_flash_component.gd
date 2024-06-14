extends Node
class_name HitFlashComponent


@export var health_component: HealthComponent
## This should be either a Sprite2D or AnimatedSprite2D
@export var sprite: Node2D

var hit_flash_tween: Tween


func _ready() -> void:
	await get_tree().physics_frame # OPTIMISING FOR WEB
	#sprite.material = hit_flash_material
	health_component.health_changed.connect(_on_health_changed)


func _on_health_changed() -> void:
	if hit_flash_tween != null and hit_flash_tween.is_valid():
		hit_flash_tween.kill()
	
	var material := sprite.material as ShaderMaterial
	
	material.set_shader_parameter("lerp_percent", 1.0)
	hit_flash_tween = create_tween()
	
	hit_flash_tween.tween_property(material, "shader_parameter/lerp_percent", 0.0, 0.2)\
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)


