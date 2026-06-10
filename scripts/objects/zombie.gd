class_name Enemy
extends CharacterBody2D

@export var player: CharacterBody2D

@export var health: Health
@export var hitbox: HitBox
@export var hurtbox: HurtBox

@export var speed: float = 50.0
@export var jump_velocity: float = -300.0
@export var gravity: float = 900.0
@export var acceleration: float = 600.0
@export var friction: float = 800.0

@onready var wall_detector: RayCast2D = $WallDetector

var near_player: bool = false

enum States { CHASING, ATTACKING, DEAD }
var state: States = States.CHASING

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta: float) -> void:
	if !is_on_floor():
		velocity.y += gravity * delta

	update_state()
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

	velocity.x = move_toward(
		velocity.x,
		dir * speed,
		acceleration * get_physics_process_delta_time()
	)

	if wall_detector.is_colliding() and is_on_floor():
		jump()

func jump() -> void:
	if is_on_floor() and wall_detector.is_colliding():
		velocity.y = jump_velocity

func attack() -> void:
	if abs(player.global_position.x - global_position.x) > 5:
		state = States.CHASING

	velocity.x = move_toward(
		velocity.x,
		0,
		friction * get_physics_process_delta_time()
	)

func die() -> void:
	queue_free()
