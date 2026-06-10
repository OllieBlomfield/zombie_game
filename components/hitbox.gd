class_name HitBox
extends Area2D

@export var damage: int

func set_damage(value: int):
	damage = value


func get_damage() -> int:
	return damage

func enable() -> void:
	monitoring = true
	monitorable = true
	
func disable() -> void:
	monitoring = false
	monitorable = false
