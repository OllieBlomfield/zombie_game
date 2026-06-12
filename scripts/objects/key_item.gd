extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		ScoreManager.key_item_collected = true
		queue_free()
