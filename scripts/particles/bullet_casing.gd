extends Node2D

@onready var timer: Timer = $Timer

var velocity_y: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.timeout.connect(_on_timeout)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	velocity_y += 30 * delta
	
	position.y += velocity_y
	
func _on_timeout():
	queue_free()
