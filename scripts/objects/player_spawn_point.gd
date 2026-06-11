extends Area2D

@export var shop: Control
@export var level: Node2D

func _on_body_entered(body: Node2D) -> void:
	if body is Player and GameManager.can_leave and GameManager.player_active:
		print("You Escaped!")
		print(ScoreManager.get_score())
		shop.visible = true
		GameManager.pause_game()
		GameManager.player_active = false
	else:
		print("Cant Leave Yet!")
