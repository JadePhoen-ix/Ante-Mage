extends CharacterBody2D
class_name FlareSpellProjectile


signal hit_something()

var direction: Vector2
var target_enemy: Enemy
var target_found := false
var has_hit := false

@onready var animation_player := $AnimationPlayer as AnimationPlayer
@onready var velocity_component := $VelocityComponent as VelocityComponent
@onready var visuals := $Visuals as Node2D
@onready var projectile_cast_component := $ProjectileCastComponent as ProjectileCastComponent
@onready var hitbox_component := $HitboxComponent as HitboxComponent 
@onready var hit_particles := $Visuals/GPUParticles2D as GPUParticles2D


func _ready() -> void:
	projectile_cast_component.collision_detected.connect(_on_cast_collision_detected)


func _physics_process(delta: float) -> void:
	if target_enemy == null and not target_found:
		var potential_target = SpellTargeting.random_enemy() as Enemy
		if potential_target != null:
			target_enemy = potential_target
			target_found = true
			
			direction = (target_enemy.global_position - global_position).normalized()
			projectile_cast_component.direction = direction
			rotation = direction.angle()
	
	velocity_component.accelerate_in_direction(direction)
	velocity_component.move(self)


func hit(collider: Object) -> void:
	animation_player.play("hit")
	
	var foreground_layer := get_tree().get_first_node_in_group("foreground_layer") as Node2D
	var spawn_position := global_position as Vector2
	
	visuals.remove_child(hit_particles)
	foreground_layer.add_child(hit_particles)
	
	hit_particles.global_position = spawn_position
	hit_particles.emitting = true


func _on_cast_collision_detected(collider: Object) -> void:
	if has_hit:
		return
	has_hit = true
	hit(collider)



