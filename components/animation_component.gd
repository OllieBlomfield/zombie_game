extends Node2D
class_name AnimationComponent

var facing_direction: int = 1
var velocity: Vector2 = Vector2.ZERO
var turning: bool = false
var attacking: bool = false
var is_on_floor: bool = false
var down_pressed: bool = false

const DUST_PARTICLE = preload("uid://br77vrl7a7wcv")
@onready var dust_timer: Timer = $DustTimer
@onready var dust_marker: Marker2D = $Dust_Marker
@onready var run_sound: AudioStreamPlayer2D = $"../RunSound"
@onready var player: Player = $".."

var current_attack_anim: String = "mele_attack"

enum AnimationState {DEFAULT, ATTACK_BEGIN, CURRENTLY_ATTACKING}
var anim_state: AnimationState = AnimationState.DEFAULT

@export var animated_sprite_2d: AnimatedSprite2D
@export var combat: Combat

func _ready() -> void:
	animated_sprite_2d.animation_finished.connect(_animation_finished)
	
	dust_timer.timeout.connect(add_dust)

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
	anim_state = AnimationState.DEFAULT

func _handle_default_anim():
	if is_on_floor:
		if down_pressed:
			animated_sprite_2d.play("crouch")
			animated_sprite_2d.scale.x = 1.05
		elif turning:
			animated_sprite_2d.play("turn")
		elif abs(velocity.x) > 2:
			animated_sprite_2d.play("run")
			if player.is_on_floor():
				if not run_sound.playing:
					run_sound.play()
			else:
				run_sound.stop()
			if dust_timer.is_stopped(): dust_timer.start(0.1 + 0.1*randf())
			if animated_sprite_2d.frame == 1 or animated_sprite_2d.frame == 3:
				#I know how scuffed this is but running out of time
				combat.set_weapon_offset(Vector2(0,1))
			else:
				combat.set_weapon_offset(Vector2.ZERO)
		
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

func weapon_switched():
	anim_state = AnimationState.DEFAULT

func add_dust():
	var dust_particle = DUST_PARTICLE.instantiate()
	dust_particle.global_position = dust_marker.global_position
	get_tree().current_scene.add_child(dust_particle)
	dust_timer.stop()
