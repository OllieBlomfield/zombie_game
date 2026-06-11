class_name RangedWeapon
extends Weapon


@export var bullet_scene: PackedScene
@export var fire_point: Marker2D
@export var bullet_speed: float = 400
@export var flip_h: bool = false

func perform_attack() -> void: #call pefrom_attack or execute_attack to imply something active is happening
	var bullet = bullet_scene.instantiate()

	get_tree().current_scene.add_child(bullet)

	bullet.global_position = fire_point.global_position

	var dir := Vector2.RIGHT
	if flip_h:
		dir = Vector2.LEFT

	bullet.direction = Vector2.LEFT if flip_h else Vector2.RIGHT
	bullet.speed = bullet_speed
