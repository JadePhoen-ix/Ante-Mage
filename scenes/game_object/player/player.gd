extends CharacterBody2D
class_name Player


var base_speed := 0.0
var colliding_bodies := 0

@onready var abilities := $Abilities as Node
@onready var animation_player := $AnimationPlayer as AnimationPlayer
@onready var collision_area := $CollisionArea2D as Area2D
@onready var damage_interval_timer := $DamageIntervalTimer as Timer
@onready var health_component := $HealthComponent as HealthComponent
@onready var hit_random_audio_component := $HitRandomAudioComponent2D as RandomAudioComponent2D
@onready var velocity_component := $VelocityComponent as VelocityComponent
@onready var health_bar := $HealthBar as ProgressBar
@onready var visuals := $Visuals as Node2D


func _ready() -> void:
	base_speed = velocity_component.max_speed
	
	collision_area.body_entered.connect(_on_body_entered)
	collision_area.body_exited.connect(_on_body_exited)
	damage_interval_timer.timeout.connect(_on_damage_interval_timer_timeout)
	health_component.health_changed.connect(_on_health_changed)
	
	GameEvents.upgrade_added.connect(_on_upgrade_added)
	GameEvents.spell_cast.connect(_on_spell_cast)
	
	update_health_bar()


func _physics_process(delta: float) -> void:
	var movement_vector := get_movement_vector()
	var direction := movement_vector.normalized()
	velocity_component.accelerate_in_direction(direction)
	velocity_component.move(self)
	
	if movement_vector != Vector2.ZERO and not animation_player.is_playing():
		animation_player.play("walk")
	
	var move_sign := signf(movement_vector.x)
	if move_sign != 0:
		visuals.scale = Vector2(move_sign, 1)


func get_movement_vector() -> Vector2:
	return Input.get_vector("move_left", "move_right", "move_up", "move_down")


func check_deal_damage() -> void:
	if colliding_bodies == 0 or not damage_interval_timer.is_stopped():
		return
	
	health_component.damage(1)
	hit_random_audio_component.play_random()
	
	damage_interval_timer.start()


func update_health_bar() -> void:
	health_bar.value = health_component.get_health_percent()


func _on_body_entered(body: Node2D) -> void:
	colliding_bodies += 1
	check_deal_damage()


func _on_body_exited(body: Node2D) -> void:
	colliding_bodies -= 1


func _on_damage_interval_timer_timeout() -> void:
	check_deal_damage()


func _on_health_changed() -> void:
	GameEvents.emit_player_damaged()
	update_health_bar()


func _on_upgrade_added(upgrade: Upgrade, current_upgrades: Dictionary) -> void:
	if upgrade.id == "move_speed":
		var level := current_upgrades["move_speed"]["level"] as int
		velocity_component.max_speed = base_speed + (base_speed * level * 0.1)


func _on_spell_cast(spell: Spell) -> void:
	animation_player.stop()
	animation_player.play("cast")

