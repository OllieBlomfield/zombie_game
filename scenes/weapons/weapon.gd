extends Node2D
class_name Weapon

@export var icon_texture: CompressedTexture2D
@export var has_ammo: bool = false

func perform_attack(direction: int) -> void:
	pass

func get_attack_context() -> AttackContext:
	return AttackContext.new()

func get_icon() -> CompressedTexture2D:
	return icon_texture
