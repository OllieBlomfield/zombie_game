class_name RangedBullet
extends Area2D

@export var damage: int = 1
@export var knockback: float = 50

var direction: Vector2
var speed: float

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func _on_area_entered(area: Area2D) -> void:
	var hurtbox := area as HurtBox

	if hurtbox == null:
		return

	var context := HitContext.new()
	context.damage = damage
	context.direction = direction
	context.hit_point = global_position
	context.knockback = knockback

	hurtbox.handle_hit(context)

	queue_free()
