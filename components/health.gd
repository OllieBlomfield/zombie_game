class_name Health
extends Node

signal health_depleted

@export var max_health: int = 3
@export var current_health: int = 3
@export var immortality: bool
@export var immortality_time: float

@export var sprite: Node2D

var immortality_timer: Timer = null

func _ready() -> void:
	current_health = max_health
	health_depleted.connect(die)
	
	immortality_timer = Timer.new()
	immortality_timer.one_shot = true
	add_child(immortality_timer)
	
func _process(delta: float) -> void:
	if immortality: print("immortal")
	if sprite:
		sprite.visible = !immortality

func set_health(value: int) -> void:
	current_health = clamp(value, 0, max_health)
	if current_health == 0:
		health_depleted.emit()
	
func set_immortality(value: bool) -> void: 
	immortality = value

func set_temporary_immortality(time: float) -> void:
	immortality = true

	immortality_timer.wait_time = time
	immortality_timer.timeout.connect(func():
		immortality = false
	)
	immortality_timer.start()

func take_damage(amount: int) -> void:
	if immortality:
		return 
	set_health(current_health - amount)
	print(current_health)
	set_temporary_immortality(immortality_time)
		
func die():
	print("DEAD")
