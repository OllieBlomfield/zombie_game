class_name WaveSpawner
extends Node2D

signal wave_started(wave_number)
signal escape_unlocked
signal zombies_dead

@export var enemy_list: Array[PackedScene]

var enemy_cost: Array = [1,3]
var spawn_queue: Array[PackedScene] = []

var current_wave: int = 1
@export var max_waves: int = 1
@export var wave_length: int = 30
var points: int = 0

var current_spawner: Node2D
@export var pointer_arrow: PackedScene
var zombies_alive: bool = false

func _ready() -> void:
	zombies_dead.connect(end_wave)
	generate_wave()
	
func _process(delta: float) -> void:
	if current_wave > max_waves:
		check_zombie_status()
	
func get_spawn_points() -> Array:
	return get_tree().get_nodes_in_group("enemyspawnpoint")

func generate_wave():
	spawn_queue.clear()
	points = current_wave * 10
	while points > 0:
		var enemy_index = randi_range(0,len(enemy_list) - 1)
		var enemy = enemy_list[enemy_index]
		var enemy_cost_value = enemy_cost[enemy_index]
		if points - enemy_cost_value >= 0:
			spawn_queue.append(enemy)
			points -= enemy_cost_value
			print(points)
	spawn_wave()

func spawn_wave():
	wave_started.emit(current_wave)
	var spawn_points = get_spawn_points()
	current_spawner = spawn_points.pick_random()
	var pointer_arrow = pointer_arrow.instantiate()
	current_spawner.add_child(pointer_arrow)
	
	for enemy_scene in spawn_queue:
		var enemy = enemy_scene.instantiate()
		add_child(enemy)
		enemy.global_position = current_spawner.global_position
		await get_tree().create_timer(.5).timeout
	for pointer in current_spawner.get_children():
		pointer.queue_free()
	await get_tree().create_timer(wave_length).timeout
	current_wave += 1
	if current_wave > max_waves:
		return
	else:
		generate_wave()

func reset_wave():
	GameManager.player_active = true
	GameManager.can_leave = false
	max_waves += 1
	current_wave = 1
	generate_wave()

func check_zombie_status():
	var group_nodes = get_tree().get_nodes_in_group("enemy")
	if group_nodes.is_empty():
		zombies_dead.emit()

func end_wave():
	escape_unlocked.emit()
	GameManager.can_leave = true
