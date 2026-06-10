extends Node

var player: Player


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("debug"):
		debug()

func debug():
	get_tree().reload_current_scene()
