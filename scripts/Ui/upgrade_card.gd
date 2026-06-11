extends Button


@export var image: CompressedTexture2D
@export var description: String
@export var upgrade: GameManager.upgrades
@export var upgrade_amount: int
@export var upgrade_cost: int

@onready var texture_rect: TextureRect = $VBoxContainer/MarginContainer/TextureRect
@onready var description_label: Label = $VBoxContainer/MarginContainer2/DescriptionLabel
@onready var cost_label: Label = $VBoxContainer/MarginContainer3/CostLabel
@onready var money_label: Label = $"../../MoneyLabel"



func _ready() -> void:
	texture_rect.texture = image
	description_label.text = description
	cost_label.text = str(upgrade_cost)
	
func apply_upgrade():
	GameManager.add_upgrade(upgrade,upgrade_amount)
	
func _on_pressed() -> void:
	money_label.text = "Money: " + str(ScoreManager.current_money)
	apply_upgrade()
