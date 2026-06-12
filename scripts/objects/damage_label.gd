extends Node2D
class_name DamageLabel

@export var effect_time: float = 1.2
@export var label: Label

@export var jump_velocity: float = -50
@export var gravity: float = 120

@export var CRIT_COLOR: Color

var velocity: Vector2 = Vector2.ZERO

var _current_fade_time : float

func _ready():
	_current_fade_time = effect_time
	velocity.y = jump_velocity

func init(context: HitContext):
	if context.criticial_hit:
		label.text = str(context.damage*2)
		label.modulate = CRIT_COLOR
	else:
		label.text = str(context.damage)
	
	velocity.x = randf_range(-5,5)
	#position.x += randf_range(-3,3)

func _process(delta: float) -> void:
	velocity.y += gravity * delta
	
	_current_fade_time -= delta
	modulate.a = ease(_current_fade_time/effect_time,1.2)
	
	position += velocity * delta
	
	if _current_fade_time <= 0:
		queue_free()
