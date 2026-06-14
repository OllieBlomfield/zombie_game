extends Control
class_name HealthBar

@onready var texture_progress_bar: TextureProgressBar = $TextureProgressBar
@onready var label: Label = $Label

#func set_health_bar(percentage: float):
	#percentage = clamp(percentage,0.0,100.0)
	#texture_progress_bar.value = percentage
	
func set_health_bar(current_health: float, max_heath: float):
	var percentage = 100 * current_health / max_heath
	percentage = clamp(percentage,0.0,100.0)
	texture_progress_bar.value = percentage
	
	label.text = str(int(current_health)) + "/" + str(int(max_heath))
