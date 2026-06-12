extends Button
@onready var world: Node2D = $"../../.."

@onready var shop: Control = $".."
func _on_pressed() -> void:
	world.reset_level()
	shop.visible = false
	GameManager.unpause_game()
