extends Area2D
@onready var collection_sound: AudioStreamPlayer2D = $CollectionSound

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		ScoreManager.key_item_collected = true
		collection_sound.play()
		await get_tree().create_timer(.3).timeout
		queue_free()
