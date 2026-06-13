extends Node2D

var blood_particles: Array = []
var life_offset: float = 0
var blood_amount: int = 20
var drawing_timer: float = 0.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(blood_amount):
		var particle: Dictionary = {"x": 0, "y": 0, "vx": 60*(randf()-0.5), "vy":60*randf(), "life": randf()/2, "length": 7*randf()+1, "splat": false}
		blood_particles.append(particle)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	drawing_timer -= delta
	for p in blood_particles:
		if p["life"]>=0.0:
			p["x"]+=p["vx"]*delta
			p["y"]-=p["vy"]*delta
			p["life"]-=delta
		else:
			p["splat"]=true
	queue_redraw()

func _draw():
	for p in blood_particles:
		if p["splat"]:
			var rect: Rect2 = Rect2(p["x"],p["y"],2,2)
			draw_rect(rect,Color.from_rgba8(255,0,77,255))
			#draw_line(Vector2(p["x"],p["y"]),Vector2(p["x"],p["y"]+p["length"]),Color.from_rgba8(255,0,77,255))
		else:
			draw_rect(Rect2(p["x"],p["y"],2,2),Color.from_rgba8(255,0,77,255))
