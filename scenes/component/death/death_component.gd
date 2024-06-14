extends Node2D


@export var health_component: HealthComponent
@export var sprite: Sprite2D

@onready var animation_player := $AnimationPlayer as AnimationPlayer
@onready var particles := $GPUParticles2D as GPUParticles2D


func _ready() -> void:
	particles.texture = sprite.texture
	health_component.died.connect(_on_died)


func _on_died() -> void:
	if owner == null || not owner is Node2D:
		return
	
	var entities_layer := get_tree().get_first_node_in_group("entities_layer") as Node2D
	var spawn_position := owner.global_position as Vector2
	
	get_parent().remove_child(self)
	entities_layer.add_child(self)
	
	global_position = spawn_position
	animation_player.play("default")


