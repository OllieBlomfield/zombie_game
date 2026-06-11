extends Label
class_name DamageLabel

func init(context: HitContext):
	text = str(context.damage)
