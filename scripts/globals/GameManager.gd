extends Node

signal ui_active
signal ui_inactive

var player: Player
var can_leave: bool = false
var player_active: bool = true

enum upgrades{MELEE_DAMAGE, MELEE_KNOCKBACK, RANGED_DAMAGE, RANGED_PIERCE, PLAYER_HEALTH, BULLETS}


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("debug"):
		pass
		#debug()

func add_upgrade(upgrade, stats):
	if player == null:
		return
	match upgrade:
		upgrades.MELEE_DAMAGE:
			player.mele_weapon.damage += stats
		upgrades.MELEE_KNOCKBACK:
			player.mele_weapon.knockback += stats
		upgrades.RANGED_DAMAGE:
			player.ranged_weapon.damage += stats
		upgrades.RANGED_PIERCE:
			player.ranged_weapon.pierce += stats
		upgrades.PLAYER_HEALTH:
			player.health.max_health += stats
		upgrades.BULLETS:
			if !player.ranged_weapon.has_max_ammo():
				player.ranged_weapon.current_ammo += stats
		_:
			pass
			
func pause_game():
	ui_active.emit()
	get_tree().paused = true
	
func unpause_game():
	ui_inactive.emit()
	get_tree().paused = false

func debug():
	get_tree().reload_current_scene()
	
