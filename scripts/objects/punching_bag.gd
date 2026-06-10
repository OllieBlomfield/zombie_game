extends CharacterBody2D

@onready var hurt_box: HurtBox = $HurtBox

func _ready() -> void:
	hurt_box.received_damage.connect(_on_received_damage)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_received_damage():
	set_instance_shader_parameter("flash_modifier",1.0)
