class_name Enemy
extends GameCharacter

@export var player: CharacterBody2D

@export var health: Health
@export var hitbox: HitBox
@export var hurtbox: HurtBox

@export var speed: float = 50.0
@export var jump_velocity: float = -300.0
@export var gravity: float = 600.0
@export var acceleration: float = 2.0
@export var friction: float = 800.0

@export var damage: float = 3
@export var knockback: float = 100
@export var extra_knockback_y: float = 50

@export var corpse_texture: CompressedTexture2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var wall_detector: RayCast2D = $WallDetector
@onready var attack_cooldown_timer: Timer = $AttackCooldownTimer

var _flashing: bool = false

const ZOMBIE_CORPSE: PackedScene = preload("uid://cu7c7xb3s47re")

var in_jump_zone: bool = false
var near_player: bool = false

enum States { CHASING, ATTACKING, DEAD}
var state: States = States.CHASING

var can_attack = true

func _ready() -> void:
	speed = randi_range(50,70)
	player = get_tree().get_first_node_in_group("player")
	
	hurtbox.received_hit.connect(damaged_received)
	hitbox.hurtbox_hit.connect(_attack_hit)
	animated_sprite_2d.animation_finished.connect(_on_animation_finished)

func _physics_process(delta: float) -> void:
	if !is_on_floor():
		velocity.y += gravity * delta
	
	_handle_flash()
	
	update_state()
	_handle_animation()
	move_and_slide()

func update_state() -> void:
	match state:
		States.CHASING:
			chase()
		States.ATTACKING:
			attack()
		States.DEAD:
			die()

func chase() -> void:
	if player == null:
		return

	if abs(player.global_position.x - global_position.x) < 5:
		state = States.ATTACKING

	var dir = sign(player.global_position.x - global_position.x)

	wall_detector.target_position.x = 20 * dir

	var direction = sign(player.position.x - position.x)
	velocity.x += acceleration * direction
	velocity *= 0.9
	
	if wall_detector.is_colliding() and is_on_floor():
		jump(player.global_position.y)

func jump(target_y: float) -> void:
	if !is_on_floor():
		return

	velocity.y = get_jump_velocity_to_reach(target_y)

func get_jump_velocity_to_reach(target_y: float) -> float:
	var distance_y = global_position.y - target_y
	distance_y = clamp(distance_y, 0, 120)

	if distance_y <= 0:
		return 0.0
	return -sqrt(2 * gravity * distance_y) - 15

func attack() -> void:
	if abs(player.global_position.x - global_position.x) > 5:
		state = States.CHASING

	velocity.x = move_toward(
		velocity.x,
		0,
		friction * get_physics_process_delta_time()
	)
func _handle_animation() -> void:
	var facing_direction: float = sign(player.global_position.x - global_position.x)
	animated_sprite_2d.flip_h = (facing_direction < 0)
	match state:
		States.CHASING:
			animated_sprite_2d.play("move")
		States.ATTACKING:
			#attack()
			pass
		States.DEAD:
			animated_sprite_2d.play("death")
	
func damaged_received(context: HitContext):
	_flashing = true
	apply_hit_effects(context)
	if health.current_health <= 0:
		die()

func die() -> void:
	if state != States.DEAD:
		state = States.DEAD

func _handle_flash():
	if _flashing:
		animated_sprite_2d.set_instance_shader_parameter("flash_modifier",1.0)
		_flashing = false
	else:
		animated_sprite_2d.set_instance_shader_parameter("flash_modifier",0.0)

func _attack_hit(hurtbox: HurtBox):
	if can_attack:
		var context: HitContext = HitContext.new()
		context.damage = damage
		context.direction = (hurtbox.global_position - global_position).normalized()
		context.hit_point = global_position
		context.knockback = knockback
		context.extra_y_knockback = extra_knockback_y
		hurtbox.handle_hit(context)
		attack_cooldown()
	
func attack_cooldown():
	can_attack = false
	await get_tree().create_timer(1.0).timeout
	can_attack = true
	for area in hitbox.get_overlapping_areas():
		print(area)
		if area is HurtBox:
			_attack_hit(area) 
			
func _on_animation_finished() -> void:
	if state == States.DEAD: #might be more satisfying to only do this when they land on the ground?
		var corpse = ZOMBIE_CORPSE.instantiate() as ZombieCorpse
		corpse.global_position = global_position
		corpse.corpse_texture = corpse_texture
		get_parent().add_child(corpse)
		queue_free()

func _on_zone_detector_area_entered(area: Area2D) -> void:
	if area is JumpNode and abs(player.global_position.y - global_position.y) > 5:
		jump(player.global_position.y)
	elif area is DropNode and player.global_position.y > global_position.y + 3:
		position.y += 5


func _on_hit_box_body_entered(body: Node2D) -> void:
	print("HIT")
