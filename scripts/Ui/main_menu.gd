extends Node2D

const WORLD = preload("uid://dnocukpr5f4uf")

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var start_music: AudioStreamPlayer2D = $StartMusic

var go_to_game: bool = false

func _ready() -> void:
	animation_player.animation_finished.connect(transition_to_level)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("jump") and not go_to_game:
		go_to_game = true
		start_music.play()
		Input.start_joy_vibration(0, .3, .4, 3)
		await get_tree().create_timer(.5).timeout
		animation_player.play("transition_to_level")
		#get_tree().change_scene_to_packed(WORLD)
		
func transition_to_level(anim_name: String):
	if go_to_game:
		get_tree().change_scene_to_packed(WORLD)
