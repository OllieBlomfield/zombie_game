class_name Combat
extends Node

@export var weapon_list: Array[Weapon] #would later need to add to this list from code
var _current_weapon: Weapon
var _current_weapon_index: int = 0

signal attack_finished

func _ready() -> void:
	set_weapon(0)

func attack(direction: float):
	_current_weapon.flip_h = direction < 0
	_current_weapon.perform_attack(direction)

func get_attack_context() -> AttackContext:
	return _current_weapon.get_attack_context()

func next_weapon() -> void:
	_current_weapon_index += 1
	if _current_weapon_index >= len(weapon_list):
		_current_weapon_index = 0
	set_weapon(_current_weapon_index)

func set_weapon(index) -> void:
	if _current_weapon:
		_current_weapon.visible = false
	_current_weapon = weapon_list[index]
	_current_weapon.visible = true

func get_current_weapon() -> Weapon:
	return _current_weapon
