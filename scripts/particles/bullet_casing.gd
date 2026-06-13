extends Node2D

@onready var timer: Timer = $Timer

var velocity: Vector2 = Vector2(randf_range(-0.1,0.1),0)

func _ready() -> void:
	timer.timeout.connect(_on_timeout)

func _process(delta: float) -> void:
	velocity.y += 30 * delta
	
	position += velocity
	
func _on_timeout():
	queue_free()
