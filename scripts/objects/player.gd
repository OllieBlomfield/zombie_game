extends CharacterBody2D
class_name Player

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

@onready var ground_pound_timer: Timer = $GroundPoundTimer
enum GroundPoundState {GP_NOT, GP_INIT, GP_INTRO, GP_ACTION}
var ground_pounding: bool = false
var ground_pound_state: GroundPoundState = GroundPoundState.GP_NOT
var jump_buffer: int = 0
var coyote_time: float = 0

var look_up_time: float = 0
var crouch_time: float = 0

var in_water: bool = false

var ground_pound_unlocked: bool = false

@export var dust_particle: PackedScene

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var ground_pound_raycast: RayCast2D = $GroundPoundRaycast

@export var camera: Camera2D
func _physics_process(delta: float) -> void:
	
	
	# Add the gravity.
	if Input.is_action_pressed("jump"):
		set_gravity(GravityType.SLOW)
	else:
		set_gravity(GravityType.FAST)
	
	if not is_on_floor():
		if in_water:
			velocity.y = move_toward(velocity.y, 60, 0.5*current_gravity*delta)
		else:
			velocity.y = move_toward(velocity.y, 150, current_gravity*delta)
	
	
	if ground_pound_unlocked:
		_handle_ground_pound(delta)
	
	# Handle jump.
	
	#jump_buffer = move_toward(jump_buffer,0,delta)
	
	coyote_time = max(0,coyote_time-delta)
	if is_on_floor():
		coyote_time = COYOTE_TIME
	
	jump_buffer -= delta
	if Input.is_action_just_pressed("jump"):
		jump_buffer = JUMP_BUFFER_TIME
	
	if jump_buffer > 0 and coyote_time > 0:
		jump_buffer = 0
		if in_water:
			velocity.y = JUMP_VELOCITY * 0.8
		else:
			velocity.y = JUMP_VELOCITY

	if not ground_pounding:
		_handle_camera_change(delta)

	var direction := Input.get_axis("left", "right")
	
	_handle_animation(direction)
	
	if not turning and direction * velocity.x < -40: #can expand into checking until turning is done (should make game less slippery)
		turning = true
	
	velocity.x *= FRICTION
		
	if turning:
		velocity.x += TURN_ACCELERATION * direction * delta
		if direction * velocity.x >= 0:
			turning = false
	else:
		animated_sprite_2d.flip_h = velocity.x <= 0
		velocity.x += ACCELERATION * direction * delta
		
		
	velocity.x = clamp(velocity.x,-MAX_SPEED,MAX_SPEED)
	
	if abs(velocity.x) > 4 and is_on_floor():
		var dust = dust_particle.instantiate()
		dust.global_position = position
		get_parent().add_child(dust)
		
	
	if in_water:
		velocity.x *= 0.8
	
	move_and_slide()
	
func  _handle_animation(direction):
	animated_sprite_2d.scale.y = 1 + abs(velocity.y)/700
	animated_sprite_2d.scale.x = 1
	
	if is_on_floor():
		if Input.is_action_pressed("down"):
			animated_sprite_2d.play("crouch")
			animated_sprite_2d.scale.x = 1.05
		elif turning:
			animated_sprite_2d.play("turn")
		elif direction:
			animated_sprite_2d.play("run")
		else:
			animated_sprite_2d.play("idle")
	elif ground_pound_state == GroundPoundState.GP_ACTION:
		animated_sprite_2d.play("ground_pound")
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
		
func _handle_ground_pound(delta: float):
	set_collision_mask_value(4, true)
	if (
	not is_on_floor() and 
	ground_pound_state == GroundPoundState.GP_NOT and 
	Input.is_action_just_pressed("down")
	):
		ground_pound_state = GroundPoundState.GP_INIT
		
	
	if is_on_floor():
		ground_pound_state = GroundPoundState.GP_NOT
	
	if ground_pound_state == GroundPoundState.GP_INIT:
		ground_pound_timer.start(0.1)
		ground_pound_state = GroundPoundState.GP_INTRO
	if ground_pound_state == GroundPoundState.GP_INTRO:
		velocity.y = 0
		velocity.x = 0
		#velocity.y = GROUND_POUND_VELOCITY
	elif ground_pound_state == GroundPoundState.GP_ACTION:
		set_collision_mask_value(4,false)
		#print("POUNDING")
		velocity.y = GROUND_POUND_VELOCITY
		#if ground_pound_raycast.is_colliding():
			
			
func _on_hurt_box_body_entered(body: Node2D) -> void:
	print("ENTERED")
	in_water = true


func _on_hurt_box_body_exited(body: Node2D) -> void:
	print("EXITED")
	in_water = false


func _on_ground_pound_timer_timeout() -> void:
	ground_pound_state = GroundPoundState.GP_ACTION
	ground_pound_timer.stop()


func _on_ground_pound_box_body_entered(body: Node2D) -> void:
	if ground_pound_state == GroundPoundState.GP_ACTION and body is BreakableBlock:
		velocity.y = 10
		var block: BreakableBlock = body
		block.destroy()
