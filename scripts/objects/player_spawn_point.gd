extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body is Player and GameManager.can_leave and GameManager.player_active:
		print("You Escaped!")
		print(ScoreManager.get_score())
		GameManager.player_active = false
	else:
		print("Cant Leave Yet!")
