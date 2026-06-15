class_name MeleWeapon
extends Weapon

@export var damage: int = 2
@export var knockback: float = 80
@export var extra_knockback_y: float = 100
@export var hit_box: HitBox
@export var crit_chance: float = 0.3
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var cooldown_timer: Timer = $CooldownTimer
@onready var bat_sound: AudioStreamPlayer2D = $"../../BatSound"

const BLOOD_DROP_BIG = preload("uid://ccty5qickix53")

@export var user_knockback: float = 0

var _performing_attack: bool = false
var _cooling_down: bool = false

func _ready() -> void:
	hit_box.body_entered.connect(_attack_hit)
	hit_box.hurtbox_hit.connect(_attack_hit)
	cooldown_timer.timeout.connect(_on_timeout)
	
	hit_box.disable()
	animated_sprite_2d.animation_finished.connect(_attack_finished)
	
func _process(delta: float) -> void:
	pass
	#animated_sprite_2d.flip_h = flip_h #ask about this approach
	#for area in hit_box.get_overlapping_areas():
		#if area is HurtBox: #add something to check correct layers

func get_attack_context() -> AttackContext:
	var attack_context: AttackContext = AttackContext.new()
	attack_context.knockback = user_knockback
	return attack_context			

func perform_attack(direction: int) -> void: #call pefrom_attack or execute_attack to imply something active is happening
	if not _performing_attack and not _cooling_down:
		hit_box.enable()
		play_attack_anim.emit()
		bat_sound.play()
		animated_sprite_2d.play("attack")
		_performing_attack = true

func _attack_finished() -> void:
	if _performing_attack:
		_performing_attack = false
		hit_box.disable()
		cooldown_timer.start(0.2)
		_cooling_down = true
	
func _attack_hit(hurtbox: HurtBox):
	print("ATTACK HIT")
	Input.start_joy_vibration(0, .1, .2, .3)
	camera_shake.emit(2,0.2)
	var context: HitContext = HitContext.new()
	context.damage = damage
	context.direction = (hurtbox.global_position - global_position).normalized()
	context.hit_point = global_position
	context.knockback = knockback
	context.extra_y_knockback = extra_knockback_y
	context.criticial_hit = (randf() < crit_chance)
	context.effect = BLOOD_DROP_BIG
	hurtbox.handle_hit(context)
	
func _on_timeout():
	animated_sprite_2d.play("idle")
	finished_attack.emit()
	_cooling_down = false
