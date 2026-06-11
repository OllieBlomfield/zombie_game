extends Node

var player: Player
var can_leave: bool = false
var player_active: bool = true


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("debug"):
		debug()

func debug():
	get_tree().reload_current_scene()
