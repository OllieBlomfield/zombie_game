extends CharacterBody2D

@onready var hurt_box: HurtBox = $HurtBox
@onready var sprite_2d: Sprite2D = $Sprite2D

var flash: bool = false

func _ready() -> void:
	hurt_box.received_damage.connect(_on_received_damage)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	#set_instance_shader_parameter("flash_modifier",0.0)
	if flash:
		sprite_2d.set_instance_shader_parameter("flash_modifier",1.0)
		flash = false
	else:
		sprite_2d.set_instance_shader_parameter("flash_modifier",0.0)

func _on_received_damage(damage):
	print("IM HIT")
	flash = true
	#sprite_2d.set_instance_shader_parameter("flash_modifier",1.0)
