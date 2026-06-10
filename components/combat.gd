class_name Combat
extends Node

@export var current_weapon: MeleWeapon

signal attack_finished

func attack(direction: float):
	current_weapon.attack_init()
