class_name Enemy
extends CharacterBody2D

@export var player: CharacterBody2D

@export var health: Health
@export var hitbox: HitBox
@export var hurtbox: HurtBox

@export var speed: int
@export var jump_height: int
@export var gravity: float = 200

var breadcrumbs: Array = []


enum States{CHASING, ATTACKING, JUMPING, DEAD}
var state: States = States.CHASING

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	breadcrumbs.append(player.global_position)
	
func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	#update_state(delta)
func move():
	pass
	
func attack():
	pass 
	
func chase(delta):
	if breadcrumbs.is_empty():
		return
	if global_position.distance_to(breadcrumbs[0]) < 2.0:
		breadcrumbs.pop_front()
		if breadcrumbs.is_empty():
			return
	var dir = global_position.direction_to(breadcrumbs[0]) * speed
	velocity.x = dir.x
	if is_on_wall():
		jump()
	if player.global_position.y < global_position.y - 50:
		jump()
	move_and_slide()
	
func jump():
	if is_on_floor():
		velocity.y = jump_height

func die():
	queue_free()

func update_state(delta):
	match state:
		States.CHASING:
			chase(delta)
		States.ATTACKING:
			pass
		States.DEAD:
			pass


func _on_bread_crumb_timer_timeout() -> void:
	breadcrumbs.append(player.global_position)
	if breadcrumbs.size() > 10:
		breadcrumbs.pop_front()
	#print(breadcrumbs[0])
