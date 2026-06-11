extends Node2D
class_name DamageLabel

@export var effect_time: float = 2
@export var label: Label

var _current_fade_time : float

func _ready():
	_current_fade_time = effect_time

func init(context: HitContext):
	label.text = str(context.damage)
	position.x += randf_range(-3,3)

func _process(delta: float) -> void:
	position.y -= 10 * delta
	_current_fade_time -= delta
	modulate.a = ease(_current_fade_time/effect_time,1.2)
