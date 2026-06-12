class_name RangedBullet
extends Area2D

@export var damage: int = 1
@export var knockback: float = 50
@export var pierce: int = 1

var pierce_count: = 0

@export var bullet_gravity: int = 50

var velocity: Vector2

func _physics_process(delta: float) -> void:
	velocity.y += bullet_gravity * delta
	position += velocity * delta

func _on_area_entered(area: Area2D) -> void:
	var hurtbox := area as HurtBox

	if hurtbox == null:
		return

	var context := HitContext.new()
	context.damage = damage
	context.direction = velocity.normalized()
	context.hit_point = global_position
	context.knockback = knockback

	hurtbox.handle_hit(context)
	
	if pierce_count >= pierce:
		queue_free()
	
	pierce_count += 1

func _on_body_entered(body: Node2D) -> void:
	if body is TileMapLayer:
		queue_free()
