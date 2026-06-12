extends Node

func hit_stop(time: float):
	Engine.time_scale = 0
	await get_tree().create_timer(time,true,false,true).timeout
	Engine.time_scale = 1
