extends CharacterBody2D


@onready var random_audio_component := $%RandomAudioComponent2D as RandomAudioComponent2D
@onready var health_component := $HealthComponent as HealthComponent
@onready var hurtbox_component := $HurtboxComponent as HurtboxComponent
@onready var velocity_component := $VelocityComponent as VelocityComponent
@onready var visuals := $Visuals as Node2D

var is_moving := false


func _ready() -> void:
	hurtbox_component.hit.connect(_on_hit)


func _process(delta: float) -> void:
	if is_moving:
		velocity_component.accelerate_to_player()
	else:
		velocity_component.decelerate()
	
	velocity_component.move(self)
	
	var move_sign := signf(velocity.x)
	if move_sign != 0:
		visuals.scale = Vector2(move_sign, 1)


func set_is_moving(value: bool) -> void:
	is_moving = value


func _on_hit() -> void:
	random_audio_component.play_random()


