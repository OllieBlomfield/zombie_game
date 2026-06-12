extends Control
class_name PlayerUI

@onready var current_weapon_icon: TextureRect = $CurrentWeapon
@onready var ammo_background: TextureRect = $AmmoBackground
@onready var ammo_label: Label = $AmmoText

@export var player: Player

func _ready() -> void:
	if not player:
		player = GameManager.player
	
	player.update_weapon_ui.connect(_set_weapon)
	_set_weapon()
	
func _set_weapon():
	var current_weapon: Weapon = player.combat.get_current_weapon()
	current_weapon_icon.texture = current_weapon.get_icon()
	if current_weapon.has_ammo:
		ammo_background.visible = true
		ammo_label.visible = true
		ammo_label.text = str(current_weapon.current_ammo) + "/" + str(current_weapon.max_ammo)
	else:
		ammo_background.visible = false
		ammo_label.visible = false
	
