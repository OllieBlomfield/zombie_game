extends Node2D

const WORLD = preload("uid://dnocukpr5f4uf")

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.animation_finished.connect(transition_to_level)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("jump"):
		animation_player.play("transition_to_level")
		#get_tree().change_scene_to_packed(WORLD)
		
func transition_to_level(anim_name: String):
	get_tree().change_scene_to_packed(WORLD)
