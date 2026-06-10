class_name HurtBox
extends Area2D

signal received_damage(damage: int)

@export var health: Health
@export var hurtbox_name: String = "Barry"

func _ready():
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	var hitbox = area as HitBox
	if hitbox == null:
		return
	print(hurtbox_name + " was hit by " + hitbox.hitbox_name)
	if health:
		health.take_damage(hitbox.damage, health.immortality_time)
	received_damage.emit(hitbox.damage)
