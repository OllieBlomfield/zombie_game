extends ColorRect
class_name DamageVignette

@export var alpha_curve: Curve
@export var effect_time: float = 0.4

var current_effect_time: float = 0

enum VignetteState {CURVED, FIXED}
var state: VignetteState = VignetteState.CURVED

func _ready() -> void:
	visible = true

func _process(delta: float) -> void:
	var alpha_value: float = 0.0
	
	match state:
		VignetteState.CURVED:
			alpha_value = curved_vignette(delta)
		VignetteState.FIXED:
			alpha_value =fixed_vignette(delta)

	set_instance_shader_parameter("alpha",alpha_value)
	
func fixed_vignette(delta: float) -> float:
	return 0.3

func curved_vignette(delta: float) -> float:
	current_effect_time = max(current_effect_time - delta, 0)
	return alpha_curve.sample(current_effect_time/effect_time)
	
func show_vignette(new_effect_time: float = 0.7):
	effect_time = new_effect_time
	if current_effect_time <= 0:
		current_effect_time = effect_time

func set_vignette_fixed(is_fixed: bool):
	if is_fixed:
		state = VignetteState.FIXED
	else:
		state = VignetteState.CURVED
