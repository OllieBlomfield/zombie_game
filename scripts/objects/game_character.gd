extends CharacterBody2D
class_name GameCharacter

const DAMAGE_LABEL: PackedScene = preload("uid://biobengcqimdd")

@export var display_damage_labels: bool = true

@export var health: Health

func apply_hit_effects(context: HitContext):
	#print("APPLYING STUFF SIR")
	if not health.immortality:
		if context.damage > 0:
			health.take_damage(context.damage)
		add_knockback(context.direction, context.knockback, context.extra_y_knockback)
		if context.effect:
			var effect = context.effect.instantiate()
			effect.global_position = global_position
			effect.emitting = true
			get_parent().add_child(effect)
	
	if display_damage_labels:
		spawn_label(context)
	
	
func add_knockback(direction: Vector2, knockback: float, extra_y_knockback: float):
	velocity += direction * knockback
	velocity.y -= extra_y_knockback

func spawn_label(context: HitContext):
	var damage_label = DAMAGE_LABEL.instantiate() as DamageLabel
	damage_label.global_position = context.hit_point
	damage_label.init(context)
	get_tree().current_scene.add_child(damage_label)
