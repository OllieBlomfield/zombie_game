extends Label



func _ready() -> void:
	GameManager.ui_active.connect(_on_ui_active)
	
func _on_ui_active():
	text = "Money: " + str(ScoreManager.current_money)
