class_name WaveSpawner
extends Node2D

signal wave_started(wave_number)
signal escape_unlocked

@export var enemy_list: Array[PackedScene]

var enemy_cost: Dictionary = {"zombie": 1, "tank": 3}
var spawn_queue: Array[PackedScene] = []

var current_wave: int = 1
@export var max_waves: int = 1
@export var wave_length: int = 30
var points: int = 0

func _ready() -> void:
	generate_wave()
	
func get_spawn_points() -> Array:
	return get_tree().get_nodes_in_group("enemyspawnpoint")

func generate_wave():
	spawn_queue.clear()
	points = current_wave * 10
	while points > 0:
		var enemy = enemy_list.pick_random()
		var enemy_cost_value = 1
		
		if points - enemy_cost_value >= 0:
			spawn_queue.append(enemy)
			points -= enemy_cost_value
			print(points)
	spawn_wave()

func spawn_wave():
	wave_started.emit(current_wave)
	var spawn_points = get_spawn_points()

	for enemy_scene in spawn_queue:
		var enemy = enemy_scene.instantiate()
		add_child(enemy)
		var point = spawn_points.pick_random()
		enemy.global_position = point.global_position
		await get_tree().create_timer(.5).timeout
	await get_tree().create_timer(wave_length).timeout
	current_wave += 1
	if current_wave > max_waves:
		escape_unlocked.emit()
		GameManager.can_leave = true
	else:
		generate_wave()
		
func reset_wave():
	GameManager.player_active = true
	GameManager.can_leave = false
	max_waves += 1
	current_wave = 1
	generate_wave()
