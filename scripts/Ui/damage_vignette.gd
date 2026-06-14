extends ColorRect
class_name DamageVignette

@export var alpha_curve: Curve
@export var effect_time: float = 0.4

var current_effect_time: float = 0

func _ready() -> void:
	visible = true

func _process(delta: float) -> void:
	current_effect_time = max(current_effect_time - delta, 0)
	if current_effect_time > 0:
		pass
		#print(alpha_curve.sample(current_effect_time/effect_time))
		
	var alpha_value: float = alpha_curve.sample(current_effect_time/effect_time)
	
	set_instance_shader_parameter("alpha",alpha_value)

func show_vignette(new_effect_time: float = 0.7):
	effect_time = new_effect_time
	if current_effect_time <= 0:
		current_effect_time = effect_time
	#visible = true
	#await get_tree().create_timer(0.2).timeout
	#visible = false
