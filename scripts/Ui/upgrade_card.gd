extends Button


@export var image: CompressedTexture2D
@export var description: String
@export var upgrade: GameManager.upgrades
@export var upgrade_amount: int

@onready var texture_rect: TextureRect = $VBoxContainer/MarginContainer/TextureRect
@onready var label: Label = $VBoxContainer/MarginContainer2/label


func _ready() -> void:
	texture_rect.texture = image
	label.text = description
	
func apply_upgrade():
	GameManager.add_upgrade(upgrade,upgrade_amount)
	
func _on_pressed() -> void:
	apply_upgrade()


func _on_exit_button_pressed() -> void:
	pass # Replace with function body.
