extends Node2D
class_name Weapon

func perform_attack(direction: int) -> void:
	pass

func get_attack_context() -> AttackContext:
	return AttackContext.new()
