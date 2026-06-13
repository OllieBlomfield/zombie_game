class_name HurtBox
extends Area2D

signal received_hit(context: HitContext)

@export var health: Health
@export var hurtbox_name: String = "Barry"

const DAMAGE_LABEL: PackedScene = preload("uid://biobengcqimdd")
	
func handle_hit(context: HitContext) -> void:
	print("I'VE BEEN HIT with " + str(context.damage) + " damage")
	received_hit.emit(context) #can use for audio and effects/special effects

func spawn_label(context: HitContext):
	var damage_label = DAMAGE_LABEL.instantiate() as DamageLabel
	damage_label.global_position = context.hit_point
	damage_label.init(context)
	get_tree().current_scene.add_child(damage_label)
