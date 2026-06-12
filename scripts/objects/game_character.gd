extends CharacterBody2D
class_name GameCharacter

const DAMAGE_LABEL: PackedScene = preload("uid://biobengcqimdd")

func apply_hit_effects(context: HitContext):
	#print("APPLYING STUFF SIR")
	add_knockback(context.direction, context.knockback, context.extra_y_knockback)
	spawn_label(context)
	
	
func add_knockback(direction: Vector2, knockback: float, extra_y_knockback: float):
	velocity += direction * knockback
	velocity.y -= extra_y_knockback

func spawn_label(context: HitContext):
	var damage_label = DAMAGE_LABEL.instantiate() as DamageLabel
	damage_label.global_position = context.hit_point
	damage_label.init(context)
	get_tree().current_scene.add_child(damage_label)
