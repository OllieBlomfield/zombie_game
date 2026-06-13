class_name RangedWeapon
extends Weapon

@export var damage: int
@export var pierce: int
@export var bullet_scene: PackedScene
@export var fire_point: Marker2D
@export var bullet_speed: float = 300
@export var cooldown_time: float = 0.05
@export var spray: float = 1

@onready var muzzle_flash: PointLight2D = $MuzzleFlash
@onready var cooldown_timer: Timer = $CooldownTimer

@export var user_knockback: float = 5

@export var max_ammo: int = 100
@export var current_ammo: int = 50

const BULLET_CASING: PackedScene = preload("uid://dlotmvlm7iylq")

var deadzone: float = 0.2
var roatation_speed: float = 5.0
var target_angle: float

var is_on_cooldown = false

func _ready() -> void:
	cooldown_timer.timeout.connect(_on_timeout)
	muzzle_flash.visible = false
	
func _process(delta: float) -> void:
	#muzzle_flash.visible = false
	var input_vec: Vector2 = Vector2(
		Input.get_joy_axis(0, JOY_AXIS_LEFT_X),
		Input.get_joy_axis(0, JOY_AXIS_LEFT_Y)
	)

func perform_attack(facing_direction: int) -> void: #call pefrom_attack or execute_attack to imply something active is happening
	if is_on_cooldown or not has_ammunition():
		return
		
	var bullet = bullet_scene.instantiate()
	
	get_tree().current_scene.add_child(bullet)
	
	bullet.damage = damage
	bullet.pierce = pierce

	bullet.global_position = fire_point.global_position

	var spread := deg_to_rad(spray)

	var input_vec: Vector2 = Vector2(
		Input.get_joy_axis(0, JOY_AXIS_RIGHT_X),
		Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y)
	)
	
	var dir := Vector2(facing_direction, 0)
	dir.y += randf_range(-spread, spread)

	dir = dir.normalized()

	bullet.velocity = dir * bullet_speed
	
	_handle_ammo()
	
	var bullet_casing = BULLET_CASING.instantiate()
	bullet_casing.position = position
	get_parent().add_child(bullet_casing)
	
	muzzle_flash.flash()
	play_attack_anim.emit()
	camera_shake.emit(1,0.1)
	
	is_on_cooldown = true
	cooldown_timer.start(cooldown_time)
	
func get_attack_context() -> AttackContext:
	if is_on_cooldown:
		return AttackContext.new()
	else:
		var attack_context: AttackContext = AttackContext.new()
		attack_context.knockback = user_knockback
		return attack_context			

func _on_timeout():
	is_on_cooldown = false
	finished_attack.emit()

func has_ammunition() -> bool:
	return current_ammo > 0

func _handle_ammo():
	current_ammo = max(0, current_ammo - 1)
