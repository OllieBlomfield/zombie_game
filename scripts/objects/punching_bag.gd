extends CharacterBody2D

@onready var hurt_box: HurtBox = $HurtBox
@onready var sprite_2d: Sprite2D = $Sprite2D

var flash: bool = false

func _ready() -> void:
	hurt_box.received_hit.connect(_on_received_hit)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	#set_instance_shader_parameter("flash_modifier",0.0)
	if flash:
		sprite_2d.set_instance_shader_parameter("flash_modifier",1.0)
		flash = false
	else:
		sprite_2d.set_instance_shader_parameter("flash_modifier",0.0)
	velocity.x *= 0.9
	velocity.y = min(velocity.y + 900 * delta,1000)
	move_and_slide()
	
func _on_received_hit(context: HitContext):
	print("IM HIT")
	flash = true
	velocity += context.direction * context.knockback #could use a character superclass (use inheritance or composition)
