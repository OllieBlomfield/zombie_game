extends Area2D

@onready var shop: Control = $"../../CanvasLayer/Shop"
@onready var wave_label: Label = $"../../CanvasLayer/WaveLabel"
@onready var escape_label: Label = $"../../CanvasLayer/EscapeLabel"

func _on_body_entered(body: Node2D) -> void:
	if body is Player and GameManager.can_leave and GameManager.player_active:
		print("You Escaped!")
		print(ScoreManager.get_score())
		shop.visible = true
		escape_label.text = ""
		wave_label.text = ""
		GameManager.pause_game()
		GameManager.player_active = false
	else:
		print("Cant Leave Yet!")
