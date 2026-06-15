extends ColorRect
class_name SimpleFade

@export var speed: float = 0.6

enum FadeType {FADE_IN, FADE_OUT}
var fade_type: FadeType = FadeType.FADE_IN


func _ready() -> void:
	color.a = 1.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match fade_type:
		FadeType.FADE_IN:
			color.a = max(0, color.a - delta * speed)
		FadeType.FADE_OUT:
			print(color.a)
			color.a = min(1, color.a + delta * speed)
	

func fade_out():
	fade_type = FadeType.FADE_OUT

func fade_in():
	fade_type = FadeType.FADE_IN
