extends Control
class_name HealthBar

@onready var texture_progress_bar: TextureProgressBar = $TextureProgressBar

func set_health_bar(percentage: float):
	percentage = clamp(percentage,0.0,100.0)
	texture_progress_bar.value = percentage
