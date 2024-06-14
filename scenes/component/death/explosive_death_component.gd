extends Node2D


@export var health_component: HealthComponent
@export var texture: Texture2D
@export var texture_frames := Vector2.ZERO

@onready var animation_player := $AnimationPlayer as AnimationPlayer
@onready var particles := $GPUParticles2D as GPUParticles2D


func _ready() -> void:
	particles.texture = texture
	particles.material.set("particles_anim_h_frames", texture_frames.x)
	particles.material.set("particles_anim_v_frames", texture_frames.y)
	health_component.died.connect(_on_died)


func _on_died() -> void:
	if owner == null || not owner is Node2D:
		return
	
	var entities_layer := get_tree().get_first_node_in_group("entities_layer") as Node2D
	var spawn_position := owner.global_position as Vector2
	
	get_parent().remove_child(self)
	global_position = spawn_position
	entities_layer.add_child(self)
	
	animation_player.play("default")


