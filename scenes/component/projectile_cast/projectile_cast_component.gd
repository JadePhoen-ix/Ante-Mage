extends Node2D
class_name ProjectileCastComponent


signal collision_detected(collider: Object)

@export var body: CharacterBody2D
@export var projectile_hitbox_shape: CollisionShape2D
@export_flags_2d_physics var cast_mask

var direction: Vector2

@onready var shape_cast := $ShapeCast2D as ShapeCast2D


func _ready() -> void:
	shape_cast.shape = projectile_hitbox_shape.shape.duplicate()
	shape_cast.collision_mask = cast_mask


func _physics_process(delta: float) -> void:
	shape_cast.target_position = direction * body.velocity * delta
	shape_cast.force_shapecast_update()
	
	if shape_cast.is_colliding():
		var collider := shape_cast.get_collider(0)
		collision_detected.emit(collider)


func disable() -> void:
	shape_cast.process_mode = Node.PROCESS_MODE_DISABLED


