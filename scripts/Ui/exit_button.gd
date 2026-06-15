extends Button

@onready var shop: Control = $".."
@onready var select_sound: AudioStreamPlayer2D = $SelectSound

func _ready() -> void:
	grab_focus()

func _on_pressed() -> void:
	select_sound.play()
	get_tree().get_first_node_in_group("spawner").reset_wave()
	shop.visible = false
	GameManager.unpause_game()
