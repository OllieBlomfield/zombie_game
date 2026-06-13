extends Node2D
class_name Weapon

signal finished_attack
signal play_attack_anim
signal camera_shake(intensity: int, time: float)

@export var icon_texture: CompressedTexture2D
@export var has_ammo: bool = false
@export var player_anim: String = "mele_attack"

var flip_h: bool = false

func perform_attack(direction: int) -> void:
	pass

func get_attack_context() -> AttackContext:
	return AttackContext.new()

func get_icon() -> CompressedTexture2D:
	return icon_texture
