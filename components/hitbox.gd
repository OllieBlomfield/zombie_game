class_name HitBox
extends Area2D

@export var damage: int

func set_damage(value: int):
	damage = value


func get_damage() -> int:
	return damage
