extends GameCharacter
class_name ZombieCorpse

@export var corpse_texture: CompressedTexture2D
@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	sprite_2d.texture = corpse_texture

func _physics_process(delta: float) -> void:
	velocity.y += 900 * delta
	move_and_slide()
