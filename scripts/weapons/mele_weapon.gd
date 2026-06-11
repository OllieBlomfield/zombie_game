class_name MeleWeapon
extends Weapon



@export var damage: int = 2
@export var knockback: float = 80
@export var extra_knockback_y: float = 100
@export var hit_box: HitBox
@export var flip_h: bool = false
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


signal attack_finished

func _ready() -> void:
	#hit_box.body_entered.connect(_attack_hit)
	hit_box.hurtbox_hit.connect(_attack_hit)
	hit_box.disable()
	animated_sprite_2d.animation_finished.connect(_attack_finished)
	
func _process(delta: float) -> void:
	animated_sprite_2d.flip_h = flip_h #ask about this approach
	#for area in hit_box.get_overlapping_areas():
		#if area is HurtBox: #add something to check correct layers
			

func perform_attack() -> void: #call pefrom_attack or execute_attack to imply something active is happening
	hit_box.enable()
	animated_sprite_2d.play("attack")

func _attack_finished() -> void:
	hit_box.disable()
	attack_finished.emit()
	#print("DONE ATTACKING YAY")
	animated_sprite_2d.play("idle")
	
func _attack_hit(hurtbox: HurtBox):
	print("ATTACK HIT")
	var context: HitContext = HitContext.new()
	context.damage = damage
	context.direction = (hurtbox.global_position - global_position).normalized()
	context.hit_point = global_position
	context.knockback = knockback
	context.extra_y_knockback = extra_knockback_y
	hurtbox.handle_hit(context)
	
