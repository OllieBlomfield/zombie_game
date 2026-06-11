extends Node

var player: Player
var can_leave: bool = false
var player_active: bool = true

enum upgrades{MELEE_DAMAGE, MELEE_KNOCKBACK, RANGED_DAMAGE, RANGED_PIERCE, PLAYER_HEALTH, BULLETS}


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("debug"):
		debug()

func add_upgrade(upgrade, stats):
	if player == null:
		return
	match upgrade:
		upgrades.MELEE_DAMAGE:
			print("upgraded!")
			player.melee_weapon.damage += stats
		upgrades.MELEE_KNOCKBACK:
			player.melee_weapon.knockback += stats
		upgrades.RANGED_DAMAGE:
			player.ranged_weapon.damage += stats
		#upgrades.RANGED_PIERCE:
			#player.ranged_weapon.damage += stats
		upgrades.PLAYER_HEALTH:
			player.health.max_health += stats
			
func pause_game():
	get_tree().paused = true
	
func unpause_game():
	get_tree().paused = false

func debug():
	get_tree().reload_current_scene()
	
