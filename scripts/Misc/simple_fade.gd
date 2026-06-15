extends ColorRect

@export var speed: float = 0.6

func _ready() -> void:
	color.a = 1.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	color.a = max(0, color.a - delta * speed)
