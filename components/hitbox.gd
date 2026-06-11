class_name HitBox
extends Area2D

signal hurtbox_hit(hurtbox: HurtBox)

@export var damage: int
@export var hitbox_name: String = "John"



func _ready() -> void:
	area_entered.connect(_test_candidate)
	
func enable() -> void:
	monitoring = true
	monitorable = true
	
func disable() -> void:
	monitoring = false
	monitorable = false

func _test_candidate(area: Node2D):
	if area is HurtBox:
		_on_hit(area)

func _on_hit(hurtbox: HurtBox) -> void:
	hurtbox_hit.emit(hurtbox)
