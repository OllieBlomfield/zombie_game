extends Button

@onready var shop: Control = $".."

func _ready() -> void:
	grab_focus()

func _on_pressed() -> void:
	get_tree().get_first_node_in_group("spawner").reset_wave()
	shop.visible = false
	GameManager.unpause_game()
