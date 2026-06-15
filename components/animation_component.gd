extends AnimationPlayer
class_name AnimationComponent

var facing_direction: int = 1
var velocity: Vector2 = Vector2.ZERO
var turning: bool = false
var attacking: bool = false
var is_on_floor: bool = false

var current_attack_anim: String = "mele_attack"

enum AnimationState {DEFAULT, ATTACK_BEGIN, CURRENTLY_ATTACKING}
var anim_state: AnimationState = AnimationState.DEFAULT

@export var animated_sprite_2d: AnimatedSprite2D

func _ready() -> void:
	animated_sprite_2d.animation_finished.connect(_animation_finished)

func _process(delta: float) -> void:
	animated_sprite_2d.flip_h = (facing_direction < 0)
	animated_sprite_2d.scale.y = 1 + abs(velocity.y)/700
	animated_sprite_2d.scale.x = 1
	animated_sprite_2d.position.y = 0
	
	match anim_state:
		AnimationState.DEFAULT:
			_handle_default_anim()
		AnimationState.ATTACK_BEGIN:
			_handle_attack_begin_anim()
		AnimationState.CURRENTLY_ATTACKING:
			return
	
func attack_start(attack_anim: String):
	#if anim_state == AnimationState.CURRENTLY_ATTACKING:
	current_attack_anim = attack_anim
	anim_state = AnimationState.ATTACK_BEGIN

func attack_finished():
	print("finished attacking")
	anim_state = AnimationState.DEFAULT

func _handle_default_anim():
	if is_on_floor:
		if Input.is_action_pressed("down"):
			animated_sprite_2d.play("crouch")
			animated_sprite_2d.position.y = 1
			animated_sprite_2d.scale.x = 1.05
		elif turning:
			animated_sprite_2d.play("turn")
		elif abs(velocity.x) > 0:
			animated_sprite_2d.play("run")
		else:
			animated_sprite_2d.play("idle")
	elif velocity.y > 0:
		animated_sprite_2d.play("fall")
	else:
		animated_sprite_2d.play("jump")
	
func _handle_attack_begin_anim():
	animated_sprite_2d.play(current_attack_anim)
	anim_state = AnimationState.CURRENTLY_ATTACKING

func _animation_finished():
	if anim_state == AnimationState.CURRENTLY_ATTACKING: attack_finished()
