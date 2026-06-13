extends Area2D


@export var damage: int = 1
@export var knockback: float = 8
@export var pierce: int = 0
@export var crit_chance: float = 0.2

const BLOOD_DROP = preload("uid://m6vv16ke0ok4")

var pierce_count: = 0

@export var bullet_gravity: int = 50

var velocity: Vector2

func _physics_process(delta: float) -> void:
	#velocity.y += bullet_gravity * delta
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
	context.criticial_hit = (randf() < crit_chance)
	context.effect = BLOOD_DROP
	#var blood_drop: CPUParticles2D = BLOOD_DROP.instantiate()
	#blood_drop.global_position = global_position
	#blood_drop.emitting = true
	#get_parent().add_child(blood_drop)
	hurtbox.handle_hit(context)
	
	if pierce_count >= pierce:
		queue_free()
	
	pierce_count += 1

func _on_body_entered(body: Node2D) -> void:
	if body is TileMapLayer:
		queue_free()
