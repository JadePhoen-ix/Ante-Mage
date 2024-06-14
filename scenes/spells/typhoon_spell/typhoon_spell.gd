extends CharacterBody2D


@export_range(1.0, 200.0, 0.01) var pull_velocity := 10.0
@export_range(1.0, 50.0, 0.01) var pull_acceleration := 10.0

var target_position := Vector2.ZERO
var direction: Vector2

@onready var animation_player := $AnimationPlayer as AnimationPlayer
@onready var tick_hitbox_component := $TickHitboxComponent as TickHitboxComponent
@onready var velocity_component := $VelocityComponent as VelocityComponent


func _ready() -> void:
	var player := get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		queue_free()
		return
	global_position = player.global_position
	
	var hit_box_shape := PhysicsServer2D.capsule_shape_create()
	var data := Vector2(42.0, 154.0)
	PhysicsServer2D.shape_set_data(hit_box_shape, data)
	
	var params = create_params(hit_box_shape)
	target_position = SpellTargeting.densest_point(params, true)
	PhysicsServer2D.free_rid(hit_box_shape)
	
	tick_hitbox_component.duration_timeout.connect(_on_duration_timeout)
	
	if target_position == player.global_position:
		direction = Vector2.RIGHT.rotated(randf_range(0.0, TAU))
	else:
		direction = (target_position - global_position).normalized()


func _physics_process(delta: float) -> void:
	velocity_component.accelerate_in_direction(direction)
	velocity_component.move(self)
	
	for i in tick_hitbox_component.enemies_in_hitbox.size():
		var enemy := tick_hitbox_component.enemies_in_hitbox[i].owner as Enemy
		var enemy_velocity_component := enemy.velocity_component
		var pull_direction := (global_position - enemy.global_position).normalized()
		
		var desired_velocity := pull_direction * pull_velocity
		enemy_velocity_component.velocity = enemy_velocity_component.velocity\
				.lerp(desired_velocity, 1 - exp(-pull_acceleration * get_process_delta_time()))
		
		enemy_velocity_component.move(enemy)


func create_params(shape_rid: RID) -> PhysicsShapeQueryParameters2D:
	var params := PhysicsShapeQueryParameters2D.new()
	
	params.shape_rid = shape_rid
	params.collide_with_bodies = true
	params.collision_mask = 1 << 3
	params.transform = Transform2D(90.0, Vector2.ZERO)
	
	return params


func _on_duration_timeout() -> void:
	animation_player.play("out")



