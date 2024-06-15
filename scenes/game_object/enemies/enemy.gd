extends CharacterBody2D
class_name Enemy


@onready var random_audio_component := $%RandomAudioComponent2D as RandomAudioComponent2D
@onready var health_component := $HealthComponent as HealthComponent
@onready var hurtbox_component := $HitboxComponent as HitboxComponent
@onready var velocity_component := $VelocityComponent as VelocityComponent
@onready var visuals := $Visuals as Node2D


func _ready() -> void:
	hurtbox_component.hit.connect(_on_hit)


func _on_hit() -> void:
	random_audio_component.play_random()


