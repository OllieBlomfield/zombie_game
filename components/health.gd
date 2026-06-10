class_name Health
extends Node

signal health_depleted

@export var max_health: int
@export var health: int 
@export var immortality: bool
@export var immortality_time: float 

var immortality_timer: Timer = null

func _ready() -> void:
	health = max_health

func set_health(value: int) -> void:
	if value < health and immortality:
		return  
	health = clamp(value, 0, max_health)
	if health == 0:
		health_depleted.emit()
	
func set_immortality(value: bool) -> void: 
	immortality = value 

func set_temporary_immortality(time: float) -> void:
	if immortality_timer == null:
		immortality_timer = Timer.new()
		immortality_timer.one_shot = true
		add_child(immortality_timer)

	immortality = true

	immortality_timer.wait_time = time
	immortality_timer.timeout.connect(func():
		immortality = false
	)
	immortality_timer.start()

func take_damage(amount: int, temp_immortality: float = 0.0) -> void:
	if immortality:
		return 
	set_health(health - amount)
	if temp_immortality > 0:
		set_temporary_immortality(temp_immortality)
