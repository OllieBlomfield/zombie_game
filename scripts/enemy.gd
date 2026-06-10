class_name Enemy
extends Node

@export var health = Health
@export var hitbox = HitBox
@export var hurtbox = HurtBox



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hurtbox.received_damage.connect(die)

func move():
	pass
	
func attack():
	pass 
	
func die():
	queue_free()
