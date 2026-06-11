extends Button

@onready var shop: Control = $".."

func _on_pressed() -> void:
	shop.visible = false
	GameManager.unpause_game()
