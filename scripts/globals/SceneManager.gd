extends Node

@export var levels: Dictionary = {"level1": preload("res://scenes/levels/level_1.tscn").instantiate()}


func add_scene(level):
	add_scene(levels["level1"])
	
func remove_scene():
	queue_free()
