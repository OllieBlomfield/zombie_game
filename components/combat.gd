class_name Combat
extends Node

@export var current_weapon: Weapon

signal attack_finished

func attack(direction: float):
	current_weapon.flip_h = direction < 0
	current_weapon.perform_attack(direction)

func get_attack_context() -> AttackContext:
	return current_weapon.get_attack_context()
