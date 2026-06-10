class_name Enemy
extends CharacterBody2D

@export var player: CharacterBody2D

@export var health: Health
@export var hitbox: HitBox
@export var hurtbox: HurtBox

@export var speed: int
@export var jump_height: int



enum States{CHASING, ATTACKING, JUMPING, DEAD}
var state: States = States.CHASING

func _ready() -> void:
	pass
	
func _physics_process(delta: float) -> void:
	update_state()

func move():
	pass
	
func attack():
	pass 
	
func chase():
	pass
	#var dir = sign(player.global_position.x - global_position.x)
	#velocity.x = dir * speed
	#if is_on_wall():
		#jump()
	#if player.global_position.y < global_position.y - 50:
		#jump()
	#move_and_slide()
	
func jump():
	if is_on_floor():
		velocity.y = jump_height

func die():
	queue_free()

func update_state():
	match state:
		States.CHASING:
			chase()
		States.ATTACKING:
			pass
		States.DEAD:
			pass
