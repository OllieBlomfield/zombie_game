extends Area2D

@onready var shop: Control = $"../../CanvasLayer/Shop"
@onready var wave_label: Label = $"../../CanvasLayer/WaveLabel"
@onready var escape_label: Label = $"../../CanvasLayer/EscapeLabel"

var in_zone: bool = false
var arrow_added: bool = false
var current_pointer_arrow: Node2D

@onready var info_label: Label = $Info_Label

const POINTER_ARROW = preload("uid://cbvxartqh3r2f")

func _process(delta: float) -> void:
	if not arrow_added and GameManager.can_leave:
		add_arrow()
		arrow_added = true
	
	if in_zone and GameManager.can_leave:
		info_label.visible = true
		if Input.is_action_just_pressed("interact"):
			print("You Escaped!")
			print(ScoreManager.get_score())
			shop.visible = true
			escape_label.text = ""
			wave_label.text = ""
			GameManager.player_active = false
			arrow_added = false
			if (current_pointer_arrow): current_pointer_arrow.queue_free()
			GameManager.pause_game()
	else:
		info_label.visible = false
			

func _on_body_entered(body: Node2D) -> void:
	if body is Player and GameManager.player_active:
		in_zone = true

func _on_body_exited(body: Node2D) -> void:
	in_zone = false

func add_arrow() -> void:
	current_pointer_arrow = POINTER_ARROW.instantiate()
	add_child(current_pointer_arrow)
