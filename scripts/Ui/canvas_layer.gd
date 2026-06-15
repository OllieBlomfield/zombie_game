extends CanvasLayer

@onready var wave_label: Label = $WaveLabel
@onready var escape_label: Label = $EscapeLabel
@onready var shop: Control = $Shop

func _ready():
	var spawner = get_tree().get_first_node_in_group("spawner")
	spawner.wave_started.connect(_on_wave_started)
	spawner.escape_unlocked.connect(_on_escape_unlocked)
	escape_label.visible = false
	if shop: shop.visible = false

func _on_wave_started(wave_number):
	wave_label.text = "Wave: " + str(wave_number)

func _on_escape_unlocked():
	escape_label.text = "Get to van!"
	escape_label.visible = true
