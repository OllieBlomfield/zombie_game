extends AnimatedSprite2D
const DUST_PARTICLE = preload("uid://br77vrl7a7wcv")
@onready var dust_timer: Timer = $DustTimer
@onready var dust_marker: Marker2D = $Dust_Marker

func _ready() -> void:
	dust_timer.timeout.connect(add_dust)
	
func _process(delta: float) -> void:
	if dust_timer.is_stopped(): dust_timer.start(0.6 + 0.2*randf())

func add_dust():
	var dust_particle: Node2D = DUST_PARTICLE.instantiate()
	dust_particle.global_position = dust_marker.global_position
	dust_particle.z_index = 100
	dust_particle.scale.x = 8
	dust_particle.scale.y = 8
	get_parent().add_child(dust_particle)
	dust_timer.stop()
