class_name HurtBox
extends Area2D

signal received_hit(context: HitContext)

@export var health: Health
@export var hurtbox_name: String = "Barry"
	
func handle_hit(context: HitContext) -> void:
	print("I'VE BEEN HIT with " + str(context.damage) + " damage")
	if health and context.damage > 0:
		health.take_damage(context.damage)
	received_hit.emit(context)
