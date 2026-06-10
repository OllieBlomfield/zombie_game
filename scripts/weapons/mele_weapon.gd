extends Node2D
class_name MeleWeapon

@export var hit_box: HitBox
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

signal attack_finished

func _ready() -> void:
	hit_box.disable()
	animated_sprite_2d.animation_finished.connect(_attack_finished)
	
func attack_init() -> void:
	hit_box.enable()
	animated_sprite_2d.play("attack")

func _attack_finished() -> void:
	hit_box.disable()
	attack_finished.emit()
	print("DONE ATTACKING YAY")
	animated_sprite_2d.play("idle")
