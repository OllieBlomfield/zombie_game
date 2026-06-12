extends CharacterBody2D
class_name GameCharacter


func apply_hit_effects(context: HitContext):
	#print("APPLYING STUFF SIR")
	velocity += context.direction * context.knockback
	velocity.y -= context.extra_y_knockback
