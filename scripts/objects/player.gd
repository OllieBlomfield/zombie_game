class_name Player
extends CharacterBody2D

@export var camera: Camera2D
@export var weapon: MeleWeapon

@export var health: Health
@export var hurtbox: HurtBox

const DEFAULT_CAM_POSITION: Vector2 = Vector2(0,0)
const UP_CAM_POSITION: Vector2 = Vector2(0,-34)
const DOWN_CAM_POSITION: Vector2 = Vector2(0,34)

const CROUCH_CAM_CHANGE_TIME: float = 0.8
const LOOK_UP_CAM_CHANGE_TIME: float = 0.8

const SPEED: float = 100.0
const ACCELERATION: float = 750
const TURN_ACCELERATION: float = 150
const FRICTION: float = 0.85
const MAX_SPEED: float = 100

const JUMP_VELOCITY: int = -180
const JUMP_BUFFER_TIME: float = 10
const COYOTE_TIME: float = 0.1
const GROUND_POUND_VELOCITY: int = 300

enum GravityType {FAST, SLOW}
const FAST_GRAVITY: int = 900
const SLOW_GRAVITY: int = 400


var current_gravity: int = SLOW_GRAVITY
var turning: bool = false
var facing_direction: int = 1
var jump_buffer: int = 0
var coyote_time: float = 0

var look_up_time: float = 0
var crouch_time: float = 0

var attacking: bool = false #could have as a seperate state to moving

#@export var dust_particle: PackedScene
@onready var combat: Combat = $Combat

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	weapon.attack_finished.connect(_attack_finished)
	hurtbox.received_damage.connect(damage_taken)
	pass
	#GameManager.player = self

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("right"): facing_direction = 1
	if Input.is_action_just_pressed("left"): facing_direction = -1 
	
	_handle_gravity(delta)
			
	_handle_jump(delta)

	_handle_camera_change(delta)
	
	var direction := Input.get_axis("left", "right")
	_handle_horizontal_velocity(delta,direction)
	_handle_animation(direction)
	
	move_and_slide()
	
	if Input.is_action_just_pressed("attack"):
		attacking = true
		animated_sprite_2d.play("mele_attack")
		combat.attack(1)
		
		#animated_sprite_2d.play("mele_attack")
	
func _handle_gravity(delta: float):
	if Input.is_action_pressed("jump"):
		set_gravity(GravityType.SLOW)
	else:
		set_gravity(GravityType.FAST)
	
	if not is_on_floor():
		velocity.y = move_toward(velocity.y, 150, current_gravity*delta)

func _handle_jump(delta: float):
	coyote_time = max(0,coyote_time-delta)
	if is_on_floor():
		coyote_time = COYOTE_TIME
	
	jump_buffer -= delta
	if Input.is_action_just_pressed("jump"):
		jump_buffer = JUMP_BUFFER_TIME
	
	if jump_buffer > 0 and coyote_time > 0:
		jump_buffer = 0
		velocity.y = JUMP_VELOCITY

func _handle_horizontal_velocity(delta: float, direction):
	if not turning and direction * velocity.x < -40: #can expand into checking until turning is done (should make game less slippery)
		turning = true
	
	velocity.x *= FRICTION
		
	if turning:
		velocity.x += TURN_ACCELERATION * direction * delta
		if direction * velocity.x >= 0:
			turning = false
	else:
		velocity.x += ACCELERATION * direction * delta
		
	velocity.x = clamp(velocity.x,-MAX_SPEED,MAX_SPEED)

func  _handle_animation(direction):
	animated_sprite_2d.flip_h = (facing_direction < 0)
	animated_sprite_2d.scale.y = 1 + abs(velocity.y)/700
	animated_sprite_2d.scale.x = 1
	
	if attacking:
		return
	elif is_on_floor():
		if Input.is_action_pressed("down"):
			animated_sprite_2d.play("crouch")
			animated_sprite_2d.scale.x = 1.05
		elif turning:
			animated_sprite_2d.play("turn")
		elif direction:
			animated_sprite_2d.play("run")
		else:
			animated_sprite_2d.play("idle")
	elif velocity.y > 0:
		animated_sprite_2d.play("fall")
	else:
		animated_sprite_2d.play("jump")
		
func set_gravity(type: GravityType):
	match type:
		GravityType.FAST:
			current_gravity = FAST_GRAVITY
		GravityType.SLOW:
			current_gravity = SLOW_GRAVITY
	
func _handle_camera_change(delta: float):
	
	if Input.is_action_pressed("down"):
		crouch_time += delta
		if crouch_time > CROUCH_CAM_CHANGE_TIME:
			camera.position = DOWN_CAM_POSITION
	else:
		crouch_time = 0
		if Input.is_action_pressed("up"):
			look_up_time += delta
		else:
			look_up_time = 0
		if look_up_time > LOOK_UP_CAM_CHANGE_TIME:
			camera.position = UP_CAM_POSITION
		else:
			camera.position = DEFAULT_CAM_POSITION

func _attack_finished():
	attacking = false

func damage_taken(damage: int):
	ScoreManager.damage_taken += damage
