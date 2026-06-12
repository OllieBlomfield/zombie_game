extends PointLight2D
class_name MuzzleFlash

@onready var timer: Timer = $Timer

func _ready() -> void:
	visible = false
	timer.timeout.connect(_on_timeout)

func flash():
	timer.start(0.05)
	visible = true
	
func _on_timeout():
	visible = false
