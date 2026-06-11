class_name Enemy
extends CharacterBody2D

@export var player: CharacterBody2D

@export var health: Health
@export var hitbox: HitBox
@export var hurtbox: HurtBox

@export var speed: float = 50.0
@export var jump_velocity: float = -300.0
@export var gravity: float = 900.0
@export var acceleration: float = 2.0
@export var friction: float = 800.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var wall_detector: RayCast2D = $WallDetector

const ZOMBIE_CORPSE: PackedScene = preload("uid://cu7c7xb3s47re")

var in_jump_zone: bool = false
var near_player: bool = false

enum States { CHASING, ATTACKING, DEAD}
var state: States = States.CHASING

func _ready() -> void:
	speed = randi_range(50,70)
	player = get_tree().get_first_node_in_group("player")
	hurtbox.received_hit.connect(damaged_received)
	animated_sprite_2d.animation_finished.connect(_on_animation_finished)

func _physics_process(delta: float) -> void:
	if !is_on_floor():
		velocity.y += gravity * delta
	
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

	#velocity.x = move_toward(
		#velocity.x,
		#dir * speed,
		#acceleration * get_physics_process_delta_time()
	#)
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
	animated_sprite_2d.flip_h = (velocity.x < 0)
	match state:
		States.CHASING:
			animated_sprite_2d.play("move")
		States.ATTACKING:
			#attack()
			pass
		States.DEAD:
			animated_sprite_2d.play("death")
	
func damaged_received(context: HitContext):
	velocity += context.direction * context.knockback
	velocity.y -= context.extra_y_knockback
	if health.current_health <= 0:
		die()

func die() -> void:
	if state != States.DEAD:
		state = States.DEAD

func _on_animation_finished() -> void:
	print("DONE")
	if state == States.DEAD:
		var corpse = ZOMBIE_CORPSE.instantiate() as Node2D
		corpse.global_position = global_position
		get_parent().add_child(corpse)
		queue_free()

func _on_zone_detector_area_entered(area: Area2D) -> void:
	if area is JumpNode and abs(player.global_position.y - global_position.y) > 5:
		jump(player.global_position.y)
	elif area is DropNode and player.global_position.y > global_position.y + 3:
		await get_tree().create_timer(0.1).timeout
		print("down")
		position.y += 5
