extends Control
class_name PlayerUI

@onready var current_weapon_icon: TextureRect = $CurrentWeapon
@onready var ammo_background: TextureRect = $AmmoBackground
@onready var ammo_label: Label = $AmmoText
@onready var health_bar: HealthBar = $HealthBar

@export var player: Player
@export var death_message: Label
@export var fade: SimpleFade

func _ready() -> void:
	if not player:
		player = GameManager.player
	
	death_message.visible = false
	player.update_weapon_ui.connect(_set_weapon)
	_set_weapon()

func _process(delta: float) -> void:
	var health_component: Health = player.health
	#var percentage: float = 100 * health_component.current_health / health_component.max_health
	health_bar.set_health_bar(health_component.current_health, health_component.max_health)

	if player.state == player.PlayerState.DEAD:
		death_message.visible = true
		await get_tree().create_timer(0.2).timeout
		if Input.is_action_just_pressed("jump"):
			if fade:
				fade.fade_out()
			await get_tree().create_timer(2).timeout
			get_tree().reload_current_scene()

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
