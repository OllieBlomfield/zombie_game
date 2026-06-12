class_name Combat
extends Node

@export var player: Player #not good practice but need to get facing direction somehow
@export var weapon_list: Array[Weapon] #would later need to add to this list from code
@export var right_weapon_position: Marker2D
@export var left_weapon_position: Marker2D
@export var camera: PlayerCamera

var _current_weapon: Weapon
var _current_weapon_index: int = 0

signal finished_attack
signal play_attack_anim

func _ready() -> void:
	set_weapon(0)

func _process(delta: float) -> void:
	if player.facing_direction == 1:
		_current_weapon.scale.x = 1
		_current_weapon.global_position = right_weapon_position.global_position
	else:
		_current_weapon.scale.x = -1
		_current_weapon.global_position = left_weapon_position.global_position

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
		_current_weapon.finished_attack.disconnect(_finished_attack)
		_current_weapon.play_attack_anim.connect(_play_attack_anim)
		_current_weapon.visible = false
		
	_current_weapon = weapon_list[index]
	_current_weapon.visible = true
	_current_weapon.finished_attack.connect(_finished_attack)
	_current_weapon.play_attack_anim.connect(_play_attack_anim)
	_current_weapon.camera_shake.connect(_camera_shake)

func get_current_weapon() -> Weapon:
	return _current_weapon

func _finished_attack() -> void:
	finished_attack.emit()

func _play_attack_anim() -> void:
	play_attack_anim.emit()

func _camera_shake(intensity: int, time: float) -> void:
	print("shake camera")
	camera.screen_shake(intensity, time)
