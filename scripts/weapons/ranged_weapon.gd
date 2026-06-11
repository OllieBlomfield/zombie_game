class_name RangedWeapon
extends Weapon


@export var bullet_scene: PackedScene
@export var fire_point: Marker2D
@export var bullet_speed: float = 400
@export var flip_h: bool = false

func perform_attack(facing_direction: int) -> void: #call pefrom_attack or execute_attack to imply something active is happening
	var bullet = bullet_scene.instantiate()

	get_tree().current_scene.add_child(bullet)

	bullet.global_position = fire_point.global_position

	var spread := deg_to_rad(5)

	var dir := Vector2(facing_direction, 0)
	dir.y += randf_range(-spread, spread)

	dir = dir.normalized()

	bullet.velocity = dir * bullet_speed
