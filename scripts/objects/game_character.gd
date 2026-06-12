extends CharacterBody2D
class_name GameCharacter


func apply_hit_effects(context: HitContext):
	#print("APPLYING STUFF SIR")
	add_knockback(context.direction, context.knockback, context.extra_y_knockback)

func add_knockback(direction: Vector2, knockback: float, extra_y_knockback: float):
	velocity += direction * knockback
	velocity.y -= extra_y_knockback
