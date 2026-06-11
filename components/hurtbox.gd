class_name HurtBox
extends Area2D

signal received_hit(context: HitContext)

@export var health: Health
@export var hurtbox_name: String = "Barry"

const DAMAGE_LABEL: PackedScene = preload("uid://biobengcqimdd")
	
func handle_hit(context: HitContext) -> void:
	print("I'VE BEEN HIT with " + str(context.damage) + " damage")
	if health and context.damage > 0:
		health.take_damage(context.damage)
	spawn_label(context)
	received_hit.emit(context)

func spawn_label(context: HitContext):
	var damage_label = DAMAGE_LABEL.instantiate() as DamageLabel
	damage_label.global_position = context.hit_point
	damage_label.init(context)
	get_parent().add_child(damage_label)
	
