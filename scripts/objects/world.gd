extends Node2D

@onready var level: Node2D = $Level1
@onready var wave_spawner: WaveSpawner = $WaveSpawner


func reset_level() -> void:
	#var level_scene := load(level.scene_file_path)

	#level.queue_free()

	#var new_level = level_scene.instantiate()
	#add_child(new_level)

	#new_level.name = "Level"

	#level = new_level
	wave_spawner.reset_wave()
