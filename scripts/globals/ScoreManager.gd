extends Node

var time_elapsed: float = 0
var max_time: float = 150
var damage_taken: int = 0
var key_item_collected: bool = false

const POINT_MULT = 10



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_elapsed += delta
	
func calculate_score(time_elapsed: float, max_time: float, damage_taken: float, key_item_collected: bool):
		var time_score = (max_time - time_elapsed) * POINT_MULT
		var damage_score = -damage_taken * POINT_MULT
		var collection_score = 100 if key_item_collected else 0
		
		var final_score = time_score + damage_score + collection_score
		
		return final_score
		
